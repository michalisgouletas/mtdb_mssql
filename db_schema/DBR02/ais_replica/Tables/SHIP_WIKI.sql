USE [ais_replica]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SHIP_WIKI](
	[ID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[EMAIL] [varchar](128) COLLATE SQL_Latin1_General_CP1_CI_AI NULL,
	[MMSI] [int] NULL,
	[IMO] [int] NULL,
	[OWNER_ID] [smallint] NULL,
	[MANAGER_ID] [smallint] NULL,
	[BUILDER_ID] [smallint] NULL,
	[BUILT_YEAR] [smallint] NULL,
	[BUILT_MONTH] [smallint] NULL,
	[SHIPTYPE] [smallint] NULL,
	[HULLNO] [varchar](15) COLLATE SQL_Latin1_General_CP1_CI_AI NULL,
	[CLASS] [smallint] NULL,
	[SERVICE] [varchar](15) COLLATE SQL_Latin1_General_CP1_CI_AI NULL,
	[YEAR_LOST] [smallint] NULL,
	[SPEED_MAX] [real] NULL,
	[SPEED_NOM] [real] NULL,
	[GT] [int] NULL,
	[NT] [int] NULL,
	[DWT] [int] NULL,
	[DISPLACEMENT] [int] NULL,
	[LOA] [real] NULL,
	[BEAM] [real] NULL,
	[DRAFT] [real] NULL,
	[DEPTH] [real] NULL,
	[HEIGHT] [real] NULL,
	[HOLDS_TANKS] [varchar](128) COLLATE SQL_Latin1_General_CP1_CI_AI NULL,
	[GEAR_SWL] [smallint] NULL,
	[GEAR] [varchar](128) COLLATE SQL_Latin1_General_CP1_CI_AI NULL,
	[HATCHES] [varchar](128) COLLATE SQL_Latin1_General_CP1_CI_AI NULL,
	[BALE] [int] NULL,
	[GRAIN] [int] NULL,
	[TEU] [int] NULL,
	[PAX] [int] NULL,
	[CARS] [int] NULL,
	[LORRIES] [int] NULL,
	[RORO_LINES] [int] NULL,
	[LIQUID_CAP] [int] NULL,
	[LIQUID_GAS_CAP] [int] NULL,
	[OIL_CAP] [int] NULL,
	[PUMPS_NO] [int] NULL,
	[PUMPS_CAP] [varchar](20) COLLATE SQL_Latin1_General_CP1_CI_AI NULL,
	[MAIN_NO] [smallint] NULL,
	[MAIN_BUILDER] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AI NULL,
	[MAIN_MODEL] [varchar](20) COLLATE SQL_Latin1_General_CP1_CI_AI NULL,
	[MAIN_RPM] [varchar](5) COLLATE SQL_Latin1_General_CP1_CI_AI NULL,
	[MAIN_KW] [varchar](10) COLLATE SQL_Latin1_General_CP1_CI_AI NULL,
	[MAIN_HP] [varchar](10) COLLATE SQL_Latin1_General_CP1_CI_AI NULL,
	[MAIN_FUEL] [varchar](20) COLLATE SQL_Latin1_General_CP1_CI_AI NULL,
	[MAIN_CONSUMPTION] [varchar](10) COLLATE SQL_Latin1_General_CP1_CI_AI NULL,
	[AUX_NO] [smallint] NULL,
	[AUX_BUILDER] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AI NULL,
	[AUX_MODEL] [varchar](20) COLLATE SQL_Latin1_General_CP1_CI_AI NULL,
	[AUX_RPM] [varchar](5) COLLATE SQL_Latin1_General_CP1_CI_AI NULL,
	[AUX_KW] [varchar](10) COLLATE SQL_Latin1_General_CP1_CI_AI NULL,
	[AUX_HP] [varchar](10) COLLATE SQL_Latin1_General_CP1_CI_AI NULL,
	[AUX_FUEL] [varchar](20) COLLATE SQL_Latin1_General_CP1_CI_AI NULL,
	[AUX_CONSUMPTION] [varchar](10) COLLATE SQL_Latin1_General_CP1_CI_AI NULL,
	[BOWTHRUSTER] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AI NULL,
	[PROPELLER] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AI NULL,
	[TELEX] [varchar](20) COLLATE SQL_Latin1_General_CP1_CI_AI NULL,
	[PHONE] [varchar](20) COLLATE SQL_Latin1_General_CP1_CI_AI NULL,
	[FAX] [varchar](20) COLLATE SQL_Latin1_General_CP1_CI_AI NULL,
	[MOBILE] [varchar](20) COLLATE SQL_Latin1_General_CP1_CI_AI NULL,
	[SALE_PRICE] [int] NULL,
	[SALE_CONTACT] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AI NULL,
	[SALE_DAYS] [smallint] NULL,
	[SALE_POSTED] [smalldatetime] NULL,
	[SALE_EMAIL] [varchar](128) COLLATE SQL_Latin1_General_CP1_CI_AI NULL,
	[user_id] [int] NULL,
 CONSTRAINT [PK_SHIP_WIKI] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [FG01DT]
) ON [FG01DT]

GO
CREATE NONCLUSTERED INDEX [imo] ON [dbo].[SHIP_WIKI]
(
	[IMO] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [mmsi] ON [dbo].[SHIP_WIKI]
(
	[MMSI] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
