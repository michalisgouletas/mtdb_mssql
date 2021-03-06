USE [zdk_blendo00]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[xerorepeatinginvoices](
	[blendo_imported_at] [bigint] NULL,
	[brandingthemeid] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[contact_contactid] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[contact_hasvalidationerrors] [bit] NULL,
	[contact_name] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[currencycode] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[hasattachments] [bit] NULL,
	[id] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[lineamounttypes] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[lineitems_accountcode] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[lineitems_description] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[lineitems_discountrate] [float] NULL,
	[lineitems_lineamount] [float] NULL,
	[lineitems_lineitemid] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[lineitems_quantity] [float] NULL,
	[lineitems_taxamount] [float] NULL,
	[lineitems_taxtype] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[lineitems_tracking_name] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[lineitems_tracking_option] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[lineitems_tracking_trackingcategoryid] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[lineitems_unitamount] [float] NULL,
	[reference] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[repeatinginvoiceid] [varchar](256) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[schedule_duedate] [bigint] NULL,
	[schedule_duedatetype] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[schedule_enddate] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[schedule_nextscheduleddate] [datetime] NULL,
	[schedule_period] [bigint] NULL,
	[schedule_startdate] [datetime] NULL,
	[schedule_unit] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[status] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[subtotal] [float] NULL,
	[total] [float] NULL,
	[totaldiscount] [float] NULL,
	[totaltax] [float] NULL,
	[type] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [FG_DATA_00] TEXTIMAGE_ON [FG_DATA_00]

GO
