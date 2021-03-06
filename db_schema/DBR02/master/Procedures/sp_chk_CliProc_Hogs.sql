USE [master]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--
CREATE PROC dbo.sp_chk_CliProc_Hogs
	(	
		-- set paticular DB_Name
		@strDBname as varchar(100) = null, -- * DEFAULT = null (show all DBs)
		-- Check failed report ON/OFF 
		@ShowProcTOP tinyint = 0	-- * DEFAULT = 0 (Current)
	)
AS
BEGIN;
SET NOCOUNT ON
------------------------------------------------------------------------------------------- 
-- **	Client Procs  CHECK
-- 		grp by Hostname , Dbname , Status
-- -- v1
-- [2015-05-12 12:24:02.343]
------------------------------------------------------------------------------------------- 
-- -- **  dba\MSSQL\MSSQL2005+\04_sysprocesses_mon.sql
---
print ''
print getdate()
print '/* -- **	Client Procs  CHECK: (sysprocesses)  */'
print ''
SELECT 
    convert(varchar(100), ltrim(rtrim(s.hostname))) as CliHostname
	, d.name dbname, s.status
	, count(*) as CliProcsCnt  , sum(cast(s.cpu AS real)) as sumCPU
    , sum(datediff(second, s.login_time, getdate())) as sumConnSecs
	/*, sum(datediff(MINUTE, s.login_time, getdate())) as sumConnMins*/
	, convert(varchar(10), sum(datediff(MINUTE, s.login_time, getdate()))) + 'min (' + convert(varchar(10),sum(datediff(hour, s.login_time, getdate()))) + 'hrs )' as [sumConnTime]
    , CASE WHEN convert(float, sum(datediff(second, s.login_time, getdate()))) <> 0 then convert(float, sum(cast(s.cpu AS real))) / convert(float, sum(datediff(second, s.login_time, getdate())))
		ELSE null -- DevideByZero Error
		 END as [Score (sumCPU/sumConnSecs)]
    , CASE WHEN convert(float, sum(datediff(second, s.login_time, getdate()))) <> 0 then convert(float, sum(cast(s.cpu AS real))) / convert(float, sum(datediff(second, s.login_time, getdate()))) / count(*)
		ELSE null -- DevideByZero Error
		 END as ProgramBadnessFactor
	, MIN(s.last_batch) min_last_batch, MAX(s.last_batch) max_last_batch
	
FROM master..sysprocesses s LEFT JOIN 
			(SELECT sdb.*
			-- SELECTion void COL for: @strDBname:
			, CASE WHEN db_id(@strDBname) is null OR db_id(@strDBname)=sdb.dbid THEN 1 ELSE 0
			  END as sel_db_void FROM sys.sysdatabases sdb
			) AS d
			on s.dbid = d.dbid
				
WHERE s.spid > 50  
	-- choose One or ALL DBs, upon: @strDBname
	AND d.sel_db_void=1
GROUP BY
    rollup(convert(varchar(100), ltrim(rtrim(s.hostname))), d.name, s.status)
--xx ORDER BY [Score (sumCPU/sumConnSecs)] DESC
-- Order RollUp Total First (NULLS FIRST alternative)
ORDER BY (CASE WHEN CONVERT(varchar(100), ltrim(rtrim(s.hostname))) IS NULL THEN 0 ELSE 1 end), convert(varchar(100), ltrim(rtrim(s.hostname))) DESC
;
--
print ''
print '___________________'
print ' CliProcsCnt: mssql Client Processes COUNT
			 If it turns out that there are tens or hundreds of instances of a program (CliCount is a large number)
			 , then we know we have a program worth investigating first, as the biggest overall gains can be had by getting better efficiency from that app.
		sumConnSecs: Sum of Connection time (sec)
		sumConnTime: Sum of Conection time converted to min and hours
		[Score (sumCPU/sumConnSecs)] : Score metric of the grouped Client Processes valued from sumCPU/sumConn time in secs
			, which is aggregate cpu divided by aggregate connect time
		ProgramBadnessFactor : ProgramBadnessFactor metric of the grouped Client Processes valued from  [Score (sumCPU/sumConnSecs)]  / CliProcsCnt
			, This is the aggregate cpu, divided by the aggregate seconds, then divided by the number of connected instances of the program'
print ''

------------------------------------------------------------------------------------------

