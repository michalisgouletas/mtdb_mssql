USE [zdk_blendo00]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[xeroitems](
	[blendo_imported_at] [bigint] NULL,
	[code] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[description] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[inventoryassetaccountcode] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ispurchased] [bit] NULL,
	[issold] [bit] NULL,
	[istrackedasinventory] [bit] NULL,
	[itemid] [varchar](256) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[name] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[purchasedescription] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[purchasedetails_accountcode] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[purchasedetails_cogsaccountcode] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[purchasedetails_taxtype] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[purchasedetails_unitprice] [float] NULL,
	[quantityonhand] [bigint] NULL,
	[salesdetails_accountcode] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[salesdetails_taxtype] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[salesdetails_unitprice] [float] NULL,
	[totalcostpool] [bigint] NULL,
	[updateddateutc] [datetime] NULL
) ON [FG_DATA_00] TEXTIMAGE_ON [FG_DATA_00]

GO
