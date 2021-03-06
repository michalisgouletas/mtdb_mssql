USE [ais_replica]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		dlek
-- Create date: 2017-08-20
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[get_playback_data]
	@start datetime,
	@duration int = 2,
	@sw_lat real = 0,
	@sw_lon real = 0,
	@ne_lat real = 0,
	@ne_lon real = 0,
	@zoom int = 10,
	@fleet int = 0,
	@ship_list varchar(8000) = '',
	@show_nearby bit = 0

AS
BEGIN
	SET NOCOUNT ON;

declare @sql as varchar(8000)
declare @inner_sql as varchar(8000)
declare @pos_table as varchar(255)
declare @pos_table2 as varchar(255)
declare @ship_table as varchar(255)
declare @extend_coords real = 0.05
declare @extend_minutes int = 10
declare @noheading int = 0
declare @nogap int = 1
declare @clustering int = 0
declare @key varchar(50) = 'SHIP_ID'
declare @no_l_fore int = 0
declare @end as datetime

set @duration = @duration * 60

if @fleet > 0 or (@ship_list<>'' and @ship_list is not null)
	begin
	set @extend_minutes = 30
	set @end = dateadd(minute, @duration + @extend_minutes, @start)
	set @start = dateadd(minute, @extend_minutes * -1, @start)
	select @pos_table = '[' + linkedserver + '].[' + dbname + '].dbo.[' + tablename + ']' from MT1.ais.dbo.L_POSARCHIVE where @start between fromdate and todate
	select @pos_table2 = '[' + linkedserver + '].[' + dbname + '].dbo.[' + tablename + ']' from MT1.ais.dbo.L_POSARCHIVE where @end between fromdate and todate
	select @ship_table = '[' + linkedserver + '].[' + dbname + '].dbo.[SHIP]' from MT1.ais.dbo.L_POSARCHIVE where @start between fromdate and todate
	select @key = indices from MT1.ais.dbo.L_POSARCHIVE where @start between fromdate and todate
	set @extend_minutes = 30
	end
else if @zoom>=15 and @start > convert(date, getutcdate()) --ais_pos current
	begin
	set @end = dateadd(minute, @duration + @extend_minutes, @start)
	set @start = dateadd(minute, @extend_minutes * -1, @start)
	set @pos_table = 'MT1.ais_pos.dbo.POS'
	set @pos_table2 = 'MT1.ais_pos.dbo.POS'
	set @ship_table = 'MT1.ais.dbo.V_SHIP_BATCH'
	end
else if @zoom >=15 and @start > getutcdate() - 90 and dateadd(minute, @duration + @extend_minutes, @start) > getutcdate() - 90 --ais_pos past
	begin
	set @end = dateadd(minute, @duration + @extend_minutes, @start)
	set @start = dateadd(minute, @extend_minutes * -1, @start)
	set @pos_table = 'MT1.ais_pos.dbo.POS_' + CONVERT(varchar, datepart(year, @start)) + FORMAT(datepart(month, @start), '00') + FORMAT(datepart(day, @start), '00')
	if @end > convert(date, getutcdate())
		set @pos_table2 = 'MT1.ais_pos.dbo.POS'
	else
		set @pos_table2 = 'MT1.ais_pos.dbo.POS_' + CONVERT(varchar, datepart(year, @end)) + FORMAT(datepart(month, @end), '00') + FORMAT(datepart(day, @end), '00')
	set @ship_table = 'MT1.ais.dbo.V_SHIP_BATCH'
	end
else if @zoom >= 13 --pos_archive
	begin
	set @extend_minutes = 30
	set @end = dateadd(minute, @duration + @extend_minutes, @start)
	set @start = dateadd(minute, @extend_minutes * -1, @start)
	select @pos_table = '[' + linkedserver + '].[' + dbname + '].dbo.[' + tablename + ']' from MT1.ais.dbo.L_POSARCHIVE where @start between fromdate and todate
	select @pos_table2 = '[' + linkedserver + '].[' + dbname + '].dbo.[' + tablename + ']' from MT1.ais.dbo.L_POSARCHIVE where @end between fromdate and todate
	select @ship_table = '[' + linkedserver + '].[' + dbname + '].dbo.[SHIP]' from MT1.ais.dbo.L_POSARCHIVE where @start between fromdate and todate
	select @key = indices from MT1.ais.dbo.L_POSARCHIVE where @start between fromdate and todate
	set @extend_coords = 0.1
	end
