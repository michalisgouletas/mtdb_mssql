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
CREATE FUNCTION [dbo].[ConvertToLocalTime]
(
	--Converts datetime to greek time and returns string dd/MM/yyyy HH:mm
	-- Add the parameters for the function here
	@UTCdate as datetime
)
RETURNS varchar(20)
AS
BEGIN
	DECLARE @LocalTime as varchar(20)
	declare @lt as datetime

	set @lt= DATEADD(minute, DATEDIFF(minute, GETUTCDATE(), GETDATE()), @UTCdate)
	set @LocalTime = convert(varchar, @lt, 103) + ' ' + right('0'+convert(varchar,datepart(hour, @lt)),2)
		+ ':' + right('0'+convert(varchar,datepart(minute,@lt)),2)

	RETURN @LocalTime

END




GO