IF (@ShowProcTOP = 1) 
BEGIN;
	-- -- -- **  dba\MSSQL\MSSQL2005+\04_sysprocesses_mon.sql
	/* * 
	-- TOP proccesses by cpu/ConnSec (Pscope) 
	-- https://technet.microsoft.com/en-us/magazine/2005.05.systemtables.aspx
	**/
	print ''
	print getdate()
	print '/* -- **	TOP proccesses by cpu/ConnSec (Pscope) :  */'
	print ''
	SET CONCAT_NULL_YIELDS_NULL OFF
	--
	SELECT 
	 TOP 100
		s.spid, s.kpid /*kpid: Microsoft Windows NT 4.0® thread ID*/
		, s.hostprocess /*cleint pid*/
		, s.blocked, convert(varchar(20), s.loginame) as Login/*, ltrim(rtrim(s.nt_domain)) + '\' + ltrim(rtrim(s.nt_username)) [NT_user]*/
		, convert(varchar(50), ltrim(rtrim(s.hostname)) + '.[' + db_name(s.dbid)) + '] : ' +  ltrim(rtrim(s.cmd)) + ' : ' +  ltrim(rtrim(s.status))
		  + ' : ' +  ltrim(rtrim(s.program_name)) AS [hostname.dbname : cmd : status : program]
		, j.Name JobNmame
		,s.last_batch last_batch_dt, s.cpu
		/*, datediff(second,s.login_time, getdate()) as ConnSecs
		, datediff(MINUTE, s.login_time, getdate()) as ConnMins*/
		, convert(varchar(10),datediff(second,s.login_time, getdate())) + 'sec (' + convert(varchar(10),datediff(MINUTE, s.login_time, getdate())) + 'min )' as [ConnTime]
		-- Dur
		, (DATEDIFF(MINUTE,s.last_batch,GETDATE()) * 60 )  AS timeSince_lastbatch_s
		, (DATEDIFF(MINUTE,s.stmt_start,s.stmt_end) * 60.0 )  AS Duration_s
		/* (PScore is the alias we've given to the computed column which results from dividing the cpu time of a process by the connected seconds of that process.) */
		, convert(float, s.cpu / datediff(second,s.login_time, getdate())) as PScore
		, CASE   
			 WHEN s.stmt_start > 0 THEN
				--The start of the active command is not at the beginning of the full command text 
				CASE s.stmt_end  
				   WHEN -1 THEN  
					  --The end of the full command is also the end of the active statement 
					  concat('"',SUBSTRING(DEST.TEXT, (s.stmt_start/2) + 1, 2147483647) , '"') 
				   ELSE   
					  --The end of the active statement is not at the end of the full command 
					  concat('"',SUBSTRING(DEST.TEXT, (s.stmt_start/2) + 1, (s.stmt_end - s.stmt_start)/2) , '"')
				END  
			 ELSE  
				--1st part of full command is running 
				CASE s.stmt_end  
				   WHEN -1 THEN  
					  --The end of the full command is also the end of the active statement 
					  -- !!!! (turned to NULL, because mathes with: [full_sql_text])  					  RTRIM(LTRIM(DEST.[text]))  
					  '-- same as [full_sql_text] -->'
				   ELSE  
					  --The end of the active statement is not at the end of the full command 
					  concat('"',LEFT(DEST.TEXT, (s.stmt_end/2) +1) , '"')  
				END  
		END AS [executing_statement]
		, concat('"',DEST.text , '"')  full_sql_text
		-- Wait info
		/*?, s.waittype*/, (s.waittime/1000)/60 waittime_min, s.lastwaittype
	FROM master..sysprocesses s
			LEFT Join msdb.dbo.sysjobs j 
						ON right(replace(j.job_id, '-', ''),16) = right(substring( convert(varchar(100), s.program_name),patindex('%Job 0x%', convert(varchar(100), s.program_name))+6, 32 ),16)
		CROSS APPLY sys.[dm_exec_sql_text](s.[sql_handle]) DEST
	WHERE datediff(second,s.login_time, getdate()) > 0 
		-- (exclude system pids)
		 and s.spid > 50
		-- *** Runnable (active)
		 --AND lower(s.status) = 'runnable' 
		-- * SET hostname
		 --AND LOWER(s.hostname) = ltrim(rtrim(LOWER('MT14'))) 
	-- x ORDER BY pscore desc, s.cpu desc, s.status
	ORDER BY pscore desc, s.cpu desc, s.spid
	;
	SET CONCAT_NULL_YIELDS_NULL ON	;

END;
print ''
print '___________________'
print ' ConnTime: Sum of Conection time converted to min and hours
		[PScore (CPU/ConnSecs)] : Score metric of the grouped Client Processes valued from CPU/Conn time in secs
			, which is aggregate cpu divided by aggregate connect time'
print '';
-- -- ** Client Procs  CHECK
-- -- -- --
--

-- ** ENDoF sp_chk_CliProc_Hogs
SET NOCOUNT OFF
END;

GO
