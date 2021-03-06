USE [ais_replica]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [fk].[tmpx_CORE6930_PORTS_bkp20180203](
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
	[CENTERX] [real] NULL,
	[CENTERY] [real] NULL,
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
	[DRYDOCK_AVAILABLE] [varchar](1) COLLATE SQL_Latin1_General_CP1_CI_AI NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
