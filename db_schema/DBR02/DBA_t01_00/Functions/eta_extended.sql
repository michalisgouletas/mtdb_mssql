USE [DBA_t01_00]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
CREATE FUNCTION [dbo].[eta_extended]
--same as ETA function, but returns table with ETA and ROUTE
(
	@mmsi int,
	@port_id int,
	@scheduled datetime,
	@firstport bit
)
RETURNS
@RESULT_TABLE TABLE 
(
	ETA SMALLDATETIME NULL,
	ROUTE GEOGRAPHY NULL
)

AS
BEGIN

declare @current_x as real
declare @current_y as real
declare @current_course as int
declare @current_speed as int
declare @lasttime as datetime
declare @etamins as int
declare @eta as smalldatetime
declare @inport as bit
declare @arrived as bit
declare @scheduled_diff as int


if @scheduled is not null AND (@scheduled<=dateadd(hour, -3, getutcdate()) OR @scheduled>=dateadd(hour, 6, getutcdate()))
	return;

--last moving pos if in range and when not NEAR ports
SELECT TOP 1 @current_x=LON, @current_y=LAT, @current_course=COURSE, @current_speed=SPEED, @lasttime=[TIMESTAMP] FROM ais_pos.dbo.POS WITH(NOLOCK)
WHERE MMSI=@mmsi AND [TIMESTAMP]>DATEADD(HOUR, -1, GETUTCDATE()) AND SPEED >90
AND NOT EXISTS (SELECT 1 FROM PORTS WITH(NOLOCK) WHERE PORTS.SW_X-0.017 <= LON AND PORTS.NE_X+0.017 >= LON AND 
	PORTS.SW_Y-0.017 <= LAT AND PORTS.NE_Y+0.017 >= LAT)
ORDER BY TIMESTAMP DESC

if @current_x is null
	return;

--check if currently in given port
IF EXISTS (SELECT PORT_ID FROM V_POS_BATCH WHERE MMSI=@mmsi and PORT_ID=@port_id)
	set @inport=1
else
	set @inport=0
	
--check if already arrived
IF EXISTS (SELECT MMSI FROM PORT_MOVES WITH(NOLOCK)
		WHERE MMSI=@mmsi AND PORT_ID=@port_id
		AND [TIMESTAMP]>dateadd(hour, -1 ,@scheduled) AND [TIMESTAMP]<dateadd(hour, 2 ,@scheduled))
	set @arrived=1
else
	set @arrived=0

-- for ports with no Enabled ETA, find time based on distance and speed
declare @port_x as real;
declare @port_y as real;
if @firstport=1 AND @current_x is not null AND @inport=0 AND @arrived=0 AND exists (select PORT_ID from PORTS where PORT_ID=@port_id and ENABLE_ETA=0)
begin
	select @port_x = SW_X, @port_y=SW_Y from [PORTS] where PORT_ID=@port_id;
	set @etamins=dbo.distance(@current_y, @current_x, @port_y, @port_x)*600/@current_speed
	if @etamins>2 AND @etamins<720
		set @eta = dateadd(minute, @etamins, @lasttime)
	INSERT INTO @RESULT_TABLE (ETA) VALUES (@eta);
end

set @scheduled_diff = datediff(minute, @lasttime, @scheduled)

if @current_x is not null AND @inport=0 AND @arrived=0
begin
declare @tim_start as smalldatetime
declare @tim_end as smalldatetime
--find older positions within 2 miles from current position and relevant port arrivals
--SELECT @etamins=CASE WHEN COUNT(*)>3 THEN (SUM(DIFF)-MIN(DIFF)-MAX(DIFF))/(COUNT(*)-2) ELSE AVG(DIFF) END FROM
SELECT TOP 1 @etamins=DIFF, @tim_start=TIM_START, @tim_end=TIM_END FROM
(SELECT TOP 10 CASE WHEN ABS(AVG(SPEED)-@current_speed)>10 THEN --do not correct if speed diff less than 2 knots
CONVERT(REAL,AVG(SPEED))/@current_speed*DATEDIFF(MINUTE, CONVERT(datetime, AVG(CONVERT(float,POS.TIMESTAMP))), MIN(PORT_MOVES.TIMESTAMP))
ELSE DATEDIFF(MINUTE, CONVERT(datetime, AVG(CONVERT(float,POS.TIMESTAMP))), MIN(PORT_MOVES.TIMESTAMP))
END AS DIFF, CONVERT(datetime, AVG(CONVERT(float,POS.TIMESTAMP))) AS TIM_START, MIN(PORT_MOVES.TIMESTAMP) AS TIM_END
FROM ais_archive_2014B..POS_ARCHIVE AS POS WITH(NOLOCK) INNER JOIN PORT_MOVES_COPY AS PORT_MOVES WITH(NOLOCK) ON 
	PORT_MOVES.TIMESTAMP>POS.TIMESTAMP AND PORT_MOVES.TIMESTAMP<dateadd(hour,12,POS.TIMESTAMP) AND POS.MMSI=PORT_MOVES.MMSI
WHERE POS.MMSI=@mmsi AND LON<@current_x+0.010 AND LON>@current_x-0.010 
AND LAT<@current_y+0.010 AND LAT>@current_y-0.010 
AND COURSE >@current_course-20 AND COURSE < @current_course+20 AND SPEED>80
AND PORT_MOVES.MMSI=@mmsi AND PORT_ID=@port_id AND MOVE_TYPE=0 AND POS.TIMESTAMP>DATEADD(DAY, -18, GETUTCDATE()) 
GROUP BY FLOOR(CONVERT(FLOAT,POS.TIMESTAMP))) AS SUBQ 
WHERE DIFF>0 AND DIFF<480
ORDER BY ABS(DIFF-@scheduled_diff)


