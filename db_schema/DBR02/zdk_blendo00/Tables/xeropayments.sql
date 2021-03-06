USE [zdk_blendo00]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[xeropayments](
	[account_accountid] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[account_code] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[amount] [float] NULL,
	[bankamount] [float] NULL,
	[blendo_imported_at] [bigint] NULL,
	[currencyrate] [float] NULL,
	[date] [datetime] NULL,
	[hasaccount] [bit] NULL,
	[hasvalidationerrors] [bit] NULL,
	[invoice_contact_contactid] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[invoice_contact_contactnumber] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[invoice_contact_hasvalidationerrors] [bit] NULL,
	[invoice_contact_name] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[invoice_currencycode] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[invoice_haserrors] [bit] NULL,
	[invoice_invoiceid] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[invoice_invoicenumber] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[invoice_isdiscounted] [bit] NULL,
	[invoice_type] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[isreconciled] [bit] NULL,
	[paymentid] [varchar](256) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[paymenttype] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[reference] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[status] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[updateddateutc] [datetime] NULL
) ON [FG_DATA_00] TEXTIMAGE_ON [FG_DATA_00]

GO
