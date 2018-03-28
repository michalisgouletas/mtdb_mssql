USE [ais_replica]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[LAST_SEEN_SHIP](
	[SHIP_ID] [int] IDENTITY(1,1) NOT NULL,
	[MMSI] [int] NOT NULL,
	[IMO] [int] NOT NULL,
	[CALLSIGN] [varchar](7) COLLATE SQL_Latin1_General_CP1_CI_AI NOT NULL,
	[LON] [real] NULL,
	[LAT] [real] NULL,
	[AREA_ID] [smallint] NULL,
	[AREA_NAME] [varchar](20) COLLATE SQL_Latin1_General_CP1_CI_AI NULL,
	[PORT_NAME] [varchar](20) COLLATE SQL_Latin1_General_CP1_CI_AI NULL,
	[PORT_ID] [smallint] NULL,
	[TIMESTAMP] [datetime] NULL,
	[CONFIRMED] [bit] NULL,
	[SPEED] [smallint] NULL,
	[COURSE] [smallint] NULL,
	[STATUS] [tinyint] NULL,
	[STATION] [smallint] NULL,
	[HEADING] [smallint] NULL,
	[ROT] [smallint] NULL,
	[LAST_PORT_ID] [smallint] NULL,
	[LAST_PORT_TIMESTAMP] [smalldatetime] NULL,
	[PREVIOUS_PORT_ID] [smallint] NULL,
	[PREVIOUS_PORT_TIMESTAMP] [smalldatetime] NULL,
	[LAST_ARCHIVED] [smalldatetime] NULL,
	[LOCKED] [bit] NULL,
	[SAT_LON] [real] NULL,
	[SAT_LAT] [real] NULL,
	[SAT_AREA_ID] [smallint] NULL,
	[SAT_AREA_NAME] [varchar](20) COLLATE SQL_Latin1_General_CP1_CI_AI NULL,
	[SAT_PORT_NAME] [varchar](20) COLLATE SQL_Latin1_General_CP1_CI_AI NULL,
	[SAT_PORT_ID] [smallint] NULL,
	[SAT_TIMESTAMP] [smalldatetime] NULL,
	[SAT_SPEED] [smallint] NULL,
	[SAT_COURSE] [smallint] NULL,
	[SAT_STATUS] [tinyint] NULL,
	[SAT_HEADING] [smallint] NULL,
	[SAT_ROT] [smallint] NULL,
	[SAT_LAST_PORT_ID] [smallint] NULL,
	[SAT_LAST_PORT_TIMESTAMP] [smalldatetime] NULL,
	[SAT_IS_NEWER] [bit] NULL,
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
	[DRAUGHT] [tinyint] NULL,
	[INTRANSIT] [bit] NULL,
	[STOPPED] [bit] NULL,
	[LAST_ARCHIVED_HOURLY] [smalldatetime] NULL,
	[DIFF_LAT] [real] NULL,
	[DIFF_LON] [real] NULL,
	[DIFF_SPEED] [smallint] NULL,
	[DIFF_COURSE] [smallint] NULL,
	[SHIPNAME] [varchar](30) COLLATE SQL_Latin1_General_CP1_CI_AI NULL,
	[SHIPTYPE] [tinyint] NULL,
	[LENGTH] [smallint] NULL,
	[WIDTH] [tinyint] NULL,
	[ETA] [smalldatetime] NULL,
	[DESTINATION] [varchar](20) COLLATE SQL_Latin1_General_CP1_CI_AI NULL,
	[DESTINATION_ID] [smallint] NULL,
	[SHIP_TIMESTAMP] [datetime] NULL,
	[SHIP_CONFIRMED] [bit] NULL,
	[FLAG_CODE]  AS (case when [MMSI]>(0) AND [MMSI]<(9999999) then [MMSI]/(10000) when [MMSI]>(990000000) then ([MMSI]-(990000000))/(10000) when [MMSI]>(910000000) AND [MMSI]<(920000000) then ([MMSI]-(910000000))/(10000) when [MMSI]>(111000000) AND [MMSI]<(111999999) then ([MMSI]-(111000000))/(1000) when [MMSI]>(0) then [MMSI]/(1000000) when [LAST_MMSI] IS NOT NULL then [LAST_MMSI]/(1000000) else (0) end) PERSISTED,
	[TIMES_RCVD] [int] NULL,
	[SHIP_STATION] [smallint] NULL,
	[SHIP_IP] [varchar](15) COLLATE SQL_Latin1_General_CP1_CI_AI NULL,
	[SHIP_LOCKED] [bit] NULL,
	[LAST_MMSI] [int] NULL,
	[IMO_OLD] [int] NULL,
	[SAT_ETA] [smalldatetime] NULL,
	[SAT_DESTINATION] [varchar](20) COLLATE SQL_Latin1_General_CP1_CI_AI NULL,
	[SAT_SHIPTIME] [smalldatetime] NULL,
	[L_FORE] [smallint] NULL,
	[L_AFT] [smallint] NULL,
	[W_LEFT] [tinyint] NULL,
	[W_RIGHT] [tinyint] NULL,
	[SHIP_LAT] [real] NULL,
	[SHIP_LON] [real] NULL,
	[POS_TIMES_RCVD] [int] NULL,
 CONSTRAINT [PK_LAST_SEEN_TEST] PRIMARY KEY CLUSTERED 
(
	[MMSI] ASC,
	[IMO] ASC,
	[CALLSIGN] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
CREATE NONCLUSTERED INDEX [IMO] ON [dbo].[LAST_SEEN_SHIP]
(
	[IMO] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [SAT60_TIM] ON [dbo].[LAST_SEEN_SHIP]
(
	[SAT60_TIMESTAMP] DESC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [SHIP_ID] ON [dbo].[LAST_SEEN_SHIP]
(
	[SHIP_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [TIM] ON [dbo].[LAST_SEEN_SHIP]
(
	[TIMESTAMP] DESC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [dbo].[LAST_SEEN_SHIP] ADD  CONSTRAINT [DF_LAST_SEEN_TEST_IMO]  DEFAULT ((0)) FOR [IMO]
GO
ALTER TABLE [dbo].[LAST_SEEN_SHIP] ADD  CONSTRAINT [DF_LAST_SEEN_TEST_CALLSIGN]  DEFAULT ('-') FOR [CALLSIGN]
GO
ALTER TABLE [dbo].[LAST_SEEN_SHIP] ADD  CONSTRAINT [DF_LAST_SEEN_TEST_CONFIRMED1]  DEFAULT ((1)) FOR [SHIP_CONFIRMED]
GO
ALTER TABLE [dbo].[LAST_SEEN_SHIP] ADD  CONSTRAINT [DF_LAST_SEEN_TEST_TIMES_RCVD]  DEFAULT ((0)) FOR [TIMES_RCVD]
GO
ALTER TABLE [dbo].[LAST_SEEN_SHIP] ADD  CONSTRAINT [DF_LAST_SEEN_TEST_LOCKED1]  DEFAULT ((0)) FOR [SHIP_LOCKED]
GO
ALTER TABLE [dbo].[LAST_SEEN_SHIP] ADD  CONSTRAINT [DF_LAST_SEEN_SHIP_POS_TIMES_RCVD]  DEFAULT ((0)) FOR [POS_TIMES_RCVD]
GO
