USE [ais_replica]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[V_POS_SAT_TEMP](
	[SHIP_ID] [int] NOT NULL,
	[MMSI] [int] NOT NULL,
	[SHIPNAME] [varchar](30) COLLATE SQL_Latin1_General_CP1_CI_AI NULL,
	[SHIPTYPE] [int] NULL,
	[LENGTH] [smallint] NULL,
	[WIDTH] [tinyint] NULL,
	[DESTINATION] [varchar](20) COLLATE SQL_Latin1_General_CP1_CI_AI NULL,
	[FLAG] [varchar](2) COLLATE SQL_Latin1_General_CP1_CI_AI NULL,
	[TYPE_COLOR] [int] NULL,
	[STATION] [int] NULL,
	[SAT_TIMESTAMP] [smalldatetime] NULL,
	[SAT_LAT] [real] NULL,
	[SAT_LON] [real] NULL,
	[SAT_SPEED] [smallint] NULL,
	[SAT_COURSE] [smallint] NULL,
	[SAT_HEADING] [smallint] NULL,
	[SAT_STATUS] [tinyint] NULL,
	[SAT_ROT] [smallint] NULL,
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
	[SHIPTYPE_FULL] [int] NULL,
	[ETA] [smalldatetime] NULL,
	[DRAUGHT] [tinyint] NULL,
	[SAT_PORT_ID] [smallint] NULL,
	[SAT_PORT_NAME] [varchar](20) COLLATE SQL_Latin1_General_CP1_CI_AI NULL,
	[SAT_AREA_ID] [smallint] NULL,
	[SAT_AREA_NAME] [varchar](30) COLLATE SQL_Latin1_General_CP1_CI_AI NULL,
	[COUNT_PHOTOS] [int] NULL,
	[GT_SHIPTYPE] [tinyint] NULL,
	[TYPE_GROUPED_ID] [int] NULL,
	[DWT] [int] NULL,
 CONSTRAINT [PK_V_POS_SAT_TEMP] PRIMARY KEY CLUSTERED 
(
	[SHIP_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [FG01DT]
) ON [FG01DT]

GO
CREATE NONCLUSTERED INDEX [MMSI] ON [dbo].[V_POS_SAT_TEMP]
(
	[MMSI] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [SAT360_LON_LAT] ON [dbo].[V_POS_SAT_TEMP]
(
	[SAT360_LON] ASC,
	[SAT360_LAT] ASC,
	[LENGTH] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [SAT720_LON_LAT] ON [dbo].[V_POS_SAT_TEMP]
(
	[SAT720_LON] ASC,
	[SAT720_LAT] ASC,
	[LENGTH] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
