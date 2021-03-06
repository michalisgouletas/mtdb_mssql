USE [ais_replica]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--
-- CREATE 
CREATE procedure dbo.[refr_DSTMATRIX_batch_usp]
AS
/* *** (CORE-6930), (CORE-5100) : WeeklyRefresh_ais_tbs_on[ais_replica]
** 	crsp_refr_DSTMATRIX_batch_mt2.sql
**	[17:54 6/2/2018]
** 	
*** */
BEGIN;
	SET NOCOUNT ON;
	--???? SET DEADLOCK_PRIORITY HIGH;
	DECLARE @pknm sysname, @idxstr NVARCHAR(2000);
	DECLARE @DetErrorMess VARCHAR(MAX), @ErrorSeverity  tinyint, @ErrorState tinyint;
	
	
	/* Spacial Index drop is required along with PK, for [DST_MATRIX_TEMP] tb:
	Could not drop the primary key constraint 'PK_PORTS_1' because the table has an XML or spatial index.*/
	SELECT @pknm=si.name FROM sys.indexes si WHERE si.name IN ('IDXCL_DST_MATRIX', 'IDXCL_DST_MATRIX1') AND si.object_id=OBJECT_ID('DST_MATRIX_TEMP')
	IF EXISTS (SELECT @pknm)
		BEGIN
		PRINT '**** [refr_DSTMATRIX_batch_usp] (spid '+CONVERT(VARCHAR(10),@@SPID)+') : '+ @@SERVERNAME+ '.'+DB_NAME()+ '.'+USER_NAME()+' ['+CONVERT(VARCHAR(19), GETDATE(),126)+'] Dropping Idx (PK): '+@pknm;
		SET @idxstr = N'DROP INDEX ['+ @pknm +'] ON [dbo].[DST_MATRIX_TEMP];'
		--xx D.P  PRINT @idxstr;
		EXEC sp_executesql @idxstr;
	-- ENDoF: DROP indexes
	END;
		
	--
	BEGIN TRY
		-- 
		BEGIN TRAN;
		--
		print '[' + convert(varchar(20),getdate(),120) + '] TRUNCATE'
		truncate table [DST_MATRIX_TEMP] ;
		-- start INSERT
		print '[' + convert(varchar(20),getdate(),120) + '] , start INSERT on table'
		print ''
		--xx SET STATISTICS io, TIME ON;
		
		--xxxxset identity_insert [DST_MATRIX_TEMP] ON;
		INSERT INTO dbo.DST_MATRIX_TEMP ( YEAR, STARTS, ENDS, DST_REGION )
		SELECT  YEAR, STARTS, ENDS, DST_REGION 
		FROM [MT2,1438].ais_shadc.dbo.DST_MATRIX WITH(NOLOCK)
		;
		
		-- xxxx D.p
		set @DetErrorMess=convert(varchar(400),@@ROWCOUNT);
		SET CONCAT_NULL_YIELDS_NULL OFF;
		PRINT '[refr_DSTMATRIX_batch_usp]: (INSERT from [ais_shadc.dbo.DST_MATRIX]) row(s) affected: ' + @DetErrorMess;
		--xxxxset identity_insert [DST_MATRIX_TEMP] off;

		--  renable-reCreate PK/index 
		PRINT ' ** (spid '+CONVERT(VARCHAR(10),@@SPID)+') : '+ @@SERVERNAME+ '.'+DB_NAME()+ '.'+USER_NAME()+' ['+CONVERT(VARCHAR(19), GETDATE(),126)+']  , reCreate (PK):['+@pknm+'] / Rebuild indexes.'
		SET CONCAT_NULL_YIELDS_NULL ON;
		-- xx ALTER INDEX PK_SHIP_ID ON [dbo].SHIP REBUILD;
		SET @idxstr = N'CREATE CLUSTERED INDEX ['+ @pknm +'] ON dbo.[DST_MATRIX_TEMP] ( [DST_REGION] , [YEAR] , [STARTS] ) ;'
		--xx D.P  PRINT @idxstr;
		EXEC sp_executesql @idxstr;
		--
		
		--xx SET STATISTICS io, TIME OFF;
				
		COMMIT TRAN;
	END TRY
	BEGIN CATCH 
		--
		SET CONCAT_NULL_YIELDS_NULL OFF;
		SET @ErrorSeverity = ERROR_SEVERITY()
		SET @ErrorState    = ERROR_STATE()
		SET @DetErrorMess =  ' **** ERROR_NUMBER ' +        
		  CAST(ERROR_NUMBER() AS VARCHAR) + ' : '+
		  CAST(@ErrorSeverity AS VARCHAR) + ' : ' +
		  CAST(@ErrorState AS VARCHAR) + ' : ' +
		  ERROR_PROCEDURE() + ' : ' +
		  ERROR_MESSAGE() + ' : ERROR_LINE ' +
		  CAST(ERROR_LINE() AS VARCHAR);
		
		-- Test XACT_STATE for 1 or -1. XACT_STATE = 0 means there is no transaction
		--	and a commit or rollback operation would generate an error.
		IF (XACT_STATE()) <> 0
		BEGIN
			--D.p: 
			PRINT '(XACT_STATE) before ROLLBACK: ' + CAST(XACT_STATE() AS VARCHAR(10)); 
			ROLLBACK TRAN;
			-- D.p: PRINT 'after: ' + CAST(XACT_STATE() AS VARCHAR(10));
		END;
		-- detailed error message....return
		RAISERROR(@DetErrorMess, @ErrorSeverity, @ErrorState);
		RETURN;
	END CATCH;
	
	
	-- ** [15:20 28/6/2016] idx REBUILDs (like on _sp_ dbo.[v_ship_diff])
	-- [DATA-2980] : Create index rebuild scr-proc hourly
	-- xxxx Rebuild indexes ommited for : DST_MATRIX_TEMP
	-- ENDof: idx REBUILDs
	

	-- rename with: ALTER SCHEMA TRANFER
	PRINT ' '+ @@SERVERNAME+ '.'+DB_NAME()+ '.'+USER_NAME()+' ['+CONVERT(VARCHAR(19), GETDATE(),126)+'] STARToF : [DST_MATRIX_TEMP] ALTER SCHEMA TRANFER';
	BEGIN TRAN
		ALTER SCHEMA [shad] TRANSFER [dbo].[DST_MATRIX_TEMP];
		EXEC sys.sp_rename @objname = N'shad.DST_MATRIX_TEMP',
			@newname = DST_MATRIX;
			
		ALTER SCHEMA [fk] TRANSFER [dbo].[DST_MATRIX];
		ALTER SCHEMA [dbo] TRANSFER [shad].[DST_MATRIX];
		
		EXEC sys.sp_rename @objname = N'fk.DST_MATRIX',
			@newname = DST_MATRIX_TEMP;
		ALTER SCHEMA [dbo] TRANSFER [fk].[DST_MATRIX_TEMP];
	COMMIT;

	
	-- success message
	SELECT 0 [Status], 'SUCCESS: [refr_DSTMATRIX_batch_usp]: (INSERT from ais_shadc.dbo.[DST_MATRIX]) row(s) affected: '+@DetErrorMess [Message] , CONVERT(VARCHAR(19),GETUTCDATE(),126) dt;
	SET CONCAT_NULL_YIELDS_NULL ON;
	SET DEADLOCK_PRIORITY NORMAL;
	SET NOCOUNT OFF;

END;
-- * ENDoF 'refr_DSTMATRIX_batch_usp' procedure



GO
