USE [zdk_blendo00]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[xeroaccounts](
	[accountid] [varchar](256) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[bankaccountnumber] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[bankaccounttype] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[blendo_imported_at] [bigint] NULL,
	[class] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[code] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[currencycode] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[description] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[enablepaymentstoaccount] [bit] NULL,
	[hasattachments] [bit] NULL,
	[name] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[reportingcode] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[reportingcodename] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[showinexpenseclaims] [bit] NULL,
	[status] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[systemaccount] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[taxtype] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[type] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[updateddateutc] [datetime] NULL
) ON [FG_DATA_00] TEXTIMAGE_ON [FG_DATA_00]

GO
