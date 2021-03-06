USE [zdk_blendo00]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[xerolineitems](
	[accountcode] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[blendo_imported_at] [bigint] NULL,
	[description] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[discountrate] [float] NULL,
	[invoiceid] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[itemcode] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[lineamount] [float] NULL,
	[lineitemid] [varchar](256) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[quantity] [float] NULL,
	[taxamount] [float] NULL,
	[taxtype] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[unitamount] [float] NULL
) ON [FG_DATA_00] TEXTIMAGE_ON [FG_DATA_00]

GO