else if @zoom >= 10 --pos_diff
	begin
	set @extend_minutes = 90
	set @end = dateadd(minute, @duration + @extend_minutes, @start)
	set @start = dateadd(minute, @extend_minutes * -1, @start)
	select @pos_table = '[' + linkedserver + '].[' + dbname + '].dbo.[' + tablediff + ']' from MT1.ais.dbo.L_POSARCHIVE where @start between fromdate and todate
	select @pos_table2 = '[' + linkedserver + '].[' + dbname + '].dbo.[' + tablediff + ']' from MT1.ais.dbo.L_POSARCHIVE where @end between fromdate and todate
	select @ship_table = '[' + linkedserver + '].[' + dbname + '].dbo.[SHIP]' from MT1.ais.dbo.L_POSARCHIVE where @start between fromdate and todate
	select @key = indices from MT1.ais.dbo.L_POSARCHIVE where @start between fromdate and todate
	set @extend_coords = 0.5
	set @noheading = 1
	set @clustering = 1
	if @start > '2015-05-20 21:40'
		set @nogap = 0 --GAP value exists
	end
else
	return

if @start < '2013-12-31 17:03'
	set @no_l_fore = 1

if @clustering = 0
begin
--no clustering
set @inner_sql = 'SELECT P.' + @key + ' AS SHIP_ID,	P.TIMESTAMP, P.LON, P.LAT, P.SPEED, P.COURSE, CASE WHEN P.STATION in (1000, 2000) THEN 1 ELSE 0 END AS SAT, '

	if @noheading = 1
		set @inner_sql = @inner_sql + '511 AS HEADING, '
	else	
		set @inner_sql = @inner_sql +  'P.HEADING, '

	if @nogap = 1
		set @inner_sql = @inner_sql + '-1 AS GAP_MINUTES '
	else	
		set @inner_sql = @inner_sql +  'P.GAP_MINUTES '

