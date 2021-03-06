USE [zdk_blendo00]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[xeroreceipts](
	[blendo_imported_at] [bigint] NULL,
	[contact_contactid] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[contact_hasvalidationerrors] [bit] NULL,
	[contact_name] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[date] [datetime] NULL,
	[hasattachments] [bit] NULL,
	[id] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[lineamounttypes] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[receiptid] [varchar](256) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[receiptnumber] [bigint] NULL,
	[reference] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[status] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[subtotal] [float] NULL,
	[total] [float] NULL,
	[totaltax] [float] NULL,
	[updateddateutc] [datetime] NULL,
	[user_firstname] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[user_lastname] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[user_userid] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [FG_DATA_00] TEXTIMAGE_ON [FG_DATA_00]

GO
