USE [zdk_blendo00]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[xerocreditnoteslineitems](
	[accountcode] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[blendo_id] [varchar](256) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[blendo_imported_at] [bigint] NULL,
	[creditnoteid] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[description] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[itemcode] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[lineamount] [float] NULL,
	[quantity] [float] NULL,
	[taxamount] [float] NULL,
	[taxtype] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[tracking_name] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[tracking_option] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[tracking_trackingcategoryid] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[tracking_trackingoptionid] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[unitamount] [float] NULL
) ON [FG_DATA_00] TEXTIMAGE_ON [FG_DATA_00]

GO
