USE [ais_replica]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- 
CREATE PROC dbo.sp_m_IdxDDL
(
	@objname sysname = NULL,	-- ** ObjectName to search for : 
	@idx sysname = NULL,		-- ** IndexName to search for : 
	@sqlsel TINYINT = NULL	-- ** sql Selection var :  (1): Create Idx SQL only  , (2): DROP Idx SQL only
	/**** : ALL sys.*  objects  refer to CURRENT DB 
	--  So  DB Use is Required	****/
) AS
BEGIN
SET CONCAT_NULL_YIELDS_NULL OFF;
SET NOCOUNT ON;
DECLARE @objid INT = object_id(@objname);
PRINT '-- '+ @@SERVERNAME+ '.'+DB_NAME()+ '.'+USER_NAME()+' ['+CONVERT(VARCHAR(19), GETDATE(),126)+']';
PRINT 'DB_ID: ' + CONVERT(VARCHAR(20),DB_ID()) + ' | DB: '+ DB_NAME(DB_ID());
PRINT 'Object_ID: ' + ISNULL(CONVERT(VARCHAR(20), @objid),'<NULL>') + ' | Object: '+ '.['+ISNULL(object_name(@objid),'<NULL>')+'];';
PRINT ' INDEX to SearchFor: ' + ISNULL(@idx,'<NULL>');
	--!!!! WITH cte_idx AS
		SELECT 
			o.name as ObjectName, o.schema_id, i.name as IndexName, i.is_primary_key as [PrimaryKey]
			, i.[type_desc] as IndexType, i.is_unique as [Unique]
			, Columns.[Normal] as IndexColumns, Columns.[Included] as IncludedColumns
			--
			, i.index_id, o.object_id
			, i.fill_factor, i.is_padded, i.is_disabled, i.allow_row_locks, i.allow_page_locks, o.create_date ObjectCreated, o.modify_date ObjectModified
		-- ****
		INTO #tmpxcte_idx4000 
		FROM sys.indexes i 
		join sys.objects o on i.object_id = o.object_id
		cross apply
		(select
				substring
				(  (select ', ' +  CONCAT('[',co.[name],']') + ' ' + CASE ic.is_descending_key WHEN 1 THEN ' DESC ' ELSE NULL end
						from sys.index_columns ic
						join sys.columns co on co.object_id = i.object_id and co.column_id = ic.column_id
						where ic.object_id = i.object_id and ic.index_id = i.index_id and ic.is_included_column = 0
						order by ic.key_ordinal
						for xml path('')
					)
					, 3
					, 10000
				)    as [Normal]    
				, substring
				(  (select ', ' + CONCAT('[',co.[name],']')
						from sys.index_columns ic
						join sys.columns co on co.object_id = i.object_id and co.column_id = ic.column_id
						where ic.object_id = i.object_id and ic.index_id = i.index_id and ic.is_included_column = 1
						order by ic.key_ordinal
						for xml path('')
					)
					, 3
					, 10000
				)    as [Included]    

		) Columns
		where o.[type] = 'U' --USER_TABLE
	SET NOCOUNT OFF;
