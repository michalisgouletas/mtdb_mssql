USE [master]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--
CREATE PROC dbo.sp_m_backup
	(
		@dbname as sysname = NULL,  -- * DEFAULT = NULL (no database -> BAKERROR)
		@backup_type as TINYINT = 1, -- * DEFAULT = 1:'DB' <- DBFull
										-- backup_types: 1:'DB' DBFull -> '.bak'
										--				 2:'LOG' LOG backup -> '.trn'
										--				 3:'DIFF' DIFFERENTIAL -> '.dff'
		@backup_dir as nvarchar(2000) = NULL,    -- * DEFAULT = NULL (no dir path -> BAKERROR)
		@flg_compr as TINYINT = 1,		-- * DEFAULT = 1 : {WITH COMPRESSION = 1, NOCOMPRESSION = 0}
		-- [22:05 2/10/2017] added  CHECKSUM  
		@flg_cheksum as TINYINT = 0	-- * DEFAULT = 0 : {WITH CHECKSUM = 1, NO-CHECKSUM = 0}
		-- **
		/* * USE:
				EXEC dbo.sp_m_backup @dbname = 'ais2_dba', -- sysname
				@backup_type = 1, -- tinyint
				@backup_dir = N'C:\DMSSQL\MSSQL12.MSSQLSERVER\Backup' -- nvarchar(2000)
				--, @flg_compr = 1	-- bit
				--, @flg_cheksum = 1 -- bit
				;
		**/
	)
AS
BEGIN;
SET NOCOUNT ON
SET CONCAT_NULL_YIELDS_NULL OFF;
---------------------------------------------------------------------------------
-- mssql BACKUP stored procedure  
--	 ** 
---------------------------------------------------------------------------------
-- -- **  wrk_abox\dba\MSSQL\02_FullDB_bck.sql
--
print ''
-- check IN vars
DECLARE @fdt nvarchar(50) = ltrim(rtrim(replace(replace(convert(varchar(19) ,getdate(),126),':',''),'.',''))) ;
PRINT '**** (sp_m_backup) __ ___ _____ ________' +CHAR(10)+ '** ['+@fdt+']  Vars given :' ;
PRINT '[@dbname] : ' + @dbname;
PRINT '[@backup_type] : ' + CAST(@backup_type AS VARCHAR(4));
PRINT '[@backup_dir] : ' + @backup_dir;
PRINT '[@flg_compr] : ' + cast(@flg_compr AS varchar(4));
PRINT '[@flg_cheksum] : ' + cast(@flg_cheksum AS varchar(4));
--
print ''
--
IF (@dbname IS NOT NULL AND @backup_dir IS NOT NULL AND  @backup_type IN (1,2,3))
--
BEGIN;
	DECLARE @t time(3) = SYSDATETIME() ;
	---xxxx(moved) DECLARE @fdt nvarchar(50) = ltrim(rtrim(replace(replace(convert(varchar(19) ,getdate(),126),':',''),'.',''))) ;
	DECLARE @strbuptp NVARCHAR(100) = CASE @backup_type WHEN 1 then 'DBFull' WHEN 2 THEN 'TLOG' WHEN 3 THEN 'Diff' END;
	DECLARE @fn nvarchar(1000) = @backup_dir + N'\' + @dbname + '_' + @strbuptp + '_' + @fdt + CASE @backup_type WHEN 1 then '.bak' WHEN 2 THEN '.trn' WHEN 3 THEN '.dff' END ;
	DECLARE @strsql nvarchar(max) = 'BACKUP '+ CASE @backup_type WHEN 2 THEN 'LOG' ELSE 'DATABASE' END + ' ['+@dbname+'] TO  DISK = ''' + @fn +'''
	WITH ' + CASE @backup_type WHEN 3 THEN 'DIFFERENTIAL, ' ELSE NULL END + case @flg_compr WHEN 1 then 'COMPRESSION, ' ELSE NULL END + case @flg_cheksum WHEN 1 then 'CHECKSUM, ' ELSE NULL END + ' NOFORMAT, INIT
	,  NAME = ''' + @dbname + N'_' + @strbuptp + N'('+@fdt+')sp_m_backup'' , SKIP, NOREWIND, NOUNLOAD,  STATS = 10
	;'
	print SYSDATETIME();
	print 'Start off: ' + @fn;
	-- xxxx D.p
	print @strsql;
	PRINT '';
	-- execute backup
	EXEC sp_executesql @strsql;
	--
	SELECT @fn backp_fn, SYSDATETIME() dt_end, DATEDIFF(ms, @t, CAST(SYSDATETIME() AS time(3))) AS time_ms;
END;
ELSE
-- ** BAKERROR
BEGIN;
	
	PRINT '';
	PRINT '**** Check IN Vars for NULLs or invalid values: ';
	PRINT '* Vars  [@dbname]  and  [@backupdir]  should be Not NULL,'
	PRINT '* var [@backup_type] accepts values (1,2,3) : 1:''DB'' DBFull -> ''.bak''
												2:''LOG'' LOG backup -> ''.ldf''
												3:''DIFF'' DIFFERENTIAL -> ''.dff'',';
	PRINT '* var [@flg_compr] accepst values (0,1) : {WITH COMPRESSION = 1, NOCOMPRESSION = 0}.';
	PRINT '* var [@flg_cheksum] accepst values (0,1) : {WITH CHECKSUM = 1, NO-CHECKSUM = 0}.';
	--
	RETURN;
END;
-- -- ** ENDoF: IF (@dbname IS NOT NULL AND @backup_dir IS NOT NULL ..
-- -- -- --
PRINT ''

--
-- ** ENDoF sp_m_backup
SET CONCAT_NULL_YIELDS_NULL ON;
SET NOCOUNT OFF
END;

GO
