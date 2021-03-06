USE [master]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--
/* ***** [dbo].[sp_chk_ErrLog]	Date: 14/7/2015 11:38:51 ******/
CREATE PROC [dbo].[sp_chk_ErrLog]
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
		OR Message LIKE '%SQL Server is starting at high priority base%' /*(priority needs to be changed back to normal)*/
		OR Message LIKE '%occurrence(s) of I/O requests taking longer than%' /*(storage performance issues)*/
		OR Message LIKE '%lock%' /*Deadlocks*/ 
		OR Message LIKE '%[lL]og [sS]hipping%' /*LogShipping*/
		OR Message LIKE '%SQL Server shutdown%' /*SQL Server shutdown has been initiated*/ /*SQL Server is terminating in response to a 'stop' request from Service Control Manager*/
		OR Message LIKE '%SQL Server is starting%'/*SQL Server is starting at high priority base (=13)*/
		--xx [13:54 27/8/2015] OR Message LIKE '%FlushCache%' /*eg: FlushCache: cleaned up 227295 bufs with 25594 writes in 126334 ms (avoided 0 new dirty bufs) for db 14:0*/
		--xx [10:51 31/8/2015] OR Message LIKE '%AppDomain%' /*eg: AppDomain 5 (ais.dbo[runtime].4) is marked for unload due to memory pressure.*/
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

-- ** ENDoF sp_chk_ErrLog
SET NOCOUNT OFF
END;


GO
