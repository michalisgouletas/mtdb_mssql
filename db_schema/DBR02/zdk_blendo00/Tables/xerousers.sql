USE [zdk_blendo00]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[xerousers](
	[blendo_imported_at] [bigint] NULL,
	[emailaddress] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[firstname] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[issubscriber] [bit] NULL,
	[lastname] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[organisationrole] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[updateddateutc] [datetime] NULL,
	[userid] [varchar](256) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [FG_DATA_00] TEXTIMAGE_ON [FG_DATA_00]

GO
