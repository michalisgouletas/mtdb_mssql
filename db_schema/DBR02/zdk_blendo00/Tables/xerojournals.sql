USE [zdk_blendo00]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[xerojournals](
	[blendo_imported_at] [bigint] NULL,
	[createddateutc] [datetime] NULL,
	[journaldate] [datetime] NULL,
	[journalid] [varchar](256) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[journallines_accountcode] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[journallines_accountid] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[journallines_accountname] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[journallines_accounttype] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[journallines_description] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[journallines_grossamount] [float] NULL,
	[journallines_journallineid] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[journallines_netamount] [float] NULL,
	[journallines_taxamount] [bigint] NULL,
	[journallines_taxname] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[journallines_taxtype] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[journallines_trackingcategories_name] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[journallines_trackingcategories_option] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[journallines_trackingcategories_trackingcategoryid] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[journallines_trackingcategories_trackingoptionid] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[journalnumber] [bigint] NULL,
	[reference] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[sourceid] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[sourcetype] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [FG_DATA_00] TEXTIMAGE_ON [FG_DATA_00]

GO
