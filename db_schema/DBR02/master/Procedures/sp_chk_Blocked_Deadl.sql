USE [master]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--
CREATE PROC dbo.sp_chk_Blocked_Deadl
	(	-- Check failed report ON/OFF 
		@ShowDeadLockRpt tinyint = 0	-- * DEFAULT = 0 (Current)
	)
AS
BEGIN;
SET NOCOUNT ON
------------------------------------------------------------------------------------------- 
-- **	Blocking sysprocesses CHECK
-- -- v1
-- [2015-05-12 12:24] [2016-06-16 14:00] [2016-09-22 14:30]
------------------------------------------------------------------------------------------- 
-- -- **  dba\MSSQL\04_Blocking_sysprocesses.sql
---
print ''
PRINT @@SERVERNAME+ '.'+DB_NAME()+'['+CONVERT(VARCHAR(19), GETDATE(),126)+']';
print '/* -- **	Blocking sysprocesses CHECK: (sysprocesses)  */'
print ''

SET CONCAT_NULL_YIELDS_NULL OFF
select 	
	-- Waiting spid
	s.spid waiting_spid, s.kpid waiting_kpid, s.loginame, (DATEDIFF(MINUTE,s.last_batch, GETDATE()) * 60.00 ) waiting_dur_lastbatch_sec--s.last_batch
	, ltrim(rtrim(s.hostname)) + '.[' + d.name + '] : ' +  ltrim(rtrim(s.cmd)) + ' : ' +  ltrim(rtrim(s.status))
	  + ' : ' +  ltrim(rtrim(s.program_name)) AS [waiting -> hostname.dbname : cmd : status : program]
	, ltrim(rtrim(j.Name)) [waiting -> JobNmame]
	--** Blocker spid
	, s.blocked blocker_spid, spall.loginame, spall.blocked blocker_blockedby_spid, (DATEDIFF(MINUTE,spall.last_batch, GETDATE()) * 60.00 ) blocker_dur_lastbatch_sec --spall.last_batch
	, ltrim(rtrim(spall.hostname)) + '.[' + dball.name + '] : ' + ltrim(rtrim(spall.cmd)) + ' : ' + ltrim(rtrim(spall.status))
	 + ' : ' +  ltrim(rtrim(spall.program_name)) AS [Blocker -> hostname.dbname : cmd : status : program]
	, ltrim(rtrim(jall.Name)) AS [Blocker -> JobNmame]
	, CASE   
			WHEN spall.stmt_start > 0 THEN
			--The start of the active command is not at the beginning of the full command text 
			CASE spall.stmt_end  
				WHEN -1 THEN  
					--The end of the full command is also the end of the active statement 
					concat('"',SUBSTRING(DEST.TEXT, (spall.stmt_start/2) + 1, 2147483647), '"')  
				ELSE   
					--The end of the active statement is not at the end of the full command 
					concat('"',SUBSTRING(DEST.TEXT, (spall.stmt_start/2) + 1, (spall.stmt_end - spall.stmt_start)/2), '"')   
			END  
			ELSE  
			--1st part of full command is running 
			CASE spall.stmt_end  
				WHEN -1 THEN  
					--The end of the full command is also the end of the active statement 
					-- !!!! (turned to NULL, because mathes with: [full_sql_text])  RTRIM(LTRIM(DEST.[text]))  
					-- !!xx!! (use only along with) full_sql_text 
					'-- same as [full_sql_text] -->'
				ELSE  
					--The end of the active statement is not at the end of the full command 
					concat('"',LEFT(DEST.TEXT, (spall.stmt_end/2) +1), '"') 
			END  
	  END AS [Blocker -> executing_statement]
	--xx , (SELECT text FROM fn_get_sql(spall.sql_handle)) [Blocker -> sqltext]
	, concat('"',RTRIM(LTRIM(DEST.[text])), '"') [Blocker -> sqltext]
	
	--**  Waiting Info
	, ' . . ' [ waiting_stats --> ]
	, (s.waittime/1000.0)/60.0 waittime_min, s.waittime/1000.0 waittime_sec, s.lastwaittype
	, CASE   
			WHEN s.stmt_start > 0 THEN
			--The start of the active command is not at the beginning of the full command text 
			CASE s.stmt_end  
				WHEN -1 THEN  
					--The end of the full command is also the end of the active statement 
					concat('"',SUBSTRING(DESTs.TEXT, (s.stmt_start/2) + 1, 2147483647) , '"')
				ELSE   
					--The end of the active statement is not at the end of the full command 
					concat('"',SUBSTRING(DESTs.TEXT, (s.stmt_start/2) + 1, (s.stmt_end - s.stmt_start)/2) , '"')   
			END  
			ELSE  
			--1st part of full command is running 
			CASE s.stmt_end  
				WHEN -1 THEN  
					--The end of the full command is also the end of the active statement 
					-- !!!! (turned to NULL, because mathes with: [full_sql_text])
					concat('"',LEFT(RTRIM(LTRIM(DESTs.[text])), 5000) , '"')
					-- !!xx!! (use only along with) full_sql_text   	'-- same as [full_sql_text] -->'
				ELSE  
					--The end of the active statement is not at the end of the full command 
					concat('"',LEFT(DESTs.TEXT, (s.stmt_end/2) +1) , '"')  
			END  
	  END AS [waiting -> executing_statement]
	/*xx , (SELECT text FROM fn_get_sql(s.sql_handle)) waiting_sqltext */, s.sql_handle waiting_sqlhandle 
	, s.cpu , s.physical_io , s.memusage
 from (sys.sysprocesses s LEFT join sys.sysdatabases d
			on s.dbid = d.dbid) LEFT join (sys.sysprocesses spall inner join sys.sysdatabases dball on spall.dbid=dball.dbid)
									ON s.blocked = spall.spid
					/* -- join sysjobs for Waiter (s) */ 
					LEFT Join msdb.dbo.sysjobs j 
					ON right(replace(j.job_id, '-', ''),16) = right(substring( convert(varchar(100), s.program_name),patindex('%Job 0x%', convert(varchar(100), s.program_name))+6, 32 ),16)
						--**  sql_text CROSS APPLY
						CROSS APPLY sys.[dm_exec_sql_text](s.[sql_handle]) DESTs
					/* -- join sysjobs for Blocker (spall) */ 
					LEFT Join msdb.dbo.sysjobs jall 
					ON right(replace(jall.job_id, '-', ''),16) = right(substring( convert(varchar(100), spall.program_name),patindex('%Job 0x%', convert(varchar(100), spall.program_name))+6, 32 ),16)
						--**  sql_text CROSS APPLY
						CROSS APPLY sys.[dm_exec_sql_text](spall.[sql_handle]) DEST
 where (s.blocked <> 0 
		-- and s.waittime > 5000
		)
 ORDER BY s.spid, s.blocked
