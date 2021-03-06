USE [master]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--
CREATE PROC dbo.sp_chk_DBFreeSpace
(	-- Show whole DB FreeSpace
	@show_DBFreeSpace BIT = 1,
	-- Show DB FIles Freespace
	@show_DB_Files_FreeSpace BIT = 1,
	-- set paticular DB_Name
	@strDBname as varchar(100) = null -- * DEFAULT = null (show all DBs)
)
AS
--
------------------------------------------------------------------------------------------- 
-- db Free Space over whole DB and over Db File
------------------------------------------------------------------------------------------- 
-- discard rowcount info messages

BEGIN;

SET NOCOUNT ON 
print '/* -- Free Space: */'
print ''
-- -- -- -- 
-- -- -- --
/* *** 01_DatafilesSpaceUsed_7wholeDb-DAvg_allUserdbs.sql
*		Check mssql Space Allocated/Used
*
*	extra query added with wholeDb space metrics
*	[20150227]  tempdb..Results  replaced with  #Results
*	[20150227] avgUsedDaily + EXTEND_DAYS1 extra columns added
*	[20150310] added exclusion of 'OFFLINE' Dbs
*	[20150929] added set paticular DB_Name : @strDBname
****/

declare @dbname varchar(100), @dbid int
declare @strSql nvarchar(1000)

declare c_dbs cursor FOR
select name, dbid 
from master..sysdatabases A
		INNER JOIN sys.database_mirroring B
			ON A.dbid=B.database_id
			-- INCLUDE DBs with 'Mirroring not configured'
	WHERE (b.mirroring_role is null 
			-- get Mirrorig DBs, but
			-- EXCLUDE mirroring_role_desc:=MIRROR (reason: mirror Role DBs are in 'Restoring' status )
			OR b.mirroring_role <> 2)
		AND DATABASEPROPERTYEX(A.name, 'Status') not in ('OFFLINE', 'RESTORING')
-- and A.dbid > 4 -- only user dbs
;


-- create temp tb Results
create table #Results(
      db sysname NULL ,
      FileType varchar(4) NOT NULL,
      [FileGroup] sysname null,
      [FileName] sysname NOT NULL,
      TotalMB numeric(18,2) NOT NULL,
      UsedMB numeric(18,2) NULL,
      PctUsed numeric(18,2) NULL,
      FilePATH nvarchar(2000) NULL,
      FileID int null,
	  MaxSizeMB numeric(18,2) NULL,
	  GrowthMB numeric(18,2) NULL
)


open c_dbs
FETCH NEXT FROM c_dbs INTO @dbname, @dbid

WHILE (@@FETCH_STATUS = 0)
BEGIN
-----------------------
-- print '-------------------'
-- print 'db: ' + @dbname

	create table #Data(
		  FileID int NOT NULL,
		  [FileGroupId] int NOT NULL,
		  TotalExtents int NOT NULL,
		  UsedExtents int NOT NULL,
		  [FileName] sysname NOT NULL,
		  [FilePath] varchar(2000) NOT NULL,
		  [FileGroup] varchar(2000) NULL
	)


	create table #Log(
		  db sysname NOT NULL,
		  LogSize numeric(18,5) NOT NULL,
		  LogUsed numeric(18,5) NOT NULL,
		  Status int NOT NULL,
		  [FilePath] varchar(2000) NULL
	)
 

	--
	-- Insert DATA files
	set @strSql = N'use [' + @dbname + '];DBCC showfilestats WITH NO_INFOMSGS'
	-- debug.print
	-- print 'db strSql: ' + @strSql

	INSERT #Data (Fileid , [FileGroupId], TotalExtents ,
				UsedExtents , [FileName] , [FilePath])
	EXEC (@strSql)


	SET @strSql = 'update #Data
	set #data.Filegroup = s.groupname
	from #data, ['+ @dbname +']..sysfilegroups s
	where #data.FilegroupId = s.groupid'
	-- debug.print
	-- print 'db strSql: ' + @strSql

	 EXEC (@strSql)
	 

	INSERT INTO #Results (db, [FileGroup], FileType , [FileName], TotalMB ,
				UsedMB ,    PctUsed ,   FilePATH, FileID)
	SELECT @dbname db,
				[FileGroup],
				'Data' FileType,
				[FileName],
				TotalExtents * 64./1024. TotalMB,
				UsedExtents * 64./1024. UsedMB,
				CASE WHEN [TotalExtents]=0 THEN 0
					ELSE  UsedExtents * 100. /[TotalExtents]  
				END UsedPct,
				[FilePath],
				FileID
	FROM #Data
	order BY 1,2;

	 

	--
	-- Insert Log files
	insert #Log (db,LogSize,LogUsed,Status )
	exec('dbcc sqlperf(logspace)  WITH NO_INFOMSGS')


	SET @strSql = 'use [' + @dbname + '];
	insert #Results(db, [FileGroup], FileType, [FileName],  TotalMB, UsedMB, PctUsed, FilePath, FileID)
	select ''' + @dbname + ''' db, 
				''Log'' [FileGroup],
				''Log'' FileType,
				s.[name] [FileName],
				s.Size/128. as LogSize ,
				FILEPROPERTY(s.name,''spaceused'')/8.00 /16.00 As LogUsedSpace,
				((FILEPROPERTY(s.name,''spaceused'')/8.00 /16.00)*100)/(s.Size/128.) UsedPct,
				s.FileName FilePath,
				s.FileId FileID
		  from #Log l , master.dbo.sysaltfiles f , ['+ @dbname +'].dbo.sysfiles s
		  where f.dbid = ' + str(@dbid) +
		  ' and (s.status & 0x40) <> 0
		  and s.fileid=f.fileid
		  and l.db = ''' + @dbname + ''''
	-- debug.print
	-- print 'db strSql: ' + @strSql

	 EXEC (@strSql)
	 
	--
	-- Insert final attributes
	SET @strSql = 'update #Results
	set MaxSizeMB = CASE WHEN s.maxsize = -1 THEN null
							 else CONVERT(decimal(18,2), s.maxsize /128.)
		  END, GrowthMB = CONVERT(decimal(18,2), s.growth /128.)
	FROM 
	#Results r INNER JOIN [' + @dbname + '].dbo.sysfiles s ON r.FileID = s.FileID
	where db = ''' + @dbname + ''''

	-- debug.print
	-- print 'db strSql: ' + @strSql

	 EXEC (@strSql)

	-- 
	-- Drop temp tables
	DROP TABLE #Data
	DROP TABLE #Log

	--
	FETCH NEXT FROM c_dbs INTO @dbname, @dbid

