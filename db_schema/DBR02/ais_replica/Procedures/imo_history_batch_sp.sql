USE [ais_replica]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- CREATE 
CREATE PROCEDURE [dbo].[imo_history_batch_sp]
AS
/* -- =============================================
* [17:26 26/3/2018] (CORE-6010) (CORE-5100): 
**	Altered source tbs from :  [MT1].ais  to  [MT2,1438].ais_shadc
*	
*	Stop-Using special Job ('imo_history_job') , for This _sp_: [imo_history_batch_sp]
**		and included execution on  [ais_shadc] Job:  'refr_batches_replc_D'
*		[...\doc_\MT_db_srv_setup\SYS-413_mssql2016Web_mtSetup_(DBR02)\SYS-414_DBR02_migr_ais_replica_from_mt2\CORE-5100_WeeklyRefresh_ais_tbs_on[ais_replica]\crsp_refrs_BATCHEs_dbr02.readme]
* =============================================	*/
BEGIN
	SET NOCOUNT ON;
	SET QUERY_GOVERNOR_COST_LIMIT 0

TRUNCATE TABLE IMO_HISTORY_BATCH;
INSERT INTO IMO_HISTORY_BATCH (MMSI, IMO, CALLSIGN, SHIPNAME, TIMESTAMP, CODE2, COUNTRY)
(SELECT MMSI, IMO, CALLSIGN, SHIPNAME, TIMESTAMP, CODE2, COUNTRY FROM [MT2,1438].ais_shadc.dbo.IMO_HISTORY WITH(NOLOCK))
;
--
PRINT '**** [imo_history_batch_sp]: '+ @@SERVERNAME+ '.'+DB_NAME()+ '.'+USER_NAME()+' ['+CONVERT(VARCHAR(19), GETDATE(),126)+'] ENDoF: INSERT INTO [IMO_HISTORY_BATCH]..FROM ais_shadc.dbo.[IMO_HISTORY] , Rows Affected: '+convert(varchar(20), @@ROWCOUNT);  

INSERT INTO IMO_HISTORY_BATCH (MMSI, IMO, SHIPNAME, TIMESTAMP)
(SELECT   AA, IMO, LEFT(EXNAME,20), UNTIL FROM  [MT2,1438].ais_shadc.dbo.SHIP_EXNAMES WITH(NOLOCK) 
WHERE     NOT EXISTS (SELECT     1 AS Expr1
                            FROM          [MT2,1438].ais_shadc.dbo.SHIP_HISTORY WITH(NOLOCK) 
							/* [19:26 28/2/2017] Added Collation just like sp on (mt1),
							*	due to error: 'imo_history_job': step: imo_step | Executed as user: MT14\mssqlsvc. Cannot resolve the collation conflict between "SQL_Latin1_General_CP1_CI_AS" and "SQL_Latin1_General_CP1_CI_AI" in the equal to operation. [SQLSTATE 42000] (Error 468).  The step failed.
							*/
                            WHERE      (IMO = SHIP_EXNAMES.IMO) AND (SHIPNAME = SHIP_EXNAMES.EXNAME COLLATE DATABASE_DEFAULT)))
 ;
 PRINT '**** [imo_history_batch_sp]: '+ @@SERVERNAME+ '.'+DB_NAME()+ '.'+USER_NAME()+' ['+CONVERT(VARCHAR(19), GETDATE(),126)+'] ENDoF: INSERT INTO [IMO_HISTORY_BATCH]..FROM ais_shadc.dbo.[SHIP_EXNAMES] , Rows Affected: '+convert(varchar(20), @@ROWCOUNT);
                            
END


GO
