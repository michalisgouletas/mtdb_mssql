USE [DBA_t01_00]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- CREATE
CREATE PROCEDURE [dbo].[kill_long_queries]
AS
/* *** 	sp: [kill_long_queries] 
**	crdt: [2015-07-22 13:55:43]
**	executed by Job: 'kill_long_queries' .
**
**	1. kills mssql (spid) connections that are active for over 20"  , see code-part:  and datediff(second, last_request_start_time, getdate()) >= 30
**	2. (DATA-2771)  stops Job execution of ('last_pos_batch', 'v_ship_diff') that are active for over 6mins
**						OR Job execution of ('routes_all') that is active for over 30mins 
**																	, see code-part: --stop routes_all, etc. jobs after 5 OR 30 minutes
**	3. Send info email with the Job and Blocking status and the certain Job cancelation time
**	-- =============================================	****/
BEGIN
	SET NOCOUNT ON;

declare @spid as int
-- ** [13:12 9/2/2017] added LOGIN info on [kill_long_queries] and [TEMP_LONG_QUERIES]
declare @host as nvarchar(128), @login_name as nvarchar(128)
declare @client_pid as int, @status as nvarchar(30), @last_req_dt as datetime

declare c1 cursor for
select TOP(20) session_id, host_name, host_process_id as client_pid , status, last_request_start_time, login_name
from sys.dm_exec_sessions
where status = 'running' 
	AND (host_name<>'MT2' AND host_name<>'MT1' AND host_name<>'MT11' AND host_name<>'DBR02'
		AND host_name<>'MT7'  AND host_name<>'MT17' AND host_name<>'MT18' AND host_name<>'MT19' AND host_name<>'MARINETRAFFIC6' AND host_name<>'MT9' --AND host_name<>'OWNEROR-2BH75O7'
		and host_name<>'MT-AS-01' and host_name<>'MT-AS-02' and host_name<>'MTSALES06'  -- Huw Egginton [19:06 20/2/2017] : ( e m a i l  : Argyris Stasinakis , Mon, Feb 20, 2017 at 5:56 PM )
		and host_name<>'MTSALES07'  -- Tanuj Palit [17:59 15/3/2017] : ( e m a i l  : Stavroula Tsoka , Wed, Mar 8, 2017 5:55 PM )
		and host_name<>'MTSALES08'  -- Rebecca Ventham [14:20 25/5/2017] : ( e m a i l  : Yang Hee Andersen , Thu, May 18, 2017 at 3:51 PM )
		and host_name<>'MTSALES09'  -- Anthony Herbert [18:35 26/6/2017] : ( e m a i l  : Tanuj Palit , Thu, Jun 8, 2017 at 5:24 PM )
		and host_name<>'MT-AS011' -- [18:40 8/2/2017] Argyris Stasinakis ( mail-chat : Tue, Feb 7, 2017 2:53 PM)
 		and host_name<>'MTSALES03' -- [17:36 20/9/2017] 'MarineTraffic_3' replaced with: MTSALES03 (: Ricky 20170920 1716)
		and host_name <>'Toshiba-TOSH' --and host_name <>'MT27'
		AND host_name<>'halex-MBP.local' -- [20160504]: Alex Charvalias
		AND host_name<>'DESKTOP-CO311VM' -- [20160524]: DMitrodimas
		AND host_name<>'DATA-ARIS' -- [20161122]: Aris Pavlides
		-- (DATA-3213) [15:15 2/8/2016] exclude DB Users from [kill_long_queries] 
		AND host_name<>'MTSALES05' AND host_name<>'Miluse1' AND  host_name<>'LT_Miluse2'
		AND host_name<>'STELLIOS-PC'  -- [20170110]: Stellios Stratidakis ( e ma i l :  Mon, Jan 9, 2017 at 3:49 PM)
		AND host_name<>'DATACURATOR-B'	--[18:40 8/2/2017] :   ( e m a i l  : 20170203 16:40)
		AND host_name<>'GTOUROS-LAPTOP' --[11:01 28/8/2017] :  ( e m a i l  : George Touros , Wed, Aug 9, 2017 at 12:52 PM)
		AND host_name<>'RND-GIANNIS' -- [19:06 20/2/2017] Giannis Spiliopoulos ( e m a i l  : Thu, Feb 16, 2017 at 2:18 PM )
		----
		AND datediff(second, last_request_start_time, getdate()) >= 20
		) --OR datediff(MINUTE, last_request_start_time, getdate()) >= 10)
	-- [11:56 25/1/2016] : DATA-2333_create_dbuser_[ais_usrlong]_mt14
	AND login_name <> 'ais_usrlong'
	-- [15:17 14/7/2017] Aris Pavlides <aris.pavlides@marinetraffic.com> (Wed, Jul 12, 2017 at 6:37 PM)
	AND login_name <> 'mtdatainter'
	
order by datediff(second, last_request_start_time, getdate()) desc

