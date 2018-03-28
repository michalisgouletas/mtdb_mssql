USE [ais_replica]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--
-- CREATE 
CREATE PROCEDURE dbo.[refrs_SHIPGTMASTER_batch_usp]
AS
/* *** (CORE-5100) : WeeklyRefresh_ais_tbs_on[ais_replica]\crsp_refrs_SHIPGTMASTER_batch_dbr02.sql
** 	crsp_refr_PORTS_batch_br02.sql
**	[22:00 11/2/2018] 
** 
** 	
*** */
BEGIN;
	SET NOCOUNT ON;
	--???? SET DEADLOCK_PRIORITY HIGH;
	DECLARE @pknm sysname, @idxstr NVARCHAR(2000);
	DECLARE @DetErrorMess VARCHAR(MAX), @ErrorSeverity  tinyint, @ErrorState tinyint;
	
	
	/* Spacial Index drop is required along with PK, for [ROUTES_TEMP] tb:
	Could not drop the primary key constraint 'PK_ROUTES_1' because the table has an XML or spatial index.*/
	SELECT @pknm=si.name FROM sys.indexes si WHERE si.name IN ('PK_SHIP_GT_MASTER', 'PK_SHIP_GT_MASTER_1') AND si.object_id=OBJECT_ID('SHIP_GT_MASTER_TEMP');
	IF EXISTS (SELECT @pknm)
		BEGIN
		PRINT '**** [refrs_SHIPGTMASTER_batch_usp] (spid '+CONVERT(VARCHAR(10),@@SPID)+') : '+ @@SERVERNAME+ '.'+DB_NAME()+ '.'+USER_NAME()+' ['+CONVERT(VARCHAR(19), GETDATE(),126)+'] Dropping Idx (PK): '+@pknm;
		SET @idxstr = N'ALTER TABLE dbo.[SHIP_GT_MASTER_TEMP] DROP CONSTRAINT ['+ @pknm +'];'
		--xx D.P  PRINT @idxstr;
		EXEC sp_executesql @idxstr;
	-- ENDoF: DROP indexes
	END;
		
	--
	BEGIN TRY
		-- 
		BEGIN TRAN;
		--
		print '[' + convert(varchar(20),getdate(),120) + '] TRUNCATE'
		truncate table [SHIP_GT_MASTER_TEMP] ;
		-- start INSERT
		print '[' + convert(varchar(20),getdate(),120) + '] , start INSERT on table'
		print ''
		--xx SET STATISTICS io, TIME ON;
		
		--xx?? (ommitted from tb-DDL) set identity_insert [ROUTES_TEMP] ON;
		INSERT INTO dbo.SHIP_GT_MASTER_TEMP	( TIMESTAMP , CREATED , UPDATED , IMO_NUMBER , NAME , STATUS , MMSI_CODE , VESSEL_TYPE , GROSS_TONNAGE , SUMMER_DWT , BUILD , BUILDER , BUILDER_ID , FLAG , LAST_KNOWN_FLAG 
			, HOME_PORT , REGISTRATION_NUMBER , CLASS_SOCIETY , CLASS_SOCIETY_ID , MANAGER_OWNER , MANAGER_OWNER_ID , MANAGER_OWNER_LOCATION , MANAGER_OWNER_TOWN , MANAGER_OWNER_COUNTRY , MANAGER_OWNER_EMAIL 
			, MANAGER_OWNER_WEBSITE , MANAGER , MANAGER_ID , MANAGER_LOCATION , MANAGER_TOWN , MANAGER_COUNTRY , MANAGER_EMAIL , MANAGER_WEBSITE , OWNER , OWNER_ID , OWNER_LOCATION , OWNER_TOWN , OWNER_COUNTRY 
			, OWNER_EMAIL , OWNER_WEBSITE , INSURER , INSURER_ID , PLACE_OF_BUILD , BUILD_START , BUILD_END , DATE_OF_ORDER , DELIVERY_DATE , KEEL_LAID , LAUNCH_DATE , STEEL_CUTTING , YARD_NUMBER , CLASS_ASSIGNMENT 
			, CLASS_NOTATION , LAST_DRYDOCK_SURVEY , LAST_HULL_SURVEY , LAST_SPECIAL_SURVEY , NEXT_DRYDOCK_SURVEY , NEXT_HULL_SURVEY , NEXT_SPECIAL_SURVEY , SPEED_SERVICE , SPEED_TRIAL , SPEED_MAX , SERVICE_LIMIT 
			, TRADING_AREAS , BOW_TO_BRIDGE , BOW_TO_CENTER_MANIFOLD , BREADTH_REGISTERED , BREADTH_EXTREME , BREADTH_MOULDED , BULB_LENGTH_FROM_FP , DEPTH , DRAUGHT , HEIGHT , KEEL_TO_MASTHEAD , FORECASTLE 
			, LENGTH_B_W_PERPENDICULARS , LENGTH_OVERALL , LENGTH_REGISTERED , NET_TONNAGE , PANAMA_TONNAGE , PANAMA_NET_TONNAGE , SUEZ_GROSS_TONNAGE , SUEZ_NET_TONNAGE , DEADWEIGHT_MAXIMUM_ASSIGNED , DEADWEIGHT_NORMAL_BALLAST , DEADWEIGHT_SEGREGATED_BALLAST , DEADWEIGHT_TROPICAL , DEADWEIGHT_WINTER , DEADWEIGHT_LIGHTSHIP , DISPLACEMENT_LIGHTSHIP , DISPLACEMENT_NORMAL_BALLAST 
			, DISPLACEMENT_SEGREGATED_BALLAST , DISPLACEMENT_SUMMER , DISPLACEMENT_TROPICAL , DISPLACEMENT_WINTER , DRAFT_LIGHTSHIP , DRAFT_NORMAL_BALLAST , DRAFT_SEGREGATED_BALLAST , DRAFT_SUMMER , DRAFT_TROPICAL 
			, DRAFT_WINTER , DRAUGHT_AFT_NORMAL_BALLAST , DRAUGHT_FORE_NORMAL_BALLAST , FREEBOARD_LIGHTSHIP , FREEBOARD_NORMAL_BALLAST , FREEBOARD_SEGREGATED_BALLAST , FREEBOARD_SUMMER , FREEBOARD_TROPICAL 
			, FREEBOARD_WINTER , BALE , GRAIN , TEU , PASSENGERS , BERTHS , CABINS , TRAILERS , CARS , [RO-RO_RAMPS] , [RO-RO_LANES] , CARGO_SPACE , FWA_SUMMER_DRAFT , TPC_IMMERSION_SUMMER_DRAFT , BALLAST 
			, BALLAST_SEGREGATED , BUNKER , CRUDE_CAPACITY , LIQUID_OIL , LIQUID_GAS , SLOPS , CARGO_PUMPS , HATCHWAYS , LARGEST_HATCH , LIFTING_EQUIPMENT , CARGO_HANDLING , CRANES , GEAR , HOLDS , BULKHEADS 
			, TRANSVERSE_BULKHEADS , LONGITUDINAL_FRAMES , DECKS_NUMBER , CONTINUOUS_DECKS , WATERTIGHT_COMPARTMENTS , HULL_MATERIAL , HULL_TYPE , ANCHOR_CHAIN_DIAMETER , ANCHOR_HOLDING_ABILITY , ANCHOR_STRENGTH_LEVEL 
			, ENGINE_NUMBER , ENGINE , ENGINE_TYPE , ENGINE_BORE , ENGINE_BUILD_YEAR , ENGINE_BUILDER , ENGINE_BUILDER_ID , ENGINE_MODEL , ENGINE_CYLINDERS , ENGINE_POWER , ENGINE_RPM , ENGINE_STROKE , ENGINE_RATIO 
			, FRESHWATER , FUEL_CONSUMPTION , FUEL , FUEL_OIL , FUEL_TYPE , DIESEL_OIL , LUBE_OIL , PROPELLER , PROPELLING_TYPE , CALL_SIGN , SATCOM_ANSWER_BACK , SATCOM_ID , ACTUAL_MANNING_OFFICERS 
			, ACTUAL_MANNING_RATINGS , MINIMUM_MANNING_REQUIRED_OFFICERS , MINIMUM_MANNING_REQUIRED_RATINGS , TOTAL_CREW , HYDRAULIC_OIL_CAPACITY , DESCRIPTION , NUMBER_OF_TANKS , TANKS_TOTAL_CAPACITY , BROKEN_UP , CONVERSION )
		SELECT TIMESTAMP , CREATED , UPDATED , IMO_NUMBER , NAME , STATUS , MMSI_CODE , VESSEL_TYPE , GROSS_TONNAGE , SUMMER_DWT , BUILD , BUILDER , BUILDER_ID , FLAG , LAST_KNOWN_FLAG 
			, HOME_PORT , REGISTRATION_NUMBER , CLASS_SOCIETY , CLASS_SOCIETY_ID , MANAGER_OWNER , MANAGER_OWNER_ID , MANAGER_OWNER_LOCATION , MANAGER_OWNER_TOWN , MANAGER_OWNER_COUNTRY , MANAGER_OWNER_EMAIL 
			, MANAGER_OWNER_WEBSITE , MANAGER , MANAGER_ID , MANAGER_LOCATION , MANAGER_TOWN , MANAGER_COUNTRY , MANAGER_EMAIL , MANAGER_WEBSITE , OWNER , OWNER_ID , OWNER_LOCATION , OWNER_TOWN , OWNER_COUNTRY 
			, OWNER_EMAIL , OWNER_WEBSITE , INSURER , INSURER_ID , PLACE_OF_BUILD , BUILD_START , BUILD_END , DATE_OF_ORDER , DELIVERY_DATE , KEEL_LAID , LAUNCH_DATE , STEEL_CUTTING , YARD_NUMBER , CLASS_ASSIGNMENT 
			, CLASS_NOTATION , LAST_DRYDOCK_SURVEY , LAST_HULL_SURVEY , LAST_SPECIAL_SURVEY , NEXT_DRYDOCK_SURVEY , NEXT_HULL_SURVEY , NEXT_SPECIAL_SURVEY , SPEED_SERVICE , SPEED_TRIAL , SPEED_MAX , SERVICE_LIMIT 
			, TRADING_AREAS , BOW_TO_BRIDGE , BOW_TO_CENTER_MANIFOLD , BREADTH_REGISTERED , BREADTH_EXTREME , BREADTH_MOULDED , BULB_LENGTH_FROM_FP , DEPTH , DRAUGHT , HEIGHT , KEEL_TO_MASTHEAD , FORECASTLE 
			, LENGTH_B_W_PERPENDICULARS , LENGTH_OVERALL , LENGTH_REGISTERED , NET_TONNAGE , PANAMA_TONNAGE , PANAMA_NET_TONNAGE , SUEZ_GROSS_TONNAGE , SUEZ_NET_TONNAGE , DEADWEIGHT_MAXIMUM_ASSIGNED , DEADWEIGHT_NORMAL_BALLAST , DEADWEIGHT_SEGREGATED_BALLAST , DEADWEIGHT_TROPICAL , DEADWEIGHT_WINTER , DEADWEIGHT_LIGHTSHIP , DISPLACEMENT_LIGHTSHIP , DISPLACEMENT_NORMAL_BALLAST 
			, DISPLACEMENT_SEGREGATED_BALLAST , DISPLACEMENT_SUMMER , DISPLACEMENT_TROPICAL , DISPLACEMENT_WINTER , DRAFT_LIGHTSHIP , DRAFT_NORMAL_BALLAST , DRAFT_SEGREGATED_BALLAST , DRAFT_SUMMER , DRAFT_TROPICAL 
			, DRAFT_WINTER , DRAUGHT_AFT_NORMAL_BALLAST , DRAUGHT_FORE_NORMAL_BALLAST , FREEBOARD_LIGHTSHIP , FREEBOARD_NORMAL_BALLAST , FREEBOARD_SEGREGATED_BALLAST , FREEBOARD_SUMMER , FREEBOARD_TROPICAL 
			, FREEBOARD_WINTER , BALE , GRAIN , TEU , PASSENGERS , BERTHS , CABINS , TRAILERS , CARS , [RO-RO_RAMPS] , [RO-RO_LANES] , CARGO_SPACE , FWA_SUMMER_DRAFT , TPC_IMMERSION_SUMMER_DRAFT , BALLAST 
			, BALLAST_SEGREGATED , BUNKER , CRUDE_CAPACITY , LIQUID_OIL , LIQUID_GAS , SLOPS , CARGO_PUMPS , HATCHWAYS , LARGEST_HATCH , LIFTING_EQUIPMENT , CARGO_HANDLING , CRANES , GEAR , HOLDS , BULKHEADS 
			, TRANSVERSE_BULKHEADS , LONGITUDINAL_FRAMES , DECKS_NUMBER , CONTINUOUS_DECKS , WATERTIGHT_COMPARTMENTS , HULL_MATERIAL , HULL_TYPE , ANCHOR_CHAIN_DIAMETER , ANCHOR_HOLDING_ABILITY , ANCHOR_STRENGTH_LEVEL 
			, ENGINE_NUMBER , ENGINE , ENGINE_TYPE , ENGINE_BORE , ENGINE_BUILD_YEAR , ENGINE_BUILDER , ENGINE_BUILDER_ID , ENGINE_MODEL , ENGINE_CYLINDERS , ENGINE_POWER , ENGINE_RPM , ENGINE_STROKE , ENGINE_RATIO 
			, FRESHWATER , FUEL_CONSUMPTION , FUEL , FUEL_OIL , FUEL_TYPE , DIESEL_OIL , LUBE_OIL , PROPELLER , PROPELLING_TYPE , CALL_SIGN , SATCOM_ANSWER_BACK , SATCOM_ID , ACTUAL_MANNING_OFFICERS 
			, ACTUAL_MANNING_RATINGS , MINIMUM_MANNING_REQUIRED_OFFICERS , MINIMUM_MANNING_REQUIRED_RATINGS , TOTAL_CREW , HYDRAULIC_OIL_CAPACITY , DESCRIPTION , NUMBER_OF_TANKS , TANKS_TOTAL_CAPACITY , BROKEN_UP , CONVERSION
		FROM [MT2,1438].ais_shadc.dbo.SHIP_GT_MASTER WITH(NOLOCK)
		;
		-- xxxx D.p
		set @DetErrorMess=convert(varchar(400),@@ROWCOUNT);
		SET CONCAT_NULL_YIELDS_NULL OFF;
		PRINT '[refrs_SHIPGTMASTER_batch_usp]: (INSERT from [ais_shadc.dbo.SHIP_GT_MASTER]) row(s) affected: ' + @DetErrorMess;
		--
		--xx?? (ommitted from tb-DDL) set identity_insert [ROUTES_TEMP] off;

		--  renable-reCreate PK/index 
		PRINT ' ** (spid '+CONVERT(VARCHAR(10),@@SPID)+') : '+ @@SERVERNAME+ '.'+DB_NAME()+ '.'+USER_NAME()+' ['+CONVERT(VARCHAR(19), GETDATE(),126)+']  , reCreate (PK):['+@pknm+'] / Rebuild indexes.'
		SET CONCAT_NULL_YIELDS_NULL ON;
		-- xx ALTER INDEX PK_SHIP_ID ON [dbo].SHIP REBUILD;
		SET @idxstr = N'ALTER TABLE dbo.[SHIP_GT_MASTER_TEMP] ADD CONSTRAINT ['+@pknm+']  PRIMARY KEY CLUSTERED  ([IMO_NUMBER]);'
		--xx D.P  PRINT @idxstr;
		EXEC sp_executesql @idxstr;
		--
		
		--xx SET STATISTICS io, TIME OFF;
				
		COMMIT TRAN;
	END TRY
	BEGIN CATCH 
		--
		SET CONCAT_NULL_YIELDS_NULL OFF;
		SET @ErrorSeverity = ERROR_SEVERITY()
		SET @ErrorState    = ERROR_STATE()
		SET @DetErrorMess =  ' **** ERROR_NUMBER ' +        
		  CAST(ERROR_NUMBER() AS VARCHAR) + ' : '+
		  CAST(@ErrorSeverity AS VARCHAR) + ' : ' +
		  CAST(@ErrorState AS VARCHAR) + ' : ' +
		  ERROR_PROCEDURE() + ' : ' +
		  ERROR_MESSAGE() + ' : ERROR_LINE ' +
		  CAST(ERROR_LINE() AS VARCHAR);
		
		-- Test XACT_STATE for 1 or -1. XACT_STATE = 0 means there is no transaction
		--	and a commit or rollback operation would generate an error.
		IF (XACT_STATE()) <> 0
		BEGIN
			--D.p: 
			PRINT '(XACT_STATE) before ROLLBACK: ' + CAST(XACT_STATE() AS VARCHAR(10)); 
			ROLLBACK TRAN;
			-- D.p: PRINT 'after: ' + CAST(XACT_STATE() AS VARCHAR(10));
		END;
		-- detailed error message....return
		RAISERROR(@DetErrorMess, @ErrorSeverity, @ErrorState);
		RETURN;
	END CATCH;
	
	
	-- ** [15:20 28/6/2016] idx REBUILDs (like on _sp_ dbo.[v_ship_diff])
	-- [DATA-2980] : Create index rebuild scr-proc hourly
	SET CONCAT_NULL_YIELDS_NULL OFF;
	-- * SET Object UPON SYNONYM def:
		DECLARE @V_TEMP_OBJ VARCHAR(1000) = 'SHIP_GT_MASTER_TEMP';
		-- * SET (minutes) before last REBUILD (STATs check)
		DECLARE @intDiffMin TINYINT = 120;
		-- CHECK last STATs UPDATE on CLUSTERED INDEX:
		IF (
			SELECT DATEDIFF(MINUTE,STATS_DATE(object_id, stats_id),GETDATE()) --!! LastStatsUpdate DIFF_min
				FROM sys.stats
				WHERE object_id = OBJECT_ID(@V_TEMP_OBJ)
				AND LEFT(name,4)!='_WA_'
				-- Select ONLY Clustered for the CHECK:
				AND name = (SELECT i0.name FROM sys.indexes i0 WHERE i0.object_id=OBJECT_ID(@V_TEMP_OBJ) AND i0.type_desc='CLUSTERED')
			) > @intDiffMin
		BEGIN
			--xx D.p
			PRINT ' ** (spid '+CONVERT(VARCHAR(10),@@SPID)+') : '+ @@SERVERNAME+ '.'+DB_NAME()+ '.'+USER_NAME()+' ['+CONVERT(VARCHAR(19), GETDATE(),126)+']';
			PRINT ' ** LastStatsUpdate DIFF(for '+@V_TEMP_OBJ+') > '+CONVERT(VARCHAR(10), @intDiffMin)+' min'
			-- Open Cursor with ALTER statements
			DECLARE @straltSQL VARCHAR(1000);
			DECLARE c_altidx CURSOR FOR 
			SELECT
					'ALTER INDEX ' + QUOTENAME(i.name) + ' ON '
					+ QUOTENAME('dbo') + '.'
					+ QUOTENAME(OBJECT_NAME(i.OBJECT_ID)) + ' REBUILD;'	rbidx_scr
			FROM sys.indexes i
			WHERE 
				--xx [o].name = @V_TEMP_OBJ
				OBJECT_NAME(i.OBJECT_ID) = @V_TEMP_OBJ
				-- AND i.type_desc='CLUSTERED'
			ORDER BY CASE i.type_desc WHEN 'CLUSTERED' THEN 1 ELSE 0 END DESC
			;
			--
			OPEN c_altidx;
			FETCH NEXT FROM c_altidx INTO @straltSQL;
			WHILE (@@FETCH_STATUS = 0)
				BEGIN
					--xx D.p
					PRINT @@SERVERNAME+ '.'+DB_NAME()+'['+CONVERT(VARCHAR(19), GETDATE(),126)+']';
					PRINT @straltSQL;
					EXEC dbo.sp_sqlexec @straltSQL;

					FETCH NEXT FROM c_altidx INTO @straltSQL;
					-- ENDoF:  c_altidx cursor WHILE
				END;
			--
			CLOSE c_altidx;
			DEALLOCATE c_altidx;
		--
		END;
		ELSE
		BEGIN	
			/*xxxx D.p	*/
			PRINT ' ** (spid '+CONVERT(VARCHAR(10),@@SPID)+') : '+ @@SERVERNAME+ '.'+DB_NAME()+ '.'+USER_NAME()+' ['+CONVERT(VARCHAR(19), GETDATE(),126)+']';
			PRINT ' ** LastStatsUpdate DIFF(for '+@V_TEMP_OBJ+') <= '+CONVERT(VARCHAR(10), @intDiffMin)+' min'
			/*xxxx D.p	*/
			SELECT @intDiffMin = DATEDIFF(MINUTE,STATS_DATE(object_id, stats_id),GETDATE()) 
				FROM sys.stats
				WHERE object_id = OBJECT_ID(@V_TEMP_OBJ)
				AND LEFT(name,4)!='_WA_'
				-- Select ONLY Clustered for the CHECK:
				AND name = (SELECT i0.name FROM sys.indexes i0 WHERE i0.object_id=OBJECT_ID(@V_TEMP_OBJ) AND i0.type_desc='CLUSTERED')
			;
			PRINT ' **   LastStatsUpdate DIFF(for '+@V_TEMP_OBJ+') is : '+CONVERT(VARCHAR(10), @intDiffMin)+' min'
		-- ENDoF: IF () > @intDiffMin
		END
		;
	-- ENDof: idx REBUILDs
	
	
	-- rename with: ALTER SCHEMA TRANFER
	PRINT ' '+ @@SERVERNAME+ '.'+DB_NAME()+ '.'+USER_NAME()+' ['+CONVERT(VARCHAR(19), GETDATE(),126)+'] STARToF : [SHIP_GT_MASTER_TEMP] ALTER SCHEMA TRANFER';
	BEGIN TRAN
		ALTER SCHEMA [shad] TRANSFER [dbo].[SHIP_GT_MASTER_TEMP];
		EXEC sys.sp_rename @objname = N'shad.SHIP_GT_MASTER_TEMP',
			@newname = SHIP_GT_MASTER;
			
		ALTER SCHEMA [fk] TRANSFER [dbo].[SHIP_GT_MASTER];
		ALTER SCHEMA [dbo] TRANSFER [shad].[SHIP_GT_MASTER];
		
		EXEC sys.sp_rename @objname = N'fk.SHIP_GT_MASTER',
			@newname = SHIP_GT_MASTER_TEMP;
		ALTER SCHEMA [dbo] TRANSFER [fk].[SHIP_GT_MASTER_TEMP];
	COMMIT;
	
	
	-- success message
	SELECT 0 [Status], 'SUCCESS: [refrs_SHIPGTMASTER_batch_usp]: (INSERT from ais_shadc.dbo.[SHIP_GT_MASTER]) row(s) affected: '+@DetErrorMess [Message] , CONVERT(VARCHAR(19),GETUTCDATE(),126) dt;
	SET CONCAT_NULL_YIELDS_NULL ON;
	SET DEADLOCK_PRIORITY NORMAL;
	SET NOCOUNT OFF;

END;
-- * ENDoF 'refrs_SHIPGTMASTER_batch_usp' procedure



GO
