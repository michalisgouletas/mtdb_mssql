USE [master]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--
CREATE PROC dbo.sp_chk_zbx_VPOS_cnt
 ( @mBef SMALLINT = 130 			 -- set SECONDS Before to CHECK POS Count , DFAULT: 130 sec
	, @strDBname VARCHAR(100) = NULL -- set DB-Name Where to execute POS Count metric
	-- ??!!, @vExt BIT = 0 -- execute Extended version 
	, @vLog	TINYINT = 0	-- execute WITH log messages
 )
AS
/* *** -- Zabbix mssql metric
* ---- [SYS-288] (2017-06-20T17:39:55)
*
* RETURNS metric (MT POS count) UPON IN-Var DB-Name
*		with default interval 130 secs (2 min 10 secs) before the current minute (min truncation)
*	@mBef	[Mesure POS for @mBef SECONDS Before]
*	@dbname	[Name of DB to execute metric]
*** */
BEGIN;
SET NOCOUNT ON
	DECLARE @gt_trunc_min_gt DATETIME = CONVERT(DATETIME,CONVERT(VARCHAR(16), GETUTCDATE(), 121 ));
	DECLARE @strSQL NVARCHAR(2000);
	
	
	-- get POS metric 
	set @strSQL= N'SELECT COUNT(ship_id) POS_cnt_'+@strDBname;
	set @strSQL= @strSQL + N' FROM ['+@strDBname+'].dbo.V_POS_BATCH vpb WITH(NOLOCK)';
	set @strSQL= @strSQL + N' WHERE vpb.TIMESTAMP >= DATEADD(SECOND,-1*'+CONVERT(VARCHAR(20),@mBef)+','''+CONVERT(VARCHAR(19), @gt_trunc_min_gt,126)+''') AND vpb.TIMESTAMP < '''+CONVERT(VARCHAR(19), @gt_trunc_min_gt,126)+'''';

	-- Logging
	IF (@vLog=1)
	BEGIN
		print '/* -- **	metric (MT POS count) UPON IN-Var DB-Name  */'
		PRINT '-- For DB: ' + CASE WHEN @strDBname is null then '<NULL>' ELSE '['+@strDBname+']' END;
		print '--  Seconds Before Current: ' + CONVERT(VARCHAR(20),@mBef);
		PRINT '';
		PRINT 'exec info : '++ @@SERVERNAME+ '.'+DB_NAME()+ '.'+USER_NAME()+' ['+CONVERT(VARCHAR(19), GETDATE(),126)+']'; 
		PRINT 'gdt_trunc_min_mBef (From): '+ CONVERT(VARCHAR(19), DATEADD(SECOND,-1*@mBef,@gt_trunc_min_gt), 126);
		PRINT 'gdt_trunc_min (To): '+ CONVERT(VARCHAR(19), @gt_trunc_min_gt, 126) ;
		PRINT '';
		PRINT 'strSQL to execute: ';
		PRINT @strSQL;
        PRINT '';
	END;

	IF not EXISTS (SELECT database_id FROM sys.databases WHERE name=@strDBname)
	BEGIN
		SET @strSQL='**** -- '+ @@SERVERNAME+ '.'+DB_NAME()+ '.'+USER_NAME()+' ['+CONVERT(VARCHAR(19), GETDATE(),126)+']';
		SET @strSQL=@strSQL+CHAR(13)+'** [sp_chk_zbx_VPOS_cnt]:  Invalid input variable(s), @strDBname: ['+ISNULL(@strDBname,'NULL')+']';
		RAISERROR (@strsql, 16 /*Severity 0*/, 1) WITH LOG , NOWAIT;
		RETURN;
	END;
	

	-- Execute strSQL
	EXEC sp_executesql @strSQL;
	-- -- -- --
	
-- ** ENDoF sp_chk_zbx_VPOS_cnt
SET NOCOUNT OFF
END;


GO
