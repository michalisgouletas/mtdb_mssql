USE [master]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--
/* ***** [dbo].[sp_chk_ErrLog]	Date: 14/7/2015 11:38:51 ******/
CREATE PROC [dbo].[sp_chk_ErrLogAll]
	(	-- Set errorLog id : {0 (Current) , 1 - 6}
		@intErrLogId tinyint = 0,	-- * DEFAULT = 0 (Current)
		-- Set days before current date to be searched
		@intDaysBefore tinyint = 4, -- * DEFAULT = 4 Days before current date
		--Search error log with a specific key word
		@nvarKeyWord nvarchar(40) = NULL -- DEFAULT = NULL all error log
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
print '/* --    Searched with ' + ISNULL(@nvarKeyWord, 'NULL') + ' keyword */';
print '/* --  KeyWord suggestions: lock , rror, significant, I/O, occurrence(s) of I/O requests taking longer than, high priority, Login failed'
--

declare @Time_Start datetime;
set @Time_Start = getdate() - @intDaysBefore;


CREATE TABLE #ErrorLog (logdate datetime
                      , processinfo varchar(255)
                      , Message varchar(1500))
-- Populate the temporary table
INSERT #ErrorLog (logdate, processinfo, Message)
   EXEC master.dbo.xp_readerrorlog @intErrLogId, 1, @nvarKeyWord, null , @Time_Start, null, N'desc';
-- Filter the temporary table
SELECT * FROM #ErrorLog 

ORDER BY logdate DESC
-- Drop the temporary table 
DROP TABLE #ErrorLog
--
print '___________________'
print '(***) : Errors Information:'
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

-- ** ENDoF sp_chk_ErrLogAll
SET NOCOUNT OFF
END;


GO
