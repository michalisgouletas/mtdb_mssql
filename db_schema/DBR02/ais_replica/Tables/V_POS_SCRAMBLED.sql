USE [ais_replica]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[V_POS_SCRAMBLED](
	[SHIP_ID] [int] NOT NULL,
	[MMSI] [int] NULL,
	[STATUS] [tinyint] NULL,
	[SPEED] [smallint] NULL,
	[LON] [real] NULL,
	[LAT] [real] NULL,
	[COURSE] [smallint] NULL,
	[HEADING] [smallint] NULL,
	[TIMESTAMP] [datetime] NULL,
	[SHIPNAME] [varchar](30) COLLATE SQL_Latin1_General_CP1_CI_AI NULL,
	[SHIPTYPE] [smallint] NULL,
	[LENGTH] [smallint] NULL,
	[WIDTH] [smallint] NULL,
	[DESTINATION] [varchar](20) COLLATE SQL_Latin1_General_CP1_CI_AI NULL,
	[FLAG] [varchar](2) COLLATE SQL_Latin1_General_CP1_CI_AI NULL,
	[TYPE_COLOR] [smallint] NULL,
	[AREA_ID] [smallint] NULL,
	[ELAPSED] [int] NULL,
	[STATION] [smallint] NULL,
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
	[L_FORE] [smallint] NULL,
	[W_LEFT] [tinyint] NULL,
	[IMO] [int] NULL,
	[CALLSIGN] [varchar](7) COLLATE SQL_Latin1_General_CP1_CI_AI NULL,
	[ETA] [smalldatetime] NULL,
	[DRAUGHT] [tinyint] NULL,
	[SHIPTYPE_FULL] [tinyint] NULL,
	[PORT_ID] [smallint] NULL,
	[AREA_ID_ALL] [smallint] NULL,
	[PORT_NAME] [varchar](20) COLLATE SQL_Latin1_General_CP1_CI_AI NULL,
	[AREA_NAME] [varchar](20) COLLATE SQL_Latin1_General_CP1_CI_AI NULL,
	[COUNT_PHOTOS] [smallint] NULL,
	[SHIPTIME] [smalldatetime] NULL,
	[ROT] [smallint] NULL,
	[GT_SHIPTYPE] [tinyint] NULL,
	[TYPE_GROUPED_ID] [int] NULL,
	[DWT] [int] NULL,
	[AIS_SECONDS] [tinyint] NULL
) ON [FG01DT]

GO
CREATE NONCLUSTERED INDEX [LON_LAT] ON [dbo].[V_POS_SCRAMBLED]
(
	[LON] ASC,
	[LAT] ASC,
	[TYPE_GROUPED_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [TIME] ON [dbo].[V_POS_SCRAMBLED]
(
	[TIMESTAMP] DESC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
