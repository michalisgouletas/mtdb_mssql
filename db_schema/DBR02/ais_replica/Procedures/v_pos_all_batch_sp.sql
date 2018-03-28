USE [ais_replica]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- =============================================
--CREATE 
CREATE PROCEDURE [dbo].[v_pos_all_batch_sp]
AS
/* ***
**	[CORE-3413, SYS-156] [16:34 20/12/2016]
**		change  proc:  [sp_rename]  to  [ALTER SCHEMA .. TRANFER ]
**
*** */
BEGIN
	SET NOCOUNT ON;
	SET QUERY_GOVERNOR_COST_LIMIT 0

--V_POS_ALL
--TRUNCATE TABLE V_POS_ALL_TEMP
--INSERT INTO V_POS_ALL_TEMP (SHIP_ID, MMSI, STATUS, SPEED, LON, LAT, COURSE, HEADING, TIMESTAMP, SHIPNAME, LENGTH, WIDTH, DESTINATION, IMO, CALLSIGN, ETA, DRAUGHT, 
--                      COUNT_PHOTOS, SHIPTYPE, [TYPE_NAME], TYPE_COLOR, PORT_NAME, CENTERX, CENTERY, ZOOM, STATUS_NAME, TYPE_SUMMARY, PORT_ID, 
--                      STATION, CODE2, COUNTRY, ICON, SHIPTIME, AREA_NAME, OPERATOR, STATION_VIA, ALTITUDE)
--(SELECT SHIP_ID, MMSI, STATUS, SPEED, LON, LAT, COURSE, HEADING, TIMESTAMP, SHIPNAME, LENGTH, WIDTH, DESTINATION, IMO, CALLSIGN, ETA, DRAUGHT, 
--                      COUNT_PHOTOS, SHIPTYPE, [TYPE_NAME], TYPE_COLOR, PORT_NAME, CENTERX, CENTERY, ZOOM, STATUS_NAME, TYPE_SUMMARY, PORT_ID, 
--                      STATION, CODE2, COUNTRY, ICON, SHIPTIME, AREA_NAME, OPERATOR, STATION_VIA, ALTITUDE FROM MT1.ais.dbo.V_POS_ALL WITH(NOLOCK))

----SWAP NAMES - FASTER
--BEGIN TRAN
--exec sp_rename 'V_POS_ALL_BATCH', 'V_POS_ALL_TEMP1'
--exec sp_rename 'V_POS_ALL_TEMP', 'V_POS_ALL_BATCH'
--exec sp_rename 'V_POS_ALL_TEMP1', 'V_POS_ALL_TEMP'
--COMMIT

SELECT * INTO #V_POS FROM V_POS_BATCH WITH(NOLOCK)


--CLUSTERED DATA
MERGE shad.V_POS_CLUSTERED_TEMP A
USING (SELECT *
FROM #V_POS WITH(NOLOCK)
WHERE SHIP_ID IN
(SELECT SHIP_ID FROM
(SELECT ROW_NUMBER()OVER (PARTITION BY ROUND(LAT, 1), ROUND(LON, 1) ORDER BY DWT DESC) AS ROWNUMBER, SHIP_ID
FROM V_POS_BATCH WITH(NOLOCK)) A WHERE ROWNUMBER=1)) B
ON A.SHIP_ID=B.SHIP_ID
WHEN MATCHED AND (A.TERRSAT_TIMESTAMP<>B.TERRSAT_TIMESTAMP) THEN
  UPDATE
  SET A.STATUS=B.STATUS,A.SPEED=B.SPEED,A.LON=B.LON,A.LAT=B.LAT,A.COURSE=B.COURSE,A.HEADING=B.HEADING,A.ROT=B.ROT,A.[TIMESTAMP]=B.[TIMESTAMP],
  A.SHIPNAME=B.SHIPNAME,A.SHIPTYPE=B.SHIPTYPE,A.TYPE_GROUPED_ID=B.TYPE_GROUPED_ID,A.DWT=B.DWT,A.GT_SHIPTYPE=B.GT_SHIPTYPE,A.LENGTH=B.LENGTH,A.WIDTH=B.WIDTH,A.DESTINATION=B.DESTINATION,A.FLAG=B.FLAG,A.TYPE_COLOR=B.TYPE_COLOR,A.AREA_ID=B.AREA_ID,A.STATION=B.STATION
  ,L_FORE=B.L_FORE, W_LEFT=B.W_LEFT, AREA_NAME=B.AREA_NAME
  	,A.SAT_TIMESTAMP=B.SAT_TIMESTAMP, A.SAT_LAT=B.SAT_LAT, A.SAT_LON=B.SAT_LON, A.SAT_SPEED=B.SAT_SPEED, A.SAT_COURSE=B.SAT_COURSE, A.IS_COASTAL=B.IS_COASTAL, A.SAT_HEADING=B.SAT_HEADING, 
    A.SAT60_TIMESTAMP=B.SAT60_TIMESTAMP, A.SAT60_LAT=B.SAT60_LAT, A.SAT60_LON=B.SAT60_LON, A.SAT60_SPEED=B.SAT60_SPEED, A.SAT60_COURSE=B.SAT60_COURSE, 
	A.SAT360_TIMESTAMP=B.SAT360_TIMESTAMP, A.SAT360_LAT=B.SAT360_LAT, A.SAT360_LON=B.SAT360_LON, A.SAT360_SPEED=B.SAT360_SPEED, A.SAT360_COURSE=B.SAT360_COURSE, 
    A.SAT720_TIMESTAMP=B.SAT720_TIMESTAMP, A.SAT720_LAT=B.SAT720_LAT, A.SAT720_LON=B.SAT720_LON, A.SAT720_SPEED=B.SAT720_SPEED, A.SAT720_COURSE=B.SAT720_COURSE
	,A.TERRSAT_TIMESTAMP = B.TERRSAT_TIMESTAMP, A.TERRSAT_LAT = B.TERRSAT_LAT, A.TERRSAT_LON = B.TERRSAT_LON, A.TERRSAT_SPEED = B.TERRSAT_SPEED, A.TERRSAT_COURSE = B.TERRSAT_COURSE
