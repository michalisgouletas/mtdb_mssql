USE [master]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--
CREATE PROC dbo.sp_chk_Batch_Mem
AS
BEGIN;
SET NOCOUNT ON
------------------------------------------------------------------------------------------- 
-- How many requests SQL Server is processing?
-- [http://www.mssqltips.com/sqlservertip/2522/sql-server-monitoring-checklist/]
-------------------------------------------------------------------------------------------
-- --
print ''
print '/* -- Batch Requests/sec AND Avail Mem on SQLServer: */'
print ''
--
-- How many requests SQL Server is processing?
-- [http://www.mssqltips.com/sqlservertip/2522/sql-server-monitoring-checklist/]
--
DECLARE @BRPS BIGINT
SELECT @BRPS=cntr_value 
	FROM sys.dm_os_performance_counters
	WHERE counter_name LIKE 'Batch Requests/sec%'
	WAITFOR DELAY '000:00:10'
-- -- ** ENDoF: How many requests SQL Server is processing?
-- -- -- --
-- check the memory on server, use the dynamic management view dm_os_sys_memory, along with the above Batch/reqs
-- [https://msdn.microsoft.com/en-us/library/bb510493.aspx]
--
SELECT CONVERT(VARCHAR(50), SERVERPROPERTY(ltrim(rtrim('Servername')))) [server\instance]
	, (opc.cntr_value-@BRPS)/10.0 AS "Batch Requests/sec"		
	, sm.available_physical_memory_kb/1024 as "Total_Avail_Memory_MB"
	, sm.available_physical_memory_kb/(sm.total_physical_memory_kb*1.0)*100 AS "%_Memory_Free"
	, cast(sm.total_physical_memory_kb/1024 as varchar(10)) + 'MB ('+ cast(round(sm.total_physical_memory_kb/1024/1024.00,4) as varchar(20)) + ' GB)'   as  [Total_Phys_Mem MB(GB]
	, sm.system_memory_state_desc
	, convert(varchar(20),getdate(),120) Checked_dt /*, sm.**/
FROM sys.dm_os_sys_memory sm, sys.dm_os_performance_counters opc WHERE opc.counter_name LIKE 'Batch Requests/sec%'
;
--
print '____ ___________________'
print '(**) system_memory_state_desc'
print '------------------------'
print 'Condition | Value'
print '. system_high_memory_signal_state = 1 and system_low_memory_signal_state = 0'
print ' -> Available physical memory is high'
print '. system_high_memory_signal_state = 0 and system_low_memory_signal_state = 1'
print ' -> Available physical memory is low'
print '. system_high_memory_signal_state = 0 and system_low_memory_signal_state = 0'
print ' -> Physical memory usage is steady'
print '. system_high_memory_signal_state = 1 and system_low_memory_signal_state = 1'
print ' -> Physical memory state is transitioning'
print '	The high and low signal should never be on at the same time. However, rapid changes at the operating system level can cause both values to appear to be on to a user mode application.'
print '	The appearance of both signals being on will be interpreted as a transition state.'
print ''
-- -- ** ENDoF: check the memory on server, use the dynamic management view dm_os_sys_memory
-- -- -- --
--

-- ** ENDoF sp_chk_Batch_Mem
SET NOCOUNT OFF
END;

GO
