USE [master]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--
CREATE PROC dbo.sp_chk_inst_DBs
	( -- set paticular DB_Name
		@strDBname as varchar(100) = null, -- * DEFAULT = null (show all DBs)
		-- Show MSSQL server instance Info
		@show_serverInsInfo BIT = 1 -- * DEFAULT = 1 (Show)
	)
AS
/* *** sp_chk_inst_DBs
*	[20150929] added set paticular DB_Name : @strDBname
*	[16:10 22/10/2015] added Restore DB Info
*	[15:50 04/03/2016] added @show_serverInsInfo INput Var
* ***/

BEGIN;

-- discard rowcount info messages
SET NOCOUNT ON

IF (@show_serverInsInfo = 1) 
BEGIN;
	print '/* -- server info: */'
	select
		-- server info
		CONVERT(VARCHAR(50), SERVERPROPERTY('Servername')) [server\instance]
		, case SERVERPROPERTY ( 'IsClustered' )
			when 0 then 'Not_Clustered'
			when 1 then 'Clustered'
			Else CONVERT(VARCHAR(50), SERVERPROPERTY ( 'IsClustered' ))
		  END [isClustered]
		, osi.virtual_machine_type_desc 	
		,rtrim(ltrim(cast(SERVERPROPERTY('productversion') as varchar(20)))) --SQLServerDatabaseEngine_version 
		 + ' (' +rtrim(ltrim(cast(SERVERPROPERTY ('productlevel') as varchar(10)))) --product_level
		 + ') - ' +rtrim(ltrim(cast(SERVERPROPERTY ('edition') as varchar(40)))) [SQLServerDBEngine ( product_level - SP ) - edition]
		, CONVERT(VARCHAR(50), SERVERPROPERTY('MachineName')) [Windows_computer_name], CONVERT(VARCHAR(10), SERVERPROPERTY('IsSingleUser')) [IsSingleUser]
		, CONVERT(VARCHAR(20), SERVERPROPERTY('ProcessID')) [Instance_OS_ProcID]
		-- [13:24 18/9/2015] dm_os_sys_info
		, ' os_sys_info -> ' [______]
		, osi.cpu_count, osi.hyperthread_ratio
		, osi.physical_memory_kb/1024 physical_memory_mb , osi.virtual_memory_kb/1024 [virtual_memory_mb]
		, osi.sqlserver_start_time
		, osi.max_workers_count , osi.scheduler_count
	from sys.dm_os_sys_info osi
	;
	--
	print '___________________'
	print '(*) : virtual_machine_type_desc : Describes the virtual_machine_type column. Not nullable.'
	print '		NONE = SQL Server is not running inside a virtual machine.'
	print '		HYPERVISOR = SQL Server is running inside a hypervisor, which implies a hardware-assisted virtualization. '
	print '		When the Hyper_V role is installed, the hypervisor hosts the OS, so an instance running on the host OS is running in the hypervisor.'
	print '		OTHER = SQL Server is running inside a virtual machine that does not employ hardware assistant such as Microsoft Virtual PC.'
	print '		____ Applies to: SQL Server 2008 R2 through SQL Server 2016.'
	print ''
-- ENDoF IF
END;


SET NOCOUNT OFF
print ''
print ''
print '/* -- databases info  ('+ convert(varchar(20),getdate(),120) +') : */'
print '';
--
-- Last Restore (cte) full info
WITH c_restLast AS (
		SELECT  [rs].[destination_database_name], db_id(rs.destination_database_name) DB_id,
		        restMax.last_restore_date,
		        --x [rs].[restore_date] ,
		        rs.user_name AS [Restored_By], rs.restore_type,
				CASE WHEN rs.restore_type = 'D' THEN 'FullDatabase'
				  WHEN rs.restore_type = 'F' THEN 'File'
				  WHEN rs.restore_type = 'G' THEN 'Filegroup'
				  WHEN rs.restore_type = 'I' THEN 'Differential'
				  WHEN rs.restore_type = 'L' THEN 'Log'
				  WHEN rs.restore_type = 'V' THEN 'Verifyonly'
				  WHEN rs.restore_type = 'R' THEN 'Revert'
				  ELSE rs.restore_type 
				 END AS [Restore_Type_Descr],
		        [bs].[backup_start_date] ,
		        --x [bs].[backup_finish_date] ,
		        --x [bs].[database_name] AS [source_database_name] ,
		        [bmf].[physical_device_name] AS [Restored_From], --[backup_file_used_for_restore]
		        [bs].server_name +'.'+ [bs].[database_name] AS [source_server_db]
		FROM   msdb..restorehistory rs
		       INNER JOIN msdb..backupset bs ON [rs].[backup_set_id] = [bs].[backup_set_id]
		       INNER JOIN msdb..backupmediafamily bmf ON [bs].[media_set_id] = [bmf].[media_set_id]
		       INNER JOIN (
			        SELECT [rs1].[destination_database_name], rs1.restore_type, MAX([rs1].[restore_date]) [last_restore_date]
					FROM    msdb..restorehistory rs1
					        INNER JOIN msdb..backupset bs1 ON [rs1].[backup_set_id] = [bs1].[backup_set_id]
					        INNER JOIN msdb..backupmediafamily bmf1 ON [bs1].[media_set_id] = [bmf1].[media_set_id]
					GROUP BY [rs1].[destination_database_name], rs1.restore_type
		        ) AS restMax  ON rs.restore_date = restMax.last_restore_date
)
-- AllOuter Select stmt
SELECT ao.dbname, ao.dbid, ao.DB_Status "[DB_Status : DataModfStatus : DB UserAccess]",ao.sysdb_status_owner "[sysDBs_Status : DB Owner]",
	ao.LAST_DB_BACKUP_DATE, ao.backup_type_dscr, ao.backup_size_MB,
	ao.backup_physical_device_name, ao.db_created_dt, ao.compatibility_level, ao.db_Recovery_model, ao.db_Collation
	--xx D.P : 	,ord_void, sel_db_void
	-- Last Restore
	, ao.LAST_RESTORE_DATE, ao.[Restore_Type_Descr], ao.Restored_By, ao.Restored_From, ao.source_server_db RestoreSource_server_db