WHEN NOT MATCHED BY TARGET THEN
  INSERT (SHIP_ID, MMSI,STATUS,SPEED,LON,LAT,COURSE,HEADING,ROT,[TIMESTAMP],SHIPNAME,SHIPTYPE,TYPE_GROUPED_ID,DWT,GT_SHIPTYPE,LENGTH,WIDTH,DESTINATION,FLAG,TYPE_COLOR,AREA_ID,STATION
    ,L_FORE, W_LEFT, AREA_NAME
  	,SAT_TIMESTAMP, SAT_LAT, SAT_LON, SAT_SPEED, SAT_COURSE, IS_COASTAL, SAT_HEADING, 
    SAT60_TIMESTAMP, SAT60_LAT, SAT60_LON, SAT60_SPEED, SAT60_COURSE, SAT360_TIMESTAMP, SAT360_LAT, SAT360_LON, SAT360_SPEED, SAT360_COURSE, 
    SAT720_TIMESTAMP, SAT720_LAT, SAT720_LON, SAT720_SPEED, SAT720_COURSE, TERRSAT_TIMESTAMP, TERRSAT_LAT, TERRSAT_LON, TERRSAT_SPEED, TERRSAT_COURSE)
  VALUES (B.SHIP_ID, B.MMSI,B.STATUS,B.SPEED,B.LON,B.LAT,B.COURSE,B.HEADING,B.ROT,B.[TIMESTAMP],B.SHIPNAME,B.SHIPTYPE,B.TYPE_GROUPED_ID,B.DWT,B.GT_SHIPTYPE,B.LENGTH,B.WIDTH,B.DESTINATION,B.FLAG,B.TYPE_COLOR,B.AREA_ID,B.STATION
    ,B.L_FORE, B.W_LEFT, B.AREA_NAME
  	,B.SAT_TIMESTAMP, B.SAT_LAT, B.SAT_LON, B.SAT_SPEED, B.SAT_COURSE, B.IS_COASTAL, B.SAT_HEADING, 
    B.SAT60_TIMESTAMP, B.SAT60_LAT, B.SAT60_LON, B.SAT60_SPEED, B.SAT60_COURSE, 
	B.SAT360_TIMESTAMP, B.SAT360_LAT, B.SAT360_LON, B.SAT360_SPEED, B.SAT360_COURSE, 
    B.SAT720_TIMESTAMP, B.SAT720_LAT, B.SAT720_LON, B.SAT720_SPEED, B.SAT720_COURSE,
	B.TERRSAT_TIMESTAMP, B.TERRSAT_LAT, B.TERRSAT_LON, B.TERRSAT_SPEED, B.TERRSAT_COURSE)
WHEN NOT MATCHED BY SOURCE THEN
  DELETE;

PRINT @@SERVERNAME+ '.'+DB_NAME()+'['+CONVERT(VARCHAR(19), GETDATE(),126)+'] -- ** V_POS_CLUSTERED';
/* [CORE-3413, SYS-156] [16:34 20/12/2016]
BEGIN TRAN
exec sp_rename 'V_POS_CLUSTERED', 'V_POS_CLUSTERED_TEMP1'
exec sp_rename 'V_POS_CLUSTERED_TEMP', 'V_POS_CLUSTERED'
exec sp_rename 'V_POS_CLUSTERED_TEMP1', 'V_POS_CLUSTERED_TEMP'
COMMIT
*/
BEGIN TRAN
	EXEC sp_rename N'shad.V_POS_CLUSTERED_TEMP', N'V_POS_CLUSTERED';
	ALTER SCHEMA fk TRANSFER dbo.V_POS_CLUSTERED;
	ALTER SCHEMA dbo TRANSFER shad.V_POS_CLUSTERED;
	ALTER SCHEMA shad TRANSFER fk.V_POS_CLUSTERED;
	EXEC sp_rename N'shad.V_POS_CLUSTERED', N'V_POS_CLUSTERED_TEMP';
