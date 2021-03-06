USE [zdk_blendo00]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[xerobudgetsummaryreport](
	[account] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[blendo_id] [varchar](256) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[blendo_imported_at] [bigint] NULL,
	[period] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[row] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[section] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[value] [float] NULL
) ON [FG_DATA_00] TEXTIMAGE_ON [FG_DATA_00]

GO
