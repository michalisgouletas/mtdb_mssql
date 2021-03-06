USE [master]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION  [dbo].[fn_chk_GetJobName]
	(	-- Set errorLog id : {0 (Current) , 1 - 6}
		@str_sysproc_job varchar(2000) = NULL	-- * DEFAULT null output
	)
RETURNS varchar(500)
AS
BEGIN;
DECLARE @rtnJobName varchar(500);
--------------------------------------------------------------------------------- 
-- Date: 11:05 9/10/2015
-- Get JobName
-- 	get  JobID  from
--	 sys.processes.program := SQLAgent - TSQL JobStep (Job 0x42CCD72503E4A14B96C3D455D489469C : Step 1)
--	OR := MT1.[ais] : INSERT : runnable : SQLAgent - TSQL JobStep (Job 0x48CD8BDD1AF7414E83FC332C99353233 : Step 1)
--
--  USE: 
--		SELECT  dbo.fn_chk_GetJobName('SQLAgent - TSQL JobStep (Job 0xC1E1BDA471522A4CA1DAD18EE07C6629 : Step 1)')
--------------------------------------------------------------------------------- 
/*
[http://thinknook.com/get-sql-server-job-agent-execution-information-and-history-2012-11-09/]
[http://msdn.microsoft.com/en-us/library/ms174997.aspx]

ref:
	[D:\Docs\dbadmin\wrk_abox\dba\MSSQL\quick_checkDBs\hc_sp\sp_chk_GetJob.sql]
*/

-- xx D.P
-- xx DECLARE @str_sysproc_job varchar(1000);
-- xx select @str_sysproc_job = 'MT1.[ais] : INSERT : runnable : SQLAgent - TSQL JobStep (Job 0x48CD8BDD1AF7414E83FC332C99353233 : Step 1)';

IF @str_sysproc_job IS NULL OR  @str_sysproc_job not like 'SQLAgent%(Job%'
BEGIN;
	-- [xxxx] RETURN print '[fn_chk_GetJobName] IN Var Error: Insert var from'+CHAR(10)+'   sys.processes.program like : '+CHAR(10)+'  SQLAgent - TSQL JobStep (Job 0x42CCD72503E4A14B96C3D455D489469C : Step 1)';
	RETURN null;
END;
--

-- get JobId identifier from 'str_sysproc_job' in var
select @str_sysproc_job = substring(@str_sysproc_job, patindex('%Job % : Step %', @str_sysproc_job)+4, patindex('% : Step %', @str_sysproc_job) - (patindex('%Job % : Step %', @str_sysproc_job)+4) );

/* ? */
--
SELECT 
    @rtnJobName = j.Name
 FROM msdb.dbo.sysjobhistory jh
 INNER JOIN msdb.dbo.sysjobs j ON jh.job_id = j.job_id
	LEFT JOIN msdb.dbo.sysjobschedules js ON jh.job_id=js.job_id 
 WHERE 
	jh.step_id = 0 -- only (outcome) step
 -- Failed jobs
 -- or jh.run_status=0
  /* * SET Job id from sysprocesses */
   AND right(replace(j.job_id, '-', ''),16) = right(@str_sysproc_job,16)
 ;

RETURN @rtnJobName;
-- ** ENDoF fn_chk_GetJobName
--xxxx SET NOCOUNT OFF
END;

GO