COMMIT TRAN;


MERGE shad.V_POS_CLUSTERED_TEMP A
USING (SELECT *
FROM #V_POS WITH(NOLOCK)
WHERE SHIP_ID IN
(SELECT SHIP_ID FROM
(SELECT ROW_NUMBER()OVER (PARTITION BY ROUND(LAT, 2), ROUND(LON, 2) ORDER BY DWT DESC) AS ROWNUMBER, SHIP_ID
FROM V_POS_BATCH WITH(NOLOCK)) A WHERE ROWNUMBER=1)) B

ON A.SHIP_ID=B.SHIP_ID
WHEN MATCHED AND (A.TERRSAT_TIMESTAMP<>B.TERRSAT_TIMESTAMP) THEN
  UPDATE
  SET A.STATUS=B.STATUS,A.SPEED=B.SPEED,A.LON=B.LON,A.LAT=B.LAT,A.COURSE=B.COURSE,A.HEADING=B.HEADING,A.ROT=B.ROT,A.[TIMESTAMP]=B.[TIMESTAMP],A.SHIPNAME=B.SHIPNAME
  ,A.SHIPTYPE=B.SHIPTYPE,A.TYPE_GROUPED_ID=B.TYPE_GROUPED_ID,A.DWT=B.DWT,A.GT_SHIPTYPE=B.GT_SHIPTYPE,A.LENGTH=B.LENGTH,A.WIDTH=B.WIDTH,A.DESTINATION=B.DESTINATION,A.FLAG=B.FLAG,A.TYPE_COLOR=B.TYPE_COLOR,A.AREA_ID=B.AREA_ID,A.STATION=B.STATION
  ,L_FORE=B.L_FORE, W_LEFT=B.W_LEFT, AREA_NAME=B.AREA_NAME
  	,A.SAT_TIMESTAMP=B.SAT_TIMESTAMP, A.SAT_LAT=B.SAT_LAT, A.SAT_LON=B.SAT_LON, A.SAT_SPEED=B.SAT_SPEED, A.SAT_COURSE=B.SAT_COURSE, A.IS_COASTAL=B.IS_COASTAL, A.SAT_HEADING=B.SAT_HEADING, 
    A.SAT60_TIMESTAMP=B.SAT60_TIMESTAMP, A.SAT60_LAT=B.SAT60_LAT, A.SAT60_LON=B.SAT60_LON, A.SAT60_SPEED=B.SAT60_SPEED, A.SAT60_COURSE=B.SAT60_COURSE, 
	A.SAT360_TIMESTAMP=B.SAT360_TIMESTAMP, A.SAT360_LAT=B.SAT360_LAT, A.SAT360_LON=B.SAT360_LON, A.SAT360_SPEED=B.SAT360_SPEED, A.SAT360_COURSE=B.SAT360_COURSE, 
    A.SAT720_TIMESTAMP=B.SAT720_TIMESTAMP, A.SAT720_LAT=B.SAT720_LAT, A.SAT720_LON=B.SAT720_LON, A.SAT720_SPEED=B.SAT720_SPEED, A.SAT720_COURSE=B.SAT720_COURSE
	,A.TERRSAT_TIMESTAMP = B.TERRSAT_TIMESTAMP, A.TERRSAT_LAT = B.TERRSAT_LAT, A.TERRSAT_LON = B.TERRSAT_LON, A.TERRSAT_SPEED = B.TERRSAT_SPEED, A.TERRSAT_COURSE = B.TERRSAT_COURSE
WHEN NOT MATCHED BY TARGET THEN
  INSERT (SHIP_ID, MMSI,STATUS,SPEED,LON,LAT,COURSE,HEADING,ROT,[TIMESTAMP],SHIPNAME,SHIPTYPE,TYPE_GROUPED_ID,DWT,GT_SHIPTYPE,LENGTH,WIDTH,DESTINATION,FLAG,TYPE_COLOR,AREA_ID,STATION
    ,L_FORE, W_LEFT, AREA_NAME
   	,SAT_TIMESTAMP, SAT_LAT, SAT_LON, SAT_SPEED, SAT_COURSE, IS_COASTAL, SAT_HEADING, 
    SAT60_TIMESTAMP, SAT60_LAT, SAT60_LON, SAT60_SPEED, SAT60_COURSE, SAT360_TIMESTAMP, SAT360_LAT, SAT360_LON, SAT360_SPEED, SAT360_COURSE, 
    SAT720_TIMESTAMP, SAT720_LAT, SAT720_LON, SAT720_SPEED, SAT720_COURSE, TERRSAT_TIMESTAMP, TERRSAT_LAT, TERRSAT_LON, TERRSAT_SPEED, TERRSAT_COURSE)
  VALUES (B.SHIP_ID, B.MMSI,B.STATUS,B.SPEED,B.LON,B.LAT,B.COURSE,B.HEADING,B.ROT,B.[TIMESTAMP],B.SHIPNAME,B.SHIPTYPE,B.TYPE_GROUPED_ID,B.DWT,B.GT_SHIPTYPE,B.LENGTH,B.WIDTH,B.DESTINATION,B.FLAG,B.TYPE_COLOR,B.AREA_ID,B.STATION
    ,B.L_FORE, B.W_LEFT, B.AREA_NAME
   	,B.SAT_TIMESTAMP, B.SAT_LAT, B.SAT_LON, B.SAT_SPEED, B.SAT_COURSE, B.IS_COASTAL, B.SAT_HEADING, 
    B.SAT60_TIMESTAMP, B.SAT60_LAT, B.SAT60_LON, B.SAT60_SPEED, B.SAT60_COURSE, 
	B.SAT360_TIMESTAMP, B.SAT360_LAT, B.SAT360_LON, B.SAT360_SPEED, B.SAT360_COURSE, 
    B.SAT720_TIMESTAMP, B.SAT720_LAT, B.SAT720_LON, B.SAT720_SPEED, B.SAT720_COURSE,
	B.TERRSAT_TIMESTAMP, B.TERRSAT_LAT, B.TERRSAT_LON, B.TERRSAT_SPEED, B.TERRSAT_COURSE)
