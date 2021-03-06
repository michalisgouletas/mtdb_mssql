USE [master]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--
CREATE PROC dbo.sp_chk_zbx_VPOS2_cnt
 ( @mBef SMALLINT = 130 			 -- set SECONDS Before to CHECK POS/SHIP Count , DEFAULT: 130 sec
	, @strDBname VARCHAR(100) = NULL -- set DB-Name Where to execute POS/SHIP Count metric
	, @bVPOS tinyint = 1			 -- SET flag for [V_POS_BATCH] count, DEFAULT: 1 (executes VPOS metric)
	, @bVSHIP tinyint = 0			 -- SET flag for [V_SHIP_BATCH] count, DEFAULT: 0 (executes VPOS metric only)
	, @mBefSHIP SMALLINT = 0		 -- SET SECONDS Before  to CHECK SHIP Count	 , DEFAULT: 0 sec
									 --   , Overides @mBef ONLY for VSHIP count, and ONLY when @vExt=1 (Extended version)
	, @vExt TINYINT = 0 -- execute Extended version 
	, @vLog	TINYINT = 0	-- execute WITH log messages
 )
AS
/* *** -- Zabbix mssql metric
* ---- [SYS-288] (2017-06-20T17:39:55):  RETURNS metric (MT POS count) UPON IN-Var DB-Name
* ---- [SYS-288] (2017-10-12T11:33) :  	Added [V_SHIP_BATCH] for metric (MT SHIPS count) UPON IN-Var DB-Name
*
* Uses:
* 	. [DEFAULT] RETURNS metric (MT POS count) ONLY UPON IN-Var DB-Name
*		with default interval 130 secs (2 min 10 secs) before the current minute (min truncation)
*	@mBef	[Mesure POS for @mBef SECONDS Before]
*	@dbname	[Name of DB to execute metric]	:
*
*		EXEC master.dbo.sp_chk_zbx_VPOS2_cnt @strDBname='ais_replica';
*
*	. [VSHIP] RETURNS metric (MT SHIPS count) UPON IN-Var DB-Name
*		with default interval 130 secs (2 min 10 secs) before the current minute (min truncation)
*	@mBef	[Mesure POS for @mBef SECONDS Before]
*	@dbname	[Name of DB to execute metric]	
*	@bVPOS=0  ,  @bVSHIP=1					:
*
*		EXEC master.dbo.sp_chk_zbx_VPOS2_cnt @mBef=305, @strDBname='ais_replica', @bVPOS=0,  @bVSHIP=1;
*
*	. [VPOS] and [VSHIP] RETURNS metric (MT POS and SHIPS count) UPON IN-Var DB-Name, in separate Result-OUTPUTs
*		with default interval 130 secs (2 min 10 secs) before the current minute (min truncation)
*	@bVPOS=1  ,  @bVSHIP=1
*	@mBefSHIP	[Mesure SHIP for @mBefSHIP SECONDS Before] , Overides @mBef ONLY for VSHIP count	
*	@vLog=1	WITH Logging					:
*
*		EXEC master.dbo.sp_chk_zbx_VPOS2_cnt @strDBname='ais_replica', @bVPOS=1,  @bVSHIP=1, @mBefSHIP=305, @vLog=1;
*
*	. [EXTENDED] [VPOS] and [VSHIP] RETURNS metric (MT POS and SHIPS count) UPON IN-Var DB-Name, in the same Result-OUTPUT
*	@vExt		[EXTENDED Results]
*	@bVPOS and @bVSHIP INVars don't change the result
*	@mBefSHIP	[Mesure SHIP for @mBefSHIP SECONDS Before] , Overides @mBef ONLY for VSHIP count
*	@vLog=1	WITH Logging
*
*		EXEC master.dbo.sp_chk_zbx_VPOS2_cnt @strDBname='ais_replica', @vExt=1, @mBefSHIP=305, @vLog=1;
*	
*** */
BEGIN;
SET NOCOUNT ON
	DECLARE @gt_trunc_min_gt DATETIME = CONVERT(DATETIME,CONVERT(VARCHAR(16), GETUTCDATE(), 121 ));
	DECLARE @strSQL NVARCHAR(2000);
		
	-- check INVar @strDBname , for DB existence
	IF not EXISTS (SELECT database_id FROM sys.databases WHERE name=@strDBname)
	BEGIN
		SET @strSQL='**** -- '+ @@SERVERNAME+ '.'+DB_NAME()+ '.'+USER_NAME()+' ['+CONVERT(VARCHAR(19), GETDATE(),126)+']';
		SET @strSQL=@strSQL+CHAR(13)+'** [sp_chk_zbx_VPOS_cnt]:  Invalid input variable(s), @strDBname: ['+ISNULL(@strDBname,'NULL')+']';
		RAISERROR (@strsql, 16 /*Severity 0*/, 1) WITH LOG , NOWAIT;
		RETURN;
	END;
	
	-- Logging
	IF (@vLog=1)
	BEGIN
		print '/* -- **	metric (MT POS/SHIP count) UPON IN-Var DB-Name  */'
		PRINT '-- For DB: ' + CASE WHEN @strDBname is null then '<NULL>' ELSE '['+@strDBname+']' END;
		print '--  Seconds Before Current Timestamp (mBef): ' + CONVERT(VARCHAR(20),@mBef);
		PRINT '';
		PRINT 'exec info : '++ @@SERVERNAME+ '.'+DB_NAME()+ '.'+USER_NAME()+' ['+CONVERT(VARCHAR(19), GETDATE(),126)+']'; 
		PRINT 'gdt_trunc_min_mBef (From): '+ CONVERT(VARCHAR(19), DATEADD(SECOND,-1*@mBef,@gt_trunc_min_gt), 126);
		PRINT 'gdt_trunc_min (To): '+ CONVERT(VARCHAR(19), @gt_trunc_min_gt, 126) ;
		PRINT '';
	END;
	
	
	-- get POS metric
	IF (@bVPOS=1 AND @vExt=0)
	BEGIN
		set @strSQL= N'SELECT COUNT(ship_id) POS_cnt_'+@strDBname;
		set @strSQL= @strSQL + N' FROM ['+@strDBname+'].dbo.V_POS_BATCH vpb WITH(NOLOCK)';
		set @strSQL= @strSQL + N' WHERE vpb.TIMESTAMP >= DATEADD(SECOND,-1*'+CONVERT(VARCHAR(20),@mBef)+','''+CONVERT(VARCHAR(19), @gt_trunc_min_gt,126)+''') AND vpb.TIMESTAMP < '''+CONVERT(VARCHAR(19), @gt_trunc_min_gt,126)+'''';
		-- Logging
		IF (@vLog=1)
		BEGIN
			PRINT '';
			PRINT 'strSQL to execute: ';
			PRINT @strSQL;
			PRINT '';
		END;
		
		-- Execute strSQL
		EXEC sp_executesql @strSQL;
		-- -- -- --
	END;
	
	-- get SHIPs metric
	IF (@bVSHIP=1 AND @vExt=0)
	BEGIN
		IF (@mBefSHIP=0) SET @mBef = @mBef
			ELSE
			BEGIN
				SET	@mBef = @mBefSHIP;
			END;

		set @strSQL= N'SELECT COUNT(ship_id) SHIP_cnt_'+@strDBname;
		set @strSQL= @strSQL + N' FROM ['+@strDBname+'].dbo.V_SHIP_BATCH vpb WITH(NOLOCK)';
		set @strSQL= @strSQL + N' WHERE vpb.TIMESTAMP >= DATEADD(SECOND,-1*'+CONVERT(VARCHAR(20),@mBef)+','''+CONVERT(VARCHAR(19), @gt_trunc_min_gt,126)+''') AND vpb.TIMESTAMP < '''+CONVERT(VARCHAR(19), @gt_trunc_min_gt,126)+'''';
		-- Logging
		IF (@vLog=1)
		BEGIN
			PRINT '';
			print '--  Seconds Before Current Timestamp for (MT SHIP count) , given (vExt='+CONVERT(VARCHAR(20),@vExt)+') (mBefSHIP): ' + CONVERT(VARCHAR(20),@mBefSHIP);
			PRINT '';
			PRINT 'strSQL to execute: ';
			PRINT @strSQL;
			PRINT '';
		END;

		-- Execute strSQL
		EXEC sp_executesql @strSQL;
		-- -- -- --
	END;

	-- @vExt=1 : execute Extended version
	IF (@vExt=1)
	BEGIN
		PRINT '';
		PRINT '/* -- **	[EXTENDED] metric (MT POS/SHIP count) UPON IN-Var DB-Name  */';
		PRINT '';
		-- Insert POS cnt
		SET @strSQL= N'DECLARE @tbRes TABLE (cnt_name VARCHAR(40), cnt_value INT, mBef SMALLINT, gdt_trunc_min_mBef_From DATETIME, gdt_trunc_min_To DATETIME);  '+CHAR(13);
		SET @strSQL= @strSQL + N' INSERT into @tbRes ';
		SET @strSQL= @strSQL + N'SELECT ''POS_cnt_'+@strDBname+''', COUNT(ship_id), '+CONVERT(VARCHAR(20),@mBef)+', '''+CONVERT(VARCHAR(19), DATEADD(SECOND,-1*@mBef,@gt_trunc_min_gt), 126)+''', '''+CONVERT(VARCHAR(19), @gt_trunc_min_gt, 126)+'''';
		SET @strSQL= @strSQL + N' FROM ['+@strDBname+'].dbo.V_POS_BATCH vpb WITH(NOLOCK)';
		set @strSQL= @strSQL + N' WHERE vpb.TIMESTAMP >= DATEADD(SECOND,-1*'+CONVERT(VARCHAR(20),@mBef)+','''+CONVERT(VARCHAR(19), @gt_trunc_min_gt,126)+''') AND vpb.TIMESTAMP < '''+CONVERT(VARCHAR(19), @gt_trunc_min_gt,126)+''';'+CHAR(13);
		-- Execute strSQL
		--xxxx-- D.p
		--xxxxPRINT @strSQL;
		--xxxxEXEC sp_executesql @strSQL;

		-- Insert SHIP cnt
		IF (@mBefSHIP=0) SET @mBef = @mBef
			ELSE
			BEGIN
				SET	@mBef = @mBefSHIP;
				print '--  Seconds Before Current Timestamp for (MT SHIP count) , given (vExt='+CONVERT(VARCHAR(20),@vExt)+') (mBefSHIP): ' + CONVERT(VARCHAR(20),@mBefSHIP);
				PRINT '';
			END;
		--		
		SET @strSQL= @strSQL + N' INSERT into @tbRes ';
		SET @strSQL= @strSQL + N'SELECT ''SHIP_cnt_'+@strDBname+''', COUNT(ship_id), '+CONVERT(VARCHAR(20),@mBef)+', '''+CONVERT(VARCHAR(19), DATEADD(SECOND,-1*@mBef,@gt_trunc_min_gt), 126)+''', '''+CONVERT(VARCHAR(19), @gt_trunc_min_gt, 126)+'''';
		SET @strSQL= @strSQL + N' FROM ['+@strDBname+'].dbo.V_SHIP_BATCH vpb WITH(NOLOCK)';
		set @strSQL= @strSQL + N' WHERE vpb.TIMESTAMP >= DATEADD(SECOND,-1*'+CONVERT(VARCHAR(20),@mBef)+','''+CONVERT(VARCHAR(19), @gt_trunc_min_gt,126)+''') AND vpb.TIMESTAMP < '''+CONVERT(VARCHAR(19), @gt_trunc_min_gt,126)+''';'+CHAR(13);
		-- ** OUT: Results
		set @strSQL= @strSQL + N' SELECT * FROM @tbRes;'
		
		-- Logging
		IF (@vLog=1)
		BEGIN
			PRINT '';
			PRINT 'strSQL to execute: ';
			PRINT @strSQL;
			PRINT '';
		END;

		-- Execute strSQL
		EXEC sp_executesql @strSQL;

		
	END;
	

-- ** ENDoF sp_chk_zbx_VPOS2_cnt
SET NOCOUNT OFF
END;


GO
