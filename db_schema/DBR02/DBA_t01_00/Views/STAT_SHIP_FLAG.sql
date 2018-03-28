USE [DBA_t01_00]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[STAT_SHIP_FLAG]
AS
SELECT     TOP (100) PERCENT COUNT(*) AS COUNTER, CODE2, COUNTRY
FROM         dbo.V_SHIP_BATCH
WHERE     (IMO > 0) AND (SHIPTYPE < 100)
GROUP BY CODE2, COUNTRY
ORDER BY counter DESC



GO
