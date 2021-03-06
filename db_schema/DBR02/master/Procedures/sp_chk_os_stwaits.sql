USE [master]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--
CREATE PROC dbo.sp_chk_os_stwaits
AS
BEGIN;
SET NOCOUNT ON
------------------------------------------------------------------------------------------- 
-- sys.dm_os_wait_stats:
--	. [http://www.brentozar.com/responder/triage-wait-stats-in-sql-server/]
-------------------------------------------------------------------------------------------
-- --
print ''
print '/* -- Check (sys.dm_os_wait_stats) OS STATS  and  WAITs: */'

--
--
/* os_Stats waits _v2 */
------------------------
-- sp_chk_os_stwaits
-- set delay time '000:00:10'
declare @wdel as varchar(10) = '000:00:10'
print ' wait for DELAY (hhh:mi:ss) : '  + @wdel;
print ''
-- set intitial counter-measure values
select 
	osw.cnt_os_workers, ost.cnt_os_tasks
	, ' wait_type:'+ ows.wait_type +' -> ' [______]
	, ows.waiting_tasks_count, ows.wait_time_ms, ows.max_wait_time_ms, ows.signal_wait_time_ms
	, agr1.[AVG(schedulers_work_queue_count)]
	, convert(varchar(20),getdate(),120) Checked_dt 
INTO #tmp_os_waits
from sys.dm_os_sys_info osi , 
	(select COUNT(*) cnt_os_workers
		from sys.dm_os_workers ) osw ,
	(select COUNT(*) cnt_os_tasks
		from sys.dm_os_tasks) ost ,
	-- sys.dm_os_wait_stats
	sys.dm_os_wait_stats ows ,
	(SELECT AVG(work_queue_count) [AVG(schedulers_work_queue_count)] FROM sys.dm_os_schedulers 
		WHERE status = 'VISIBLE ONLINE') agr1
where ows.wait_type = 'THREADPOOL'
WAITFOR DELAY @wdel
;

-- print results
print ''
print 'current timestamp: ' + cast(getdate() as varchar(20));

-- 
-- SELECT * FROM #tmp_os_waits
select osi.cpu_count, osi.hyperthread_ratio
	, osi.physical_memory_kb/1024 physical_memory_mb
	, osi.max_workers_count, osi.scheduler_count
	, CONVERT(VARCHAR(10),osw.cnt_os_workers)+ ' | ' + CONVERT(VARCHAR(10),osw.cnt_os_workers-tmpos.cnt_os_workers) [cnt_os_workers | Diff]
	, CONVERT(VARCHAR(10),ost.cnt_os_tasks)+ ' | ' + CONVERT(VARCHAR(10),ost.cnt_os_tasks-tmpos.cnt_os_tasks) [cnt_os_tasks | Diff]
	, CONVERT(VARCHAR(10),agr1.[AVG(schedulers_work_queue_count)])+ ' | ' + CONVERT(VARCHAR(10),agr1.[AVG(schedulers_work_queue_count)]-tmpos.[AVG(schedulers_work_queue_count)]) [AVG(schedulers_work_queue_cnt) | Diff]
	, osi.sqlserver_start_time
	, CONVERT(VARCHAR(20),tmpos.Checked_dt) + ' | '+@wdel [Sample_Checked_dt | Delay]
from sys.dm_os_sys_info osi , 
	(select COUNT(*) cnt_os_workers
		from sys.dm_os_workers ) osw ,
	(select COUNT(*) cnt_os_tasks
		from sys.dm_os_tasks) ost ,
	(SELECT AVG(work_queue_count) [AVG(schedulers_work_queue_count)] FROM sys.dm_os_schedulers 
		WHERE status = 'VISIBLE ONLINE') agr1,
	-- tmp
	#tmp_os_waits tmpos
;
-- -- wait_type = 'THREADPOOL'
-- dm_os_wait_time: TOTAL
Select
	' wait_type:'+ ows.wait_type +' -> ' [______]
	, CONVERT(VARCHAR(20),ows.waiting_tasks_count)+ ' | ' + CONVERT(VARCHAR(20),ows.waiting_tasks_count-tmpos.waiting_tasks_count) [waiting_tasks_count | Diff]
	, CONVERT(VARCHAR(20),ows.wait_time_ms)+ ' | ' + CONVERT(VARCHAR(20),ows.wait_time_ms-tmpos.wait_time_ms) [wait_time_ms | Diff]
	, CONVERT(VARCHAR(20),ows.max_wait_time_ms)+ ' | ' + CONVERT(VARCHAR(20),ows.max_wait_time_ms-tmpos.max_wait_time_ms) [max_wait_time_ms | Diff]
	, CONVERT(VARCHAR(20),ows.signal_wait_time_ms)+ ' | ' + CONVERT(VARCHAR(20),ows.signal_wait_time_ms-tmpos.signal_wait_time_ms) [signal(cpu)_wait_time_ms | Diff]
	--
	, ' dm_os_wait_time: TOTAL -> ' [______]
	, agr1.signal_wait_time_ms, agr1.[%signal (cpu) waits], agr1.resource_wait_time_ms, agr1.[%resource waits]
from sys.dm_os_sys_info osi , 
	-- sys.dm_os_wait_stats
	sys.dm_os_wait_stats ows,
	-- agr1
	(Select signal_wait_time_ms=sum(signal_wait_time_ms)
          ,'%signal (cpu) waits' = cast(100.0 * sum(signal_wait_time_ms) / sum (wait_time_ms) as numeric(20,2))
          ,resource_wait_time_ms=sum(wait_time_ms - signal_wait_time_ms)
          ,'%resource waits'= cast(100.0 * sum(wait_time_ms - signal_wait_time_ms) / sum (wait_time_ms) as numeric(20,2))
	FROM sys.dm_os_wait_stats ) agr1,

	-- tmp
	#tmp_os_waits tmpos
where ows.wait_type = 'THREADPOOL'
;

--
DROP TABLE #tmp_os_waits
;
--
print ''
print '____ ___________________'
PRINT '(*) sys.dm_os_workers'
print '------------------------'
print '	max_workers_count (int):	Represents the maximum number of workers that can be created.'
print '	scheduler_count	 (int):		Represents the number of user schedulers configured in the SQL Server process'
print '    [https://msdn.microsoft.com/en-us/library/ms175048.aspx]'
print '------------------------'
PRINT '(**) sys.dm_os_wait_stats'
print '------------------------'
PRINT 'The total amount of time waiting consists of RESOURCE and SIGNAL WAITS'
print '>  The time waiting for a resource is shown as Resource Waits'
print '>  The time waiting in the runnable queue for CPU is called Signal Waits.'
PRINT '** NOTE: If Signal (CPU) Waits are a significant percentage of total waits, you have CPU pressure which may be alleviated by faster or more CPUs.'
PRINT '		CPU pressure can be reduced by eliminating unnecessary sorts (indexes can avoid sorts in order & group by’s) and joins, and compilations (and re-compilations).'
PRINT '------------------------'
print 'The counters are reset each time SQL server is restarted, or when the following command is run:'
print '		DBCC SQLPERF (''sys.dm_os_wait_stats'', CLEAR);'
PRINT ''
-- -- ** ENDoF:  Check (sys.dm_os_wait_stats) OS_STATS  and  WAITs: 
-- -- -- --
--

-- ** ENDoF sp_chk_os_stwaits
SET NOCOUNT OFF
END;

GO
