USE [zdk_blendo00]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[xerotaxrates](
	[blendo_imported_at] [bigint] NULL,
	[canapplytoassets] [bit] NULL,
	[canapplytoequity] [bit] NULL,
	[canapplytoexpenses] [bit] NULL,
	[canapplytoliabilities] [bit] NULL,
	[canapplytorevenue] [bit] NULL,
	[displaytaxrate] [float] NULL,
	[effectiverate] [float] NULL,
	[name] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[reporttaxtype] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[status] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[taxcomponents_iscompound] [bit] NULL,
	[taxcomponents_isnonrecoverable] [bit] NULL,
	[taxcomponents_name] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[taxcomponents_rate] [float] NULL,
	[taxtype] [varchar](256) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [FG_DATA_00] TEXTIMAGE_ON [FG_DATA_00]

GO
