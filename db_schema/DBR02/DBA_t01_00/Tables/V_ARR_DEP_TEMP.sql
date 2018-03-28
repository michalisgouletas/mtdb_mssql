USE [DBA_t01_00]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[V_ARR_DEP_TEMP](
	[SHIPNAME] [varchar](30) COLLATE SQL_Latin1_General_CP1_CI_AI NULL,
	[PORT_NAME] [varchar](20) COLLATE SQL_Latin1_General_CP1_CI_AI NULL,
	[COUNTRY_CODE] [varchar](2) COLLATE SQL_Latin1_General_CP1_CI_AI NULL,
	[CENTERX] [real] NULL,
	[CENTERY] [real] NULL,
	[ZOOM] [tinyint] NULL,
	[MMSI] [int] NULL,
	[PORT_ID] [smallint] NULL,
	[TIMEZONE] [real] NULL,
	[ARRIVAL] [smalldatetime] NULL,
	[DEPARTURE] [smalldatetime] NULL,
	[ARR_DEP_SORT] [smalldatetime] NULL,
	[ARRIVAL_UTC] [smalldatetime] NULL,
	[DEPARTURE_UTC] [smalldatetime] NULL,
	[INTRANSIT] [bit] NULL,
	[TYPE_COLOR] [tinyint] NULL,
	[SHIP_ID] [int] NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING ON

GO
CREATE NONCLUSTERED INDEX [_dta_index_V_ARR_DEP_BATCH_8_1145771139__K6_K10_1_2_3_4_5_7_8_9] ON [dbo].[V_ARR_DEP_TEMP]
(
	[MMSI] ASC,
	[ARR_DEP_SORT] ASC
)
INCLUDE ( 	[SHIPNAME],
	[PORT_NAME],
	[CENTERX],
	[CENTERY],
	[ZOOM],
	[PORT_ID],
	[ARRIVAL],
	[DEPARTURE]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
CREATE NONCLUSTERED INDEX [_dta_index_V_ARR_DEP_BATCH_8_1145771139__K7_K10_1_2_3_4_5_6_8_9] ON [dbo].[V_ARR_DEP_TEMP]
(
	[PORT_ID] ASC,
	[ARR_DEP_SORT] ASC
)
INCLUDE ( 	[SHIPNAME],
	[PORT_NAME],
	[CENTERX],
	[CENTERY],
	[ZOOM],
	[MMSI],
	[ARRIVAL],
	[DEPARTURE]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [ARR_DEP] ON [dbo].[V_ARR_DEP_TEMP]
(
	[ARR_DEP_SORT] DESC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [MMSI] ON [dbo].[V_ARR_DEP_TEMP]
(
	[MMSI] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [PORT] ON [dbo].[V_ARR_DEP_TEMP]
(
	[PORT_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [SHIP_ID_TIM] ON [dbo].[V_ARR_DEP_TEMP]
(
	[SHIP_ID] ASC,
	[ARR_DEP_SORT] DESC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
