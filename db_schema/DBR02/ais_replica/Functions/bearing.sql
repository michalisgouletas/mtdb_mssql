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
CREATE FUNCTION [dbo].[bearing]
(
	@lat1 as real,
	@lon1 as real,
	@lat2 as real,
	@lon2 as real
)
RETURNS real
WITH SCHEMABINDING
AS
BEGIN
declare @result as float
declare @x as float
declare @y as float
declare @dLon as float
declare @dLat as float

set @dLon = radians(@lon2-@lon1)
set @y = sin(@dLon) * cos(RADIANS(@lat2))
set @x = COS(radians(@lat1))*sin(radians(@lat2)) - SIN(radians(@lat1))*COS(radians(@lat2))*COS(@dLon)

if(@x=0 AND @y=0)
	set @result=0
else
	set @result = (convert(Integer,degrees(atn2(@y, @x)))+360) % 360


RETURN @result

END



GO