FROM (Select
	-- Ordering CompColumn (fake)
	CASE when  sdb.dbid <= 4
		THEN  0
		ELSE  1
	END   as  ord_void
	, CASE WHEN db_id(@strDBname) is null OR db_id(@strDBname)=sdb.dbid THEN 1
		ELSE 0
	END as sel_db_void
	-- gen database info
	,sdb.dbid, CONVERT(VARCHAR(50), sdb.name) dbname
	, cast(DATABASEPROPERTYEX(sdb.name, 'Status') as varchar(10)) 
		+ ' : ' + cast(DATABASEPROPERTYEX(sdb.name, 'Updateability') as varchar(20))
		+ ' : ' + cast(DATABASEPROPERTYEX(sdb.name, 'UserAccess')as varchar(10))  DB_Status, cast(sdb.status as varchar(10)) + ' : ' +suser_sname(sdb.sid) sysdb_status_owner
	, sdb.crdate db_created_dt, sdb.cmptlevel compatibility_level
	, w.backup_type, w.backup_type_dscr, w.last_db_backup_date, (w.backup_size/1024)/1024 backup_size_MB
	, m.physical_device_name as backup_physical_device_name
	, CONVERT(VARCHAR(30), DATABASEPROPERTYEX(sdb.name, 'Recovery')) db_Recovery_model
	, CONVERT(VARCHAR(40), DATABASEPROPERTYEX(sdb.name, 'Collation')) db_Collation
	-- Last Restore
	, c_restLast.last_restore_date, c_restLast.[Restore_Type_Descr], c_restLast.Restored_By, c_restLast.Restored_From, c_restLast.source_server_db
	from (master..sysdatabases sdb 
		-- Last Backup Db INFO (only MAX)
		LEFT JOIN (
					SELECT abmax.database_name, abmax.backup_type, abmax.backup_type_dscr,
						 abmax.last_db_backup_date, ibs.backup_size
					 FROM (
							SELECT bs.database_name, bs.type backup_type,
							   CASE bs.type WHEN 'D' THEN 'FullDatabase'
								  WHEN 'F' THEN 'File'
								  WHEN 'G' THEN 'Filegroup'
								  WHEN 'I' THEN 'Differential'
								  WHEN 'L' THEN 'Log'
								  WHEN 'V' THEN 'Verifyonly'
								  WHEN 'R' THEN 'Revert'
								   ELSE  bs.type
							   END AS backup_type_dscr,   
							   MAX(bs.backup_finish_date) AS last_db_backup_date 
							 FROM  msdb.dbo.backupmediafamily  bmf
							   INNER JOIN msdb.dbo.backupset bs ON bmf.media_set_id = bs.media_set_id 
							 GROUP BY 
							   bs.database_name , bs.type
						   ) as abmax
					-- get backup_size of MAX(backup_finish_date)
					 LEFT JOIN (select database_name, backup_finish_date, type, backup_size
									from msdb.dbo.backupset) AS ibs
						 ON ibs.database_name = abmax.database_name AND ibs.type = abmax.backup_type
										AND ibs.backup_finish_date = abmax.last_db_backup_date
	   
	     ) w ON db_id(sdb.name) = db_id(w.database_name) --xxxx ON lower(sdb.name) = lower(w.database_name)
			) LEFT JOIN 
				( select bmf1.physical_device_name, bmf1.media_set_id, bs1.backup_finish_date, bs1.database_name 
					from msdb.dbo.backupmediafamily bmf1 
						INNER JOIN msdb.dbo.backupset bs1 ON bmf1.media_set_id = bs1.media_set_id 
				) m 
				ON w.last_db_backup_date = m.backup_finish_date and db_id(w.database_name) = db_id(m.database_name)
				-- ** Last Restore DB info
				-- c_restLast
				LEFT JOIN c_restLast ON sdb.dbid = c_restLast.DB_id
					AND CASE WHEN w.backup_type = c_restLast.restore_type THEN w.backup_type
						WHEN w.backup_type IS NULL THEN c_restLast.restore_type
						--ELSE NULL
						 END  = c_restLast.restore_type

		-- ENDoF : AllOuter Select stmt
		) ao
	--
	WHERE ao.sel_db_void = 1
	--	
	ORDER BY
		ao.ord_void, ao.dbname, ao.backup_type
;

--
print '___________________'
print '(**) : Attribute ''backup_size_MB'' refers to actual db-backup-size and not ''Conmpressed_size'' allocated on disk'
print '		(compression works on MSSQL2008R2+ systems only)'
print ''
print ''


-- ENDoF sp_chk_inst_DBs
SET NOCOUNT OFF
END;

GO
