USE [master]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROC [dbo].[sp_chk_GetJob]
-- ALTER PROC dbo.sp_chk_GetJob
	(	-- Set errorLog id : {0 (Current) , 1 - 6}
		@str_sysproc_job varchar(2000) = NULL	-- * DEFAULT null output
	)
AS
BEGIN;
SET NOCOUNT ON
--------------------------------------------------------------------------------- 
-- Date: 2015-06-18 12:48:06.910
-- Check Job Status  (detailed)
-- get  JobID  from
--	 sys.processes.program : SQLAgent - TSQL JobStep (Job 0x42CCD72503E4A14B96C3D455D489469C : Step 1)
--	OR : MT1.[ais] : INSERT : runnable : SQLAgent - TSQL JobStep (Job 0x48CD8BDD1AF7414E83FC332C99353233 : Step 1)
--
-- EXECUTE dbo.sp_chk_GetJob @str_sysproc_job = 'SQLAgent - TSQL JobStep (Job 0x48CD8BDD1AF7414E83FC332C99353233 : Step 1)';
--------------------------------------------------------------------------------- 
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

-- xx D.P
-- xx DECLARE @str_sysproc_job varchar(1000);
-- xx select @str_sysproc_job = 'MT1.[ais] : INSERT : runnable : SQLAgent - TSQL JobStep (Job 0x48CD8BDD1AF7414E83FC332C99353233 : Step 1)';

IF @str_sysproc_job IS NULL
BEGIN;
	PRINT 'Insert var like'+CHAR(13)+'   sys.processes.program : '+CHAR(13)+'  SQLAgent - TSQL JobStep (Job 0x42CCD72503E4A14B96C3D455D489469C : Step 1)';
	RETURN;
END;


-- get JobId identifier from 'str_sysproc_job' in var
select @str_sysproc_job = substring(@str_sysproc_job, patindex('%Job % : Step %', @str_sysproc_job)+4, patindex('% : Step %', @str_sysproc_job) - (patindex('%Job % : Step %', @str_sysproc_job)+4) );

/* ? */
--
SELECT 
    j.Name as Job_Name,
     CONVERT(DATETIME,CONVERT(CHAR(8),jh.run_date) + ' ' +  STUFF(STUFF((LEFT('000000',6-LEN(run_time))+ CONVERT(VARCHAR(6),run_time)),3,0,':'),6,0,':')) AS start_datetime,
	 --	
     dateadd(second,
     -- what to DATEadd
		(cast(left(LEFT('000000',6-LEN(run_duration))+ CONVERT(VARCHAR(6),run_duration), 2) as int)*60*60
		  + cast(substring(LEFT('000000',6-LEN(run_duration))+ CONVERT(VARCHAR(6),run_duration),3,2)*60 as int)
		  + cast(right(LEFT('000000',6-LEN(run_duration))+ CONVERT(VARCHAR(6),run_duration), 2) as int)) ,
		-- where to DATEadd
		CONVERT(DATETIME,CONVERT(CHAR(8),run_date) + ' ' +  STUFF(STUFF((LEFT('000000',6-LEN(run_time))+ CONVERT(VARCHAR(6),run_time)),3,0,':'),6,0,':')))
	  AS end_datetime,
     --
     STUFF(STUFF((LEFT('000000',6-LEN(run_duration))+ CONVERT(VARCHAR(6),run_duration)),3,0,':'),6,0,':') [duration_HH:MM:SS] ,
     case run_status 
		when 0 then 'Failed'
		when 1 then 'Succeeded'
		when 2 then 'Retry'
		when 3 then 'Canceled'
		when 4 then 'In Progress' 
	 END as job_run_status,
     -- on error
     sql_message_id, sql_severity ,message, instance_id sysjobhistory_instance_id,
     server server_name,
	 '-- --' [_ sep _]
	 , js.schedule_id
	, DATENAME(DW, CONVERT(DATETIME,CONVERT(CHAR(8),js.next_run_date) )) NextRun_WDay
	, CONVERT(DATETIME, CONVERT(CHAR(8),js.next_run_date) + ' ' +  STUFF(STUFF((LEFT('000000',6-LEN( js.next_run_time))
			+ CONVERT(VARCHAR(6),js.next_run_time)),3,0,':'),6,0,':')) next_run_timetime
	, j.job_id
 FROM msdb.dbo.sysjobhistory jh
 INNER JOIN msdb.dbo.sysjobs j ON jh.job_id = j.job_id
	LEFT JOIN msdb.dbo.sysjobschedules js ON jh.job_id=js.job_id 

 WHERE 
	step_id = 0 -- only (outcome) step
 -- Failed jobs
 -- or jh.run_status=0
  /* * SET Job id from sysprocesses */
   AND right(replace(j.job_id, '-', ''),16) = right(@str_sysproc_job,16)
	
 ORDER BY 3 desc,1
 ;

-- ** ENDoF sp_chk_GetJob
SET NOCOUNT OFF
END;

GO