WHEN NOT MATCHED BY SOURCE THEN
  DELETE;

PRINT @@SERVERNAME+ '.'+DB_NAME()+'['+CONVERT(VARCHAR(19), GETDATE(),126)+'] -- ** V_POS_CLUSTERED2';
/* [CORE-3413, SYS-156] [16:34 20/12/2016]
BEGIN TRAN
exec sp_rename 'V_POS_CLUSTERED2', 'V_POS_CLUSTERED_TEMP1'
exec sp_rename 'V_POS_CLUSTERED_TEMP', 'V_POS_CLUSTERED2'
exec sp_rename 'V_POS_CLUSTERED_TEMP1', 'V_POS_CLUSTERED_TEMP'
COMMIT
*/

BEGIN TRAN
	EXEC sp_rename N'shad.V_POS_CLUSTERED_TEMP', N'V_POS_CLUSTERED2';
	ALTER SCHEMA fk TRANSFER dbo.V_POS_CLUSTERED2;
	ALTER SCHEMA dbo TRANSFER shad.V_POS_CLUSTERED2;
	ALTER SCHEMA shad TRANSFER fk.V_POS_CLUSTERED2;
	EXEC sp_rename N'shad.V_POS_CLUSTERED2', N'V_POS_CLUSTERED_TEMP';
COMMIT TRAN;


MERGE shad.V_POS_CLUSTERED_TEMP A
USING (SELECT *
FROM #V_POS WITH(NOLOCK)
WHERE SHIP_ID IN
(SELECT SHIP_ID FROM
(SELECT ROW_NUMBER()OVER (PARTITION BY ROUND(LAT, 3), ROUND(LON, 3) ORDER BY DWT DESC) AS ROWNUMBER, SHIP_ID
FROM V_POS_BATCH WITH(NOLOCK)) A WHERE ROWNUMBER=1)) B
ON A.SHIP_ID=B.SHIP_ID
WHEN MATCHED AND (A.TERRSAT_TIMESTAMP<>B.TERRSAT_TIMESTAMP) THEN
  UPDATE
  SET A.STATUS=B.STATUS,A.SPEED=B.SPEED,A.LON=B.LON,A.LAT=B.LAT,A.COURSE=B.COURSE,A.HEADING=B.HEADING,A.ROT=B.ROT,A.[TIMESTAMP]=B.[TIMESTAMP],A.SHIPNAME=B.SHIPNAME
  ,A.SHIPTYPE=B.SHIPTYPE,A.TYPE_GROUPED_ID=B.TYPE_GROUPED_ID,A.DWT=B.DWT,A.GT_SHIPTYPE=B.GT_SHIPTYPE,A.LENGTH=B.LENGTH,A.WIDTH=B.WIDTH,A.DESTINATION=B.DESTINATION,A.FLAG=B.FLAG,A.TYPE_COLOR=B.TYPE_COLOR,A.AREA_ID=B.AREA_ID,A.STATION=B.STATION
  ,L_FORE=B.L_FORE, W_LEFT=B.W_LEFT, AREA_NAME=B.AREA_NAME
  	,A.SAT_TIMESTAMP=B.SAT_TIMESTAMP, A.SAT_LAT=B.SAT_LAT, A.SAT_LON=B.SAT_LON, A.SAT_SPEED=B.SAT_SPEED, A.SAT_COURSE=B.SAT_COURSE, A.IS_COASTAL=B.IS_COASTAL, A.SAT_HEADING=B.SAT_HEADING, 
    A.SAT60_TIMESTAMP=B.SAT60_TIMESTAMP, A.SAT60_LAT=B.SAT60_LAT, A.SAT60_LON=B.SAT60_LON, A.SAT60_SPEED=B.SAT60_SPEED, A.SAT60_COURSE=B.SAT60_COURSE, 
	A.SAT360_TIMESTAMP=B.SAT360_TIMESTAMP, A.SAT360_LAT=B.SAT360_LAT, A.SAT360_LON=B.SAT360_LON, A.SAT360_SPEED=B.SAT360_SPEED, A.SAT360_COURSE=B.SAT360_COURSE, 
    A.SAT720_TIMESTAMP=B.SAT720_TIMESTAMP, A.SAT720_LAT=B.SAT720_LAT, A.SAT720_LON=B.SAT720_LON, A.SAT720_SPEED=B.SAT720_SPEED, A.SAT720_COURSE=B.SAT720_COURSE
	,A.TERRSAT_TIMESTAMP = B.TERRSAT_TIMESTAMP, A.TERRSAT_LAT = B.TERRSAT_LAT, A.TERRSAT_LON = B.TERRSAT_LON, A.TERRSAT_SPEED = B.TERRSAT_SPEED, A.TERRSAT_COURSE = B.TERRSAT_COURSE
