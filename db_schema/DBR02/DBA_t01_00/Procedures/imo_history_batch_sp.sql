USE [DBA_t01_00]
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
CREATE PROCEDURE [dbo].[imo_history_batch_sp]
AS
BEGIN
	SET NOCOUNT ON;
	SET QUERY_GOVERNOR_COST_LIMIT 0

TRUNCATE TABLE IMO_HISTORY_BATCH
INSERT INTO IMO_HISTORY_BATCH (MMSI, IMO, CALLSIGN, SHIPNAME, TIMESTAMP, CODE2, COUNTRY)
(SELECT MMSI, IMO, CALLSIGN, SHIPNAME, TIMESTAMP, CODE2, COUNTRY FROM MT1.ais.dbo.IMO_HISTORY WITH(NOLOCK))

INSERT INTO IMO_HISTORY_BATCH (MMSI, IMO, SHIPNAME, TIMESTAMP)
(SELECT   AA, IMO, LEFT(EXNAME,20), UNTIL FROM  MT1.ais.dbo.SHIP_EXNAMES WITH(NOLOCK) 
WHERE     NOT EXISTS (SELECT     1 AS Expr1
                            FROM          MT1.ais.dbo.SHIP_HISTORY WITH(NOLOCK) 
							/* [19:26 28/2/2017] Added Collation just like sp on (mt1),
							*	due to error: 'imo_history_job': step: imo_step | Executed as user: MT14\mssqlsvc. Cannot resolve the collation conflict between "SQL_Latin1_General_CP1_CI_AS" and "SQL_Latin1_General_CP1_CI_AI" in the equal to operation. [SQLSTATE 42000] (Error 468).  The step failed.
							*/
                            WHERE      (IMO = SHIP_EXNAMES.IMO) AND (SHIPNAME = SHIP_EXNAMES.EXNAME COLLATE DATABASE_DEFAULT)))
                            
                            
END


GO
