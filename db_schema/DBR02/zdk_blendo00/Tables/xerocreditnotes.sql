USE [zdk_blendo00]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[xerocreditnotes](
	[allocations_amount] [float] NULL,
	[allocations_date] [datetime] NULL,
	[allocations_invoice_haserrors] [bit] NULL,
	[allocations_invoice_invoiceid] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[allocations_invoice_invoicenumber] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[allocations_invoice_isdiscounted] [bit] NULL,
	[blendo_imported_at] [bigint] NULL,
	[brandingthemeid] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[contact_contactid] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[contact_hasvalidationerrors] [bit] NULL,
	[contact_name] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[creditnoteid] [varchar](256) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[creditnotenumber] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[currencycode] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[currencyrate] [float] NULL,
	[date] [datetime] NULL,
	[datestring] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[fullypaidondate] [datetime] NULL,
	[hasattachments] [bit] NULL,
	[id] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[lineamounttypes] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[payments_amount] [float] NULL,
	[payments_currencyrate] [float] NULL,
	[payments_date] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[payments_hasaccount] [bit] NULL,
	[payments_hasvalidationerrors] [bit] NULL,
	[payments_paymentid] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[payments_reference] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[reference] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[remainingcredit] [float] NULL,
	[senttocontact] [bit] NULL,
	[status] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[subtotal] [float] NULL,
	[total] [float] NULL,
	[totaltax] [float] NULL,
	[type] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[updateddateutc] [datetime] NULL
) ON [FG_DATA_00] TEXTIMAGE_ON [FG_DATA_00]

GO
