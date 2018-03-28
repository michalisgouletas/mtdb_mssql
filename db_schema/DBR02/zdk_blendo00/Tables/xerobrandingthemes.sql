USE [zdk_blendo00]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[xerobrandingthemes](
	[blendo_imported_at] [bigint] NULL,
	[brandingthemeid] [varchar](256) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[createddateutc] [datetime] NULL,
	[name] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[sortorder] [bigint] NULL
) ON [FG_DATA_00] TEXTIMAGE_ON [FG_DATA_00]

GO
