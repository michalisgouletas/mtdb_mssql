USE [ais_replica]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PORTS](
	[PORT_ID] [smallint] IDENTITY(1,1) NOT NULL,
	[PORT_NAME] [varchar](20) COLLATE SQL_Latin1_General_CP1_CI_AI NULL,
	[SW_X] [real] NULL,
	[SW_Y] [real] NULL,
	[NE_X] [real] NULL,
	[NE_Y] [real] NULL,
	[ZOOM] [tinyint] NULL,
	[PORT_FORTH] [varchar](3) COLLATE SQL_Latin1_General_CP1_CI_AI NULL,
	[TIMEZONE] [real] NULL,
	[DST] [tinyint] NULL,
	[ALTNAME1] [varchar](20) COLLATE SQL_Latin1_General_CP1_CI_AI NULL,
	[ALTNAME2] [varchar](20) COLLATE SQL_Latin1_General_CP1_CI_AI NULL,
	[ALTNAME3] [varchar](20) COLLATE SQL_Latin1_General_CP1_CI_AI NULL,
	[ALTNAME4] [varchar](20) COLLATE SQL_Latin1_General_CP1_CI_AI NULL,
	[COUNTRY_CODE] [varchar](2) COLLATE SQL_Latin1_General_CP1_CI_AI NULL,
	[ENABLE_ETA] [bit] NULL,
	[CONFIRMED] [bit] NULL,
	[COVERAGE] [smalldatetime] NULL,
	[MARINASCOM_ID] [int] NULL,
	[ENABLE_CALLS] [bit] NULL,
	[UNLOCODE] [varchar](5) COLLATE SQL_Latin1_General_CP1_CI_AI NULL,
	[G_dstoffset] [int] NULL,
	[G_rawoffset] [int] NULL,
	[POLYGON] [geography] NULL,
	[PORT_TYPE] [varchar](1) COLLATE SQL_Latin1_General_CP1_CI_AI NULL,
	[PORT_SIZE] [varchar](1) COLLATE SQL_Latin1_General_CP1_CI_AI NULL,
	[CENTERX]  AS (([SW_X]+[NE_X])/(2.0)) PERSISTED,
	[CENTERY]  AS (([SW_Y]+[NE_Y])/(2.0)) PERSISTED,
	[RELATED_ANCH_ID] [smallint] NULL,
	[RELATED_PORT_ID] [smallint] NULL,
	[PORT_GEOTYPE] [tinyint] NULL,
	[MAX_LENGTH] [real] NULL,
	[MAX_BREADTH] [real] NULL,
	[MAX_DRAUGHT] [real] NULL,
	[PORT_AUTHORITY_ID] [int] NULL,
	[SHELTER] [varchar](1) COLLATE SQL_Latin1_General_CP1_CI_AI NULL,
	[PILOT_COMPULSORY] [bit] NULL,
	[PILOT_AVAILABLE] [bit] NULL,
	[TUGS_AVAILABLE] [bit] NULL,
	[REPAIRS_AVAILABLE] [varchar](1) COLLATE SQL_Latin1_General_CP1_CI_AI NULL,
	[DRYDOCK_AVAILABLE] [varchar](1) COLLATE SQL_Latin1_General_CP1_CI_AI NULL,
	[SUPER_PORT_ID] [smallint] NULL,
	[AREA_ID] [smallint] NULL,
	[AREA_CODE] [varchar](10) COLLATE SQL_Latin1_General_CP1_CI_AI NULL,
	[MOVING_SHIP_ID] [int] NULL,
	[ENABLE_INTRANSIT] [bit] NULL,
	[BUFFER_METERS] [smallint] NULL,
 CONSTRAINT [PK_PORTS_1] PRIMARY KEY CLUSTERED 
(
	[PORT_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [FG01DT]
) ON [FG01DT] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING ON

GO
CREATE NONCLUSTERED INDEX [ALT] ON [dbo].[PORTS]
(
	[ALTNAME1] ASC,
	[ALTNAME2] ASC,
	[ALTNAME3] ASC,
	[ALTNAME4] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ARITHABORT ON
SET CONCAT_NULL_YIELDS_NULL ON
SET QUOTED_IDENTIFIER ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON
SET NUMERIC_ROUNDABORT OFF

GO
CREATE NONCLUSTERED INDEX [centerXY] ON [dbo].[PORTS]
(
	[CENTERX] ASC,
	[CENTERY] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
CREATE NONCLUSTERED INDEX [confirmed] ON [dbo].[PORTS]
(
	[CONFIRMED] ASC,
	[PORT_TYPE] ASC
)
INCLUDE ( 	[PORT_ID],
	[SW_X],
	[SW_Y],
	[ALTNAME1],
	[ALTNAME2],
	[ALTNAME3],
	[ALTNAME4]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [coords] ON [dbo].[PORTS]
(
	[SW_X] ASC,
	[SW_Y] ASC,
	[NE_X] ASC,
	[NE_Y] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [MOVING_SHIP_ID_UNIQUE] ON [dbo].[PORTS]
(
	[MOVING_SHIP_ID] ASC
)
WHERE ([MOVING_SHIP_ID] IS NOT NULL)
WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
CREATE NONCLUSTERED INDEX [port forth] ON [dbo].[PORTS]
(
	[PORT_FORTH] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
CREATE NONCLUSTERED INDEX [port name] ON [dbo].[PORTS]
(
	[PORT_NAME] ASC,
	[PORT_TYPE] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [RELATED_ANCHORAGE_ID] ON [dbo].[PORTS]
(
	[RELATED_ANCH_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
CREATE NONCLUSTERED INDEX [unlocode] ON [dbo].[PORTS]
(
	[UNLOCODE] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [dbo].[PORTS] ADD  CONSTRAINT [DF_PORTS_ZOOM_1]  DEFAULT ((13)) FOR [ZOOM]
GO
ALTER TABLE [dbo].[PORTS] ADD  CONSTRAINT [DF_PORTS_TIMEZONE_1]  DEFAULT ((2)) FOR [TIMEZONE]
GO
ALTER TABLE [dbo].[PORTS] ADD  CONSTRAINT [DF_PORTS_DST_1]  DEFAULT ((1)) FOR [DST]
GO
ALTER TABLE [dbo].[PORTS] ADD  CONSTRAINT [DF_PORTS_COUNTRY_CODE_1]  DEFAULT ('GR') FOR [COUNTRY_CODE]
GO
ALTER TABLE [dbo].[PORTS] ADD  CONSTRAINT [DF_PORTS_ENABLE_ETA_1]  DEFAULT ((0)) FOR [ENABLE_ETA]
GO
ALTER TABLE [dbo].[PORTS] ADD  CONSTRAINT [DF_PORTS_CONFIRMED_1]  DEFAULT ((0)) FOR [CONFIRMED]
GO
ALTER TABLE [dbo].[PORTS] ADD  CONSTRAINT [DF_PORTS_ENABLE_CALLS_1]  DEFAULT ((0)) FOR [ENABLE_CALLS]
GO
ALTER TABLE [dbo].[PORTS] ADD  CONSTRAINT [DF_PORTS_PORT_TYPE_1]  DEFAULT ('P') FOR [PORT_TYPE]
GO
ALTER TABLE [dbo].[PORTS] ADD  CONSTRAINT [DF_PORTS_PORT_SIZE_1]  DEFAULT ('S') FOR [PORT_SIZE]
GO
ALTER TABLE [dbo].[PORTS] ADD  CONSTRAINT [DF_PORTS_ENABLE_INTRANSIT_1]  DEFAULT ((1)) FOR [ENABLE_INTRANSIT]
GO
ALTER TABLE [dbo].[PORTS] ADD  CONSTRAINT [DF_PORTS_BUFFER_METERS]  DEFAULT ((500)) FOR [BUFFER_METERS]
GO
SET ARITHABORT ON
SET CONCAT_NULL_YIELDS_NULL ON
SET QUOTED_IDENTIFIER ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON
SET NUMERIC_ROUNDABORT OFF

GO
CREATE SPATIAL INDEX [polygon] ON [dbo].[PORTS]
(
	[POLYGON]
)USING  GEOGRAPHY_GRID 
WITH (GRIDS =(LEVEL_1 = MEDIUM,LEVEL_2 = MEDIUM,LEVEL_3 = MEDIUM,LEVEL_4 = MEDIUM), 
CELLS_PER_OBJECT = 8, PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [FG01DT]
GO
