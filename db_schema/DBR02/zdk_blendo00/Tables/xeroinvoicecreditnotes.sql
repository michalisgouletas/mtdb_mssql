USE [zdk_blendo00]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[xeroinvoicecreditnotes](
	[appliedamount] [float] NULL,
	[blendo_id] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[blendo_imported_at] [bigint] NULL,
	[creditnoteid] [varchar](256) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[creditnotenumber] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[date] [datetime] NULL,
	[datestring] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[id] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[invoiceid] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[total] [float] NULL
) ON [FG_DATA_00] TEXTIMAGE_ON [FG_DATA_00]

GO
