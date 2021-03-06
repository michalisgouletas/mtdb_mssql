USE [master]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--
CREATE PROC dbo.sp_chk_zbx_Blocked_Deadl
 (@wdel as varchar(10) = '000:00:02' 	-- set delay time for DIFFerence: '000:00:10'
	, @avgWaiTime_ms bit = 0	-- [Average Wait Time (ms)]
	, @LkReqsPerSec	BIT = 0		-- [Lock Requests/sec]
	, @LkTimeoutsPerSec	BIT = 0 -- [Lock Timeouts (timeout > 0)/sec]
	, @LkWaitsPerSec BIT = 0	-- [Lock Waits/sec]
	, @NumOfDeadlocksPerSec BIT = 0 -- [Number of Deadlocks/sec]
	, @vExt BIT = 0 -- execute Extended version 
	, @vLog	BIT = 0	-- execute WITH log messages
 )
AS
/* *** -- Zabbix showDeadLockRpt metrics
* ---- [SYS-288] (2017-03-28T15:12:33)
*
* RETURNS metrics (SQLServer:Locks) UPON IN-Var bit selection
*	@avgWaiTime_ms			[Average Wait Time (ms)]
*	@LkReqsPerSec			[Lock Requests/sec]
*	@LkTimeoutsPerSec		[Lock Timeouts (timeout > 0)/sec]
*	@LkWaitsPerSec			[Lock Waits/sec]
*	@NumOfDeadlocksPerSec	[Number of Deadlocks/sec]
*** */
BEGIN;
SET NOCOUNT ON
-- -- -- ** dba\MSSQL\quick_checkDBs\hc_sp\sp_chk_Blocked_Deadl.sql
-- -- -- ** dba\MSSQL\wax_deadlocks\01.deadlock_info.sql
	/* * Get-Data
	This provides all the deadlocks that have happened on your server since the last restart.  
	We can look at this counter using the following SQL Statement:
	**/
	
	-- cr temp Metric Sel tb
	DECLARE @T_SelMetrics TABLE (counter_name NVARCHAR(130) null, sel_bit BIT null);
	INSERT INTO @T_SelMetrics ( counter_name, sel_bit ) VALUES
	  ( N'Average Wait Time (ms)', @avgWaiTime_ms ),
	  ( N'Lock Requests/sec', @LkReqsPerSec ),
	  ( N'Lock Timeouts (timeout > 0)/sec', @LkTimeoutsPerSec ),
	  ( N'Lock Waits/sec', @LkWaitsPerSec ),
	  ( N'Number of Deadlocks/sec', @NumOfDeadlocksPerSec )
	;																										  
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

	-- Logging
	IF (@vLog=1)
	BEGIN
		print ''
		-- Lock Waits Totals:
		print '/* -- **	Lock Waits Totals report:  */'
		print ' wait for DELAY (hhh:mi:ss) : '  + @wdel;
		print ''
		PRINT '-- '+ @@SERVERNAME+ '.'+DB_NAME()+ '.'+USER_NAME()+' ['+CONVERT(VARCHAR(19), GETDATE(),126)+'] -- IN-Vars given';
		SELECT * FROM @T_SelMetrics;
		--
	END;

	-- print results
	IF (@vExt=1)
	BEGIN
		--
		SELECT  pc.object_name, pc.counter_name, pc.cntr_value, t.cntr_value cntr_value_measured
			, pc.cntr_value - t.cntr_value as cntr_value_diff
			, case when ltrim(rtrim(pc.counter_name)) = 'Average Wait Time (ms)' then   cast(((pc.cntr_value - t.cntr_value)/1000)/60.00 as varchar(40) ) + ' (min)'
					ELSE null END  as cntr_value_diff2	
			FROM sys.dm_os_performance_counters pc inner join #tmpx_deadl t ON pc.counter_name=t.counter_name
				INNER JOIN @T_SelMetrics ON [@T_SelMetrics].counter_name = pc.counter_name AND [@T_SelMetrics].sel_bit=1 
			WHERE (pc.object_name = 'SQLServer:Locks' OR pc.object_name = 'MSSQL$MT22016SP1:Locks')
				AND (pc.counter_name = 'Number of Deadlocks/sec' OR pc.counter_name='Lock Waits/sec' OR pc.counter_name='Lock Timeouts (timeout > 0)/sec' 
						OR pc.counter_name='Lock Requests/sec' OR pc.counter_name='Average Wait Time (ms)')
			-- GET ONLY Totals  
			AND pc.instance_name = '_Total'
			ORDER BY 1,2
		;
	END;
	ELSE
	BEGIN
		--
		SELECT /*!! pc.counter_name, t.cntr_value cntr_value_measured
			,!!*/ pc.cntr_value - t.cntr_value as cntr_value_diff
			FROM sys.dm_os_performance_counters pc inner join #tmpx_deadl t ON pc.counter_name=t.counter_name
				INNER JOIN @T_SelMetrics ON [@T_SelMetrics].counter_name = pc.counter_name AND [@T_SelMetrics].sel_bit=1 
			WHERE (pc.object_name = 'SQLServer:Locks' OR pc.object_name = 'MSSQL$MT22016SP1:Locks')
				AND (pc.counter_name = 'Number of Deadlocks/sec' OR pc.counter_name='Lock Waits/sec' OR pc.counter_name='Lock Timeouts (timeout > 0)/sec' 
						OR pc.counter_name='Lock Requests/sec' OR pc.counter_name='Average Wait Time (ms)')
			-- GET ONLY Totals  
			AND pc.instance_name = '_Total'
			ORDER BY 1
		;
	END;
	--
	DROP table #tmpx_deadl;
	-- -- -- --
	
-- ** ENDoF sp_chk_zbx_Blocked_Deadl
SET NOCOUNT OFF
END;

GO