--if not found, try an estimation with nearby positions of other vessels
/*if @etamins is null AND @current_speed>0 
SELECT @etamins= CASE WHEN COUNT(*)>2 THEN (SUM(DIFF)-MIN(DIFF)-MAX(DIFF))/(COUNT(*)-2) ELSE AVG(DIFF) END
 FROM	--EXCLUDE MIN AND MAX VALUES FROM AVERAGE (SUM(DIFF)-MIN(DIFF)-MAX(DIFF))/(COUNT(DIFF)-2)
(SELECT TOP 10 CONVERT(REAL,AVG(SPEED))/@current_speed*DATEDIFF(MINUTE, CONVERT(datetime, MIN(CONVERT(float,POS.TIMESTAMP))), MIN(PORT_MOVES.TIMESTAMP)) AS DIFF 
FROM ais_history..POS_HISTORY AS POS WITH(NOLOCK) INNER JOIN PORT_MOVES_COPY AS PORT_MOVES WITH(NOLOCK) ON PORT_MOVES.MMSI=POS.MMSI
	AND PORT_MOVES.TIMESTAMP>POS.TIMESTAMP AND PORT_MOVES.TIMESTAMP<dateadd(hour,6,POS.TIMESTAMP)
WHERE LON<@current_x+0.017 AND LON>@current_x-0.017 
AND LAT<@current_y+0.017 AND LAT>@current_y-0.017 
AND COURSE >@current_course-10 AND COURSE < @current_course+10 AND SPEED>90
AND PORT_ID=@port_id AND MOVE_TYPE=0 AND POS.TIMESTAMP>DATEADD(day, -5, GETUTCDATE())  AND POS.TIMESTAMP<DATEADD(HOUR, -20, GETUTCDATE())
GROUP BY FLOOR(CONVERT(FLOAT,POS.TIMESTAMP)), POS.MMSI) AS SUBQ WHERE DIFF>0 AND DIFF<360
*/

--find route from archive and store in Linestring geography
if @etamins is not null
begin
declare @lat as real
declare @lon as real
declare @course as smallint
declare @last_course as smallint
declare @tim as smalldatetime
declare @last_tim as smalldatetime
declare @linestring as varchar(max)
declare @included as bit
declare @max_time_interval as int
set @last_course=-1
set @last_tim = '1/1/2000'
set @linestring = 'LINESTRING('

--find route from archive
declare cursorpos cursor for
    SELECT LON, LAT, COURSE, [TIMESTAMP] FROM ais_archive_2014B..POS_ARCHIVE 
	WHERE MMSI=@mmsi AND TIMESTAMP>=@tim_start AND TIMESTAMP<=@tim_end AND SPEED>=50
	ORDER BY TIMESTAMP

open cursorpos

fetch next from cursorpos into @lon, @lat, @course, @tim

while @@fetch_status=0
	begin
	--build geography linestring
	set @included=0
	if(Abs(@course-@last_course)>=5 OR datediff(minute,@last_tim, @tim)>30) --remove collinear
		begin
		set @linestring = @linestring + convert(varchar, @lon) + ' ' + convert(varchar, @lat)
		set @last_course=@course
		set @last_tim=@tim
		set @included=1
		end
	fetch next from cursorpos into @lon, @lat, @course, @tim
	if @@fetch_status=0 and @included =1 --not last record
		set @linestring = @linestring + ', '
	if @@FETCH_STATUS<>0 and @included=0 --insert last record in all cases
		set @linestring = @linestring + convert(varchar, @lon) + ' ' + convert(varchar, @lat)
	end

close cursorpos
deallocate cursorpos

set @linestring=@linestring+')'
end


if @firstport=1 AND @etamins is null --then based on distance
begin
	select @port_x = SW_X, @port_y=SW_Y from PORTS where PORT_ID=@port_id;
	set @etamins=dbo.distance(@current_y, @current_x, @port_y, @port_x)*600/@current_speed
end


--do not estimate etas further than 8 hours and not more than 1 hour before scheduled
if len (@linestring)>60 and @etamins is not null AND @etamins>2 AND @etamins<720 AND @etamins>@scheduled_diff-120
	begin
	set @eta = dateadd(minute, @etamins-1, @lasttime)
	INSERT INTO @RESULT_TABLE (ETA, ROUTE) VALUES (@eta, geography::STGeomFromText(@linestring, 4326));
	end
end

return

END































GO
