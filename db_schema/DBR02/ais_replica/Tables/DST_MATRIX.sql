USE [ais_replica]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DST_MATRIX](
	[YEAR] [smallint] NOT NULL,
	[STARTS] [smalldatetime] NOT NULL,
	[ENDS] [smalldatetime] NOT NULL,
	[DST_REGION] [tinyint] NOT NULL
) ON [FG01DT]

GO
CREATE CLUSTERED INDEX [IDXCL_DST_MATRIX] ON [dbo].[DST_MATRIX]
(
	[DST_REGION] ASC,
	[YEAR] ASC,
	[STARTS] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [FG01DT]
GO
