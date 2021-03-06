USE [zdk_blendo00]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[xeroexpenseclaims](
	[amountdue] [float] NULL,
	[amountpaid] [float] NULL,
	[blendo_imported_at] [bigint] NULL,
	[expenseclaimid] [varchar](256) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[paymentduedate] [datetime] NULL,
	[reportingdate] [datetime] NULL,
	[status] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[total] [float] NULL,
	[updateddateutc] [datetime] NULL,
	[user_emailaddress] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[user_firstname] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[user_issubscriber] [bit] NULL,
	[user_lastname] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[user_organisationrole] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[user_updateddateutc] [datetime] NULL,
	[user_userid] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [FG_DATA_00] TEXTIMAGE_ON [FG_DATA_00]

GO
