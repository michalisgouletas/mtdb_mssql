USE [DBA_t01_00]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tmpx_CORE3379_V_POS_CLUSTERED](
	[SHIP_ID] [int] NOT NULL,
	[MMSI] [int] NULL,
	[STATUS] [tinyint] NULL,
	[SPEED] [smallint] NULL,
	[LON] [real] NULL,
	[LAT] [real] NULL,
	[COURSE] [smallint] NULL,
	[HEADING] [smallint] NULL,
	[TIMESTAMP] [smalldatetime] NULL,
	[SHIPNAME] [varchar](30) COLLATE SQL_Latin1_General_CP1_CI_AI NULL,
	[SHIPTYPE] [smallint] NULL,
	[LENGTH] [smallint] NULL,
	[WIDTH] [smallint] NULL,
	[DESTINATION] [varchar](20) COLLATE SQL_Latin1_General_CP1_CI_AI NULL,
	[FLAG] [varchar](2) COLLATE SQL_Latin1_General_CP1_CI_AI NULL,
	[TYPE_COLOR] [smallint] NULL,
	[AREA_ID] [smallint] NULL,
	[ELAPSED]  AS (datediff(minute,[TIMESTAMP],getutcdate())),
	[STATION] [smallint] NULL,
	[IS_COASTAL] [bit] NULL,
	[SAT_TIMESTAMP] [smalldatetime] NULL,
	[SAT_LAT] [real] NULL,
	[SAT_LON] [real] NULL,
	[SAT_SPEED] [smallint] NULL,
	[SAT_COURSE] [smallint] NULL,
	[SAT_HEADING] [smallint] NULL,
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
	[L_FORE] [smallint] NULL,
	[W_LEFT] [tinyint] NULL,
	[AREA_NAME] [varchar](20) COLLATE SQL_Latin1_General_CP1_CI_AI NULL,
	[SAT720_COURSE] [smallint] NULL,
	[ROT] [smallint] NULL,
	[TYPE_GROUPED_ID] [int] NULL,
	[DWT] [int] NULL,
	[GT_SHIPTYPE] [tinyint] NULL,
	[TERRSAT_TIMESTAMP] [smalldatetime] NULL,
	[TERRSAT_LAT] [real] NULL,
	[TERRSAT_LON] [real] NULL,
	[TERRSAT_SPEED] [smallint] NULL,
	[TERRSAT_COURSE] [smallint] NULL,
 CONSTRAINT [PK_V_POS_CLUSTERED21] PRIMARY KEY NONCLUSTERED 
(
	[SHIP_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
CREATE CLUSTERED INDEX [_dta_index_V_POS_CLUSTERED_c_8_1610488816__K15_K4_K5] ON [dbo].[tmpx_CORE3379_V_POS_CLUSTERED]
(
	[TERRSAT_LAT] ASC,
	[TERRSAT_LON] ASC,
	[AREA_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
