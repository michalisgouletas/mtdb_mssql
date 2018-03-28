USE [DBA_t01_00]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[V_POS_TERRSAT_720] AS 
SELECT      
	SHIP_ID, MMSI, IMO, STATUS, SHIPNAME, SHIPTYPE, TYPE_GROUPED_ID, GT_SHIPTYPE, DWT, FLAG, LENGTH, WIDTH, DRAUGHT, L_FORE, W_LEFT, CALLSIGN
	LAT, LON, SPEED, COURSE, HEADING, TIMESTAMP, ELAPSED, 
	AREA_ID, STATION, DESTINATION, ETA, PORT_ID
FROM V_POS_BATCH
UNION ALL
SELECT      
	SHIP_ID, MMSI, IMO, SAT_STATUS, SHIPNAME, SHIPTYPE, TYPE_GROUPED_ID, GT_SHIPTYPE, DWT, FLAG, LENGTH, WIDTH, DRAUGHT, L_FORE, W_LEFT, CALLSIGN
	SAT720_LAT, SAT720_LON, SAT720_SPEED, SAT720_COURSE, SAT720_COURSE, SAT720_TIMESTAMP, DATEDIFF(MINUTE, GETUTCDATE(), SAT720_TIMESTAMP),
	SAT_AREA_ID, 1000, DESTINATION, ETA, SAT_PORT_ID
FROM V_POS_SAT_BATCH

GO