WHEN NOT MATCHED BY TARGET THEN
  INSERT (SHIP_ID, MMSI,STATUS,SPEED,LON,LAT,COURSE,HEADING,ROT,[TIMESTAMP],SHIPNAME,SHIPTYPE,TYPE_GROUPED_ID,DWT,GT_SHIPTYPE,LENGTH,WIDTH,DESTINATION,FLAG,TYPE_COLOR,AREA_ID,STATION
    ,L_FORE, W_LEFT, AREA_NAME
   	,SAT_TIMESTAMP, SAT_LAT, SAT_LON, SAT_SPEED, SAT_COURSE, IS_COASTAL, SAT_HEADING, 
    SAT60_TIMESTAMP, SAT60_LAT, SAT60_LON, SAT60_SPEED, SAT60_COURSE, SAT360_TIMESTAMP, SAT360_LAT, SAT360_LON, SAT360_SPEED, SAT360_COURSE, 
    SAT720_TIMESTAMP, SAT720_LAT, SAT720_LON, SAT720_SPEED, SAT720_COURSE, TERRSAT_TIMESTAMP, TERRSAT_LAT, TERRSAT_LON, TERRSAT_SPEED, TERRSAT_COURSE)
  VALUES (B.SHIP_ID, B.MMSI,B.STATUS,B.SPEED,B.LON,B.LAT,B.COURSE,B.HEADING,B.ROT,B.[TIMESTAMP],B.SHIPNAME,B.SHIPTYPE,B.TYPE_GROUPED_ID,B.DWT,B.GT_SHIPTYPE,B.LENGTH,B.WIDTH,B.DESTINATION,B.FLAG,B.TYPE_COLOR,B.AREA_ID,B.STATION
    ,B.L_FORE, B.W_LEFT, B.AREA_NAME
   	,B.SAT_TIMESTAMP, B.SAT_LAT, B.SAT_LON, B.SAT_SPEED, B.SAT_COURSE, B.IS_COASTAL, B.SAT_HEADING, 
    B.SAT60_TIMESTAMP, B.SAT60_LAT, B.SAT60_LON, B.SAT60_SPEED, B.SAT60_COURSE, 
	B.SAT360_TIMESTAMP, B.SAT360_LAT, B.SAT360_LON, B.SAT360_SPEED, B.SAT360_COURSE, 
    B.SAT720_TIMESTAMP, B.SAT720_LAT, B.SAT720_LON, B.SAT720_SPEED, B.SAT720_COURSE,
	B.TERRSAT_TIMESTAMP, B.TERRSAT_LAT, B.TERRSAT_LON, B.TERRSAT_SPEED, B.TERRSAT_COURSE)
WHEN NOT MATCHED BY SOURCE THEN
  DELETE;

  PRINT @@SERVERNAME+ '.'+DB_NAME()+'['+CONVERT(VARCHAR(19), GETDATE(),126)+'] -- ** V_POS_CLUSTERED3';
/* [CORE-3413, SYS-156] [16:34 20/12/2016]
BEGIN TRAN
exec sp_rename 'V_POS_CLUSTERED3', 'V_POS_CLUSTERED_TEMP1'
exec sp_rename 'V_POS_CLUSTERED_TEMP', 'V_POS_CLUSTERED3'
exec sp_rename 'V_POS_CLUSTERED_TEMP1', 'V_POS_CLUSTERED_TEMP'
COMMIT
*/
BEGIN TRAN
	EXEC sp_rename N'shad.V_POS_CLUSTERED_TEMP', N'V_POS_CLUSTERED3';
	ALTER SCHEMA fk TRANSFER dbo.V_POS_CLUSTERED3;
	ALTER SCHEMA dbo TRANSFER shad.V_POS_CLUSTERED3;
	ALTER SCHEMA shad TRANSFER fk.V_POS_CLUSTERED3;
	EXEC sp_rename N'shad.V_POS_CLUSTERED3', N'V_POS_CLUSTERED_TEMP';
