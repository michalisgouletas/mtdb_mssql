USE [zdk_blendo00]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[xerojournallines](
	[accountcode] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[accountid] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[accountname] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[accounttype] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[blendo_imported_at] [bigint] NULL,
	[description] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[grossamount] [float] NULL,
	[journalid] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[journallineid] [varchar](256) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[netamount] [float] NULL,
	[taxamount] [float] NULL,
	[taxname] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[taxtype] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [FG_DATA_00] TEXTIMAGE_ON [FG_DATA_00]

GO