open c1
fetch next from c1 into @spid, @host, @client_pid, @status, @last_req_dt, @login_name
-- for each spid...
while @@FETCH_STATUS = 0
begin
	declare @sqltext as varchar(MAX), @execsql AS VARCHAR(MAX), @client_net_address as nvarchar(48);
	-- [00:30 28/7/2016] Added: EXECSQL_STMT
	SELECT @sqltext=sqltext.TEXT
		, @execsql=CASE   
			 WHEN req.statement_start_offset > 0 THEN
				--The start of the active command is not at the beginning of the full command text 
				CASE req.statement_end_offset  
				   WHEN -1 THEN  
					  --The end of the full command is also the end of the active statement 
					  concat('"',SUBSTRING(sqltext.TEXT, (req.statement_start_offset/2) + 1, 2147483647) , '"') 
				   ELSE   
					  --The end of the active statement is not at the end of the full command 
					  concat('"',SUBSTRING(sqltext.TEXT, (req.statement_start_offset/2) + 1, (req.statement_end_offset - req.statement_start_offset)/2) , '"')
				END  
			 ELSE  
				--1st part of full command is running 
				CASE req.statement_end_offset  
				   WHEN -1 THEN  
					  --The end of the full command is also the end of the active statement 
					  -- !!!! (turned to NULL, because mathes with: [full_sql_text])  					  RTRIM(LTRIM(DEST.[text]))  
					  '-- same as [full_sql_text] -->'
				   ELSE  
					  --The end of the active statement is not at the end of the full command 
					  concat('"',LEFT(sqltext.TEXT, (req.statement_end_offset/2) +1) , '"')  
				END  
		END
		--
		, @client_net_address =c.client_net_address
	FROM  (sys.dm_exec_requests req
	CROSS APPLY sys.dm_exec_sql_text(sql_handle) AS sqltext )  LEFT JOIN  sys.dm_exec_connections c ON c.session_id=req.session_id
	WHERE req.session_id=@spid
	order by total_elapsed_time desc

	declare @killstatement as nvarchar(20)
	set @killstatement = N'KILL ' + cast(@spid as nvarchar)
    -- Don't kill the connection of the user executing this statement
    IF @@SPID <> @spid
		exec sp_executesql @killstatement

	INSERT INTO ais_replica.dbo.TEMP_LONG_QUERIES (SQLTEXT, HOST, CLIENT_PID, STATUS, LAST_REQUEST_START_TIME, SPID, EXECSQL_STMT, LOGIN_NAME, CLIENT_NET_ADDRESS) 
	 VALUES (@sqltext, @host, @client_pid, @status, @last_req_dt, @spid, @execsql, @login_name, @client_net_address);

	fetch next from c1 into @spid, @host, @client_pid, @status, @last_req_dt, @login_name
end

close c1
deallocate c1

-- **
--stop routes_all, etc. jobs after 5 OR 30 minutes
declare @job_mins INT, @job_minslimit INT;
declare @job_name varchar(250);
--SELECT top 1 @job_mins=DATEDIFF(minute,aj.start_execution_date,GetDate()), @job_name=sj.name
WITH cte_jobex AS (
	SELECT DATEDIFF(MINUTE,aj.start_execution_date,GetDate()) job_mins, sj.name job_name
		-- (DATA-2771) [2016-07-04_18:20]
		-- [17:51 23/9/2016]  change limit to  6  from  5  due to [SYS-86] (mt14) E: DiskQueue raise
		, CASE WHEN sj.name in ('last_pos_batch', 'v_ship_diff') THEN 6
			ELSE 30
		END AS job_minslimit
	FROM msdb..sysjobactivity aj
	JOIN msdb..sysjobs sj on sj.job_id = aj.job_id
	WHERE aj.stop_execution_date IS NULL -- job hasn't stopped running
	AND aj.start_execution_date IS NOT NULL -- job is currently running
	AND sj.name in ('routes_all', 'last_pos_batch', 'v_ship_diff')
	and not exists( -- make sure this is the most recent run
		select 1
		from msdb..sysjobactivity new
		where new.job_id = aj.job_id
		and new.start_execution_date > aj.start_execution_date
		)
)
SELECT top 1 @job_mins=job_mins, @job_name=job_name, @job_minslimit=job_minslimit 
FROM cte_jobex 	ORDER BY job_mins DESC
;

--
if @job_mins>@job_minslimit
BEGIN
	-- 
	-- (DATA-2771) [2016-08-05_13:30] : Send email dba_Notification of the cancellation
	DECLARE @strSubj as varchar(300) = '('+@@SERVERNAME+') ['+@job_name+'] Job: Cancelled-duration '+CONVERT(VARCHAR(10),@job_mins)+'m (> '+CONVERT(VARCHAR(10),@job_minslimit)+'m limit) - ' + convert(varchar(10), getdate(), 126);
	DECLARE @strAttf as nvarchar(200) = '('+@@SERVERNAME+')_'+@job_name+'_JobCancelled'+REPLACE(REPLACE(convert(varchar(19), getdate(), 126),'-',''),':','')+'.csv';
	-- xx D.p
	PRINT @strAttf
	EXEC msdb.dbo.sp_send_dbmail
		@profile_name = 'smtp',
		@recipients = 'yannis.batistakis@marinetraffic.com',
		@subject = @strSubj,
		@query = N'EXEC master.dbo.sp_chk_JobsStatus_detail @ShowCheckRunning = 1, @ShowCheckJobDet = 0;
EXEC master.dbo.sp_chk_JobsLast;
EXEC master..sp_chk_Blocked_Deadl;',
		@attach_query_result_as_file = 1,
		@query_attachment_filename= @strAttf,
		@query_result_separator=';', @query_result_width=640, @query_result_no_padding=1
	;
	
	-- disable selected job by var:@job_name
	PRINT '-- '+ @@SERVERNAME+ '.'+DB_NAME()+ '.'+USER_NAME()+' ['+CONVERT(VARCHAR(19), GETDATE(),126)+'] stopping job: '+@job_name;
	exec msdb.dbo.sp_stop_job @job_name = @job_name
END

-- ENDoF sp: [kill_long_queries]
END



GO
