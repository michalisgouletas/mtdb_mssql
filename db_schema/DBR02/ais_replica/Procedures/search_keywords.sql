USE [ais_replica]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
-- CREATE 
CREATE PROCEDURE [dbo].[search_keywords]
AS
BEGIN
	SET NOCOUNT ON;
	SET QUERY_GOVERNOR_COST_LIMIT 0

/*Result types:
1. Vessel
2. Port
3. IMO
4. ExName
5. Photographer
6. Station
7. MMSI
8. MT Ship ID
9. Callsign
10. Light
*/

/* * [13/12/2017 13:50] (CORE-6011): migr SEARCH on DBR02(WebEdi) [ais_replica]
*		: alter _sp_ to get SEARCH data from mt2.ais_shadc
*		: NOT to Disable job v_ship_diff
*		: alter _job_ to execute morning after _shadc job
**/

-- [16:49 5/12/2017] CORE-6011: Enable-Disable  job_name='v_ship_diff' moved to separate Job-Step
-- [ENABLE]  Only on [search_keywords_step] :  Failure
--!!xx --Disable job v_ship_diff
--!!xx EXEC msdb.dbo.sp_update_job @job_name='v_ship_diff',@enabled = 0
--!!xx waitfor delay '00:00:30'

	DECLARE @DetErrorMess VARCHAR(MAX), @ErrorSeverity  tinyint, @ErrorState tinyint;
	-- ** [18:51 28/7/2016] DATA-2771: (mt1)_V_POS_BATCH1-2_logical_idx_corruption
	-- **	sp not failling totally after:  Error on UPDATEs
	BEGIN TRY
	BEGIN TRAN;
		--
		TRUNCATE TABLE SEARCH_TEMP --problem with full text index???
		--DELETE FROM [SEARCH_TEMP]

		--ship names
		INSERT INTO SEARCH_TEMP (KEYWORD,INFO,[TYPE], [TYPE_ID], ITEM_ID, SHIP_ID, RANK, TYPE_COLOR) 
		(SELECT     SHIPNAME, TYPE_NAME + ' ' + CASE WHEN STATUS='DEAD' THEN '[Dead]' WHEN CODE2 IS NULL THEN '' ELSE '['+CODE2+']' END AS Expr1, 'Vessel', 1
			,MMSI, SHIP_ID
			,COUNT_PHOTOS --Ranking calculation
			+ ROUND(LENGTH/10.0,0)
			- COALESCE(DATEDIFF(DAY,LAST_POS,GETUTCDATE())/5, 500)
			+ (SELECT COUNT(*) FROM [MT2,1438].ais_shadc.dbo.crm_collection_items INNER JOIN [MT2,1438].ais_shadc.dbo.crm_collections ON crm_collections.ID=collection_id 
				WHERE collection_type=1 AND ITEM=V_SHIP_BATCH.SHIP_ID)
			+ (SELECT COUNT(*) FROM [MT2,1438].ais_shadc.dbo.ALERTS WHERE ALERTS.SHIP_ID=V_SHIP_BATCH.SHIP_ID)
			+ CASE WHEN CODE2 IS NULL THEN -100 ELSE 0 END
			+ CASE WHEN IMO>0 THEN 20 ELSE 0 END
			, TYPE_COLOR
		FROM V_SHIP_BATCH 
		WHERE SHIPNAME IS NOT NULL)

		--ports
		INSERT INTO SEARCH_TEMP (KEYWORD,INFO,[TYPE], [TYPE_ID], ITEM_ID, RANK, LAT, LON) 
		(SELECT PORT_NAME, PORT_TYPE_NAME + ' [' + COUNTRY_CODE + ']', 
		CASE WHEN PORT_TYPE IN ('M','F','S') THEN 'Marina' ELSE 'Port' END, 
		CASE WHEN PORT_TYPE IN ('M','F','S') THEN 12 ELSE 2 END, 
		PORT_ID, ARRIVECOUNT+EXPECTEDCOUNT, CENTERY, CENTERX
		FROM PORTS_CURRENT_BATCH WITH(NOLOCK) 
		INNER JOIN [MT2,1438].ais_shadc.dbo.L_PORT_TYPE ON PORT_TYPE=PORT_TYPE_ID)
		ORDER BY ARRIVECOUNT+EXPECTEDCOUNT DESC, PORT_NAME

		INSERT INTO SEARCH_TEMP (KEYWORD,INFO,[TYPE], [TYPE_ID], ITEM_ID, RANK, LAT, LON) 
		(SELECT ALTNAME1, PORT_TYPE_NAME + ' [' + COUNTRY_CODE + ']', 
		CASE WHEN PORT_TYPE IN ('M','F','S') THEN 'Marina' ELSE 'Port' END, 
		CASE WHEN PORT_TYPE IN ('M','F','S') THEN 12 ELSE 2 END, 
		PORT_ID, (ARRIVECOUNT+EXPECTEDCOUNT)/5, CENTERY, CENTERX
		FROM PORTS_CURRENT_BATCH WITH(NOLOCK) 
		INNER JOIN [MT2,1438].ais_shadc.dbo.L_PORT_TYPE ON PORT_TYPE=PORT_TYPE_ID
		WHERE ALTNAME1 IS NOT NULL AND ALTNAME1<>'')
		ORDER BY ARRIVECOUNT+EXPECTEDCOUNT DESC, PORT_NAME

		INSERT INTO SEARCH_TEMP (KEYWORD,INFO,[TYPE], [TYPE_ID], ITEM_ID, RANK, LAT, LON) 
		(SELECT ALTNAME2, PORT_TYPE_NAME + ' [' + COUNTRY_CODE + ']', 
		CASE WHEN PORT_TYPE IN ('M','F','S') THEN 'Marina' ELSE 'Port' END, 
		CASE WHEN PORT_TYPE IN ('M','F','S') THEN 12 ELSE 2 END, 
		PORT_ID, 0, CENTERY, CENTERX
		FROM PORTS_CURRENT_BATCH WITH(NOLOCK) 
		INNER JOIN [MT2,1438].ais_shadc.dbo.L_PORT_TYPE ON PORT_TYPE=PORT_TYPE_ID
		WHERE ALTNAME2 IS NOT NULL AND ALTNAME2<>'')
		ORDER BY ARRIVECOUNT+EXPECTEDCOUNT DESC, PORT_NAME

		INSERT INTO SEARCH_TEMP (KEYWORD,INFO,[TYPE], [TYPE_ID], ITEM_ID, RANK, LAT, LON) 
		(SELECT ALTNAME3, PORT_TYPE_NAME + ' [' + COUNTRY_CODE + ']', 
		CASE WHEN PORT_TYPE IN ('M','F','S') THEN 'Marina' ELSE 'Port' END, 
		CASE WHEN PORT_TYPE IN ('M','F','S') THEN 12 ELSE 2 END, 
		PORT_ID, 0, CENTERY, CENTERX
		FROM PORTS_CURRENT_BATCH WITH(NOLOCK) 
		INNER JOIN [MT2,1438].ais_shadc.dbo.L_PORT_TYPE ON PORT_TYPE=PORT_TYPE_ID
		WHERE ALTNAME3 IS NOT NULL AND ALTNAME3<>'')
		ORDER BY ARRIVECOUNT+EXPECTEDCOUNT DESC, PORT_NAME

		INSERT INTO SEARCH_TEMP (KEYWORD,INFO,[TYPE], [TYPE_ID], ITEM_ID, RANK, LAT, LON) 
		(SELECT ALTNAME4, PORT_TYPE_NAME + ' [' + COUNTRY_CODE + ']', 
		CASE WHEN PORT_TYPE IN ('M','F','S') THEN 'Marina' ELSE 'Port' END, 
		CASE WHEN PORT_TYPE IN ('M','F','S') THEN 12 ELSE 2 END, 
		PORT_ID, 0, CENTERY, CENTERX
		FROM PORTS_CURRENT_BATCH WITH(NOLOCK) 
		INNER JOIN [MT2,1438].ais_shadc.dbo.L_PORT_TYPE ON PORT_TYPE=PORT_TYPE_ID
		WHERE ALTNAME4 IS NOT NULL AND ALTNAME4<>'')
		ORDER BY ARRIVECOUNT+EXPECTEDCOUNT DESC, PORT_NAME


		--UNLOCODE 5 digits
		INSERT INTO SEARCH_TEMP (KEYWORD,INFO,[TYPE], [TYPE_ID], ITEM_ID, RANK, LAT, LON) 
		(SELECT UNLOCODE, PORT_NAME + ', ' + COUNTRY_CODE, 'Port', 2, PORT_ID, 1, CENTERY, CENTERX
		FROM PORTS_CURRENT_BATCH WITH(NOLOCK) WHERE UNLOCODE IS NOT NULL AND len(UNLOCODE)=5)
		--UNLOCODE 3 digits
		INSERT INTO SEARCH_TEMP (KEYWORD,INFO,[TYPE], [TYPE_ID], ITEM_ID, RANK, LAT, LON) 
		(SELECT right(UNLOCODE,3), PORT_NAME + ', ' + COUNTRY_CODE, 'Port', 2, PORT_ID, -1, CENTERY, CENTERX
		FROM PORTS_CURRENT_BATCH WITH(NOLOCK) WHERE UNLOCODE IS NOT NULL AND len(UNLOCODE)=5)

		--IMO
		INSERT INTO SEARCH_TEMP (KEYWORD,INFO,[TYPE], [TYPE_ID], ITEM_ID, SHIP_ID, RANK, TYPE_COLOR) 
		(SELECT IMO, SHIPNAME + ' [' + CODE2 + ']', 'IMO number', 3, MMSI, SHIP_ID, 1, TYPE_COLOR
		FROM V_SHIP_BATCH 
		WHERE IMO>0)
		ORDER BY IMO

		--EX NAMES
		INSERT INTO SEARCH_TEMP (KEYWORD,INFO,[TYPE], [TYPE_ID], ITEM_ID, SHIP_ID, RANK, TYPE_COLOR) 
		(SELECT     SHIPNAME, 'Ex Name (' + CONVERT(varchar, IMO) + ')', 'Exname', 4, 
							  IMO, SHIP_ID, -1, TYPE_COLOR
		FROM [MT2,1438].ais_shadc.dbo.IMO_HISTORY_BATCH A WITH(NOLOCK) 
		CROSS APPLY (SELECT TOP 1 SHIP_ID, TYPE_COLOR FROM V_SHIP_BATCH B WITH(NOLOCK) WHERE B.IMO=A.IMO) C)
		ORDER BY SHIPNAME


		--PHOTOGRAPHERS
		INSERT INTO SEARCH_TEMP (KEYWORD,INFO,[TYPE], [TYPE_ID], RANK) 
		(SELECT left(COPYRIGHT,30), CONVERT(varchar,PHOTO_COUNT) + ' Photos', 'Photographer', 5, PHOTO_COUNT/50
		FROM MT1.ais2.dbo.V_PHOTOGRAPHER_BATCH WITH(NOLOCK) )
		ORDER BY PHOTO_COUNT DESC

		--stations
		INSERT INTO SEARCH_TEMP (KEYWORD,INFO,[TYPE], [TYPE_ID], ITEM_ID, RANK, LAT, LON) 
		(SELECT left(STATION_NAME,30), 'AIS Station', 'Station', 6, STATION_ID, 0, LAT_PUB, LON_PUB
		FROM [MT2,1438].ais_shadc.dbo.V_STATION_DETAILS)

		--real mmsi
		INSERT INTO SEARCH_TEMP (KEYWORD,INFO,[TYPE], [TYPE_ID], ITEM_ID, SHIP_ID, RANK, TYPE_COLOR) 
		(SELECT MMSI, COALESCE(SHIPNAME + ' [' + CODE2 + ']', 'No Data'), 'MMSI number', 7, MMSI, SHIP_ID, 0, TYPE_COLOR
		FROM V_SHIP_BATCH 
		WHERE MMSI<910000000 OR MMSI>919999999)
		ORDER BY V_SHIP_BATCH.MMSI

		--MT mmsi
		INSERT INTO SEARCH_TEMP (KEYWORD,INFO,[TYPE], [TYPE_ID], ITEM_ID, SHIP_ID, RANK, TYPE_COLOR) 
		(SELECT MMSI, COALESCE(SHIPNAME + ' [' + CODE2 + ']', 'No Data'), 'MT Ship ID', 8, MMSI, SHIP_ID, 0, TYPE_COLOR
		FROM V_SHIP_BATCH 
		WHERE MMSI>=910000000 AND MMSI<=919999999)
		ORDER BY V_SHIP_BATCH.MMSI

		--CALLSIGN
		INSERT INTO SEARCH_TEMP (KEYWORD,INFO,[TYPE], [TYPE_ID], ITEM_ID, SHIP_ID, RANK, TYPE_COLOR) 
		(SELECT CALLSIGN, SHIPNAME + ' [' + CALLSIGN + ']', 'Callsign', 9, MMSI, SHIP_ID, 0, TYPE_COLOR
		FROM V_SHIP_BATCH )

		--Lights
		INSERT INTO SEARCH_TEMP (KEYWORD,INFO,[TYPE], [TYPE_ID], ITEM_ID, RANK, LAT, LON) 
		(SELECT LIGHT_NAME, 'Lighthouse, ' + COUNTRY, 'Light', 10, LIGHT_ID, 0, LAT, LON
		FROM [MT2,1438].ais_shadc.dbo.LIGHTHOUSE WITH(NOLOCK) )
		ORDER BY LIGHT_NAME
		INSERT INTO SEARCH_TEMP (KEYWORD,INFO,[TYPE], [TYPE_ID], ITEM_ID, RANK, LAT, LON) 
		(SELECT ALT1, 'Lighthouse, ' + COUNTRY, 'Light', 10, LIGHT_ID, -1, LAT, LON
		FROM [MT2,1438].ais_shadc.dbo.LIGHTHOUSE WITH(NOLOCK)  WHERE ALT1 IS NOT NULL AND ALT1<>'')
		ORDER BY LIGHT_NAME
		INSERT INTO SEARCH_TEMP (KEYWORD,INFO,[TYPE], [TYPE_ID], ITEM_ID, RANK, LAT, LON) 
		(SELECT ALT2, 'Lighthouse, ' + COUNTRY, 'Light', 10, LIGHT_ID, -2, LAT, LON
		FROM [MT2,1438].ais_shadc.dbo.LIGHTHOUSE WITH(NOLOCK)  WHERE ALT2 IS NOT NULL AND ALT2<>'')
		ORDER BY LIGHT_NAME

		--Companies
		INSERT INTO SEARCH_TEMP (KEYWORD,INFO,[TYPE], [TYPE_ID], ITEM_ID, RANK, LAT, LON) 
		(SELECT LEFT(COM_NAME,50), INDUSTRYTERMS + COALESCE(',' + COUNTRY, ''), 'Company', 11, COM_ID, -1, LAT, LON
		FROM [MT2,1438].ais_shadc.dbo.COMPANY WITH(NOLOCK) WHERE verified=1)
		ORDER BY COM_NAME

	-- xxxx D.p: success message
	PRINT ' **** '+@@SERVERNAME+ '.'+DB_NAME()+'['+CONVERT(VARCHAR(19), GETDATE(),126)+']';
	PRINT ' ** [search_keywords] ENDoF: [SEARCH_TEMP] INSERTs  ' ;
	COMMIT TRAN;		
	END TRY
	BEGIN CATCH 
		SET CONCAT_NULL_YIELDS_NULL OFF;
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

		--!xxxx! --Enable job v_ship_diff
		--!xxxx! EXEC msdb.dbo.sp_update_job @job_name='v_ship_diff',@enabled = 1
		-- detailed error message....return
		RAISERROR(@DetErrorMess, @ErrorSeverity, @ErrorState) WITH LOG;
		SET CONCAT_NULL_YIELDS_NULL ON;
		RETURN;
	END CATCH;
	-- ** ENDoF:  [18:51 28/7/2016] DATA-2771


