USE [master]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--
CREATE PROC dbo.sp_chk_TBFreeSpace
	(	-- substitute for whatever desatabase name is checked
		@obj_name nvarchar(400) = NULL	-- * DEFAULT = NUll (Show ALL DBs)
	)
AS
BEGIN;
	SET NOCOUNT ON
	------------------------------------------------------------------------------------------- 
	-- ???? DB USE Error - must be found a way to pass DB_NAME to all sys. tables  ????
	-- Tables FreeSpace CHECK
	------------------------------------------------------------------------------------------- 
	-- -- **  ...\MSSQL\01_DB-Table_SpaceUsed_2.sql
	-- [sp_spaceused (Transact-SQL)	[http://msdn.microsoft.com/en-us/library/ms188776(SQL.90).aspx]
	-- Displaying the Sizes of Your SQL Server's Database's Tables [http://www.4guysfromrolla.com/webtech/032906-1.shtml]
	
	PRINT ''
	PRINT @@SERVERNAME+ '.'+DB_NAME()+'['+CONVERT(VARCHAR(19), GETDATE(),126)+']';
	print '/* -- Tables FreeSpace CHECK (order by reserved_mb DESC):  */';	
	print '/* -- (for [' + isnull(@obj_name, 'ALL Objects') +'] )  */';
	print '';

	WITH pages as (
	SELECT object_id, SUM (reserved_page_count) as reserved_pages, SUM (used_page_count) as used_pages,
			SUM (case 
					when (index_id < 2) then (in_row_data_page_count + lob_used_page_count + row_overflow_used_page_count)
					else lob_used_page_count + row_overflow_used_page_count
				 end) as pages
			, max(row_count) as row_count_all
	FROM sys.dm_db_partition_stats
	group by object_id
	), extra as (
	SELECT p.object_id, sum(reserved_page_count) as reserved_pages, sum(used_page_count) as used_pages
	FROM sys.dm_db_partition_stats p, sys.internal_tables it
	WHERE it.internal_type IN (202,204,211,212,213,214,215,216) AND p.object_id = it.object_id
	group by p.object_id
	)
	SELECT p.object_id, object_schema_name(p.object_id) + '.' + object_name(p.object_id) as TableName,
		p.row_count_all,
		(p.reserved_pages + isnull(e.reserved_pages, 0)) * 8 as reserved_kb, ((p.reserved_pages + isnull(e.reserved_pages, 0)) * 8)/1024.0 as reserved_mb,
		pages * 8 as data_kb, (pages * 8)/1024.0 as data_mb,
		(CASE WHEN p.used_pages + isnull(e.used_pages, 0) > pages THEN (p.used_pages + isnull(e.used_pages, 0) - pages) ELSE 0 END) * 8 as index_kb,
		((CASE WHEN p.used_pages + isnull(e.used_pages, 0) > pages THEN (p.used_pages + isnull(e.used_pages, 0) - pages) ELSE 0 END) * 8)/1024.0 as index_mb,
		(CASE WHEN p.reserved_pages + isnull(e.reserved_pages, 0) > p.used_pages + isnull(e.used_pages, 0) THEN (p.reserved_pages + isnull(e.reserved_pages, 0) - p.used_pages + isnull(e.used_pages, 0)) else 0 end) * 8 as unused_kb,
		CASE WHEN CAST(p.row_count_all AS real) = 0 THEN 0 ELSE
			((p.reserved_pages + isnull(e.reserved_pages, 0)) * 8) / CAST(p.row_count_all AS real) 
		END AS avg_row_size_kb, 
		--(((p.reserved_pages + isnull(e.reserved_pages, 0)) * 8) / CAST(p.row_count_all AS NUMERIC(14,1)))*1024.0 AS avg_row_size_b, 
		p.pages reserved_data_pages, so.type_desc, so.create_date, so.modify_date, so.parent_object_id,  td.value AS [table_desc]
	from pages p
	left outer join extra e on p.object_id = e.object_id
	LEFT JOIN sys.objects so ON p.object_id = so.object_id
	LEFT OUTER JOIN sys.extended_properties td
		ON		td.major_id = so.object_id
		AND 	td.minor_id = 0
		AND		td.name = 'MS_Description'
	--
	where 
	object_name(p.object_id) NOT LIKE 'dt%'    -- filter out system tables for diagramming
	AND p.OBJECT_ID > 255 
	-- SET Object_name
	--xx AND p.OBJECT_ID = object_id(@obj_name)
	AND p.OBJECT_ID = isnull(object_id(@obj_name), p.OBJECT_ID)  --if no dbname, then return all
	-- order by object_name(p.object_id), p.object_id
	-- order by reserved
	order by reserved_mb DESC , object_name(p.object_id)
	;
	--
	print ''
	-- -- ** ENDoF: Tables FreeSpace CHECK
	-- -- -- --
	--


	-- ** ENDoF sp_chk_TBFreeSpace
	SET NOCOUNT OFF
END;

GO
