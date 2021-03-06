USE [zdk_blendo00]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[xerocontactgroups](
	[blendo_imported_at] [bigint] NULL,
	[contactgroupid] [varchar](256) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[hasvalidationerrors] [bit] NULL,
	[name] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[status] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [FG_DATA_00] TEXTIMAGE_ON [FG_DATA_00]

GO
