USE [master]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--
CREATE PROC dbo.sp_chk_JobsLast
AS
BEGIN;
SET NOCOUNT ON
---------------------------------------------------------------------------------
-- latest (Datetime) JOB Execution status  
--	 ** {CONCAT(h.run_date , h.run_time)}
---------------------------------------------------------------------------------
-- -- **  wrk_abox\dba\MSSQL\MSSQL2005+\03_CheckJobStatus.sql
--
print ''
print getdate();
print '/* -- db SQL Job Status (by Latest Datetime) : */'
print ''
--
select /**distinct**/ j.Name as "Job Name"
	, DATENAME(DW, CONVERT(DATETIME,CONVERT(CHAR(8),run_date) + ' ' +  STUFF(STUFF((LEFT('000000',6-LEN(run_time))
				+ CONVERT(VARCHAR(6),run_time)),3,0,':'),6,0,':'))
		) WDay
	, CONVERT(DATETIME, CONVERT(CHAR(8),run_date) + ' ' +  STUFF(STUFF((LEFT('000000',6-LEN(run_time))
			+ CONVERT(VARCHAR(6),run_time)),3,0,':'),6,0,':')) LastStatusDateTime
	-- where to DATEadd
	, -- ** [2016-04-11 14:16] exclude non-physical run_duration (6-digits) times like: -954439132	
    CASE WHEN LEN(h.run_duration) < 7 then
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
	AS job_end_datetime
	, CASE WHEN LEN(h.run_duration) < 7 THEN STUFF(STUFF((LEFT('000000',6-LEN(run_duration))+ CONVERT(VARCHAR(6),run_duration)),3,0,':'),6,0,':') 
	 ELSE concat('** ',h.run_duration, ' **')
	 END AS [duration_HH:MM:SS]
	,case h.run_status 
		when 0 then '-- Failed --' 
		when 1 then 'Succeeded'
		WHEN 2 THEN '-- RETRY --' 
		when 3 then '-- Cancelled --' 
		when 4 then 'In Progress' 
	end as JobStatus
	, j.enabled IsJobEnabled
	-- ** Job Outcome or failed-Job message
	, CASE h.run_status
		 WHEN 0 THEN (SELECT 'step: '+h1.step_name +' | '+ h1.message FROM msdb.dbo.sysJobHistory h1
						WHERE h1.instance_id = (SELECT MAX(h11.instance_id) FROM msdb.dbo.sysJobHistory h11 WHERE h11.job_id=h.job_id AND  h11.run_date=h.run_date 
													AND h11.step_id = case when PATINDEX('%The last step to run was step %', h.message) <> 0 then LTRIM(RTRIM(REPLACE(SUBSTRING(h.message,PATINDEX('%The last step to run was step %', h.message)+LEN('The last step to run was step '),4),'(','')))
													else h11.step_id end
													)
						)
		 ELSE h.message END  AS  [job/step_message]
	-- ** job schedule info
	/* The sysjobschedules table refreshes every 20 minutes, which may affect the values returned by the sp_help_jobschedule stored procedure.
	Applies to: SQL Server (SQL Server 2008 through current version). */
	, js.schedule_id
	, CASE WHEN ISDATE(js.next_run_date)=1 THEN DATENAME(DW, CONVERT(DATETIME,CONVERT(CHAR(8),js.next_run_date) ))  ELSE NULL END  NextRun_WDay
	, CASE WHEN ISDATE(js.next_run_date)=1 THEN CONVERT(DATETIME, CONVERT(CHAR(8),js.next_run_date) + ' ' +  STUFF(STUFF((LEFT('000000',6-LEN( js.next_run_time))
			+ CONVERT(VARCHAR(6),js.next_run_time)),3,0,':'),6,0,':'))  ELSE NULL END  [next_run_time(*)]
	-- ** job info
	, j.description as "Job Description", j.job_id
from msdb.dbo.sysJobHistory h RIGHT JOIN msdb.dbo.sysJobs j ON j.job_id = h.job_id
		LEFT JOIN msdb.dbo.sysjobschedules js ON j.job_id=js.job_id 
where  h.step_id = 0 -- only (outcome) step
	-- ** GET only latest RUN DATETIME
	AND CONCAT(h.run_date , RIGHT('000000' + CAST(h.run_time AS VARCHAR(20)),6)) = (select max(CONCAT(hi.run_date , RIGHT('000000' + CAST(hi.run_time AS VARCHAR(20)),6))) from msdb.dbo.sysJobHistory hi 
																					WHERE hi.job_id = h.job_id  AND hi.step_id = 0 )
order by 4 desc,1
;
--
print ''
PRINT '___________________'
PRINT '(*) NOTE: sysjobschedules table refreshes every 20 minutes, which may affect the values returned by the sp_help_jobschedule stored procedure.
	Applies to: SQL Server (SQL Server 2008 through current version).'
PRINT ''
-- -- ** ENDoF: server Logread errors, failed
-- -- -- --
--

-- ** ENDoF sp_chk_JobsLast
SET NOCOUNT OFF
END;

GO
