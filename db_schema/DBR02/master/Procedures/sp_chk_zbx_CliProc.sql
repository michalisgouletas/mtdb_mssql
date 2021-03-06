USE [master]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--
CREATE PROC dbo.sp_chk_zbx_CliProc
 (/*x!x @wdel as varchar(10) = '000:00:02' 	-- set delay time for DIFFerence: '000:00:10'
	, x!x*/ 
	@strDBname as varchar(100) = null -- * DEFAULT = null (show all DBs)
	, @CliProcsCnt bit = 0	-- [CliProcsCnt]
	, @sumCPU	BIT = 0		-- [sumCPU_ms]
	, @sumConnSecs	BIT = 0 -- [sumConnSecs]
	, @Score BIT = 0	-- [Score (sumCPU_ms/sumConnSecs)]
	, @ProgramBadnessFactor BIT = 0 -- [ProgramBadnessFactor]
	, @minlastbatchbef_d BIT = 0 -- [min_last_batch_bef_d]
	, @maxlastbatchbef_d BIT = 0 -- [max_last_batch_bef_d]
	, @vExt BIT = 0 -- execute Extended version 
	, @vLog	BIT = 0	-- execute WITH log messages
 )
AS
/* *** -- Zabbix showDeadLockRpt metrics
* ---- [SYS-288] (2017-04-24T19:07)
*
* RETURNS metrics (Client Procs  CHECK: (sysprocesses)) UPON IN-Var bit selection
*	@CliProcsCnt			-- [CliProcsCnt]
*	@sumCPU					-- [sumCPU_ms]
*	@sumConnSecs			-- [sumConnSecs]
*	@Score					-- [Score (sumCPU_ms/sumConnSecs)]
*	@ProgramBadnessFactor	-- [ProgramBadnessFactor]
*	@minlastbatchbef_d		-- [min_last_batch_bef_d]
*	@maxlastbatchbef_d		-- [max_last_batch_bef_d]
*** */
BEGIN;
SET NOCOUNT ON
-- -- -- ** dba\MSSQL\quick_checkDBs\hc_sp\sp_chk_CliProc_Hogs.sql
-- -- -- ** dba\MSSQL\MSSQL2005+\04_sysprocesses_mon.sql
	/* * Get-Data
	This provides all the deadlocks that have happened on your server since the last restart.  
	We can look at this counter using the following SQL Statement:
	**/
	
	-- cr temp Metric Sel tb
	DECLARE @T_SelMetrics TABLE (counter_name NVARCHAR(130) null, sel_bit BIT null);
	INSERT INTO @T_SelMetrics ( counter_name, sel_bit ) VALUES
	  ( N'CliProcsCnt', @CliProcsCnt ),
	  ( N'sumCPU_ms', @sumCPU ),
	  ( N'sumConnSecs', @sumConnSecs ),
	  ( N'Score (sumCPU_ms/sumConnSecs)', @Score ),
	  ( N'ProgramBadnessFactor', @ProgramBadnessFactor ),
	  ( N'min_last_batch_bef_d', @minlastbatchbef_d ),
	  ( N'max_last_batch_bef_d', @maxlastbatchbef_d )
	;																										  
	/*x!x  ( ONLY for Diff : @wdel )
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
	xx!!xx */

	-- Logging
	IF (@vLog=1)
	BEGIN
		print ''
		-- Client Procs  CHECK:
		print '/* -- **	Client Procs  CHECK: (sysprocesses)  */'
		PRINT '-- For DB: ' + CASE WHEN @strDBname is null then '<ALL DBs>' ELSE '['+@strDBname+']' END;
		print ''
		PRINT '-- '+ @@SERVERNAME+ '.'+DB_NAME()+ '.'+USER_NAME()+' ['+CONVERT(VARCHAR(19), GETDATE(),126)+'] -- IN-Vars given';
		SELECT * FROM @T_SelMetrics;
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
	END;

	-- print results
	IF (@vExt=1)
	BEGIN
		--
		WITH cte_ps AS (
		SELECT 
			convert(float,count(*)) as CliProcsCnt  , sum(convert(float,s.cpu)) as sumCPU_ms
			--!! , sum(datediff(second, s.login_time, getdate())) as sumConnSecs
			--!! /*, sum(datediff(MINUTE, s.login_time, getdate())) as sumConnMins*/
			--!! , convert(varchar(10), sum(datediff(MINUTE, s.login_time, getdate()))) + 'min (' + convert(varchar(10),sum(datediff(hour, s.login_time, getdate()))) + 'hrs )' as [sumConnTime]
			, CASE WHEN convert(float, sum(datediff(second, s.login_time, getdate()))) <> 0 then convert(float, sum(cast(s.cpu AS real))) / convert(float, sum(datediff(second, s.login_time, getdate())))
				ELSE null -- DevideByZero Error
				 END as [Score (sumCPU_ms/sumConnSecs)]
			, CASE WHEN convert(float, sum(datediff(second, s.login_time, getdate()))) <> 0 then convert(float, sum(cast(s.cpu AS real))) / convert(float, sum(datediff(second, s.login_time, getdate()))) / count(*)
				ELSE convert(float,null) -- DevideByZero Error
				 END as ProgramBadnessFactor
			--, MIN(s.last_batch) min_last_batch, MAX(s.last_batch) max_last_batch
			, CONVERT(FLOAT,DATEDIFF(DAY,MIN(s.last_batch),GETDATE())) min_last_batch_bef_d, CONVERT(FLOAT,DATEDIFF(DAY,MAX(s.last_batch),GETDATE())) max_last_batch_bef_d
		FROM sys.sysprocesses s LEFT JOIN 
					(SELECT sdb.*
					-- SELECTion void COL for: @strDBname:
					, CASE WHEN db_id(@strDBname) is null OR db_id(@strDBname)=sdb.dbid THEN 1 ELSE 0
					  END as sel_db_void FROM sys.sysdatabases sdb
					) AS d
					on s.dbid = d.dbid
		WHERE s.spid > 50  
			-- choose One or ALL DBs, upon: @strDBname
			AND d.sel_db_void=1

		)
		SELECT [@T_SelMetrics].sel_bit, a.counter_name, a.value cntr_value FROM @T_SelMetrics 
		-- !!!! sel_bit Join
		INNER JOIN (
			SELECT counter_name, value
			FROM cte_ps
			UNPIVOT (
						value FOR counter_name IN (cte_ps.CliProcsCnt, cte_ps.sumCPU_ms, cte_ps.[Score (sumCPU_ms/sumConnSecs)] ,
						cte_ps.ProgramBadnessFactor , cte_ps.min_last_batch_bef_d , cte_ps.max_last_batch_bef_d )
					) unpvt
			) as a 
			ON [@T_SelMetrics].counter_name=a.counter_name  --!! AND [@T_SelMetrics].sel_bit=1
		;
	END;
	ELSE
	BEGIN
		--
		WITH cte_ps AS (
		SELECT 
			convert(float,count(*)) as CliProcsCnt  , sum(convert(float,s.cpu)) as sumCPU_ms
			--!! , sum(datediff(second, s.login_time, getdate())) as sumConnSecs
			--!! /*, sum(datediff(MINUTE, s.login_time, getdate())) as sumConnMins*/
			--!! , convert(varchar(10), sum(datediff(MINUTE, s.login_time, getdate()))) + 'min (' + convert(varchar(10),sum(datediff(hour, s.login_time, getdate()))) + 'hrs )' as [sumConnTime]
			, CASE WHEN convert(float, sum(datediff(second, s.login_time, getdate()))) <> 0 then convert(float, sum(cast(s.cpu AS real))) / convert(float, sum(datediff(second, s.login_time, getdate())))
				ELSE null -- DevideByZero Error
				 END as [Score (sumCPU_ms/sumConnSecs)]
			, CASE WHEN convert(float, sum(datediff(second, s.login_time, getdate()))) <> 0 then convert(float, sum(cast(s.cpu AS real))) / convert(float, sum(datediff(second, s.login_time, getdate()))) / count(*)
				ELSE convert(float,null) -- DevideByZero Error
				 END as ProgramBadnessFactor
			--!! , MIN(s.last_batch) min_last_batch, MAX(s.last_batch) max_last_batch
			, CONVERT(FLOAT,DATEDIFF(DAY,MIN(s.last_batch),GETDATE())) min_last_batch_bef_d, CONVERT(FLOAT,DATEDIFF(DAY,MAX(s.last_batch),GETDATE())) max_last_batch_bef_d
		FROM sys.sysprocesses s LEFT JOIN 
					(SELECT sdb.*
					-- SELECTion void COL for: @strDBname:
					, CASE WHEN db_id(@strDBname) is null OR db_id(@strDBname)=sdb.dbid THEN 1 ELSE 0
					  END as sel_db_void FROM sys.sysdatabases sdb
					) AS d
					on s.dbid = d.dbid
		WHERE s.spid > 50  
			-- choose One or ALL DBs, upon: @strDBname
			AND d.sel_db_void=1

		)
		--SELECT cte_ps.CliProcsCnt,cte_ps.sumCPU_ms ,
		--                          cte_ps.[Score (sumCPU_ms/sumConnSecs)] ,
		--                          cte_ps.ProgramBadnessFactor ,
		--                          cte_ps.min_last_batch_bef_d ,
		--                          cte_ps.max_last_batch_bef_d FROM cte_ps
		SELECT /*!![@T_SelMetrics].sel_bit, a.counter_name,!!*/ a.value cntr_value  FROM @T_SelMetrics 
		-- !!!! sel_bit Join
		INNER JOIN (
			SELECT counter_name, value
			FROM cte_ps
			UNPIVOT (
						value FOR counter_name IN (cte_ps.CliProcsCnt, cte_ps.sumCPU_ms, cte_ps.[Score (sumCPU_ms/sumConnSecs)] ,
						cte_ps.ProgramBadnessFactor , cte_ps.min_last_batch_bef_d , cte_ps.max_last_batch_bef_d )
					) unpvt
			) as a 
			ON [@T_SelMetrics].counter_name=a.counter_name  AND [@T_SelMetrics].sel_bit=1
		;
	END;
	--
	-- -- -- --
	
-- ** ENDoF sp_chk_zbx_CliProc
SET NOCOUNT OFF
END;

GO