--
-- **** 
IF @sqlsel IS NULL
BEGIN;
	-- Form output for ALL Columns:
	SELECT DB_NAME(DB_ID()) db, object_name(I.object_id) object
		, I.index_id, I.IndexName, I.IndexType, i.[Unique] idx_is_unique, I.PrimaryKey is_PK, I.[Unique] is_unique_constraint
		, I.is_disabled, I.allow_row_locks, I.allow_page_locks
		--xxxx , ic.index_column_id, ac.name idx_column_name
		, I.IndexColumns, I.IncludedColumns
		--xx , ' -- ' [ -- index_usage_stats > -- ], s.* 
		, I.ObjectCreated, I.ObjectModified
		-- * DROP sql
		, ' -- '  [ -- index_drop_sql > -- ]
		, CASE I.PrimaryKey WHEN 1 THEN					-- Check PK
			'ALTER TABLE ' + SCHEMA_NAME(I.schema_id) + '.['+object_name(I.object_id)+']' + ' DROP CONSTRAINT [' + I.IndexName +']  '
			+ ';'+CHAR(10)+'GO'
		ELSE 
			 'DROP INDEX ['+i.IndexName+'] ON ' + db_name(DB_ID())+ '.'+ SCHEMA_NAME(I.schema_id) + '.['+object_name(I.object_id)+'];'+CHAR(10)+'GO' 
		END  [- sql_dropidx -]
		, object_name(I.object_id) object, I.index_id, i.IndexName, i.IndexType, i.IndexColumns, i.IncludedColumns
		-- * CREATE sql
		, ' -- '  [ -- index_cr_sql > -- ]
		, CASE I.PrimaryKey WHEN 1 THEN					-- Check PK
			'"ALTER TABLE ' + SCHEMA_NAME(I.schema_id) + '.['+object_name(I.object_id)+']' + ' ADD CONSTRAINT [' + I.IndexName +']  PRIMARY KEY CLUSTERED '
			+ ' ( ' + I.IndexColumns + ') '			-- IndexColumns
			+ ';'+CHAR(10)+'GO"'
		ELSE 
			'"CREATE ' + I.IndexType
			+ CASE I.[Unique] WHEN 1 THEN ' UNIQUE '	-- Check Unique
			  ELSE NULL END
			+ ' INDEX [' + I.IndexName COLLATE DATABASE_DEFAULT + '] ON ' + SCHEMA_NAME(I.schema_id) + '.['+object_name(I.object_id)+']'
			+ ' ( ' + I.IndexColumns + ') '			-- IndexColumns
			+ CASE when I.IncludedColumns IS NOT null	-- Check InlcudedColumns
			  THEN ' INCLUDE ( ' + I.IncludedColumns + ' ) '
			  ELSE null END
			+ ';'+CHAR(10)+'GO"'
		END [- sql_createidx -]
		-- sp_filters
	--xx??xx FROM sys.dm_db_index_usage_stats s
	--xx??xx 		LEFT join cte_idx as I on s.[object_id] = I.[object_id] AND s.[index_id] = I.[index_id] 
	--xx??xx 		--xxxx inner join sys.index_columns as IC on IC.[object_id] = I.[object_id] and IC.[index_id] = I.[index_id] 
	--xx??xx 		--xxxx inner join sys.all_columns as AC on IC.[object_id] = AC.[object_id] and IC.[column_id] = AC.[column_id]
	--xx??xx WHERE  s.object_id = @objid
	FROM #tmpxcte_idx4000 AS I
	WHERE (CASE WHEN @objid is NULL THEN I.object_id
			ELSE @objid
			END) = I.object_id
	
	 -- ** (OR) SET Multiple objects [**** : sys.objects refers to CURRENT DB]
	 --** ???? OR EXISTS  (SELECT so.object_id FROM sys.objects so WHERE so.type='U' AND so.name LIKE '%V_POS_BATCH%' AND so.object_id = s.object_id)

	 -- select ALL or Particular INDEX , void-col
	 AND (CASE WHEN @idx is NULL OR @idx='' OR @idx=I.IndexName THEN 1
					ELSE 0
			END) = 1
	
	-- ????
	ORDER BY idx_is_unique desc, I.index_id
	;