;
SET CONCAT_NULL_YIELDS_NULL ON
print ''

------------------------------------------------------------------------------------------

IF (@ShowDeadLockRpt = 1) 
BEGIN;
	-- -- -- **  dba\MSSQL\wax_deadlocks\01.deadlock_info.sql
	/* * 
	This provides all the deadlocks that have happened on your server since the last restart.  
	We can look at this counter using the following SQL Statement:
	**/
	print ''
	-- Lock Waits Totals:
	-- set delay time '000:00:10'
	declare @wdel as varchar(10) = '000:00:10'
	print '/* -- **	Lock Waits Totals report:  */'
	print ' wait for DELAY (hhh:mi:ss) : '  + @wdel;
																											  
	-- set intitial counter-measure values
	SELECT pc.counter_name, pc.cntr_value, getdate() as measure_dt
	into #tmpx_deadl
		FROM sys.dm_os_performance_counters pc
		WHERE (pc.object_name = 'SQLServer:Locks' OR pc.object_name = 'MSSQL$MT22016SP1:Locks')
			AND (counter_name = 'Number of Deadlocks/sec' OR counter_name='Lock Waits/sec' OR counter_name='Lock Timeouts (timeout > 0)/sec' 
					OR counter_name='Lock Requests/sec' OR counter_name='Average Wait Time (ms)')
		--  GET ONLY Totals  
		AND pc.instance_name = '_Total'
		WAITFOR DELAY @wdel
	;
	-- xxx d.p
	--xxx SELECT * from #tmpx_deadl;

	-- print results
	print ''
	print 'current timestamp: ' + cast(getdate() as varchar(20));
	SELECT pc.object_name, pc.counter_name, pc.cntr_value, t.cntr_value cntr_value_measured
		, pc.cntr_value - t.cntr_value as cntr_value_diff, t.measure_dt counter_measure_timestamp
		, case when ltrim(rtrim(pc.counter_name)) = 'Average Wait Time (ms)' then   cast(((pc.cntr_value - t.cntr_value)/1000)/60.00 as varchar(40) ) + ' (min)'
				ELSE null END  as cntr_value_diff2
		FROM sys.dm_os_performance_counters pc inner join #tmpx_deadl t ON pc.counter_name=t.counter_name
		WHERE (pc.object_name = 'SQLServer:Locks' OR pc.object_name = 'MSSQL$MT22016SP1:Locks')
			AND (pc.counter_name = 'Number of Deadlocks/sec' OR pc.counter_name='Lock Waits/sec' OR pc.counter_name='Lock Timeouts (timeout > 0)/sec' 
					OR pc.counter_name='Lock Requests/sec' OR pc.counter_name='Average Wait Time (ms)')

		-- GET ONLY Totals  
		AND pc.instance_name = '_Total'
		ORDER BY 1,2
	;
	--
	--
	DROP table #tmpx_deadl;
	--
	
	--
	print ''
	print getdate()
	print '/* -- **	Deadlock / Locking dyn-view:  */'
	print ''
	SELECT pc.object_name, pc.counter_name
		, pc.instance_name
		, pc.cntr_value, case WHEN counter_name like '%ms%' THEN CAST( ((pc.cntr_value/1000)/60.0/60.0) AS VARCHAR(100)) + ' (h)'  ELSE NULL END cntr_value_2
		, getdate() exec_dt
	  FROM sys.dm_os_performance_counters pc
	 WHERE (pc.object_name = 'SQLServer:Locks' OR pc.object_name = 'MSSQL$MT22016SP1:Locks')
		 AND (counter_name = 'Number of Deadlocks/sec' OR counter_name='Lock Waits/sec' OR counter_name='Average Wait Time (ms)')

	--  GET ONLY Totals  
	-- AND instance_name = '_Total'
	ORDER BY 1,2,3
	;

END;
print ''
-- -- ** ENDoF: Blocking sysprocesses CHECK
-- -- -- --
--

-- ** ENDoF sp_chk_Blocked_Deadl
SET NOCOUNT OFF
END;

GO
