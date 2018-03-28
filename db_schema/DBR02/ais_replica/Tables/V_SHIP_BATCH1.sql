USE [ais_replica]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[V_SHIP_BATCH1](
	[SHIP_ID] [int] NOT NULL,
	[MMSI] [int] NULL,
	[IMO] [int] NULL,
	[CALLSIGN] [varchar](7) COLLATE SQL_Latin1_General_CP1_CI_AI NULL,
	[SHIPNAME] [varchar](30) COLLATE SQL_Latin1_General_CP1_CI_AI NULL,
	[TIMESTAMP] [datetime] NULL,
	[PORT_ID] [smallint] NULL,
	[CURRENT_PORT] [varchar](20) COLLATE SQL_Latin1_General_CP1_CI_AI NULL,
	[CURRENT_PORT_COUNTRY] [varchar](2) COLLATE SQL_Latin1_General_CP1_CI_AI NULL,
	[TYPE_NAME] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AI NULL,
	[COUNTRY] [varchar](30) COLLATE SQL_Latin1_General_CP1_CI_AI NULL,
	[LAST_PORT_ID] [smallint] NULL,
	[LAST_PORT] [varchar](20) COLLATE SQL_Latin1_General_CP1_CI_AI NULL,
	[LAST_PORT_TIME] [smalldatetime] NULL,
	[LAST_PORT_COUNTRY] [varchar](2) COLLATE SQL_Latin1_General_CP1_CI_AI NULL,
	[PREVIOUS_PORT_ID] [smallint] NULL,
	[PREVIOUS_PORT] [varchar](30) COLLATE SQL_Latin1_General_CP1_CI_AI NULL,
	[PREVIOUS_PORT_TIME] [smalldatetime] NULL,
	[PREVIOUS_PORT_COUNTRY] [varchar](2) COLLATE SQL_Latin1_General_CP1_CI_AI NULL,
	[LON] [real] NULL,
	[LAT] [real] NULL,
	[ETA] [smalldatetime] NULL,
	[DRAUGHT] [tinyint] NULL,
	[DESTINATION] [varchar](20) COLLATE SQL_Latin1_General_CP1_CI_AI NULL,
	[SHIPTIME] [smalldatetime] NULL,
	[LENGTH] [real] NULL,
	[WIDTH] [real] NULL,
	[CODE2] [varchar](2) COLLATE SQL_Latin1_General_CP1_CI_AI NULL,
	[COUNT_PHOTOS] [int] NULL,
	[SHIPTYPE] [tinyint] NULL,
	[TYPE_COLOR] [tinyint] NULL,
	[MAXSPEED] [real] NULL,
	[AVGSPEED] [real] NULL,
	[TYPE_SUMMARY] [varchar](30) COLLATE SQL_Latin1_General_CP1_CI_AI NULL,
	[LAST_POS] [datetime] NULL,
	[DWT] [int] NULL,
	[YOB] [smallint] NULL,
	[AREA_ID] [smallint] NULL,
	[AREA_NAME] [varchar](30) COLLATE SQL_Latin1_General_CP1_CI_AI NULL,
	[COURSE] [smallint] NULL,
	[HEADING] [smallint] NULL,
	[STATUS_AIS] [tinyint] NULL,
	[ROT] [smallint] NULL,
	[SPEED] [smallint] NULL,
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[GRT] [int] NULL,
	[STATUS] [varchar](20) COLLATE SQL_Latin1_General_CP1_CI_AI NULL,
	[STATION] [smallint] NULL,
	[SAT_LON] [real] NULL,
	[SAT_LAT] [real] NULL,
	[SAT_AREA_ID] [smallint] NULL,
	[SAT_AREA_NAME] [varchar](30) COLLATE SQL_Latin1_General_CP1_CI_AI NULL,
	[SAT_PORT_NAME] [varchar](20) COLLATE SQL_Latin1_General_CP1_CI_AI NULL,
	[SAT_PORT_ID] [smallint] NULL,
	[SAT_TIMESTAMP] [smalldatetime] NULL,
	[SAT_LAST_POS] [smalldatetime] NULL,
	[SAT_SPEED] [smallint] NULL,
	[SAT_COURSE] [smallint] NULL,
	[SAT_HEADING] [smallint] NULL,
	[SAT_LAST_PORT_ID] [smallint] NULL,
	[SAT_LAST_PORT_TIMESTAMP] [smalldatetime] NULL,
	[SAT_IS_NEWER] [bit] NULL,
	[SAT_LAST_PORT_NAME] [varchar](30) COLLATE SQL_Latin1_General_CP1_CI_AI NULL,
	[SAT_LAST_PORT_ZOOM] [tinyint] NULL,
	[SAT_LAST_PORT_COUNTRY] [varchar](2) COLLATE SQL_Latin1_General_CP1_CI_AI NULL,
	[IS_COASTAL] [bit] NULL,
	[SAT60_TIMESTAMP] [smalldatetime] NULL,
	[SAT60_LAT] [real] NULL,
	[SAT60_LON] [real] NULL,
	[SAT60_SPEED] [smallint] NULL,
	[SAT60_COURSE] [smallint] NULL,
	[SAT360_TIMESTAMP] [smalldatetime] NULL,
	[SAT360_LAT] [real] NULL,
	[SAT360_LON] [real] NULL,
	[SAT360_SPEED] [smallint] NULL,
	[SAT360_COURSE] [smallint] NULL,
	[SAT720_TIMESTAMP] [smalldatetime] NULL,
	[SAT720_LAT] [real] NULL,
	[SAT720_LON] [real] NULL,
	[SAT720_SPEED] [smallint] NULL,
	[SAT720_COURSE] [smallint] NULL,
	[OPERATOR] [varchar](30) COLLATE SQL_Latin1_General_CP1_CI_AI NULL,
	[SAT_ETA] [smalldatetime] NULL,
	[SAT_DESTINATION] [varchar](20) COLLATE SQL_Latin1_General_CP1_CI_AI NULL,
	[SAT_SHIPTIME] [smalldatetime] NULL,
	[BUILDER_ID] [int] NULL,
	[MANAGER_ID] [int] NULL,
	[OWNER_ID] [int] NULL,
	[NEXT_PORT_ID] [int] NULL,
	[NEXT_PORT_NAME] [varchar](30) COLLATE SQL_Latin1_General_CP1_CI_AI NULL,
	[NEXT_PORT_COUNTRY] [varchar](2) COLLATE SQL_Latin1_General_CP1_CI_AI NULL,
	[STATUS_NAME] [varchar](30) COLLATE SQL_Latin1_General_CP1_CI_AI NULL,
	[AIS_SHIPNAME] [varchar](30) COLLATE SQL_Latin1_General_CP1_CI_AI NULL,
	[ETA_CALC] [smalldatetime] NULL,
	[ETA_UPDATED] [smalldatetime] NULL,
	[DISTANCE_TO_GO] [smallint] NULL,
	[SUEZ] [bit] NULL,
	[PANAMA] [bit] NULL,
	[SAT_ETA_CALC] [smalldatetime] NULL,
	[SAT_ETA_UPDATED] [smalldatetime] NULL,
	[SAT_DISTANCE_TO_GO] [smallint] NULL,
	[SAT_SUEZ] [bit] NULL,
	[SAT_PANAMA] [bit] NULL,
	[NEXT_PORT_UNLOCODE] [varchar](5) COLLATE SQL_Latin1_General_CP1_CI_AI NULL,
	[CURRENT_PORT_UNLOCODE] [varchar](5) COLLATE SQL_Latin1_General_CP1_CI_AI NULL,
	[LAST_PORT_UNLOCODE] [varchar](5) COLLATE SQL_Latin1_General_CP1_CI_AI NULL,
	[PREVIOUS_PORT_UNLOCODE] [varchar](5) COLLATE SQL_Latin1_General_CP1_CI_AI NULL,
	[GT_SHIPTYPE] [smallint] NULL,
	[DISTANCE_TRAVELLED] [int] NULL,
	[SAT_DISTANCE_TRAVELLED] [int] NULL,
	[TYPE_GROUPED_ID] [int] NULL,
	[AIS_SECONDS] [tinyint] NULL,
	[RELATED_PORT_ID] [smallint] NULL,
	[DRAUGHT_MIN] [tinyint] NULL,
	[DRAUGHT_MAX] [tinyint] NULL,
	[SPEED_CALC] [smallint] NULL,
	[SAT_SPEED_CALC] [smallint] NULL,
	[CURRENT_PORT_TIMESTAMP] [smalldatetime] NULL,
	[SAT_CURRENT_PORT_TIMESTAMP] [smalldatetime] NULL,
	[INLAND_ENI] [int] NULL,
	[AREA_CODE] [varchar](10) COLLATE SQL_Latin1_General_CP1_CI_AI NULL,
	[SAT_AREA_CODE] [varchar](10) COLLATE SQL_Latin1_General_CP1_CI_AI NULL,
	[LOAD_STATUS_ID] [tinyint] NULL,
	[LOAD_STATUS_NAME] [varchar](15) COLLATE SQL_Latin1_General_CP1_CI_AI NULL,
	[TIMEZONE] [real] NULL,
	[WIND_ANGLE] [smallint] NULL,
	[WIND_SPEED] [tinyint] NULL,
	[WIND_TEMP] [smallint] NULL,
	[L_FORE] [smallint] NULL,
	[W_LEFT] [tinyint] NULL,
	[TERRSAT_TIMESTAMP] [smalldatetime] NULL,
	[TERRSAT_LAT] [real] NULL,
	[TERRSAT_LON] [real] NULL,
	[TEU] [int] NULL,
	[LIQUID_GAS] [int] NULL,
	[STATION_SHOW] [bit] NULL,
	[DEP_TIME] [smalldatetime] NULL,
	[SEARCH_RANK] [int] NULL,
	[TERRSAT_SPEED] [smallint] NULL,
	[CURRENT_PORT_OFFSET] [smallint] NULL,
	[LAST_PORT_OFFSET] [smallint] NULL,
	[PREVIOUS_PORT_OFFSET] [smallint] NULL,
	[ETA_OFFSET] [smallint] NULL,
	[ETA_CALC_OFFSET] [smallint] NULL,
	[BIT_FLAGS] [tinyint] NOT NULL,
	[VOYAGE_IDLE_TIME_SECS] [int] NULL,
	[FIRST_POS_TIMESTAMP] [smalldatetime] NULL,
	[LAST_UNDERWAY_TIMESTAMP] [smalldatetime] NULL,
	[BERTH_ID] [int] NULL,
	[TERMINAL_ID] [int] NULL,
	[COMFLEET_GROUPEDTYPE] [varchar](20) COLLATE SQL_Latin1_General_CP1_CI_AI NULL,
	[SHIP_CLASS_NAME] [varchar](15) COLLATE SQL_Latin1_General_CP1_CI_AI NULL,
	[INVALID_MMSI] [bit] NULL,
	[INVALID_CALLSIGN] [bit] NULL,
	[MISMATCHED_MMSI_CALL] [bit] NULL,
	[INVALID] [bit] NULL,
	[INVALID_DIMENSIONS] [bit] NULL,
	[INVALID_SHIPNAME] [bit] NULL,
 CONSTRAINT [PK_VSHIPBATCH1_SHIPID] PRIMARY KEY CLUSTERED 
(
	[SHIP_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [FG01DT]
) ON [FG01DT]

GO
SET ANSI_PADDING ON

GO
CREATE NONCLUSTERED INDEX [callsign] ON [dbo].[V_SHIP_BATCH1]
(
	[CALLSIGN] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
CREATE NONCLUSTERED INDEX [CURRENT_PORT_UNLOCODE] ON [dbo].[V_SHIP_BATCH1]
(
	[CURRENT_PORT_UNLOCODE] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
CREATE NONCLUSTERED INDEX [destination] ON [dbo].[V_SHIP_BATCH1]
(
	[DESTINATION] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [imo] ON [dbo].[V_SHIP_BATCH1]
(
	[IMO] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [last_pos] ON [dbo].[V_SHIP_BATCH1]
(
	[LAST_POS] DESC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [lat_lon_tim] ON [dbo].[V_SHIP_BATCH1]
(
	[LAT] ASC,
	[LON] ASC,
	[LAST_POS] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [mmsi] ON [dbo].[V_SHIP_BATCH1]
(
	[MMSI] ASC,
	[SHIPTIME] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
CREATE NONCLUSTERED INDEX [NEXT_PORT_UNLOCODE] ON [dbo].[V_SHIP_BATCH1]
(
	[NEXT_PORT_UNLOCODE] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [PHOTO_COUNT] ON [dbo].[V_SHIP_BATCH1]
(
	[COUNT_PHOTOS] DESC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [sat_lat_lon_tim] ON [dbo].[V_SHIP_BATCH1]
(
	[SAT_TIMESTAMP] ASC,
	[SAT_LAT] ASC,
	[SAT_LON] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [sat60_lat_lon_tim] ON [dbo].[V_SHIP_BATCH1]
(
	[SAT60_TIMESTAMP] ASC,
	[SAT60_LAT] ASC,
	[SAT60_LON] ASC,
	[IS_COASTAL] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
CREATE NONCLUSTERED INDEX [shipname] ON [dbo].[V_SHIP_BATCH1]
(
	[SHIPNAME] ASC,
	[STATUS] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
CREATE NONCLUSTERED INDEX [STATUS] ON [dbo].[V_SHIP_BATCH1]
(
	[STATUS] ASC,
	[STATION] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [TERRSAT_LAT_LON_TIM] ON [dbo].[V_SHIP_BATCH1]
(
	[TERRSAT_LAT] ASC,
	[TERRSAT_LON] ASC,
	[TERRSAT_TIMESTAMP] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [timestamp] ON [dbo].[V_SHIP_BATCH1]
(
	[TIMESTAMP] DESC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [type_color] ON [dbo].[V_SHIP_BATCH1]
(
	[TYPE_COLOR] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [dbo].[V_SHIP_BATCH1] ADD  CONSTRAINT [DF_VSHIPBATCH1_SEARCH_RANK]  DEFAULT ((0)) FOR [SEARCH_RANK]
GO
ALTER TABLE [dbo].[V_SHIP_BATCH1] ADD  CONSTRAINT [DF_VSHIPBATCH1_BIT_F]  DEFAULT ((0)) FOR [BIT_FLAGS]
GO
ALTER TABLE [dbo].[V_SHIP_BATCH1] ADD  CONSTRAINT [DF_V_SHIP_BATCH1_INVALID_MMSI]  DEFAULT ((0)) FOR [INVALID_MMSI]
GO
ALTER TABLE [dbo].[V_SHIP_BATCH1] ADD  CONSTRAINT [DF_V_SHIP_BATCH1_INVALID_CALLSIGN]  DEFAULT ((0)) FOR [INVALID_CALLSIGN]
GO
ALTER TABLE [dbo].[V_SHIP_BATCH1] ADD  CONSTRAINT [DF_V_SHIP_BATCH1_MISMATCHED_MMSI_CALL]  DEFAULT ((0)) FOR [MISMATCHED_MMSI_CALL]
GO
ALTER TABLE [dbo].[V_SHIP_BATCH1] ADD  CONSTRAINT [DF_V_SHIP_BATCH1_INVALID]  DEFAULT ((0)) FOR [INVALID]
GO
ALTER TABLE [dbo].[V_SHIP_BATCH1] ADD  CONSTRAINT [DF_V_SHIP_BATCH1_INVALID_DIMENSIONS]  DEFAULT ((0)) FOR [INVALID_DIMENSIONS]
GO
ALTER TABLE [dbo].[V_SHIP_BATCH1] ADD  CONSTRAINT [DF_V_SHIP_BATCH1_INVALID_SHIPNAME]  DEFAULT ((0)) FOR [INVALID_SHIPNAME]
GO
