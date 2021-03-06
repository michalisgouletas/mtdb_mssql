USE [master]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--
CREATE PROC dbo.sp_m_cleanupbak
	(
		-- ** SET bakcup file extention  (Mask filter on forfiles cmd) 
		-- ** without wildcards or dot
		-- (required)
		@Mfilter varchar(50) = NULL, 
		
		-- ** USing <days>-1 Before:  eg: 4 Days means 5 days before, due to 'date trunc'
		-- (required)
		@daysBef SMALLINT = NULL,
		
		-- ** SET cleanup Path , log file path:
		-- * DEFAULT = NULL (no dir path -> BAKERROR
		-- (required)
		@Path nvarchar(500) = NULL,
		
		-- (not required)
		@flog nvarchar(500) = @Path
		/* * USE:
		* -- !!!! DON'T Use Double-Qoutes on Paths
				EXEC sp_m_cleanupbak @Mfilter='bak', -- varchar(50)
				@daysBef = 8,  -- tinyint
				@Path = N'F:\backup',  -- nvarchar(500)
				@flog = N'F:\dbadmin\maint_log' -- nvarchar(500)
		* */
	
	)
AS
/* *** sp_m_cleanupbak 
** ---------------------------------------------------------------------------------
** 	procedure to CLEANUP-Delete backup files (.bak, .trn, .dff)
*	-- (@fdt) uses trunc getdate: DATEADD(dd, 0, DATEDIFF(dd, 0, GETDATE()))
**
**	 !!!! [13:42 27/1/2016] proc changed to use:  forfiles  for DELETE
*		[like: D:\Docs\dbadmin\01.dba\doc_\backup_dbs\ftps_copy_mt8\retend_del_baktrn]
**	 !!!!  use of:  'master.dbo.xp_delete_file' which only deletes native sql server backup files or native maintenance report files
**
**	 [15:33 24/1/2018]  Alter @log to initially append ( >> ) to log-file and not create ( > ) at :
**		--xxxx print '--	 log file: ' + @flog;
**		SET @cmd = @cmd + ' >> ' + @flog + ' 2>&1';
**
*** */
BEGIN;
SET NOCOUNT ON
SET CONCAT_NULL_YIELDS_NULL OFF;

-- ** SETing from '@daysBef', GETDATE()-<days> before HERE
--		(@fdt) uses trunc getdate: DATEADD(dd, 0, DATEDIFF(dd, 0, GETDATE()))
--		so (@daysBef) is used as (@daysBef - 1)
-- 		eg: Given @daysBef=5  Days means 6 days before, due to 'date trunc'
--			, so (@daysBef - 1) = 4 is used in (@fdt) for 5 DaysBefore 
DECLARE @fdt nvarchar(50) = convert(varchar(19) , DATEADD(dd, 0, DATEDIFF(dd, 0, GETDATE()- (@daysBef-1) )),126) ;
DECLARE @ffdt nvarchar(50) = convert(varchar(19) , convert(datetime,@fdt)-1 ,101) ;  --<< "MM/dd/yyyy"
--!!!! DECLARE @ffdt nvarchar(50) = convert(varchar(19) , convert(datetime,@fdt)-1 ,103) ;  --<< "dd/MM/yyyy"
DECLARE @cmd varchar(1000), @cmdlog VARCHAR(1000) /*xxxx, @Path nvarchar(500), @flog nvarchar(500)*/;
DECLARE @srv varchar(100) = REPLACE(@@servername, '\', '-');
-- !! SET logFile name : 
SET @flog = @flog + N'\'+ @srv +'_maintcleanup_'+@Mfilter+'_' + replace(convert(varchar(19) ,getdate(), 126),':','') + '.log';
--
print ''
-- check IN vars
PRINT '**** (sp_m_cleanupbak) __ ___ _____ ________' +CHAR(10)+ '**   Vars given :' ;
PRINT ' [@Mfilter] file extention mask-filter: ' + @Mfilter;
PRINT ' [@daysBef] cleanup ('+ @Mfilter +') Days Before: ' + convert(VARCHAR(10),@daysBef);
PRINT ' [@fdt] cleanup ('+ @Mfilter +') Before date: ' + @fdt;
PRINT ' [@Path] cleanup Path: ' + @Path;
PRINT ' [@srv] server/instance (back-slash replaced): ' + @srv;
PRINT ' [@flog] cleanup logfile: ' + @flog;

--
print ''
IF ((@Mfilter IS NOT NULL AND @Mfilter!='') AND (@daysBef IS NOT NULL AND @daysBef>0) AND  (@Path  IS NOT NULL AND LTRIM(RTRIM(@path)) !=''))
--
BEGIN;
	-- add double-quotes "" on @path, @flog vars
	SET @path = '"'+LTRIM(RTRIM(@path))+'"';
	SET @flog = '"'+LTRIM(RTRIM(@flog))+'"';
	-- log list-file Results
	print '';
	SET @cmd='echo ---- ** List ('+@Mfilter+') files older than '''+ @fdt +''' (from '+ @Path +') ';
	--xxxx print '--	 log file: ' + @flog;
	SET @cmd = @cmd + ' >> ' + @flog + ' 2>&1';
	-- debug.print
	-- print 'cmd_ : '+@cmd;

	-- EXECUTE  logfile init create
	EXEC XP_CMDSHELL @cmd ;
	
	
	-- ** format forfiles cmd
	SET @cmd = 'forfiles /P ' + @path + ' /m  *.'+ @Mfilter +' /d -'+ @ffdt +'  /c "cmd /c echo @fdate @ftime;@fsize;@path"'
	-- debug.print
	-- print 'cmd forfiles: '+@cmd;
	-- -- -- --
	SET @cmd = @cmd + ' >> ' + @flog + ' 2>&1';
	-- debug.print
	-- print 'cmd_ : '+@cmd;
	-- -- -- [13:42 27/1/2016]
	-- * log DEL-'forfiles' cmd:
	SET @cmdlog =  'echo ----    cmd_ : ' + @cmd+ ' >> ' + @flog + ' 2>&1';
	-- EXECUTE  log DEL-'forfiles' cmd
	EXEC XP_CMDSHELL @cmdlog;
	-- EXECUTE  forfiles for list of files found
	EXEC XP_CMDSHELL @cmd ;



	-- ** ===========================
	-- ** format forfiles cmd
	SET @cmd = 'forfiles /P ' + @path + ' /m  *.'+ @Mfilter +' /d -'+ @ffdt +'  /c "cmd /c echo @path & del @path"'
	-- debug.print
	-- print 'cmd DEL forfiles: '+@cmd;
	-- -- -- --
	SET @cmd = @cmd + ' >> ' + @flog + ' 2>&1';
	-- debug.print
	print 'cmd_ : '+@cmd;

	print '';
	print N'---- ** ('+@srv+')  Deleting (.'+@Mfilter+') files before: ' + @fdt;
	--xxxx EXECUTE master.dbo.xp_delete_file 0,@Path,@Mfilter,@fdt;
	-- [13:42 27/1/2016]
	-- * log DEL-'forfiles' cmd:
	SET @cmdlog =  'echo -- --- ----- --------  Deleting .. >> ' + @flog + ' 2>&1';
	-- EXECUTE  log DEL-'forfiles' cmd
	EXEC XP_CMDSHELL @cmdlog;
	-- debug.print
	-- print 'cmdlog_ : '+@cmdlog;
	-- EXECUTE  forfiles for DELETE of files found
	EXEC XP_CMDSHELL @cmd ;
	

END;
ELSE
-- ** BAKERROR
BEGIN;
	
	PRINT '';
	PRINT '**** Check IN Vars for NULLs or invalid values: ';
	PRINT '* Vars  [@Mfilter]  and  [@daysBef]  and [@Path] should be Not NULL.'
	PRINT '*	Also Var  [@Mfilter]  and [@Path] should NOT be like '''' .'
	PRINT '*	, and Var  [@daysBef]  should be GreaterThan 0'
	--
	RETURN;
END;
-- -- ** ENDoF: IF (@Mfilter IS NOT NULL AND @daysBef IS NOT NULL AND  @Path  IS NOT NULL ..
-- -- -- --
PRINT ''

--
-- ** ENDoF  sp_m_cleanupbak
SET CONCAT_NULL_YIELDS_NULL ON;
SET NOCOUNT OFF
END;

GO
