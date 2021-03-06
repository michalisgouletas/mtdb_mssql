USE [zdk_blendo00]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[xerotrackingcategories](
	[blendo_imported_at] [bigint] NULL,
	[name] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[options_hasvalidationerrors] [bit] NULL,
	[options_isactive] [bit] NULL,
	[options_isarchived] [bit] NULL,
	[options_isdeleted] [bit] NULL,
	[options_name] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[options_status] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[options_trackingoptionid] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[status] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[trackingcategoryid] [varchar](256) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [FG_DATA_00] TEXTIMAGE_ON [FG_DATA_00]

GO
