USE [zdk_blendo00]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[xerojournallinestracking](
	[blendo_id] [varchar](256) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[blendo_imported_at] [bigint] NULL,
	[journalid] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[journallineid] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[name] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[option] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[trackingcategoryid] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[trackingoptionid] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [FG_DATA_00] TEXTIMAGE_ON [FG_DATA_00]

GO
