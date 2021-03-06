USE [zdk_blendo00]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[xerobanktransfers](
	[amount] [float] NULL,
	[banktransferid] [varchar](256) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[blendo_imported_at] [bigint] NULL,
	[createddateutc] [datetime] NULL,
	[createddateutcstring] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[date] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[datestring] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[frombankaccount_accountid] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[frombankaccount_name] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[frombanktransactionid] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[hasattachments] [bit] NULL,
	[tobankaccount_accountid] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[tobankaccount_name] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[tobanktransactionid] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [FG_DATA_00] TEXTIMAGE_ON [FG_DATA_00]

GO
