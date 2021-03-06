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
CREATE FUNCTION [dbo].[distance]
(
	@lat1 as float,
	@lon1 as float,
	@lat2 as float,
	@lon2 as float
)
RETURNS float
AS
BEGIN
declare @result as float
declare @R as float
declare @a as float
declare @dLon as float
declare @dLat as float

set @R = 3440.0 --earth radius in nautical miles
set @dLat = radians(@lat2-@lat1)
set @dLon = radians(@lon2-@lon1)
set @a = sin(@dLat/2.0) * sin(@dLat/2.0) +
        cos(radians(@lat1)) * cos(radians(@lat2)) * sin(@dLon/2.0) * sin(@dLon/2.0)
set @result = @R * 2.0 * atn2(sqrt(@a), sqrt(1.0-@a))

	RETURN @result

END



GO
