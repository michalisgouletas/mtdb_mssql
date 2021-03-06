USE [ais_replica]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[L_TYPE_GT_GROUPED](
	[id] [int] NOT NULL,
	[TYPE_GROUPED_NAME] [varchar](30) COLLATE SQL_Latin1_General_CP1_CI_AI NULL,
	[TYPE_DENSITY_ID] [int] NULL,
	[TYPE_DENSITY_NAME] [varchar](30) COLLATE SQL_Latin1_General_CP1_CI_AI NULL,
	[TYPE_PORT_STATS] [varchar](20) COLLATE SQL_Latin1_General_CP1_CI_AI NULL,
	[COMFLEET_GROUPEDTYPE] [varchar](20) COLLATE SQL_Latin1_General_CP1_CI_AI NULL
) ON [PRIMARY]

GO
