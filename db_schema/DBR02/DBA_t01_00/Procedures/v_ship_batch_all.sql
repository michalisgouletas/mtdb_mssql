USE [DBA_t01_00]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- CREATE 
CREATE PROCEDURE [dbo].[v_ship_batch_all]
AS
/* ** 
* -- [13:30 01/12/2016] SYS-134 (mt14)  SYS-134_DropUnusedCols_mt14
* -- update sql due to removed columns :
	[CURRENT_CENTERX] [real] ,
	[CURRENT_CENTERY] [real] ,
	[CENTERX] [real] ,
	[CENTERY] [real] ,
	[CURRENT_ZOOM] [tinyint] ,
	[ZOOM] [tinyint] ,
	[ICON] [varchar](86) ,
	[SAT_LAST_PORT_CENTERX] [real] ,
	[SAT_LAST_PORT_CENTERY] [real] ,
	[SAT_ICON] [varchar](86)

*
* -- [09:12 22/1/2017] SYS-131 : [v_ship_batch_job] PK Violation errors (improve sp)
* -- sql Add: one-off create #tmp tb: #tmpSYS131_VSHIPALL for use on the two V_SHIP_BATCH1/2 tables recreate								
* -- [22:52 19/3/2017] (SYS-100) Migr to (mt2) : Added  "ALTER Schema .. TRANSFER" for DROP-CREATE SCHEMA 	
** */
BEGIN
	SET NOCOUNT ON;
	SET QUERY_GOVERNOR_COST_LIMIT 0
	SET DEADLOCK_PRIORITY HIGH;
	SET CONCAT_NULL_YIELDS_NULL OFF;

declare @syn_object as varchar(50)
set @syn_object = (SELECT TOP 1 PARSENAME(base_object_name,1) AS objectName 
FROM sys.synonyms WHERE name='V_SHIP_BATCH')

DECLARE @DetErrorMess VARCHAR(MAX), @ErrorSeverity  tinyint, @ErrorState tinyint;
-- ** [19:06 26/7/2016] DATA-3194: [v_ship_batch_job] PK Violation errors (improve sp)
-- **	sp not failling totally after:  Error on INSERTs
		
