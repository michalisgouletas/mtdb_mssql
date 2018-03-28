USE [DBA_t01_00]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW dbo.LAST_POS_SAT_ONLY
AS
SELECT        TOP (100) PERCENT MMSI, LON, LAT, AREA_ID, AREA_NAME, PORT_ID, PORT_NAME, TIMESTAMP, CONFIRMED, SPEED, COURSE, STATUS, 
                         COALESCE (CASE WHEN SAT720_TIMESTAMP > TIMESTAMP AND TIMESTAMP < DATEADD(MINUTE, - 180, GETUTCDATE()) THEN - 2 ELSE NULL END, 
                         CASE WHEN SAT360_TIMESTAMP > TIMESTAMP AND TIMESTAMP < DATEADD(MINUTE, - 180, GETUTCDATE()) THEN - 1 ELSE NULL END, 
                         CASE WHEN SAT_TIMESTAMP > DATEADD(MINUTE, 30, TIMESTAMP) THEN 1000 ELSE NULL END, STATION) AS STATION, HEADING, IS_COASTAL, 
                         SAT60_TIMESTAMP, SAT60_LAT, SAT60_LON, SAT60_SPEED, SAT60_COURSE, SAT360_TIMESTAMP, SAT360_LAT, SAT360_LON, SAT360_SPEED, 
                         SAT360_COURSE, SAT720_TIMESTAMP, SAT720_LAT, SAT720_LON, SAT720_SPEED, SAT720_COURSE, SAT_LON, SAT_LAT, SAT_AREA_ID, 
                         SAT_AREA_NAME, SAT_PORT_NAME, SAT_PORT_ID, SAT_TIMESTAMP, SAT_SPEED, SAT_COURSE, SAT_STATUS, SAT_HEADING, SHIP_ID, IMO, CALLSIGN, 
                         ROT, DRAUGHT, SHIPNAME, SHIPTYPE, LENGTH, WIDTH, ETA, DESTINATION, SHIP_TIMESTAMP, FLAG_CODE, SAT_DESTINATION, SAT_ETA, 
                         SAT_SHIPTIME, L_FORE, W_LEFT
FROM            dbo.LAST_SEEN_SHIP
WHERE        (CONFIRMED = 1) AND (SAT_TIMESTAMP > TIMESTAMP) AND (SAT_TIMESTAMP > DATEADD(HOUR, - 24, getutcdate())) OR
                         (CONFIRMED = 1) AND (SAT_TIMESTAMP > TIMESTAMP) AND (SAT360_TIMESTAMP > DATEADD(HOUR, - 24, GETUTCDATE())) OR
                         (CONFIRMED = 1) AND (SAT_TIMESTAMP > TIMESTAMP) AND (SAT720_TIMESTAMP > DATEADD(HOUR, - 24, GETUTCDATE()))


GO