--READY TO GO LIVE WHEN SINGLE SHIP WITH NEARBY VESSELS IS READY ON THE UI
if @ship_list <> '' and @ship_list not like '%,%' and @show_nearby = 1 --single vessel tracking, find nearby positions as well
	set @inner_sql = REPLACE(@inner_sql, 'SELECT ', 'SELECT DISTINCT ') + ' FROM ' + @pos_table + ' AS A WITH(NOLOCK)
		INNER JOIN ' + @pos_table + ' P WITH(NOLOCK) ON P.LAT BETWEEN A.LAT-0.1 AND A.LAT+0.1
		AND P.LON BETWEEN A.LON-0.1 AND A.LON+0.1
		AND P.TIMESTAMP BETWEEN DATEADD(MINUTE, -30, A.TIMESTAMP) AND DATEADD(MINUTE, 30, A.TIMESTAMP)
		WHERE A.' + @key + ' IN (' + @ship_list + ')'
		+ ' AND A.TIMESTAMP >= ''' + convert(varchar, @start) + ''' AND A.TIMESTAMP <= ''' + convert(varchar, @end) + ''''
		+ ' AND P.TIMESTAMP >= ''' + convert(varchar, @start) + ''' AND P.TIMESTAMP <= ''' + convert(varchar, @end) + ''''else if @ship_list <> ''
	set @inner_sql = @inner_sql + ' FROM ' + @pos_table + ' AS P WITH(NOLOCK) WHERE P.' + @key + ' IN (' + @ship_list + ')'
		+ ' AND P.TIMESTAMP >= ''' + convert(varchar, @start) + ''' AND P.TIMESTAMP <= ''' + convert(varchar, @end) + ''''
else if @fleet > 0
	set @inner_sql = @inner_sql + ' FROM ' + @pos_table + ' AS P WITH(NOLOCK) WHERE P.' + @key + ' IN (SELECT item FROM MT1.ais.dbo.crm_collection_items WHERE collection_id = ' + convert(varchar, @fleet) + ') '
		+ ' AND P.TIMESTAMP >= ''' + convert(varchar, @start) + ''' AND P.TIMESTAMP <= ''' + convert(varchar, @end) + ''''
else
	set @inner_sql = @inner_sql + ' FROM ' + @pos_table + ' AS P WITH(NOLOCK) WHERE P.LON BETWEEN ' + convert(varchar, (@sw_lon - @extend_coords)) + ' AND ' + convert(varchar, @ne_lon + @extend_coords) 
		+ ' AND P.LAT BETWEEN ' + convert(varchar, @sw_lat - @extend_coords) + ' AND ' + convert(varchar, @ne_lat + @extend_coords) 
		+ ' AND P.TIMESTAMP >= ''' + convert(varchar, @start) + ''' AND P.TIMESTAMP <= ''' + convert(varchar, @end) + ''''


--UNION two tables if required
set @sql = 'SELECT P.SHIP_ID, P.TIMESTAMP, P.LON, P.LAT, P.SPEED, P.COURSE, P.SAT, S.LENGTH, S.SHIPNAME, S.TYPE_COLOR, S.WIDTH, P.HEADING, P.GAP_MINUTES, '
	if @no_l_fore = 1
		set @sql = @sql + 'NULL AS L_FORE, NULL AS W_LEFT '
	else	
		set @sql = @sql +  'S.L_FORE, S.W_LEFT '

set @sql = @sql + ' FROM (' + @inner_sql 
if @pos_table <> @pos_table2
	set @sql = @sql + ' UNION ALL ' + REPLACE(@inner_sql, @pos_table, @pos_table2)
set @sql = @sql + ') P INNER JOIN ' + @ship_table + ' AS S WITH ( NOLOCK ) ON P.SHIP_ID = S.' + @key + ' 
	ORDER BY P.SHIP_ID ASC, P.TIMESTAMP ASC'

end

else
begin
--with data clustering
set @inner_sql = 'SELECT B.SHIP_ID, B.TIMESTAMP, B.LON, B.LAT, B.SPEED, B.COURSE, B.HEADING, B.SAT, B.GAP_MINUTES
	FROM (SELECT
		ROW_NUMBER()
		OVER (
		PARTITION BY ROUND(LAT, 3)
			, ROUND(LON, 3)
			, DATEPART(HOUR, TIMESTAMP)
			, DATEPART(MINUTE, TIMESTAMP) / 10
			ORDER BY SPEED DESC
		) AS ROWNUMBER,
		A.' + @key + ' AS SHIP_ID, A.TIMESTAMP, A.LON, A.LAT, A.SPEED, A.COURSE, CASE WHEN A.STATION in (1000, 2000) THEN 1 ELSE 0 END AS SAT, '
	if @noheading = 1
		set @inner_sql = @inner_sql + '511 AS HEADING, '
	else	
		set @inner_sql = @inner_sql +  'A.HEADING, '

	if @nogap = 1
		set @inner_sql = @inner_sql + '-1 AS GAP_MINUTES '
	else	
		set @inner_sql = @inner_sql +  'A.GAP_MINUTES '

set @inner_sql = @inner_sql + 'FROM ' + @pos_table + ' AS A WITH(NOLOCK)
	WHERE 	A.LON BETWEEN ' + convert(varchar, (@sw_lon - @extend_coords)) + ' AND ' + convert(varchar, @ne_lon + @extend_coords) 
	+ ' AND A.LAT BETWEEN ' + convert(varchar, @sw_lat - @extend_coords) + ' AND ' + convert(varchar, @ne_lat + @extend_coords) 
	+ ' AND A.TIMESTAMP >= ''' + convert(varchar, @start) + ''' AND A.TIMESTAMP <= ''' + convert(varchar, @end) + ''' 
			) B
			WHERE B.ROWNUMBER = 1 '

set @sql = 'SELECT P.SHIP_ID, P.TIMESTAMP, P.LON, P.LAT, P.SPEED, P.COURSE, P.SAT, P.HEADING, S.WIDTH, S.LENGTH, S.SHIPNAME, S.TYPE_COLOR, P.GAP_MINUTES, '

if @no_l_fore = 1
	set @sql = @sql + 'NULL AS L_FORE, NULL AS W_LEFT '
else
	set @sql = @sql +  'S.L_FORE, S.W_LEFT '

set @sql = @sql + ' FROM (' + @inner_sql 
if @pos_table <> @pos_table2
	set @sql = @sql + ' UNION ALL ' + REPLACE(@inner_sql, @pos_table, @pos_table2)
set @sql = @sql + '	) P INNER JOIN ' + @ship_table + ' S WITH ( NOLOCK ) ON P.SHIP_ID = S.' + @key + '  
		ORDER BY P.SHIP_ID ASC, P.TIMESTAMP ASC'
end

--print @sql

EXEC (@sql)


END

GO