-- ** [09:12 22/1/2017] 1st INSERT ON [V_SHIP_TEMP] , for one of the two tbs under Syn [V_SHIP_TEMP] : V_SHIP_BATCH1/2
-- ** Next  INSERT ON [V_SHIP_TEMP]  after Syn(s) recreate - switch names. 
BEGIN TRY
	BEGIN TRAN;
		-- ** [09:12 22/1/2017] Create #tmp tb: #tmpSYS131_VSHIPALL
		SELECT DISTINCT SHIP_ID, MMSI, IMO, CALLSIGN, SHIPNAME, TIMESTAMP, PORT_ID, CURRENT_PORT, CURRENT_PORT_COUNTRY, 
			CURRENT_PORT_UNLOCODE, TYPE_NAME, GT_SHIPTYPE, COUNTRY, 
			LAST_PORT_ID, LAST_PORT, LAST_PORT_TIME, LAST_PORT_COUNTRY, LAST_PORT_UNLOCODE,
			PREVIOUS_PORT_ID, PREVIOUS_PORT, PREVIOUS_PORT_TIME, PREVIOUS_PORT_COUNTRY, PREVIOUS_PORT_UNLOCODE,
			NEXT_PORT_ID, NEXT_PORT_NAME, NEXT_PORT_COUNTRY, NEXT_PORT_UNLOCODE,
			LON, LAT, ETA, DRAUGHT, DESTINATION, SHIPTIME, LENGTH, WIDTH, CODE2, COUNT_PHOTOS, SHIPTYPE, TYPE_COLOR, /*CURRENT_CENTERX, 
							  CURRENT_CENTERY, CENTERX, CENTERY,*/ MAXSPEED, AVGSPEED, /*CURRENT_ZOOM, ZOOM,*/ TYPE_SUMMARY, LAST_POS, DWT, YOB,GRT,[STATUS], AREA_ID, AREA_NAME, 
							  COURSE, HEADING, STATUS_AIS, ROT, SPEED, /*ICON,*/ STATION,
							   SAT_LON, SAT_LAT, SAT_AREA_ID, SAT_AREA_NAME, SAT_PORT_NAME, SAT_PORT_ID, SAT_TIMESTAMP, SAT_LAST_POS, SAT_SPEED, SAT_COURSE, SAT_HEADING, 
							  SAT_LAST_PORT_ID, SAT_LAST_PORT_TIMESTAMP, SAT_LAST_PORT_COUNTRY, SAT_IS_NEWER, SAT_LAST_PORT_NAME, SAT_LAST_PORT_ZOOM, /*SAT_LAST_PORT_CENTERX, 
							  SAT_LAST_PORT_CENTERY, SAT_ICON,*/ IS_COASTAL, SAT60_TIMESTAMP, SAT60_LAT, SAT60_LON, SAT60_SPEED, 
							  SAT60_COURSE, SAT360_TIMESTAMP, SAT360_LAT, SAT360_LON, SAT360_SPEED, SAT360_COURSE, SAT720_TIMESTAMP, SAT720_LAT, SAT720_LON, 
							  SAT720_SPEED, SAT720_COURSE, OPERATOR, SAT_ETA, SAT_DESTINATION, SAT_SHIPTIME, BUILDER_ID, MANAGER_ID, OWNER_ID, STATUS_NAME, AIS_SHIPNAME, 
							  ETA_CALC, ETA_UPDATED, DISTANCE_TO_GO, SUEZ, PANAMA,
							  SAT_ETA_CALC, SAT_ETA_UPDATED, SAT_DISTANCE_TO_GO, SAT_SUEZ, SAT_PANAMA
							  ,DISTANCE_TRAVELLED, SAT_DISTANCE_TRAVELLED
							  ,SPEED_CALC, SAT_SPEED_CALC
							  ,CURRENT_PORT_TIMESTAMP,SAT_CURRENT_PORT_TIMESTAMP
							  -- [CORE-1274 | 17:00 24/8/2015]
							  ,TYPE_GROUPED_ID, AIS_SECONDS, RELATED_PORT_ID, DRAUGHT_MIN, DRAUGHT_MAX, INLAND_ENI, AREA_CODE, SAT_AREA_CODE 
							  ,LOAD_STATUS_ID, LOAD_STATUS_NAME, TIMEZONE 
							  ,WIND_ANGLE, WIND_SPEED, WIND_TEMP, L_FORE, W_LEFT
							  ,TERRSAT_TIMESTAMP, TERRSAT_LAT, TERRSAT_LON, TERRSAT_SPEED, TEU, LIQUID_GAS, STATION_SHOW
							  ,CURRENT_PORT_OFFSET, LAST_PORT_OFFSET, PREVIOUS_PORT_OFFSET, ETA_OFFSET, ETA_CALC_OFFSET
		into #tmpSYS131_VSHIPALL
		FROM MT1.ais.dbo.V_SHIP
		OPTION (MAXDOP 1)
		;
		set @DetErrorMess=convert(varchar(400),@@ROWCOUNT);
		PRINT ' **** '+@@SERVERNAME+ '.'+DB_NAME()+'['+CONVERT(VARCHAR(19), GETDATE(),126)+']';
		PRINT ' ** v_ship_batch_all : (Create #tmp tb: #tmpSYS131_VSHIPALL) row(s) affected: ' + @DetErrorMess;
		
		if(@syn_object='V_SHIP_BATCH1')
			TRUNCATE TABLE V_SHIP_BATCH2
		else
			TRUNCATE TABLE V_SHIP_BATCH1
		;

		--DELETE FROM V_SHIP_TEMP
		WAITFOR DELAY '00:00:50'; 
		INSERT INTO V_SHIP_TEMP WITH (TABLOCK) (SHIP_ID, MMSI, IMO, CALLSIGN, SHIPNAME, TIMESTAMP, PORT_ID, CURRENT_PORT, CURRENT_PORT_COUNTRY, 
			CURRENT_PORT_UNLOCODE, TYPE_NAME, GT_SHIPTYPE, COUNTRY, 
			LAST_PORT_ID, LAST_PORT, LAST_PORT_TIME, LAST_PORT_COUNTRY, LAST_PORT_UNLOCODE,
			PREVIOUS_PORT_ID, PREVIOUS_PORT, PREVIOUS_PORT_TIME, PREVIOUS_PORT_COUNTRY, PREVIOUS_PORT_UNLOCODE,
			NEXT_PORT_ID, NEXT_PORT_NAME, NEXT_PORT_COUNTRY, NEXT_PORT_UNLOCODE,
			LON, LAT, ETA, DRAUGHT, DESTINATION, SHIPTIME, LENGTH, WIDTH, CODE2, COUNT_PHOTOS, SHIPTYPE, TYPE_COLOR, /*CURRENT_CENTERX, 
							  CURRENT_CENTERY, CENTERX, CENTERY,*/ MAXSPEED, AVGSPEED, /*CURRENT_ZOOM, ZOOM,*/ TYPE_SUMMARY, LAST_POS, DWT, YOB,GRT,[STATUS], AREA_ID, AREA_NAME, 
							  COURSE, HEADING, STATUS_AIS, ROT, SPEED, /*ICON,*/ STATION,
							   SAT_LON, SAT_LAT, SAT_AREA_ID, SAT_AREA_NAME, SAT_PORT_NAME, SAT_PORT_ID, SAT_TIMESTAMP, SAT_LAST_POS, SAT_SPEED, SAT_COURSE, SAT_HEADING, 
							  SAT_LAST_PORT_ID, SAT_LAST_PORT_TIMESTAMP, SAT_LAST_PORT_COUNTRY, SAT_IS_NEWER, SAT_LAST_PORT_NAME, SAT_LAST_PORT_ZOOM, /*SAT_LAST_PORT_CENTERX, 
							  SAT_LAST_PORT_CENTERY, SAT_ICON,*/ IS_COASTAL, SAT60_TIMESTAMP, SAT60_LAT, SAT60_LON, SAT60_SPEED, 
							  SAT60_COURSE, SAT360_TIMESTAMP, SAT360_LAT, SAT360_LON, SAT360_SPEED, SAT360_COURSE, SAT720_TIMESTAMP, SAT720_LAT, SAT720_LON, 
							  SAT720_SPEED, SAT720_COURSE, OPERATOR, SAT_ETA, SAT_DESTINATION, SAT_SHIPTIME, BUILDER_ID, MANAGER_ID, OWNER_ID, STATUS_NAME, AIS_SHIPNAME,
							  ETA_CALC, ETA_UPDATED, DISTANCE_TO_GO, SUEZ, PANAMA,
							  SAT_ETA_CALC, SAT_ETA_UPDATED, SAT_DISTANCE_TO_GO, SAT_SUEZ, SAT_PANAMA
							  ,DISTANCE_TRAVELLED, SAT_DISTANCE_TRAVELLED
							  ,SPEED_CALC, SAT_SPEED_CALC
							  ,CURRENT_PORT_TIMESTAMP,SAT_CURRENT_PORT_TIMESTAMP
							  -- [CORE-1274 | 17:00 24/8/2015]
							  ,TYPE_GROUPED_ID, AIS_SECONDS, RELATED_PORT_ID, DRAUGHT_MIN, DRAUGHT_MAX, INLAND_ENI, AREA_CODE, SAT_AREA_CODE
							  ,LOAD_STATUS_ID, LOAD_STATUS_NAME, TIMEZONE 
							  ,WIND_ANGLE, WIND_SPEED, WIND_TEMP, L_FORE, W_LEFT
							  ,TERRSAT_TIMESTAMP, TERRSAT_LAT, TERRSAT_LON, TERRSAT_SPEED, TEU, LIQUID_GAS, STATION_SHOW
							  ,CURRENT_PORT_OFFSET, LAST_PORT_OFFSET, PREVIOUS_PORT_OFFSET, ETA_OFFSET, ETA_CALC_OFFSET)
		(SELECT DISTINCT SHIP_ID, MMSI, IMO, CALLSIGN, SHIPNAME, TIMESTAMP, PORT_ID, CURRENT_PORT, CURRENT_PORT_COUNTRY, 
			CURRENT_PORT_UNLOCODE, TYPE_NAME, GT_SHIPTYPE, COUNTRY, 
			LAST_PORT_ID, LAST_PORT, LAST_PORT_TIME, LAST_PORT_COUNTRY, LAST_PORT_UNLOCODE,
			PREVIOUS_PORT_ID, PREVIOUS_PORT, PREVIOUS_PORT_TIME, PREVIOUS_PORT_COUNTRY, PREVIOUS_PORT_UNLOCODE,
			NEXT_PORT_ID, NEXT_PORT_NAME, NEXT_PORT_COUNTRY, NEXT_PORT_UNLOCODE,
			LON, LAT, ETA, DRAUGHT, DESTINATION, SHIPTIME, LENGTH, WIDTH, CODE2, COUNT_PHOTOS, SHIPTYPE, TYPE_COLOR, /*CURRENT_CENTERX, 
							  CURRENT_CENTERY, CENTERX, CENTERY,*/ MAXSPEED, AVGSPEED, /*CURRENT_ZOOM, ZOOM,*/ TYPE_SUMMARY, LAST_POS, DWT, YOB,GRT,[STATUS], AREA_ID, AREA_NAME, 
							  COURSE, HEADING, STATUS_AIS, ROT, SPEED, /*ICON,*/ STATION,
							   SAT_LON, SAT_LAT, SAT_AREA_ID, SAT_AREA_NAME, SAT_PORT_NAME, SAT_PORT_ID, SAT_TIMESTAMP, SAT_LAST_POS, SAT_SPEED, SAT_COURSE, SAT_HEADING, 
							  SAT_LAST_PORT_ID, SAT_LAST_PORT_TIMESTAMP, SAT_LAST_PORT_COUNTRY, SAT_IS_NEWER, SAT_LAST_PORT_NAME, SAT_LAST_PORT_ZOOM, /*SAT_LAST_PORT_CENTERX, 
							  SAT_LAST_PORT_CENTERY, SAT_ICON,*/ IS_COASTAL, SAT60_TIMESTAMP, SAT60_LAT, SAT60_LON, SAT60_SPEED, 
							  SAT60_COURSE, SAT360_TIMESTAMP, SAT360_LAT, SAT360_LON, SAT360_SPEED, SAT360_COURSE, SAT720_TIMESTAMP, SAT720_LAT, SAT720_LON, 
							  SAT720_SPEED, SAT720_COURSE, OPERATOR, SAT_ETA, SAT_DESTINATION, SAT_SHIPTIME, BUILDER_ID, MANAGER_ID, OWNER_ID, STATUS_NAME, AIS_SHIPNAME, 
							  ETA_CALC, ETA_UPDATED, DISTANCE_TO_GO, SUEZ, PANAMA,
							  SAT_ETA_CALC, SAT_ETA_UPDATED, SAT_DISTANCE_TO_GO, SAT_SUEZ, SAT_PANAMA
							  ,DISTANCE_TRAVELLED, SAT_DISTANCE_TRAVELLED
							  ,SPEED_CALC, SAT_SPEED_CALC
							  ,CURRENT_PORT_TIMESTAMP,SAT_CURRENT_PORT_TIMESTAMP
							  -- [CORE-1274 | 17:00 24/8/2015]
							  ,TYPE_GROUPED_ID, AIS_SECONDS, RELATED_PORT_ID, DRAUGHT_MIN, DRAUGHT_MAX, INLAND_ENI, AREA_CODE, SAT_AREA_CODE 
							  ,LOAD_STATUS_ID, LOAD_STATUS_NAME, TIMEZONE 
							  ,WIND_ANGLE, WIND_SPEED, WIND_TEMP, L_FORE, W_LEFT
							  ,TERRSAT_TIMESTAMP, TERRSAT_LAT, TERRSAT_LON, TERRSAT_SPEED, TEU, LIQUID_GAS, STATION_SHOW
							  ,CURRENT_PORT_OFFSET, LAST_PORT_OFFSET, PREVIOUS_PORT_OFFSET, ETA_OFFSET, ETA_CALC_OFFSET
							  FROM #tmpSYS131_VSHIPALL)
							  --xxxx OPTION (MAXDOP 1)
		;
		-- xxxx D.p: success message
		set @DetErrorMess=convert(varchar(400),@@ROWCOUNT);
		PRINT ' **** '+@@SERVERNAME+ '.'+DB_NAME()+'['+CONVERT(VARCHAR(19), GETDATE(),126)+']';
		PRINT ' ** v_ship_batch_all : (1st INSERT on NOT:['+@syn_object+']) row(s) affected: ' + @DetErrorMess;

		/*TRUNCATE TABLE V_SHIP_BATCH
		INSERT INTO V_SHIP_BATCH (MMSI, IMO, CALLSIGN, SHIPNAME, TIMESTAMP, PORT_ID, CURRENT_PORT, TYPE_NAME, COUNTRY, LAST_PORT, LAST_PORT_TIME, LON, LAT, 
							  ETA, DRAUGHT, DESTINATION, SHIPTIME, LENGTH, WIDTH, CODE2, COUNT_PHOTOS, SHIPTYPE, TYPE_COLOR, CURRENT_CENTERX, 
							  CURRENT_CENTERY, CENTERX, CENTERY, MAXSPEED, AVGSPEED, CURRENT_ZOOM, ZOOM, TYPE_SUMMARY, LAST_POS, DWT, YOB, AREA_NAME)
		(SELECT MMSI, IMO, CALLSIGN, SHIPNAME, TIMESTAMP, PORT_ID, CURRENT_PORT, TYPE_NAME, COUNTRY, LAST_PORT, LAST_PORT_TIME, LON, LAT, 
							  ETA, DRAUGHT, DESTINATION, SHIPTIME, LENGTH, WIDTH, CODE2, COUNT_PHOTOS, SHIPTYPE, TYPE_COLOR, CURRENT_CENTERX, 
							  CURRENT_CENTERY, CENTERX, CENTERY, MAXSPEED, AVGSPEED, CURRENT_ZOOM, ZOOM, TYPE_SUMMARY, LAST_POS, DWT, YOB, AREA_NAME FROM V_SHIP_TEMP WITH(NOLOCK))
		*/
		--SWAP NAMES - FASTER
		--if exists (select top(1) * from V_SHIP_TEMP) --do not swap tables if something went wrong and table is empty
		--begin
		--exec sp_rename 'V_SHIP_BATCH', 'V_SHIP_TEMP1'
		--exec sp_rename 'V_SHIP_TEMP', 'V_SHIP_BATCH'
		--exec sp_rename 'V_SHIP_TEMP1', 'V_SHIP_TEMP'
		--end

	COMMIT TRAN;		
END TRY
BEGIN CATCH
	--
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
		--D.p: PRINT XACT_STATE(); 
		ROLLBACK TRAN;
		-- D.p: PRINT 'after: ' + CAST(XACT_STATE() AS VARCHAR(10));
	END;
	-- detailed error message....return
	PRINT ' **** '+@@SERVERNAME+ '.'+DB_NAME()+'['+CONVERT(VARCHAR(19), GETDATE(),126)+']';
	RAISERROR(@DetErrorMess, @ErrorSeverity, @ErrorState) WITH LOG;
	RETURN;
END CATCH;
-- ** ENDoF:  1st INSERT ON [V_SHIP_TEMP]



--rename table replaced by swapping synonyms
-- [22:52 19/3/2017] (SYS-100) Migr to (mt2) : Added  "ALTER Schema .. TRANSFER" for DROP-CREATE SCHEMA 
if exists (select top(1) * from V_SHIP_TEMP) --do not swap tables if something went wrong and table is empty
BEGIN
	if(@syn_object='V_SHIP_BATCH1')
	begin
	BEGIN TRAN
		DROP SYNONYM [shad].[V_SHIP_BATCH];
		CREATE SYNONYM [shad].[V_SHIP_BATCH] FOR [dbo].[V_SHIP_BATCH2];
		ALTER SCHEMA [fk] TRANSFER [dbo].[V_SHIP_BATCH];
		ALTER SCHEMA [dbo] TRANSFER [shad].[V_SHIP_BATCH];
		ALTER SCHEMA [shad] TRANSFER [fk].[V_SHIP_BATCH];
		--
		DROP SYNONYM [dbo].[V_SHIP_TEMP]; 
		CREATE SYNONYM [dbo].[V_SHIP_TEMP] FOR [dbo].[V_SHIP_BATCH1];
	COMMIT TRAN;  
	end
	else if(@syn_object='V_SHIP_BATCH2')
	begin
		BEGIN TRAN
			DROP SYNONYM [shad].[V_SHIP_BATCH];
			CREATE SYNONYM [shad].[V_SHIP_BATCH] FOR [dbo].[V_SHIP_BATCH1];
			ALTER SCHEMA [fk] TRANSFER [dbo].[V_SHIP_BATCH];
			ALTER SCHEMA [dbo] TRANSFER [shad].[V_SHIP_BATCH];
			ALTER SCHEMA [shad] TRANSFER [fk].[V_SHIP_BATCH];
			--
			DROP SYNONYM [dbo].[V_SHIP_TEMP]; 
			CREATE SYNONYM [dbo].[V_SHIP_TEMP] FOR [dbo].[V_SHIP_BATCH2];
		COMMIT TRAN;  
	end
	else if(@syn_object is null)
	begin
		CREATE SYNONYM [dbo].[V_SHIP_BATCH] FOR [dbo].[V_SHIP_BATCH1]  
		CREATE SYNONYM [dbo].[V_SHIP_TEMP] FOR [dbo].[V_SHIP_BATCH2]  
	end
END




-- ** [09:12 22/1/2017] 2nd INSERT ON [V_SHIP_TEMP] , for one of the two tbs under Syn [V_SHIP_TEMP] : V_SHIP_BATCH1/2
set @syn_object = (SELECT TOP 1 PARSENAME(base_object_name,1) AS objectName 
FROM sys.synonyms WHERE name='V_SHIP_BATCH')

BEGIN TRY
	BEGIN TRAN ins2;
		if(@syn_object='V_SHIP_BATCH1')
			TRUNCATE TABLE V_SHIP_BATCH2
		else
			TRUNCATE TABLE V_SHIP_BATCH1
		;
		
		WAITFOR DELAY '00:00:30';
		INSERT INTO V_SHIP_TEMP WITH (TABLOCK) (SHIP_ID, MMSI, IMO, CALLSIGN, SHIPNAME, TIMESTAMP, PORT_ID, CURRENT_PORT, CURRENT_PORT_COUNTRY, 
			CURRENT_PORT_UNLOCODE, TYPE_NAME, GT_SHIPTYPE, COUNTRY, 
			LAST_PORT_ID, LAST_PORT, LAST_PORT_TIME, LAST_PORT_COUNTRY, LAST_PORT_UNLOCODE,
			PREVIOUS_PORT_ID, PREVIOUS_PORT, PREVIOUS_PORT_TIME, PREVIOUS_PORT_COUNTRY, PREVIOUS_PORT_UNLOCODE,
			NEXT_PORT_ID, NEXT_PORT_NAME, NEXT_PORT_COUNTRY, NEXT_PORT_UNLOCODE,
			LON, LAT, ETA, DRAUGHT, DESTINATION, SHIPTIME, LENGTH, WIDTH, CODE2, COUNT_PHOTOS, SHIPTYPE, TYPE_COLOR, /*CURRENT_CENTERX, 
							  CURRENT_CENTERY, CENTERX, CENTERY,*/ MAXSPEED, AVGSPEED, /*CURRENT_ZOOM, ZOOM,*/ TYPE_SUMMARY, LAST_POS, DWT, YOB,GRT,[STATUS], AREA_ID, AREA_NAME, 
							  COURSE, HEADING, STATUS_AIS, ROT, SPEED, /*ICON,*/ STATION,
							   SAT_LON, SAT_LAT, SAT_AREA_ID, SAT_AREA_NAME, SAT_PORT_NAME, SAT_PORT_ID, SAT_TIMESTAMP, SAT_LAST_POS, SAT_SPEED, SAT_COURSE, SAT_HEADING, 
							  SAT_LAST_PORT_ID, SAT_LAST_PORT_TIMESTAMP, SAT_LAST_PORT_COUNTRY, SAT_IS_NEWER, SAT_LAST_PORT_NAME, SAT_LAST_PORT_ZOOM, /*SAT_LAST_PORT_CENTERX, 
							  SAT_LAST_PORT_CENTERY, SAT_ICON,*/ IS_COASTAL, SAT60_TIMESTAMP, SAT60_LAT, SAT60_LON, SAT60_SPEED, 
							  SAT60_COURSE, SAT360_TIMESTAMP, SAT360_LAT, SAT360_LON, SAT360_SPEED, SAT360_COURSE, SAT720_TIMESTAMP, SAT720_LAT, SAT720_LON, 
							  SAT720_SPEED, SAT720_COURSE, OPERATOR, SAT_ETA, SAT_DESTINATION, SAT_SHIPTIME, BUILDER_ID, MANAGER_ID, OWNER_ID, STATUS_NAME, AIS_SHIPNAME,
							  ETA_CALC, ETA_UPDATED, DISTANCE_TO_GO, SUEZ, PANAMA,
							  SAT_ETA_CALC, SAT_ETA_UPDATED, SAT_DISTANCE_TO_GO, SAT_SUEZ, SAT_PANAMA
							  ,DISTANCE_TRAVELLED, SAT_DISTANCE_TRAVELLED
							  ,SPEED_CALC, SAT_SPEED_CALC
							  ,CURRENT_PORT_TIMESTAMP,SAT_CURRENT_PORT_TIMESTAMP
							  -- [CORE-1274 | 17:00 24/8/2015]
							  ,TYPE_GROUPED_ID, AIS_SECONDS, RELATED_PORT_ID, DRAUGHT_MIN, DRAUGHT_MAX, INLAND_ENI, AREA_CODE, SAT_AREA_CODE
							  ,LOAD_STATUS_ID, LOAD_STATUS_NAME, TIMEZONE 
							  ,WIND_ANGLE, WIND_SPEED, WIND_TEMP, L_FORE, W_LEFT
							  ,TERRSAT_TIMESTAMP, TERRSAT_LAT, TERRSAT_LON, TERRSAT_SPEED, TEU, LIQUID_GAS, STATION_SHOW)
		(SELECT DISTINCT SHIP_ID, MMSI, IMO, CALLSIGN, SHIPNAME, TIMESTAMP, PORT_ID, CURRENT_PORT, CURRENT_PORT_COUNTRY, 
			CURRENT_PORT_UNLOCODE, TYPE_NAME, GT_SHIPTYPE, COUNTRY, 
			LAST_PORT_ID, LAST_PORT, LAST_PORT_TIME, LAST_PORT_COUNTRY, LAST_PORT_UNLOCODE,
			PREVIOUS_PORT_ID, PREVIOUS_PORT, PREVIOUS_PORT_TIME, PREVIOUS_PORT_COUNTRY, PREVIOUS_PORT_UNLOCODE,
			NEXT_PORT_ID, NEXT_PORT_NAME, NEXT_PORT_COUNTRY, NEXT_PORT_UNLOCODE,
			LON, LAT, ETA, DRAUGHT, DESTINATION, SHIPTIME, LENGTH, WIDTH, CODE2, COUNT_PHOTOS, SHIPTYPE, TYPE_COLOR, /*CURRENT_CENTERX, 
							  CURRENT_CENTERY, CENTERX, CENTERY,*/ MAXSPEED, AVGSPEED, /*CURRENT_ZOOM, ZOOM,*/ TYPE_SUMMARY, LAST_POS, DWT, YOB,GRT,[STATUS], AREA_ID, AREA_NAME, 
							  COURSE, HEADING, STATUS_AIS, ROT, SPEED, /*ICON,*/ STATION,
							   SAT_LON, SAT_LAT, SAT_AREA_ID, SAT_AREA_NAME, SAT_PORT_NAME, SAT_PORT_ID, SAT_TIMESTAMP, SAT_LAST_POS, SAT_SPEED, SAT_COURSE, SAT_HEADING, 
							  SAT_LAST_PORT_ID, SAT_LAST_PORT_TIMESTAMP, SAT_LAST_PORT_COUNTRY, SAT_IS_NEWER, SAT_LAST_PORT_NAME, SAT_LAST_PORT_ZOOM, /*SAT_LAST_PORT_CENTERX, 
							  SAT_LAST_PORT_CENTERY, SAT_ICON,*/ IS_COASTAL, SAT60_TIMESTAMP, SAT60_LAT, SAT60_LON, SAT60_SPEED, 
							  SAT60_COURSE, SAT360_TIMESTAMP, SAT360_LAT, SAT360_LON, SAT360_SPEED, SAT360_COURSE, SAT720_TIMESTAMP, SAT720_LAT, SAT720_LON, 
							  SAT720_SPEED, SAT720_COURSE, OPERATOR, SAT_ETA, SAT_DESTINATION, SAT_SHIPTIME, BUILDER_ID, MANAGER_ID, OWNER_ID, STATUS_NAME, AIS_SHIPNAME, 
							  ETA_CALC, ETA_UPDATED, DISTANCE_TO_GO, SUEZ, PANAMA,
							  SAT_ETA_CALC, SAT_ETA_UPDATED, SAT_DISTANCE_TO_GO, SAT_SUEZ, SAT_PANAMA
							  ,DISTANCE_TRAVELLED, SAT_DISTANCE_TRAVELLED
							  ,SPEED_CALC, SAT_SPEED_CALC
							  ,CURRENT_PORT_TIMESTAMP,SAT_CURRENT_PORT_TIMESTAMP
							  -- [CORE-1274 | 17:00 24/8/2015]
							  ,TYPE_GROUPED_ID, AIS_SECONDS, RELATED_PORT_ID, DRAUGHT_MIN, DRAUGHT_MAX, INLAND_ENI, AREA_CODE, SAT_AREA_CODE 
							  ,LOAD_STATUS_ID, LOAD_STATUS_NAME, TIMEZONE 
							  ,WIND_ANGLE, WIND_SPEED, WIND_TEMP, L_FORE, W_LEFT
							  ,TERRSAT_TIMESTAMP, TERRSAT_LAT, TERRSAT_LON, TERRSAT_SPEED, TEU, LIQUID_GAS, STATION_SHOW
							  FROM #tmpSYS131_VSHIPALL)
							  --xxxx OPTION (MAXDOP 1)
							  
		-- xxxx D.p: success message
		set @DetErrorMess=convert(varchar(400),@@ROWCOUNT);
		PRINT ' **** '+@@SERVERNAME+ '.'+DB_NAME()+'['+CONVERT(VARCHAR(19), GETDATE(),126)+']';
		PRINT ' ** v_ship_batch_all : (2nd INSERT on NOT:['+@syn_object+']) row(s) affected: ' + @DetErrorMess;
		
	COMMIT TRAN ins2;		
END TRY
BEGIN CATCH
	--
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
		--D.p: PRINT XACT_STATE(); 
		ROLLBACK TRAN ins2;
		-- D.p: PRINT 'after: ' + CAST(XACT_STATE() AS VARCHAR(10));
	END;
	-- detailed error message....return
	PRINT ' **** '+@@SERVERNAME+ '.'+DB_NAME()+'['+CONVERT(VARCHAR(19), GETDATE(),126)+']';
	RAISERROR(@DetErrorMess, @ErrorSeverity, @ErrorState) WITH LOG;
	RETURN;
END CATCH;
-- ** ENDoF:  2nd INSERT ON [V_SHIP_TEMP]
		
		
		
-- ** [09:12 22/1/2017]  Cleanup #tmp
PRINT ' **** '+@@SERVERNAME+ '.'+DB_NAME()+'['+CONVERT(VARCHAR(19), GETDATE(),126)+']';
PRINT ' ** v_ship_batch_all :  DROPing tmp tb: #tmpSYS131_VSHIPALL';
drop table #tmpSYS131_VSHIPALL;
	
		
--export to CSV, to be imported to mySQL
--exec msdb..sp_start_job 'export_V_SHIP_BATCH'

--ADD NEW SHIPS INTO SHIP_WIKI
PRINT ' **** '+@@SERVERNAME+ '.'+DB_NAME()+'['+CONVERT(VARCHAR(19), GETDATE(),126)+']';
PRINT ' ** v_ship_batch_all :  ADD NEW SHIPS INTO SHIP_WIKI';
insert into SHIP_WIKI (MMSI,IMO,BUILT_YEAR,DWT,LOA,BEAM,DRAFT,GT) (SELECT MMSI,IMO,YOB,DWT,LENGTH,WIDTH,DRAUGHT,GRT FROM V_SHIP_BATCH WITH(NOLOCK) WHERE 
NOT EXISTS (SELECT 1 FROM SHIP_WIKI A WITH(NOLOCK) WHERE (A.IMO>1000000 AND A.IMO=V_SHIP_BATCH.IMO) OR (A.IMO<1000000 AND A.MMSI=V_SHIP_BATCH.MMSI)))

END




GO