COMMIT TRAN;


MERGE shad.V_POS_CLUSTERED_TEMP A
USING (SELECT *
FROM #V_POS WITH(NOLOCK)
WHERE SHIP_ID IN
(SELECT SHIP_ID FROM
(SELECT ROW_NUMBER()OVER (PARTITION BY ROUND(LAT, 0), ROUND(LON, 0) ORDER BY DWT DESC) AS ROWNUMBER, SHIP_ID
FROM V_POS_BATCH WITH(NOLOCK)) A WHERE ROWNUMBER=1)) B
ON A.SHIP_ID=B.SHIP_ID
WHEN MATCHED AND (A.TERRSAT_TIMESTAMP<>B.TERRSAT_TIMESTAMP) THEN
  UPDATE
  SET A.STATUS=B.STATUS,A.SPEED=B.SPEED,A.LON=B.LON,A.LAT=B.LAT,A.COURSE=B.COURSE,A.HEADING=B.HEADING,A.ROT=B.ROT,A.[TIMESTAMP]=B.[TIMESTAMP],A.SHIPNAME=B.SHIPNAME
  ,A.SHIPTYPE=B.SHIPTYPE,A.TYPE_GROUPED_ID=B.TYPE_GROUPED_ID,A.DWT=B.DWT,A.GT_SHIPTYPE=B.GT_SHIPTYPE,A.LENGTH=B.LENGTH,A.WIDTH=B.WIDTH,A.DESTINATION=B.DESTINATION,A.FLAG=B.FLAG,A.TYPE_COLOR=B.TYPE_COLOR,A.AREA_ID=B.AREA_ID,A.STATION=B.STATION
  ,L_FORE=B.L_FORE, W_LEFT=B.W_LEFT, AREA_NAME=B.AREA_NAME
  	,A.SAT_TIMESTAMP=B.SAT_TIMESTAMP, A.SAT_LAT=B.SAT_LAT, A.SAT_LON=B.SAT_LON, A.SAT_SPEED=B.SAT_SPEED, A.SAT_COURSE=B.SAT_COURSE, A.IS_COASTAL=B.IS_COASTAL, A.SAT_HEADING=B.SAT_HEADING, 
    A.SAT60_TIMESTAMP=B.SAT60_TIMESTAMP, A.SAT60_LAT=B.SAT60_LAT, A.SAT60_LON=B.SAT60_LON, A.SAT60_SPEED=B.SAT60_SPEED, A.SAT60_COURSE=B.SAT60_COURSE, 
	A.SAT360_TIMESTAMP=B.SAT360_TIMESTAMP, A.SAT360_LAT=B.SAT360_LAT, A.SAT360_LON=B.SAT360_LON, A.SAT360_SPEED=B.SAT360_SPEED, A.SAT360_COURSE=B.SAT360_COURSE, 
    A.SAT720_TIMESTAMP=B.SAT720_TIMESTAMP, A.SAT720_LAT=B.SAT720_LAT, A.SAT720_LON=B.SAT720_LON, A.SAT720_SPEED=B.SAT720_SPEED, A.SAT720_COURSE=B.SAT720_COURSE
	,A.TERRSAT_TIMESTAMP = B.TERRSAT_TIMESTAMP, A.TERRSAT_LAT = B.TERRSAT_LAT, A.TERRSAT_LON = B.TERRSAT_LON, A.TERRSAT_SPEED = B.TERRSAT_SPEED, A.TERRSAT_COURSE = B.TERRSAT_COURSE
WHEN NOT MATCHED BY TARGET THEN
  INSERT (SHIP_ID, MMSI,STATUS,SPEED,LON,LAT,COURSE,HEADING,ROT,[TIMESTAMP],SHIPNAME,SHIPTYPE,TYPE_GROUPED_ID,DWT,GT_SHIPTYPE,LENGTH,WIDTH,DESTINATION,FLAG,TYPE_COLOR,AREA_ID,STATION
    ,L_FORE, W_LEFT, AREA_NAME
   	,SAT_TIMESTAMP, SAT_LAT, SAT_LON, SAT_SPEED, SAT_COURSE, IS_COASTAL, SAT_HEADING, 
    SAT60_TIMESTAMP, SAT60_LAT, SAT60_LON, SAT60_SPEED, SAT60_COURSE, SAT360_TIMESTAMP, SAT360_LAT, SAT360_LON, SAT360_SPEED, SAT360_COURSE, 
    SAT720_TIMESTAMP, SAT720_LAT, SAT720_LON, SAT720_SPEED, SAT720_COURSE, TERRSAT_TIMESTAMP, TERRSAT_LAT, TERRSAT_LON, TERRSAT_SPEED, TERRSAT_COURSE)
  VALUES (B.SHIP_ID, B.MMSI,B.STATUS,B.SPEED,B.LON,B.LAT,B.COURSE,B.HEADING,B.ROT,B.[TIMESTAMP],B.SHIPNAME,B.SHIPTYPE,B.TYPE_GROUPED_ID,B.DWT,B.GT_SHIPTYPE,B.LENGTH,B.WIDTH,B.DESTINATION,B.FLAG,B.TYPE_COLOR,B.AREA_ID,B.STATION
    ,B.L_FORE, B.W_LEFT, B.AREA_NAME
   	,B.SAT_TIMESTAMP, B.SAT_LAT, B.SAT_LON, B.SAT_SPEED, B.SAT_COURSE, B.IS_COASTAL, B.SAT_HEADING, 
    B.SAT60_TIMESTAMP, B.SAT60_LAT, B.SAT60_LON, B.SAT60_SPEED, B.SAT60_COURSE, 
	B.SAT360_TIMESTAMP, B.SAT360_LAT, B.SAT360_LON, B.SAT360_SPEED, B.SAT360_COURSE, 
    B.SAT720_TIMESTAMP, B.SAT720_LAT, B.SAT720_LON, B.SAT720_SPEED, B.SAT720_COURSE,
	B.TERRSAT_TIMESTAMP, B.TERRSAT_LAT, B.TERRSAT_LON, B.TERRSAT_SPEED, B.TERRSAT_COURSE)
