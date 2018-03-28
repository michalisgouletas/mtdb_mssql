USE [ais_replica]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PORTS_CURRENT_BATCH](
	[SHIPCOUNT] [int] NULL,
	[PORT_ID] [smallint] NOT NULL,
	[PORT_NAME] [varchar](20) COLLATE SQL_Latin1_General_CP1_CI_AI NULL,
	[SW_X] [real] NULL,
	[SW_Y] [real] NULL,
	[NE_X] [real] NULL,
	[NE_Y] [real] NULL,
	[CENTERX] [real] NULL,
	[CENTERY] [real] NULL,
	[DEPARTCOUNT] [int] NULL,
	[ARRIVECOUNT] [int] NULL,
	[EXPECTEDCOUNT] [int] NULL,
	[ZOOM] [tinyint] NULL,
	[COUNT_PHOTOS] [int] NULL,
	[COUNTRY_CODE] [varchar](2) COLLATE SQL_Latin1_General_CP1_CI_AI NULL,
	[COUNTRY] [varchar](30) COLLATE SQL_Latin1_General_CP1_CI_AI NULL,
	[ALTNAME1] [varchar](20) COLLATE SQL_Latin1_General_CP1_CI_AI NULL,
	[ALTNAME2] [varchar](20) COLLATE SQL_Latin1_General_CP1_CI_AI NULL,
	[ALTNAME3] [varchar](20) COLLATE SQL_Latin1_General_CP1_CI_AI NULL,
	[ALTNAME4] [varchar](20) COLLATE SQL_Latin1_General_CP1_CI_AI NULL,
	[PORT_TYPE] [varchar](10) COLLATE SQL_Latin1_General_CP1_CI_AI NULL,
	[ENABLE_CALLS] [bit] NULL,
	[COVERAGE] [smalldatetime] NULL,
	[UNLOCODE] [varchar](5) COLLATE SQL_Latin1_General_CP1_CI_AI NULL,
	[CURRENT_TIME] [smalldatetime] NULL,
	[CURRENT_OFFSET] [real] NULL,
	[PORT_SIZE] [varchar](1) COLLATE SQL_Latin1_General_CP1_CI_AI NULL,
	[AREA_ID] [smallint] NULL,
	[AREA_CODE] [varchar](10) COLLATE SQL_Latin1_General_CP1_CI_AI NULL,
	[RELATED_ANCH_ID] [smallint] NULL,
	[RELATED_ANCH_NAME] [varchar](20) COLLATE SQL_Latin1_General_CP1_CI_AI NULL,
	[RELATED_PORT_ID] [smallint] NULL,
	[RELATED_PORT_NAME] [varchar](20) COLLATE SQL_Latin1_General_CP1_CI_AI NULL,
	[AREA_NAME] [varchar](30) COLLATE SQL_Latin1_General_CP1_CI_AI NULL,
	[AREA_CODE_NAME] [varchar](30) COLLATE SQL_Latin1_General_CP1_CI_AI NULL,
 CONSTRAINT [PK_PORTS_CURRENT_TEMP] PRIMARY KEY CLUSTERED 
(
	[PORT_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [FG01DT]
) ON [FG01DT]

GO
SET ANSI_PADDING ON

GO
CREATE NONCLUSTERED INDEX [ALTNAMES] ON [dbo].[PORTS_CURRENT_BATCH]
(
	[ALTNAME1] ASC,
	[ALTNAME2] ASC,
	[ALTNAME3] ASC,
	[ALTNAME4] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
CREATE NONCLUSTERED INDEX [NAME] ON [dbo].[PORTS_CURRENT_BATCH]
(
	[PORT_NAME] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
