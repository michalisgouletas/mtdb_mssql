USE [ais_replica]
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
CREATE FUNCTION [dbo].[DstOffset]
(
	--Converts UTC datetime to local time according to given time zone
	-- Add the parameters for the function here
	@UTCdate as datetime,
	@timezone as real,
	@DST as tinyint --Daylight Saving Time, 0 No DST, 1 Europe, 2 North America, 3 Australia, 4 Brazil, 5 Chile, 6 Mexico, 7 Egypt, 8 Namibia, 
	-- 9 Iran, 10 Jordan+Syria, 11 Turkey
)

--Australia: Start: First Sunday in October, End: First Sunday in April
--North America: Start: Second Sunday in March, End: First Sunday in November
--Brazil:Start: Third Sunday in October, End: Third Sunday in February
--Chile: Start:October 11, End: March 29
--Mexico: Start: First Sunday in April, End: Last Sunday in October
--Egypt: approx from 16/5 to 27/5 and from 1/8 to 26/8, No DST from 2015
--Namibia: DST begins on the first Sunday in September, and ends on the first Sunday in April.
--Iran: From March 21–22 to September 21–22; Starts on the second or third day of Nowruz
--Jordan + Syria:  From last Friday March to last Friday October
--Turkey: European DST up to 2016 - No DST from 2017


RETURNS int
AS
BEGIN

	if @UTCdate is null
		return null

	declare @lt as datetime
	declare @daylightoffset as int = 0

	set @timezone=@timezone*60.0	
	set @lt= DATEADD(minute, @timezone, @UTCdate)

	if @DST in (1,2,6,7,9,10) 
		begin
		if exists (select 1 from DST_MATRIX where DST_REGION=@DST and [YEAR]=DATEPART(YEAR, @lt) and @lt>=STARTS and @lt<=ENDS)
			set @daylightoffset=60
		end
	else if @DST in (3,4,5,8)
		begin
		if exists (select 1 from DST_MATRIX where DST_REGION=@DST and [YEAR]=DATEPART(YEAR, @lt) and (@lt>=STARTS or @lt<=ENDS))
			set @daylightoffset=60
		end
	else if @DST=11 and @UTCdate<'2016-03-29' --Turkey
		begin
		set @dst=1
		set @timezone=2
		if exists (select 1 from DST_MATRIX where DST_REGION=@DST and [YEAR]=DATEPART(YEAR, @lt) and @lt>=STARTS and @lt<=ENDS)
			set @daylightoffset=60
		end


	RETURN @daylightoffset

END





GO