WHEN NOT MATCHED BY SOURCE THEN
  DELETE;

PRINT @@SERVERNAME+ '.'+DB_NAME()+'['+CONVERT(VARCHAR(19), GETDATE(),126)+'] -- ** V_POS_CLUSTERED0';
/* [CORE-3413, SYS-156] [16:34 20/12/2016]
BEGIN TRAN
exec sp_rename 'V_POS_CLUSTERED0', 'V_POS_CLUSTERED_TEMP1'
exec sp_rename 'V_POS_CLUSTERED_TEMP', 'V_POS_CLUSTERED0'
exec sp_rename 'V_POS_CLUSTERED_TEMP1', 'V_POS_CLUSTERED_TEMP'
COMMIT
*/
BEGIN TRAN
	EXEC sp_rename N'shad.V_POS_CLUSTERED_TEMP', N'V_POS_CLUSTERED0';
	ALTER SCHEMA fk TRANSFER dbo.V_POS_CLUSTERED0;
	ALTER SCHEMA dbo TRANSFER shad.V_POS_CLUSTERED0;
	ALTER SCHEMA shad TRANSFER fk.V_POS_CLUSTERED0;
	EXEC sp_rename N'shad.V_POS_CLUSTERED0', N'V_POS_CLUSTERED_TEMP';
COMMIT TRAN;


MERGE shad.V_POS_CLUSTERED_TEMP A
USING (SELECT *
FROM #V_POS WITH(NOLOCK)
WHERE SHIP_ID IN
(SELECT SHIP_ID FROM
(SELECT ROW_NUMBER()OVER (PARTITION BY ROUND(LAT*3.0,0)/3.0, ROUND(LON*2.0,0)/2.0 ORDER BY DWT DESC, SPEED DESC) AS ROWNUMBER, SHIP_ID
FROM V_POS_BATCH WITH(NOLOCK)) A WHERE ROWNUMBER=1)) B
ON A.SHIP_ID=B.SHIP_ID
WHEN MATCHED AND (A.TERRSAT_TIMESTAMP<>B.TERRSAT_TIMESTAMP) THEN
  UPDATE
  SET A.STATUS=B.STATUS,A.SPEED=B.SPEED,A.LON=B.LON,A.LAT=B.LAT,A.COURSE=B.COURSE,A.HEADING=B.HEADING,A.ROT=B.ROT,A.[TIMESTAMP]=B.[TIMESTAMP],A.SHIPNAME=B.SHIPNAME
  ,A.SHIPTYPE=B.SHIPTYPE,A.TYPE_GROUPED_ID=B.TYPE_GROUPED_ID,A.DWT=B.DWT,A.GT_SHIPTYPE=B.GT_SHIPTYPE,A.LENGTH=B.LENGTH,A.WIDTH=B.WIDTH,A.DESTINATION=B.DESTINATION,A.FLAG=B.FLAG,A.TYPE_COLOR=B.TYPE_COLOR,A.AREA_ID=B.AREA_ID,A.STATION=B.STATION
  ,L_FORE=B.L_FORE, W_LEFT=B.W_LEFT, AREA_NAME=B.AREA_NAME
  	,A.SAT_TIMESTAMP=B.SAT_TIMESTAMP, A.SAT_LAT=B.SAT_LAT, A.SAT_LON=B.SAT_LON, A.SAT_SPEED=B.SAT_SPEED, A.SAT_COURSE=B.SAT_COURSE, A.IS_COASTAL=B.IS_COASTAL, A.SAT_HEADING=B.SAT_HEADING, 
    A.SAT60_TIMESTAMP=B.SAT60_TIMESTAMP, A.SAT60_LAT=B.SAT60_LAT, A.SAT60_LON=B.SAT60_LON, A.SAT60_SPEED=B.SAT60_SPEED, A.SAT60_COURSE=B.SAT60_COURSE, 
	A.SAT360_TIMESTAMP=B.SAT360_TIMESTAMP, A.SAT360_LAT=B.SAT360_LAT, A.SAT360_LON=B.SAT360_LON, A.SAT360_SPEED=B.SAT360_SPEED, A.SAT360_COURSE=B.SAT360_COURSE, 
    A.SAT720_TIMESTAMP=B.SAT720_TIMESTAMP, A.SAT720_LAT=B.SAT720_LAT, A.SAT720_LON=B.SAT720_LON, A.SAT720_SPEED=B.SAT720_SPEED, A.SAT720_COURSE=B.SAT720_COURSE
	,A.TERRSAT_TIMESTAMP = B.TERRSAT_TIMESTAMP, A.TERRSAT_LAT = B.TERRSAT_LAT, A.TERRSAT_LON = B.TERRSAT_LON, A.TERRSAT_SPEED = B.TERRSAT_SPEED, A.TERRSAT_COURSE = B.TERRSAT_COURSE
