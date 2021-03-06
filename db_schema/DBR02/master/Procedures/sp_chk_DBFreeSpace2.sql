USE [master]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--
CREATE PROC dbo.sp_chk_DBFreeSpace2   
( -- Show whole DB FreeSpace    
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
BEGIN;    
-- discard rowcount info messages    
SET NOCOUNT ON     
SET ANSI_WARNINGS OFF    
print '/* -- Free Space: */'    
print ''    
    
DECLARE  @dbname VARCHAR(200)    
DECLARE  @exec_sql VARCHAR(500)    
DECLARE @dbid int    
    
    
    
/*Create 2 tables :  #db_file_info for file informations and #db for all databases names and ids */    
    
CREATE TABLE #db_file_info (    
  [Database_Name]    SYSNAME    NOT NULL,    
  [File_Type]        VARCHAR(10)    NOT NULL,    
  [File_Group]       VARCHAR(30)    NULL,    
  [File_Name]        SYSNAME    NOT NULL,    
  [TotalMB]          NUMERIC(18,2)  NULL,    
  [UsedMB]           NUMERIC(18,2)  NULL,    
  [FreeMB]           NUMERIC(18,2)  NULL,    
  [PctUsed]          NUMERIC(18,2)  NULL,    
  [File_Path]        VARCHAR(500)   NOT NULL,    
  [FileId]           SMALLINT       NOT NULL,    
  [MaxSizeMB]        NUMERIC(18,2)  NULL,    
  [MaxSize Description] VARCHAR (400) NULL,        
  [GrowthMB]         NUMERIC(18,2)  NULL      )    
    
    
/*Selecting all databases that are not in offline or restoring mode */    
declare c_dbs cursor FOR    
SELECT name, dbid      
FROM  MASTER.dbo.sysdatabases as A    
  INNER JOIN sys.database_mirroring B    
   ON A.dbid = B.database_id    
   -- INCLUDE DBs with 'Mirroring not configured'    
 WHERE (b.mirroring_role is null     
   -- get Mirrorig DBs, but    
   -- EXCLUDE mirroring_role_desc:=MIRROR (reason: mirror Role DBs are in 'Restoring' status )    
   OR b.mirroring_role <> 2)    
  AND DATABASEPROPERTYEX(A.name, 'Status') not in ('OFFLINE', 'RESTORING')     
    
open c_dbs    
FETCH NEXT FROM c_dbs INTO @dbname, @dbid    
    
WHILE (@@FETCH_STATUS = 0)    
  BEGIN    
    
    
    
/*For every database in the while loop 1st Step: Insert in the #db_file_info table the Database_Name , File_Type (Data, Log) , File_Group (PRIMARY , Log) ,    
File_Name , Used_Space in the DB , File_Path in the drive and File_ID, from master views sysfiles and sysfilegroups. At this step the other row columns are set to NULL (That's why we allow null values to this columns on the creation of the table) */    
        
    SET @exec_sql = ' USE ' + @dbname + '; Insert into #DB_FILE_INFO    
Select db_name(), case when sf.groupid = 0 then ''Log'' else ''Data'' end, sg.groupname ,    
name, CAST(size/128. AS NUMERIC(10,2)), CAST(FILEPROPERTY(name, ''SpaceUsed'') AS Numeric(10,2))/128.0 , NULL, NULL, filename, Fileid, NULL, NULL, NULL     
from dbo.sysfiles as sf left join sys.sysfilegroups as sg     
on  sf.groupid = sg.groupid  ; '     
EXEC( @exec_sql)    
    
    
     
/*View sysfilegroups contains data only for the data files in the database, therefore we can't select the group name for log files. 2nd Step: We set manually the group name as Log for every log file in the table*/    
    
SET @exec_sql = ' USE ' + @dbname + '; Update  #DB_FILE_INFO      
SET [File_Group] = ''Log''     
WHERE [File_Type] = ''Log'' ; '    
    
EXEC( @exec_sql)    
    
    
/*3rd Step: Update the null columns to #db_file_info table (TotalMB , MaxSizeMB , GrowthMB , MaxSize Description) with data from view sys.master_files for each file name */    
    
UPDATE #db_file_info    
SET      
TotalMB = CASE   
               WHEN TotalMB is null then 0.00   
      ELSE TotalMB END,  
[UsedMB] = CASE   
               WHEN UsedMB is null then 0.00   
      ELSE UsedMB END,                
