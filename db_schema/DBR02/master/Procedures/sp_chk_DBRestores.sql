USE [master]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--
CREATE PROC dbo.sp_chk_DBRestores
	(	-- substitute for whatever desatabase name is checked
		@dbname sysname = NULL	-- * DEFAULT = NUll (Show ALL DBs)
		-- previous number of days to Check, default to 30
		, @days int = 30
	)
AS
BEGIN;
	SET NOCOUNT ON
	------------------------------------------------------------------------------------------- 
	-- Database Restores CHECK
	------------------------------------------------------------------------------------------- 
	-- -- **  ...\MSSQL\02_Restores_hist.sql
	-- [https://www.mssqltips.com/sqlservertip/1724/when-was-the-last-time-your-sql-server-database-was-restored/]
	print ''
	print '/* -- Database Restores CHECK: (for ' + cast(@days as varchar(10)) +' Days back) */'
	print ''

	SELECT
	 rsh.destination_database_name AS [Database],
	 rsh.user_name AS [Restored By],
	 CASE WHEN rsh.restore_type = 'D' THEN 'Database'
	  WHEN rsh.restore_type = 'F' THEN 'File'
	  WHEN rsh.restore_type = 'G' THEN 'Filegroup'
	  WHEN rsh.restore_type = 'I' THEN 'Differential'
	  WHEN rsh.restore_type = 'L' THEN 'Log'
	  WHEN rsh.restore_type = 'V' THEN 'Verifyonly'
	  WHEN rsh.restore_type = 'R' THEN 'Revert'
	  ELSE rsh.restore_type 
	 END AS [Restore Type] , 
	 rf.destination_phys_name AS [Restored_To],
	 rsh.restore_date AS [Restore_Started],
	 bmf.physical_device_name AS [Restored_From], 
	 [bs].[backup_start_date] ,
	 [bs].[backup_finish_date] ,
	 [bs].server_name +'.'+ [bs].[database_name] AS [source_server_db]
	FROM msdb.dbo.restorehistory rsh
	 left JOIN msdb.dbo.backupset bs ON rsh.backup_set_id = bs.backup_set_id
	 left JOIN msdb.dbo.restorefile rf ON rsh.restore_history_id = rf.restore_history_id
	 left JOIN msdb.dbo.backupmediafamily bmf ON bmf.media_set_id = bs.media_set_id
	WHERE rsh.restore_date >= DATEADD(dd, -1*ISNULL(@days, 30), GETDATE()) --want to search for previous days
	AND rsh.destination_database_name = ISNULL(@dbname, rsh.destination_database_name) --if no dbname, then return all
	ORDER BY rsh.restore_history_id DESC
	;
	--
	print ''


	-- -- ** ENDoF: Database Restores CHECK
	-- -- -- --
	--

	-- ** ENDoF sp_chk_DBRestores
	SET NOCOUNT OFF
END;

GO
