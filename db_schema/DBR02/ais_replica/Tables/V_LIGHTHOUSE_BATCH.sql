USE [ais_replica]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[V_LIGHTHOUSE_BATCH](
	[LIGHT_ID] [int] NOT NULL,
	[LIGHT_NAME] [nvarchar](128) COLLATE SQL_Latin1_General_CP1_CI_AI NULL,
	[ALT1] [nvarchar](128) COLLATE SQL_Latin1_General_CP1_CI_AI NULL,
	[ALT2] [nvarchar](128) COLLATE SQL_Latin1_General_CP1_CI_AI NULL,
	[LOCATION] [nvarchar](128) COLLATE SQL_Latin1_General_CP1_CI_AI NULL,
	[COUNTRY] [varchar](2) COLLATE SQL_Latin1_General_CP1_CI_AI NULL,
	[TYPE] [int] NULL,
	[STRUCTURE] [nvarchar](256) COLLATE SQL_Latin1_General_CP1_CI_AI NULL,
	[STRUCTURE_COLOR] [nvarchar](64) COLLATE SQL_Latin1_General_CP1_CI_AI NULL,
	[DESCRIPTION] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AI NULL,
	[YEAR_BUILT] [smallint] NULL,
	[YEAR_INACTIVE] [smallint] NULL,
	[OPERATIONAL] [bit] NULL,
	[LON] [real] NULL,
	[LAT] [real] NULL,
	[HEIGHT_TOWER] [real] NULL,
	[HEIGHT_FOCAL] [real] NULL,
	[POWER] [int] NULL,
	[FLASHING] [varchar](3) COLLATE SQL_Latin1_General_CP1_CI_AI NULL,
	[NUMBER_FLASHES] [int] NULL,
	[INTERVAL] [real] NULL,
	[COLOR] [varchar](3) COLLATE SQL_Latin1_General_CP1_CI_AI NULL,
	[RANGE] [int] NULL,
	[ADMIRALTY] [varchar](10) COLLATE SQL_Latin1_General_CP1_CI_AI NULL,
	[ARLHS] [varchar](10) COLLATE SQL_Latin1_General_CP1_CI_AI NULL,
	[EMAIL] [varchar](128) COLLATE SQL_Latin1_General_CP1_CI_AI NULL,
	[TIMESTAMP] [smalldatetime] NULL,
	[LIGHT_TYPE_NAME] [varchar](30) COLLATE SQL_Latin1_General_CP1_CI_AI NULL,
	[LIGHT_FLASHING_NAME] [varchar](30) COLLATE SQL_Latin1_General_CP1_CI_AI NULL,
	[LIGHT_COLOR_NAME] [varchar](30) COLLATE SQL_Latin1_General_CP1_CI_AI NULL,
	[COUNT_PHOTOS] [int] NULL,
	[COUNTRY_NAME] [varchar](30) COLLATE SQL_Latin1_General_CP1_CI_AI NULL,
	[CHART_ABBREVIATION] [varchar](135) COLLATE SQL_Latin1_General_CP1_CI_AI NULL
) ON [FG01DT] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING ON

GO
CREATE CLUSTERED INDEX [clidx_VLIGHTHOUSEB_LIGHTID_1] ON [dbo].[V_LIGHTHOUSE_BATCH]
(
	[LIGHT_ID] ASC,
	[LIGHT_NAME] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [FG01DT]
GO
SET ANSI_PADDING ON

GO
CREATE NONCLUSTERED INDEX [idx_VLIGHTHOUSEB_LIGHT_NAME_1] ON [dbo].[V_LIGHTHOUSE_BATCH]
(
	[LIGHT_NAME] ASC,
	[ALT1] ASC,
	[ALT2] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idx_VLIGHTHOUSEB_LON_LAT_incl_1] ON [dbo].[V_LIGHTHOUSE_BATCH]
(
	[LON] ASC,
	[LAT] ASC
)
INCLUDE ( 	[LIGHT_ID],
	[RANGE]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