WHEN NOT MATCHED BY TARGET THEN
  INSERT (SHIP_ID, MMSI,STATUS,SPEED,LON,LAT,COURSE,HEADING,ROT,[TIMESTAMP],SHIPNAME,SHIPTYPE,TYPE_GROUPED_ID,DWT,GT_SHIPTYPE,LENGTH,WIDTH,DESTINATION,FLAG,TYPE_COLOR,AREA_ID,STATION
    ,L_FORE, W_LEFT, AREA_NAME
   	,SAT_TIMESTAMP, SAT_LAT, SAT_LON, SAT_SPEED, SAT_COURSE, IS_COASTAL, SAT_HEADING, 
    SAT60_TIMESTAMP, SAT60_LAT, SAT60_LON, SAT60_SPEED, SAT60_COURSE, SAT360_TIMESTAMP, SAT360_LAT, SAT360_LON, SAT360_SPEED, SAT360_COURSE, 
    SAT720_TIMESTAMP, SAT720_LAT, SAT720_LON, SAT720_SPEED, SAT720_COURSE, TERRSAT_TIMESTAMP, TERRSAT_LAT, TERRSAT_LON, TERRSAT_SPEED, TERRSAT_COURSE)
  VALUES (B.SHIP_ID, B.MMSI,B.STATUS,B.SPEED,B.LON,B.LAT,B.COURSE,B.HEADING,B.ROT,B.[TIMESTAMP],B.SHIPNAME,B.SHIPTYPE,B.TYPE_GROUPED_ID,B.DWT,B.GT_SHIPTYPE,B.LENGTH,B.WIDTH,B.DESTINATION,B.FLAG,B.TYPE_COLOR,B.AREA_ID,B.STATION
    ,B.L_FORE, B.W_LEFT, B.AREA_NAME
   	,B.SAT_TIMESTAMP, B.SAT_LAT, B.SAT_LON, B.SAT_SPEED, B.SAT_COURSE, B.IS_COASTAL, B.SAT_HEADING, 
    B.SAT60_TIMESTAMP, B.SAT60_LAT, B.SAT60_LON, B.SAT60_SPEED, B.SAT60_COURSE, 
	B.SAT360_TIMESTAMP, B.SAT360_LAT, B.SAT360_LON, B.SAT360_SPEED, B.SAT360_COURSE, 
    B.SAT720_TIMESTAMP, B.SAT720_LAT, B.SAT720_LON, B.SAT720_SPEED, B.SAT720_COURSE,
	B.TERRSAT_TIMESTAMP, B.TERRSAT_LAT, B.TERRSAT_LON, B.TERRSAT_SPEED, B.TERRSAT_COURSE)
WHEN NOT MATCHED BY SOURCE THEN
  DELETE;

PRINT @@SERVERNAME+ '.'+DB_NAME()+'['+CONVERT(VARCHAR(19), GETDATE(),126)+'] -- ** V_POS_CLUSTERED05';
/* [CORE-3413, SYS-156] [16:34 20/12/2016]
BEGIN TRAN
exec sp_rename 'V_POS_CLUSTERED05', 'V_POS_CLUSTERED_TEMP1'
exec sp_rename 'V_POS_CLUSTERED_TEMP', 'V_POS_CLUSTERED05'
exec sp_rename 'V_POS_CLUSTERED_TEMP1', 'V_POS_CLUSTERED_TEMP'
COMMIT
*/
BEGIN TRAN
	EXEC sp_rename N'shad.V_POS_CLUSTERED_TEMP', N'V_POS_CLUSTERED05';
	ALTER SCHEMA fk TRANSFER dbo.V_POS_CLUSTERED05;
	ALTER SCHEMA dbo TRANSFER shad.V_POS_CLUSTERED05;
	ALTER SCHEMA shad TRANSFER fk.V_POS_CLUSTERED05;
	EXEC sp_rename N'shad.V_POS_CLUSTERED05', N'V_POS_CLUSTERED_TEMP';
COMMIT TRAN;


DROP TABLE #V_POS

END





GO