-----------------------

END -- EndOf c_dbs cursor WHILE

CLOSE c_dbs;
DEALLOCATE c_dbs;


-- **** Print Results
---------------------
IF (@show_DBFreeSpace = 1) 
BEGIN;
	-- print whole Db sizes
	print '';
	print '    /* -- Dbs Free Space */';
	print ''
	;
	WITH afw2 AS
	(	SELECT r.db, r.FileType, r.[FileGroup],
			  sum(r.TotalMB) sumOf_TotalMB, sum(UsedMB) sumOf_UsedMB,sum(r.TotalMB) - sum(UsedMB) sumOf_FREEMB
			  , CASE WHEN sum(r.TotalMB)=0 THEN null
				ELSE CAST(ROUND((sum(UsedMB)/sum(r.TotalMB))*100,2) as decimal(10,2)) END PctUsed
		FROM #Results r
		group by r.db, r.FileType, r.[FileGroup]
	)
	select afw2.db, afw2.FileType, afw2.FileGroup, afw2.sumOf_TotalMB, afw2.sumOf_UsedMB, afw2.sumOf_FREEMB, afw2.PctUsed
		--
		, case when datediff(DAY, sdb.create_date, getdate()) = 0
			THEN null		-- exclude 0 days db_created_dt (divide by zero)
			ELSE
			 -- cast(afw.SumOfSize_MB as decimal(9,3)) / datediff(DAY, sdb.create_date, getdate()) 
			 afw2.sumOf_UsedMB / datediff(DAY, sdb.create_date, getdate()) 
		   END as [avgUsedDaily_MB]
		--
		-- * (1) compute EXTEND dividing with avgUsedDaily
		, case when datediff(DAY, sdb.create_date, getdate()) = 0 OR afw2.sumOf_UsedMB=0
			THEN null		-- exclude 0 days db_created_dt (divide by zero)
			ELSE
			 -- Daily avg on USED_MB
			 -- calc EXTEND_DAYS on used_mb
			 afw2.sumOf_FREEMB / (afw2.sumOf_UsedMB / datediff(DAY, sdb.create_date, getdate()) )
		   END as [EXTEND_DAYS1]
		, sdb.create_date db_created_dt
		--xx D.P : 
		/*xx , CASE WHEN db_id(@strDBname) is null OR db_id(@strDBname)=sdb.database_id THEN 1
			ELSE 0
		END as sel_db_void */
	FROM afw2 left join master.sys.databases sdb ON afw2.db = sdb.name
	-- [13:46 29/9/2015]
	WHERE CASE WHEN db_id(@strDBname) is null OR db_id(@strDBname)=sdb.database_id THEN 1
			ELSE 0  END  =  1
	--
	ORDER BY 1,2,3
	;
-- ENDoF IF
END;

IF (@show_DB_Files_FreeSpace = 1) 
BEGIN;
	-- print db files
	print ''
	print '    /* -- Db-Files Free Space */'
	print ''
	SELECT r.*
	FROM #Results r left join master.sys.databases sdb ON r.db = sdb.name
	-- [13:46 29/9/2015]
	WHERE CASE WHEN db_id(@strDBname) is null OR db_id(@strDBname)=sdb.database_id THEN 1
			ELSE 0  END  =  1
	--
	ORDER BY 1,2,3,4,5,9
	--
	print ''
	print ''
-- ENDoF If
END;

--
-- Drop temp tables
DROP TABLE #Results

-- -- ** ENDoF: sp_chk_DBFreeSpace
SET NOCOUNT OFF
END;

GO
