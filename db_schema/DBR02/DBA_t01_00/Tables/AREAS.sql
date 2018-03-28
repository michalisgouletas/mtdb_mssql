USE [DBA_t01_00]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AREAS](
	[AREA_ID] [smallint] IDENTITY(1,1) NOT NULL,
	[AREA_NAME] [varchar](30) COLLATE SQL_Latin1_General_CP1_CI_AI NULL,
	[SW_X] [real] NULL,
	[SW_Y] [real] NULL,
	[NE_X] [real] NULL,
	[NE_Y] [real] NULL,
	[ZOOM] [int] NULL,
	[SHOWONMAP] [bit] NULL,
	[TREEORDER] [int] NULL,
	[POLYGON] [geography] NULL,
	[AREA_CODE] [varchar](10) COLLATE SQL_Latin1_General_CP1_CI_AI NULL,
	[HAS_ALERT] [bit] NULL,
 CONSTRAINT [PK_AREAS_1] PRIMARY KEY CLUSTERED 
(
	[AREA_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
CREATE NONCLUSTERED INDEX [coords_1] ON [dbo].[AREAS]
(
	[SW_X] ASC,
	[SW_Y] ASC,
	[NE_X] ASC,
	[NE_Y] ASC
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
CREATE SPATIAL INDEX [polygon] ON [dbo].[AREAS]
(
	[POLYGON]
)USING  GEOGRAPHY_GRID 
WITH (GRIDS =(LEVEL_1 = MEDIUM,LEVEL_2 = MEDIUM,LEVEL_3 = MEDIUM,LEVEL_4 = MEDIUM), 
CELLS_PER_OBJECT = 16, PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
