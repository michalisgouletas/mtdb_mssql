USE [zdk_blendo00]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[xerobanktransactions](
	[bankaccount_accountid] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[bankaccount_code] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[bankaccount_name] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[banktransactionid] [varchar](256) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[blendo_imported_at] [bigint] NULL,
	[contact_contactid] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[contact_hasvalidationerrors] [bit] NULL,
	[contact_name] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[currencycode] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[currencyrate] [float] NULL,
	[date] [datetime] NULL,
	[datestring] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[hasattachments] [bit] NULL,
	[isreconciled] [bit] NULL,
	[lineamounttypes] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[overpaymentid] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[reference] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[status] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[subtotal] [float] NULL,
	[total] [float] NULL,
	[totaltax] [float] NULL,
	[type] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[updateddateutc] [datetime] NULL
) ON [FG_DATA_00] TEXTIMAGE_ON [FG_DATA_00]

GO
