USE [ais_replica]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[V_SHIPCOUNT]
AS
SELECT     COUNT(*) AS SHIPCOUNT
FROM         dbo.V_POS_BATCH



GO
