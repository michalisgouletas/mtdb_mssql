USE [master]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--
CREATE PROC dbo.sp_chk_JobsStatus_detail
	(	-- Check Running Jobs ON/OFF 
		@ShowCheckRunning tinyint = 1,	-- * DEFAULT = 1 (Current)
		-- Check JobStatuses detail ON/OFF
		@ShowCheckJobDet tinyint = 1,	-- * DEFAULT = 1 (Current)
		-- Set Hours (HH) before current datetime to be searched, for Job Statuses detail
		@intHourssBefore SMALLINT = 12, -- * DEFAULT = 12 Hours before current date
		-- Set one JOB to search  : 'LSCopy_MT1_ais'
		@strJobName VARCHAR(200) = NULL, -- * DEFAULT = null (show all JOBs)
		-- Filter for 1: AllSteps or 0:(Job Outcome) steps only
		@bitAllSteps TINYINT  = 0, -- * DEFAULT = 0 (Job Outcome) only
		-- Filter for 1: OnlyFailed or 0:All run_status 
		@bitFailedOnly TINYINT = 0 -- * DEFAULT = 0 (All [run_status] Jobs)
		
	)
AS
/* -- [2017-06-07T16:58] exec examples:
	-- Select Running Jobs:
		EXEC dbo.sp_chk_JobsStatus_detail @ShowCheckRunning=1 , @ShowCheckJobDet=0;
	-- Select Job execution Details , without Running Jobs, for the Last 4 hours (Only Final Job Outcome records)
		EXEC dbo.sp_chk_JobsStatus_detail @ShowCheckRunning=0 , @ShowCheckJobDet=1, @intHourssBefore=4
	-- Select Job execution Details , with Running Jobs, for a certain JobName='v_ship_diff' (and ALL Steps history) 
		EXEC dbo.sp_chk_JobsStatus_detail @ShowCheckRunning=1 , @ShowCheckJobDet=1, @bitAllSteps=1, @strJobName='v_ship_diff'
	-- Select Job execution Details , without Running Jobs, with ONLY Failed Status (and ALL Steps history) 
		EXEC dbo.sp_chk_JobsStatus_detail @ShowCheckRunning=0 , @ShowCheckJobDet=1, @bitAllSteps=1, @bitFailedOnly=1
*/
BEGIN;
SET NOCOUNT ON

