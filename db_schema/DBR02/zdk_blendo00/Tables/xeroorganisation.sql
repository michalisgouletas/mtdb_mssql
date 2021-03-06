USE [zdk_blendo00]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[xeroorganisation](
	[addresses_addressline1] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[addresses_addressline2] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[addresses_addresstype] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[addresses_attentionto] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[addresses_city] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[addresses_country] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[addresses_postalcode] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[addresses_region] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[apikey] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[basecurrency] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[blendo_imported_at] [bigint] NULL,
	[countrycode] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[createddateutc] [datetime] NULL,
	[defaultpurchasestax] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[defaultsalestax] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[externallinks_linktype] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[externallinks_url] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[financialyearendday] [bigint] NULL,
	[financialyearendmonth] [bigint] NULL,
	[isdemocompany] [bit] NULL,
	[legalname] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[lineofbusiness] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[name] [varchar](256) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[organisationentitytype] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[organisationid] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[organisationstatus] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[organisationtype] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[paymentterms_sales_day] [bigint] NULL,
	[paymentterms_sales_type] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[paystax] [bit] NULL,
	[periodlockdate] [datetime] NULL,
	[phones_phoneareacode] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[phones_phonenumber] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[phones_phonetype] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[salestaxbasis] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[salestaxperiod] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[shortcode] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[taxnumber] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[timezone] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[version] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [FG_DATA_00] TEXTIMAGE_ON [FG_DATA_00]

GO
