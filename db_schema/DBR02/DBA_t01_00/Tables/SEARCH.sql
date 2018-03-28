USE [DBA_t01_00]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SEARCH](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[KEYWORD] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AI NULL,
	[INFO] [varchar](60) COLLATE SQL_Latin1_General_CP1_CI_AI NULL,
	[TYPE] [varchar](15) COLLATE SQL_Latin1_General_CP1_CI_AI NULL,
	[ITEM_ID] [int] NULL,
	[SHIP_ID] [int] NULL,
	[TYPE_ID] [tinyint] NULL,
	[RANK] [int] NULL,
	[TYPE_COLOR] [tinyint] NULL,
	[LAT] [real] NULL,
	[LON] [real] NULL,
 CONSTRAINT [PK_SEARCH_TEMP] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING ON

GO
CREATE NONCLUSTERED INDEX [IX_SEARCH] ON [dbo].[SEARCH]
(
	[KEYWORD] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
CREATE NONCLUSTERED INDEX [TYPE] ON [dbo].[SEARCH]
(
	[TYPE] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