--------------------------------------------------------------------------------- 
-- **  Check All currently running jobs
-- ** [http://www.sqlservercentral.com/blogs/sqlstudies/2013/09/05/a-t-sql-query-to-get-current-job-activity/	
--------------------------------------------------------------------------------- 
-- -- **  wrk_abox\dba\MSSQL\MSSQL2005+\03_CheckRunning_JobStatus.sql
--  [16:50 7/6/2017] Added : bitAllSteps , bitFailedOnly  Job-Selection Vars
--
IF (@ShowCheckRunning = 1) 
BEGIN;
	print ''
	print getdate();
	print '/* -- db All SQL Running_Jobs Status (current): */'
	print ''

	SELECT
		ja.job_id,
		j.name AS job_name,
		ja.start_execution_date,   
		convert(varchar(10),datediff(second,ja.start_execution_date, getdate())) + 'sec (' + convert(varchar(10),datediff(MINUTE, ja.start_execution_date, getdate())) + 'min )'  [Executing_Dur (sec OR min)],   
		ISNULL(last_executed_step_id,0)+1 AS current_executed_step_id,
		Js.step_name
	FROM msdb.dbo.sysjobactivity ja 
	LEFT JOIN msdb.dbo.sysjobhistory jh 
		ON ja.job_history_id = jh.instance_id
	JOIN msdb.dbo.sysjobs j 
	ON ja.job_id = j.job_id
	JOIN msdb.dbo.sysjobsteps js
		ON ja.job_id = js.job_id
		AND ISNULL(ja.last_executed_step_id,0)+1 = js.step_id
	WHERE ja.session_id = (SELECT TOP 1 session_id FROM msdb.dbo.syssessions ORDER BY agent_start_date DESC)
	AND start_execution_date is not null
	AND stop_execution_date is null
	;
	print ''	
END;
-- -- ** ENDoF:   Check All currently running jobs
-- -- -- --
--
--


--------------------------------------------------------------------------------- 
-- Check All Job Status  (detailed)
--------------------------------------------------------------------------------- 
-- -- **  wrk_abox\dba\MSSQL\MSSQL2005+\03_CheckJobStatus.sql
--
IF (@ShowCheckJobDet = 1) 
BEGIN;
	--
	declare @Time_Start datetime;
	set @Time_Start=dateadd(hh,(-1)*@intHourssBefore,getdate());

	print ''
	print getdate();
	print '/* -- db SQL Job Status (Detailled Datetime order): */'
	print '/* --    Searched '+ cast(@intHourssBefore as varchar(20)) +' Hours back  (since: '+ cast(@Time_Start as varchar(20)) +')  */'
	print ''

	/*
	[http://thinknook.com/get-sql-server-job-agent-execution-information-and-history-2012-11-09/]
	[http://msdn.microsoft.com/en-us/library/ms174997.aspx]
	sql_message_id	ID of any SQL Server error message returned if the job failed.
	sql_severity	Severity of any SQL Server error.
	instance_id		Unique identifier for the row.
	run_duration	Elapsed time in the execution of the job or step in HHMMSS format.
	run_status	Status of the job execution:
				0 = Failed
				1 = Succeeded
				2 = Retry
				3 = Canceled
	*/

	SELECT 
		/* --D.p:
			CASE WHEN @strJobName is null OR @strJobName=j.name THEN 1
					ELSE 0
				END as sel_job_void , */
		j.Name as Job_Name, --xxjh.step_id,
		LEFT(DATENAME(DW, CONVERT(DATETIME,CONVERT(CHAR(8),run_date) + ' ' +  STUFF(STUFF((LEFT('000000',6-LEN(run_time))
					+ CONVERT(VARCHAR(6),run_time)),3,0,':'),6,0,':'))
			),3) WDay,
		CONVERT(DATETIME,CONVERT(CHAR(8),run_date) + ' ' +  STUFF(STUFF((LEFT('000000',6-LEN(run_time))+ CONVERT(VARCHAR(6),run_time)),3,0,':'),6,0,':')) AS start_datetime,
		-- ** [2016-04-11 14:16] exclude non-physical run_duration (6-digits) times like: -954439132	
		CASE WHEN LEN(run_duration) < 7 then
		DATEADD(second,
			-- what to DATEadd
			(cast(left(LEFT('000000',6-LEN(run_duration))+ CONVERT(VARCHAR(6),run_duration), 2) as int)*60*60
			  + cast(substring(LEFT('000000',6-LEN(run_duration))+ CONVERT(VARCHAR(6),run_duration),3,2)*60 as int)
			  + cast(right(LEFT('000000',6-LEN(run_duration))+ CONVERT(VARCHAR(6),run_duration), 2) as int)) ,
			-- where to DATEadd
			CONVERT(DATETIME,CONVERT(CHAR(8),run_date) + ' ' +  STUFF(STUFF((LEFT('000000',6-LEN(run_time))+ CONVERT(VARCHAR(6),run_time)),3,0,':'),6,0,':')))
		ELSE
			null
		END
		AS end_datetime,
		--
		CASE WHEN LEN(run_duration) < 7 THEN STUFF(STUFF((LEFT('000000',6-LEN(run_duration))+ CONVERT(VARCHAR(6),run_duration)),3,0,':'),6,0,':') 
		ELSE concat('** ',run_duration, ' **')
		END as [duration_HH:MM:SS] ,						
		case run_status 
			WHEN 0 then '-- Failed --' 
			when 1 then 'Succeeded'
			WHEN 2 THEN '-- RETRY --' 
			when 3 then '-- Cancelled --' 
			when 4 then 'In Progress' 
		END as job_run_status,
		--
		j.enabled IsJobEnabled,
		-- ** Job Outcome or failed-Job message
		--xxxx CASE jh.run_status
		--xxxx 	WHEN 0 THEN (SELECT 'step: '+h1.step_name +' | '+ h1.message+ ' | step_ instance_id: ' + CAST(h1.instance_id AS VARCHAR(20)) FROM msdb.dbo.sysJobHistory h1
		CONCAT('"',CASE WHEN jh.run_status=0 AND @bitAllSteps=0 THEN (SELECT 'step: '+h1.step_name +' | '+ h1.message+ ' | step_ instance_id: ' + CAST(h1.instance_id AS VARCHAR(20)) FROM msdb.dbo.sysJobHistory h1
						WHERE h1.instance_id = (SELECT MAX(h11.instance_id) FROM msdb.dbo.sysJobHistory h11 WHERE h11.job_id=jh.job_id AND  h11.run_date=jh.run_date 
													AND h11.run_status = 0 AND h11.instance_id < jh.instance_id
													AND h11.step_id  =  case when PATINDEX('%The last step to run was step %', jh.message) <> 0 then 
			LTRIM(RTRIM(REPLACE(SUBSTRING(jh.message,PATINDEX('%The last step to run was step %', jh.message)+LEN('The last step to run was step '),4),'(','')))  
			        
			 
			 else h1.step_id  end 
													)
						)
			WHEN jh.step_id=0 THEN jh.step_name+' | '+jh.message
			ELSE 'step '+CONVERT(VARCHAR(10),jh.step_id)+': '+jh.step_name+' | '+jh.message END,'"')  AS  [job/step_message],
		jh.instance_id, jh.sql_message_id, jh.sql_severity,
		jh.server server_name
		
		-- !!xx!! ,  (CASE WHEN (@bitAllSteps=0 OR @bitAllSteps IS null) and jh.step_id = 0 THEN 1
		-- !!xx!! 		WHEN (@bitAllSteps=1) and jh.step_id >= 0 THEN 1
		-- !!xx!! 		ELSE 0
		-- !!xx!! 	END) AS [@bitAllSteps]
		-- !!xx!! , (CASE WHEN (@bitFailedOnly=0 OR @bitFailedOnly IS NULL) AND jh.run_status>=0 THEN 1
		-- !!xx!! 		WHEN @bitFailedOnly=1 AND  jh.run_status=0 THEN 1
		-- !!xx!! 		ELSE 0
		-- !!xx!! 	END) AS [@bitFailedOnly]
	FROM msdb.dbo.sysjobhistory jh
	RIGHT JOIN msdb.dbo.sysjobs j ON jh.job_id = j.job_id
	WHERE  
		-- select JOBs void-col
		(CASE WHEN @strJobName is null OR @strJobName=j.name THEN 1
					ELSE 0
			END) = 1
		-- [20170607] Select-filter only (outcome) step OR ALLSteps using IN:@bitAllSteps
		-- xxxx AND jh.step_id = 0
		AND (CASE WHEN (@bitAllSteps=0 OR @bitAllSteps IS null) and jh.step_id = 0 THEN 1
				WHEN (@bitAllSteps=1) and jh.step_id >= 0 THEN 1
				ELSE 0
			END) = 1
		-- ** [13:52 29/6/2017]
		-- ** filter only failed =(Failed, RETRY, Cancelled) or all run_status 
		AND (CASE WHEN (@bitFailedOnly=0 OR @bitFailedOnly IS NULL) AND jh.run_status>=0 THEN 1
				WHEN @bitFailedOnly=1 AND  (jh.run_status=0 OR jh.run_status=2 OR jh.run_status=3) THEN 1
				ELSE 0
			END) = 1
		-- ** filter only since StartTime set (start_datetime)
		AND CONVERT(DATETIME,CONVERT(CHAR(8),run_date) + ' ' +  STUFF(STUFF((LEFT('000000',6-LEN(run_time))+ CONVERT(VARCHAR(6),run_time)),3,0,':'),6,0,':'))
	   				>= @Time_Start
		
	ORDER BY 4 DESC, jh.instance_id DESC, 1 
	
	;
	--
	print ''
	print '___________________'
	print 'sql_message_id	ID of any SQL Server error message returned if the job failed.
	sql_severity	Severity of any SQL Server error.
	instance_id		Unique identifier for the row.
	run_duration	Elapsed time in the execution of the job or step in HHMMSS format.
	run_status	Status of the job execution:
				0 = -- Failed --
				1 = Succeeded
				2 = -- RETRY --
				3 = -- Cancelled --
				4 = In Progress' 
	print ''
	print ''	
END;
-- -- ** ENDoF: Check All Job Status  (detailed)
-- -- -- --



--
--
-- ** ENDoF sp_chk_JobsStatus_detail
SET NOCOUNT OFF
END;

GO
