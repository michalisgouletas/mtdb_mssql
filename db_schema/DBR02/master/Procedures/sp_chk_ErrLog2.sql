USE [master]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--
/* ***** [dbo].[sp_chk_ErrLog2]	Date: 13:57 27/8/2015 
* _sp with more extented quick checks filtered from xp_readerrorlog
*	than the first version [sp_chk_ErrLog]
******/
CREATE PROC [dbo].[sp_chk_ErrLog2]
	(	-- Set errorLog id : {0 (Current) , 1 - 6}
		@intErrLogId tinyint = 0,	-- * DEFAULT = 0 (Current)
		-- Set days before current date to be searched
		@intDaysBefore tinyint = 4 -- * DEFAULT = 4 Days before current date
	)
AS
BEGIN;
SET NOCOUNT ON
------------------------------------------------------------------------------------------- 
-- server Logread errors, failed
------------------------------------------------------------------------------------------- 
-- -- **  wrk_abox\dba\MSSQL\00_LogRead.sql
--
print ''
print '/* -- Errorlog (id: ' + cast(@intErrLogId as varchar(10)) + ': Search errors, failed: */'
print '/* --    Searched '+ cast(@intDaysBefore as varchar(10)) +' Days back */'
--
declare @Time_Start datetime;
declare @Time_End datetime;
set @Time_Start=getdate() - @intDaysBefore;
set @Time_End=getdate();
-- Create the temporary table
CREATE TABLE #ErrorLog (logdate datetime
                      , processinfo varchar(255)
                      , Message varchar(1500))
-- Populate the temporary table
INSERT #ErrorLog (logdate, processinfo, Message)
   EXEC master.dbo.xp_readerrorlog @intErrLogId, 1, null, null , @Time_Start, @Time_End, N'desc';
-- Filter the temporary table
SELECT LogDate, Message FROM #ErrorLog
WHERE (Message LIKE '%[eE]rror%' OR Message LIKE '%[fF]ailed%'  
		OR Message LIKE '%A significant part of sql server memory has been paged out%' /*incorrect memory configuration*/
		OR Message LIKE '%SQL Server is starting at high priority%' /*(priority needs to be changed back to normal)*/
		OR Message LIKE '%occurrence(s) of I/O requests taking longer than%' /*(storage performance issues)*/
		OR Message LIKE '%lock%' /*Deadlocks*/ 
		OR Message LIKE '%[lL]og [sS]hipping%' /*LogShipping*/
		OR Message LIKE '%SQL Server shutdown%' /*SQL Server shutdown has been initiated*/ /*SQL Server is terminating in response to a 'stop' request from Service Control Manager*/
		OR Message LIKE '%SQL Server is starting%'/*SQL Server is starting at high priority base (=13)*/
		-- [13:54 27/8/2015]
		OR Message LIKE '%FlushCache%' /*eg: FlushCache: cleaned up 227295 bufs with 25594 writes in 126334 ms (avoided 0 new dirty bufs) for db 14:0*/
		OR Message LIKE '%AppDomain%' /*eg: AppDomain 5 (ais.dbo[runtime].4) is marked for unload due to memory pressure.*/
		OR Message LIKE '%Database backed up%' /*eg: Database backed up. Database: ais, creation date(time): 2015/04/30(17:43:11), pages dumped: 11895875, first LSN: 4703475:850231:58, last LSN: 4703479:310673:1, number of dump devices: 1, device information: (FILE=1, TYPE=DISK: {'F:\BACKUP\ais_backup_2015_11_09_033001_5898427.bak'}). This is an informational message only. No user action is required.*/
		OR Message LIKE '%Database was restored%' /*eg: Database was restored: Database: ais_shadc, creation date(time): 2015/04/30(17:43:11), first LSN: 4698854:175298:59, last LSN: 4698866:86936:1, number of dump devices: 1, device information: (FILE=1, TYPE=DISK: {'F:\Backup\ais_backup_2015_11_08_033001_1525039.bak'}). Informational message. No user action required.*/
		-- [11:03 8/12/2015]
		OR Message LIKE '%I/O%' /* I/O */
		)
 AND processinfo NOT LIKE '%logon%'
ORDER BY logdate DESC
-- Drop the temporary table 
DROP TABLE #ErrorLog
--
print '___________________'
print '(***) : errors searched by sql:'
print   '. ''A significant part of sql server memory has been paged out'''
print	'	(incorrect memory configuration)'
print	'. ''SQL Server has encountered x occurrence(s) of I/O requests taking longer than 15 seconds to complete on file'''
print	'	(storage performance issues)'
print	'. ''SQL Server is starting at high priority base'''
print	'	(priority needs to be changed back to normal)'
print	'. ''Deadlock encountered .... Printing deadlock information'''
print	'. ''deadlock-list'''
print	'	(deadlock)'
print ''
print ''
-- -- ** ENDoF: server Logread errors, failed
-- -- -- --
--

-- ** ENDoF sp_chk_ErrLog2
SET NOCOUNT OFF
END;


GO
