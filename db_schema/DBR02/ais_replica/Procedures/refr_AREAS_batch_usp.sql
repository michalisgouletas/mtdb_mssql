USE [ais_replica]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--CREATE 
CREATE PROCEDURE dbo.[refr_AREAS_batch_usp]
AS
/* *** (CORE-5100) : WeeklyRefresh_ais_tbs_on[ais_replica]
** 	crsp_refrs_AREAS_batch_dbr02.sql
**	[18:08 13/12/2017] 
** 
** 	
*** */
BEGIN;
	SET NOCOUNT ON;
	--???? SET DEADLOCK_PRIORITY HIGH;
	DECLARE @pknm sysname, @idxstr NVARCHAR(2000);
	DECLARE @DetErrorMess VARCHAR(MAX), @ErrorSeverity  tinyint, @ErrorState tinyint;
	
	
	/* Spacial Index drop is required along with PK, for [AREAS_TEMP] tb:
	Could not drop the primary key constraint 'PK_AREAS_1' because the table has an XML or spatial index.*/
	SELECT @pknm=si.name FROM sys.indexes si WHERE si.name IN ('PK_AREAS', 'PK_AREAS_1') AND si.object_id=OBJECT_ID('AREAS_TEMP');
	IF EXISTS (SELECT @pknm)
		BEGIN
		PRINT '**** [refr_AREAS_batch_usp] (spid '+CONVERT(VARCHAR(10),@@SPID)+') : '+ @@SERVERNAME+ '.'+DB_NAME()+ '.'+USER_NAME()+' ['+CONVERT(VARCHAR(19), GETDATE(),126)+'] Dropping Idxs (Spacial): [polygon], (PK): '+@pknm;
		SET @idxstr = N'DROP INDEX [polygon] ON dbo.[AREAS_TEMP]; ALTER TABLE dbo.[AREAS_TEMP] DROP CONSTRAINT ['+ @pknm +'];'
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
		truncate table [AREAS_TEMP] ;
		-- start INSERT
		print '[' + convert(varchar(20),getdate(),120) + '] , start INSERT on table'
		print ''
		--xx SET STATISTICS io, TIME ON;
		
		--xx?? (ommitted from tb-DDL) set identity_insert [AREAS_TEMP] ON;
		INSERT INTO dbo.AREAS_TEMP
        ( AREA_ID , AREA_NAME , SW_X , SW_Y , NE_X , NE_Y ,
          ZOOM , SHOWONMAP , TREEORDER , POLYGON , AREA_CODE , HAS_ALERT )
		SELECT AREA_ID , AREA_NAME , SW_X , SW_Y , NE_X , NE_Y ,
				  ZOOM , SHOWONMAP , TREEORDER , POLYGON , AREA_CODE , HAS_ALERT 
		FROM OPENQUERY([MT2,1438], 'SELECT * FROM ais_shadc.dbo.AREAS WITH(NOLOCK)')
		;
		-- xxxx D.p
		set @DetErrorMess=convert(varchar(400),@@ROWCOUNT);
		SET CONCAT_NULL_YIELDS_NULL OFF;
		PRINT '[refr_AREAS_batch_usp]: (INSERT from [ais_shadc.dbo.AREAS]) row(s) affected: ' + @DetErrorMess;
		--
		--xx?? (ommitted from tb-DDL) set identity_insert [AREAS_TEMP] off;

		--  renable-reCreate PK/index 
		PRINT ' ** (spid '+CONVERT(VARCHAR(10),@@SPID)+') : '+ @@SERVERNAME+ '.'+DB_NAME()+ '.'+USER_NAME()+' ['+CONVERT(VARCHAR(19), GETDATE(),126)+']  , reCreate [polygon], (PK):['+@pknm+'] / Rebuild indexes.'
		SET CONCAT_NULL_YIELDS_NULL ON;
		-- xx ALTER INDEX PK_SHIP_ID ON [dbo].SHIP REBUILD;
		SET @idxstr = N'ALTER TABLE dbo.[AREAS_TEMP] ADD CONSTRAINT ['+@pknm+']  PRIMARY KEY CLUSTERED  ([AREA_ID]); CREATE SPATIAL INDEX [polygon] ON [dbo].[AREAS_TEMP] ([POLYGON]) WITH (GRIDS = (MEDIUM, MEDIUM, MEDIUM, MEDIUM), CELLS_PER_OBJECT = 16 , SORT_IN_TEMPDB=ON);'
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
	SET CONCAT_NULL_YIELDS_NULL OFF;
	-- * SET Object UPON SYNONYM def:
		DECLARE @V_TEMP_OBJ VARCHAR(1000) = 'AREAS_TEMP';
		-- * SET (minutes) before last REBUILD (STATs check)
		DECLARE @intDiffMin TINYINT = 120;
		-- CHECK last STATs UPDATE on CLUSTERED INDEX:
		IF (
			SELECT DATEDIFF(MINUTE,STATS_DATE(object_id, stats_id),GETDATE()) --!! LastStatsUpdate DIFF_min
				FROM sys.stats
				WHERE object_id = OBJECT_ID(@V_TEMP_OBJ)
				AND LEFT(name,4)!='_WA_'
				-- Select ONLY Clustered for the CHECK:
				AND name = (SELECT i0.name FROM sys.indexes i0 WHERE i0.object_id=OBJECT_ID(@V_TEMP_OBJ) AND i0.type_desc='CLUSTERED')
			) > @intDiffMin
		BEGIN
			--xx D.p
			PRINT ' ** (spid '+CONVERT(VARCHAR(10),@@SPID)+') : '+ @@SERVERNAME+ '.'+DB_NAME()+ '.'+USER_NAME()+' ['+CONVERT(VARCHAR(19), GETDATE(),126)+']';
			PRINT ' ** LastStatsUpdate DIFF(for '+@V_TEMP_OBJ+') > '+CONVERT(VARCHAR(10), @intDiffMin)+' min'
			-- Open Cursor with ALTER statements
			DECLARE @straltSQL VARCHAR(1000);
			DECLARE c_altidx CURSOR FOR 
			SELECT
					'ALTER INDEX ' + QUOTENAME(i.name) + ' ON '
					+ QUOTENAME('dbo') + '.'
					+ QUOTENAME(OBJECT_NAME(i.OBJECT_ID)) + ' REBUILD;'	rbidx_scr
			FROM sys.indexes i
			WHERE 
				--xx [o].name = @V_TEMP_OBJ
				OBJECT_NAME(i.OBJECT_ID) = @V_TEMP_OBJ
				-- AND i.type_desc='CLUSTERED'
			ORDER BY CASE i.type_desc WHEN 'CLUSTERED' THEN 1 ELSE 0 END DESC
			;
			--
			OPEN c_altidx;
			FETCH NEXT FROM c_altidx INTO @straltSQL;
			WHILE (@@FETCH_STATUS = 0)
				BEGIN
					--xx D.p
					PRINT @@SERVERNAME+ '.'+DB_NAME()+'['+CONVERT(VARCHAR(19), GETDATE(),126)+']';
					PRINT @straltSQL;
					EXEC dbo.sp_sqlexec @straltSQL;

					FETCH NEXT FROM c_altidx INTO @straltSQL;
					-- ENDoF:  c_altidx cursor WHILE
				END;
			--
			CLOSE c_altidx;
			DEALLOCATE c_altidx;
		--
		END;
		ELSE
		BEGIN	
			/*xxxx D.p	*/
			PRINT ' ** (spid '+CONVERT(VARCHAR(10),@@SPID)+') : '+ @@SERVERNAME+ '.'+DB_NAME()+ '.'+USER_NAME()+' ['+CONVERT(VARCHAR(19), GETDATE(),126)+']';
			PRINT ' ** LastStatsUpdate DIFF(for '+@V_TEMP_OBJ+') <= '+CONVERT(VARCHAR(10), @intDiffMin)+' min'
			/*xxxx D.p	*/
			SELECT @intDiffMin = DATEDIFF(MINUTE,STATS_DATE(object_id, stats_id),GETDATE()) 
				FROM sys.stats
				WHERE object_id = OBJECT_ID(@V_TEMP_OBJ)
				AND LEFT(name,4)!='_WA_'
				-- Select ONLY Clustered for the CHECK:
				AND name = (SELECT i0.name FROM sys.indexes i0 WHERE i0.object_id=OBJECT_ID(@V_TEMP_OBJ) AND i0.type_desc='CLUSTERED')
			;
			PRINT ' **   LastStatsUpdate DIFF(for '+@V_TEMP_OBJ+') is : '+CONVERT(VARCHAR(10), @intDiffMin)+' min'
		-- ENDoF: IF () > @intDiffMin
		END
		;
	-- ENDof: idx REBUILDs
	
	
	-- rename with: ALTER SCHEMA TRANFER
	PRINT ' '+ @@SERVERNAME+ '.'+DB_NAME()+ '.'+USER_NAME()+' ['+CONVERT(VARCHAR(19), GETDATE(),126)+'] STARToF : [AREAS_TEMP] ALTER SCHEMA TRANFER';
	BEGIN TRAN
		ALTER SCHEMA [shad] TRANSFER [dbo].[AREAS_TEMP];
		EXEC sys.sp_rename @objname = N'shad.AREAS_TEMP',
			@newname = AREAS;
			
		ALTER SCHEMA [fk] TRANSFER [dbo].[AREAS];
		ALTER SCHEMA [dbo] TRANSFER [shad].[AREAS];
		
		EXEC sys.sp_rename @objname = N'fk.AREAS',
			@newname = AREAS_TEMP;
		ALTER SCHEMA [dbo] TRANSFER [fk].[AREAS_TEMP];
	COMMIT;
	
	
	-- success message
	SELECT 0 [Status], 'SUCCESS: [refr_AREAS_batch_usp]: (INSERT from ais_shadc.dbo.[AREAS]) row(s) affected: '+@DetErrorMess [Message] , CONVERT(VARCHAR(19),GETUTCDATE(),126) dt;
	SET CONCAT_NULL_YIELDS_NULL ON;
	SET DEADLOCK_PRIORITY NORMAL;
	SET NOCOUNT OFF;

END;
-- * ENDoF 'refr_AREAS_batch_usp' procedure



GO