MaxSizeMB = CASE      
                WHEN mf.max_size = -1 THEN NULL     
    WHEN mf.max_size = 0  THEN TotalMB    
    ELSE CONVERT(decimal(18,2), mf.max_size /128.) END ,    
GrowthMB = CONVERT(decimal(18,2), mf.growth /128.),    
[MaxSize Description] = CASE  WHEN fi.[File_Type] = 'Data' THEN       
           CASE    
                WHEN mf.max_size = -1 THEN 'File will grow until the disk is full.'    
    WHEN mf.max_size = 0  THEN 'No growth is allowed.'    
    WHEN mf.max_size = 268435456 THEN 'File will grow to a maximum size of 2 TB'    
    ELSE 'File will grow until the selected growth value'  END    
            ELSE    
           CASE    
                WHEN mf.max_size = -1 THEN 'Log file will grow until the disk is full.'    
    WHEN mf.max_size = 0  THEN 'No growth is allowed.'    
    WHEN mf.max_size = 268435456 THEN 'Log file will grow to a maximum size of 2 TB'    
    ELSE 'Log file will grow until the selected growth value'  END    
           END    
FROM #db_file_info as fi inner join sys.master_files  AS mf on fi.[File_Name] = mf.[name];    
    
    
/*4th Step: Compute Percentance used for each file name and update #db_file_info table column PctUsed with this value */    
UPDATE #db_file_info    
SET PctUsed = CASE     
               WHEN [TotalMB] = 0.00 THEN 0    
      ELSE  [UsedMB] * 100. / [TotalMB]  END ,    
    FreeMB = CASE   
            WHEN [TotalMB] - [UsedMB] is null then 0.00  
      ELSE [TotalMB] - [UsedMB] END ;    
       
 FETCH NEXT FROM c_dbs INTO @dbname, @dbid    
    
-----------------------    
    
END -- EndOf c_dbs cursor WHILE    
    
CLOSE c_dbs;    
DEALLOCATE c_dbs;    
    
    
IF (@show_DBFreeSpace = 1)     
BEGIN;    
    
    
WITH afw2 AS     
(    
SELECT f.[Database_Name], f.File_Type, f.[File_Group],    
     sum(f.TotalMB) as sumOf_TotalMB, sum(UsedMB) as sumOf_UsedMB,sum(f.TotalMB) - sum(UsedMB) as sumOf_FREEMB    
     , CASE WHEN sum(f.TotalMB)=0 THEN null    
    ELSE CAST(ROUND((sum(UsedMB)/sum(f.TotalMB))*100,2) as decimal(10,2)) END  as PctUsed     
  FROM #db_file_info as f     
  group by f.[Database_Name], f.File_Type, f.[File_Group]    
)    
    
SELECT afw2.[Database_Name] , afw2.File_Type, afw2.[File_Group], afw2.sumOf_TotalMB, afw2.sumOf_UsedMB, afw2.sumOf_FREEMB, afw2.PctUsed,    
case when datediff(DAY, sdb.create_date, getdate()) = 0    
   THEN null  -- exclude 0 days db_created_dt (divide by zero)    
   ELSE    
    -- cast(afw.SumOfSize_MB as decimal(9,3)) / datediff(DAY, sdb.create_date, getdate())     
    afw2.sumOf_UsedMB / datediff(DAY, sdb.create_date, getdate())     
     END as [avgUsedDaily_MB]    
  --    
  -- * (1) compute EXTEND dividing with avgUsedDaily    
  , case when datediff(DAY, sdb.create_date, getdate()) = 0 OR afw2.sumOf_UsedMB=0    
   THEN null  -- exclude 0 days db_created_dt (divide by zero)    
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
 FROM afw2 left join master.sys.databases sdb ON afw2.[Database_Name] = sdb.name    
 -- [13:46 29/9/2015]    
  WHERE CASE WHEN db_id(@strDBname) is null OR db_id(@strDBname)=sdb.database_id THEN 1    
   ELSE 0  END  =  1    
 --    
 ORDER BY 1,2,3     
           
END;    
    
    
IF (@show_DB_Files_FreeSpace = 1)     
BEGIN ;    
SELECT *    
FROM   #db_file_info as f    
 WHERE CASE WHEN db_id(@strDBname) is null OR @strDBname = f.Database_Name THEN 1    
   ELSE 0  END  =  1    
ORDER BY f.[Database_Name], f.File_Type, f.File_Group, f.[File_Name], f.FileId    
END;    
    
    
DROP TABLE #db_file_info    
    
    
SET NOCOUNT OFF    
SET ANSI_WARNINGS ON    
END ; 
GO
