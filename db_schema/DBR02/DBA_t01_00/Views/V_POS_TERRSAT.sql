USE [DBA_t01_00]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW "V_POS_TERRSAT" AS 
SELECT        LAT, LON, SHIPNAME, SHIPTYPE, TYPE_GROUPED_ID, DWT, COURSE, SPEED, FLAG, MMSI, LENGTH, ELAPSED, AREA_ID, STATION, TIMESTAMP,DESTINATION,ETA,PORT_ID
FROM            V_POS_BATCH
UNION ALL
SELECT        SAT_LAT, SAT_LON, SHIPNAME, SHIPTYPE, TYPE_GROUPED_ID, DWT, SAT_COURSE, SAT_SPEED, FLAG, MMSI, LENGTH, DATEDIFF(MINUTE, GETUTCDATE(), SAT_TIMESTAMP), 
                         SAT_AREA_ID, 1000, SAT_TIMESTAMP,DESTINATION,ETA,SAT_PORT_ID
FROM            V_POS_SAT_BATCH

 
GO
