USE [ais_replica]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW dbo.V_POS_FAKE
AS
SELECT        TOP (50)
                             (SELECT        TOP (1) MMSI
                               FROM            dbo.LAST_SEEN_SHIP
                               WHERE        (COURSE = dbo.V_POS_BATCH.HEADING)) AS MMSI, STATUS, CONVERT(int, RAND() * SPEED * 10) AS SPEED, LON + RAND() * RAND() 
                         * 2 AS LON, LAT - RAND() AS LAT, FLOOR(HEADING * RAND() * 1.45) AS HEADING, TIMESTAMP, DESTINATION AS SHIPNAME, SHIPTYPE, 
                         FLOOR((LENGTH - WIDTH) + RAND() * 10) AS LENGTH, FLOOR((WIDTH + LENGTH / 10) - RAND() * 10) AS WIDTH, DESTINATION, FLAG, TYPE_COLOR, 
                         AREA_ID, ELAPSED, 0 AS STATION
FROM            dbo.V_POS_BATCH


GO