END;  -- ENDoF :  (IF @sqlsel IS NULL)
ELSE 
BEGIN
-- Form output for only SQL
	-- ** sql Selection var :  (1): Create Idx SQL only  , (2): DROP Idx SQL only
	IF @sqlsel = 1
	BEGIN
		PRINT 'Given @SQLSel, for SQL output : ['+CONVERT(VARCHAR(10),@sqlsel)+']';
		SELECT  I.IndexName
		-- * CREATE sql
		, CASE I.PrimaryKey WHEN 1 THEN					-- Check PK
			'ALTER TABLE ' + SCHEMA_NAME(I.schema_id) + '.['+object_name(I.object_id)+']' + ' ADD CONSTRAINT [' + I.IndexName +']  PRIMARY KEY CLUSTERED '
			+ ' ( ' + I.IndexColumns + ') '			-- IndexColumns
			+ ';'+CHAR(10)+'GO'
		ELSE 
			'CREATE ' + I.IndexType
			+ CASE I.[Unique] WHEN 1 THEN ' UNIQUE '	-- Check Unique
			  ELSE NULL END
			+ ' INDEX [' + I.IndexName COLLATE DATABASE_DEFAULT + '] ON ' + SCHEMA_NAME(I.schema_id) + '.['+object_name(I.object_id)+']'
			+ ' ( ' + I.IndexColumns + ') '			-- IndexColumns
			+ CASE when I.IncludedColumns IS NOT null	-- Check InlcudedColumns
			  THEN ' INCLUDE ( ' + I.IncludedColumns + ' ) '
			  ELSE null END
			+ ';'+CHAR(10)+'GO'
		END [- sql_createidx -]
		FROM #tmpxcte_idx4000 AS I
		WHERE (CASE WHEN @objid is NULL THEN I.object_id
			ELSE @objid
			END) = I.object_id
		 -- select ALL or Particular INDEX , void-col
		 AND (CASE WHEN @idx is NULL OR @idx='' OR @idx=I.IndexName THEN 1
						ELSE 0
				END) = 1
		;
	END;
	--
	-- ** sql Selection var :  (1): Create Idx SQL only  , (2): DROP Idx SQL only
	ELSE IF @sqlsel =2
	BEGIN
		PRINT 'Given @SQLSel, for SQL output : ['+CONVERT(VARCHAR(10),@sqlsel)+']';
		SELECT  I.IndexName
		-- * DROP sql
		, CASE I.PrimaryKey WHEN 1 THEN					-- Check PK
			'ALTER TABLE ' + SCHEMA_NAME(I.schema_id) + '.['+object_name(I.object_id)+']' + ' DROP CONSTRAINT [' + I.IndexName +']  '
			+ ';'+CHAR(10)+'GO'
		ELSE 
			 'DROP INDEX ['+i.IndexName+'] ON ' + db_name(DB_ID())+ '.'+ SCHEMA_NAME(I.schema_id) + '.['+object_name(I.object_id)+'];'+CHAR(10)+'GO'
		END  [- sql_dropidx -]
		FROM #tmpxcte_idx4000 AS I
		WHERE (CASE WHEN @objid is NULL THEN I.object_id
			ELSE @objid
			END) = I.object_id
	
		 -- select ALL or Particular INDEX , void-col
		 AND (CASE WHEN @idx is NULL OR @idx='' OR @idx=I.IndexName THEN 1
						ELSE 0
				END) = 1
		;
    END;
	--
	ELSE
	BEGIN
		DECLARE @Errmess NVARCHAR(1000) ='**** -- '+ @@SERVERNAME+ '.'+DB_NAME()+ '.'+USER_NAME()+' ['+CONVERT(VARCHAR(19), GETDATE(),126)+']';
		SET @Errmess=@Errmess+CHAR(13)+ ' **** [sp_m_IdxDDL]: Invalid input variable(s), @SQLSel, for SQL output : ['+CONVERT(VARCHAR(10),@sqlsel)+']';
		RAISERROR (@Errmess, 16 /*Severity 0*/, 1) WITH /*xxLOG ,*/ NOWAIT;
		RETURN;
	END;

END;

-- cleanup
DROP TABLE #tmpxcte_idx4000;
-- ** ENDoF sp_m_IdxDDL
SET CONCAT_NULL_YIELDS_NULL ON;
SET NOCOUNT OFF
END;

GO
