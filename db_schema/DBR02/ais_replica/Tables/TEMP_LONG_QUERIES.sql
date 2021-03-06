USE [ais_replica]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TEMP_LONG_QUERIES](
	[SQLTEXT] [varchar](max) COLLATE SQL_Latin1_General_CP1_CI_AI NULL,
	[TIM] [smalldatetime] NULL,
	[HOST] [varchar](max) COLLATE SQL_Latin1_General_CP1_CI_AI NULL,
	[client_pid] [int] NULL,
	[status] [nvarchar](30) COLLATE SQL_Latin1_General_CP1_CI_AI NULL,
	[last_request_start_time] [datetime] NULL,
	[spid] [int] NULL,
	[EXECSQL_STMT] [varchar](max) COLLATE SQL_Latin1_General_CP1_CI_AI NULL,
	[login_name] [nvarchar](128) COLLATE SQL_Latin1_General_CP1_CI_AI NULL,
	[client_net_address] [nvarchar](48) COLLATE SQL_Latin1_General_CP1_CI_AI NULL
) ON [FG01DT] TEXTIMAGE_ON [PRIMARY]

GO
CREATE CLUSTERED INDEX [TIM] ON [dbo].[TEMP_LONG_QUERIES]
(
	[TIM] DESC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [FG01DT]
GO
ALTER TABLE [dbo].[TEMP_LONG_QUERIES] ADD  CONSTRAINT [DF_TEMP_LONG_QUERIES_TIM]  DEFAULT (getutcdate()) FOR [TIM]
GO