--export to CSV, to be imported to mySQL
--exec msdb..sp_start_job 'export_SEARCH'

--!!xxxx -- [16:49 5/12/2017] CORE-6011: Enable-Disable  job_name='v_ship_diff' moved to separate Job-Step
--!!xxxx -- [ENABLE]  Only on [search_keywords_step] :  Failure
--!!xxxx ---Enable job v_ship_diff
--!!xxxx EXEC msdb.dbo.sp_update_job @job_name='v_ship_diff',@enabled = 1

--Make sure that Full Text Index 'Track Changes' is set to OFF
PRINT ' **** '+@@SERVERNAME+ '.'+DB_NAME()+'['+CONVERT(VARCHAR(19), GETDATE(),126)+']';
PRINT ' ** [search_keywords] StartOf: SEARCH_TEMP START FULL POPULATION ' ;
ALTER FULLTEXT INDEX ON SEARCH_TEMP 
   START FULL POPULATION;

--Wait for the Full population to complete
WAITFOR DELAY '00:59';

IF (SELECT COUNT(*) FROM SEARCH_TEMP)>1000000
BEGIN TRAN
exec sp_rename 'SEARCH', 'SEARCH_TEMP1'
exec sp_rename 'SEARCH_TEMP', 'SEARCH'
exec sp_rename 'SEARCH_TEMP1', 'SEARCH_TEMP'
COMMIT
PRINT ' **** '+@@SERVERNAME+ '.'+DB_NAME()+'['+CONVERT(VARCHAR(19), GETDATE(),126)+']';
PRINT ' ** [search_keywords] ENDOf: SEARCH_TEMP sp_renames' ;

END



GO
