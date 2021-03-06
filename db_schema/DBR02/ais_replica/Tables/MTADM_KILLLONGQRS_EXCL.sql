USE [ais_replica]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MTADM_KILLLONGQRS_EXCL](
	[id] [smallint] IDENTITY(1,1) NOT NULL,
	[client_host_name] [nvarchar](40) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[client_user_id] [int] NOT NULL,
	[client_mt_email] [varchar](100) COLLATE SQL_Latin1_General_CP1_CI_AI NULL,
	[exclusion_notes] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AI NULL,
	[inserttsutc] [datetime] NOT NULL,
 CONSTRAINT [pk_mtadm_killlongqrs_excl_client_host_name] PRIMARY KEY NONCLUSTERED 
(
	[client_host_name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [FG01DT]

GO
ALTER TABLE [dbo].[MTADM_KILLLONGQRS_EXCL] ADD  CONSTRAINT [df_mtadm_killlongqrs_excl_userid]  DEFAULT ((-1)) FOR [client_user_id]
GO
ALTER TABLE [dbo].[MTADM_KILLLONGQRS_EXCL] ADD  CONSTRAINT [df_mtadm_killlongqrs_excl_insertts]  DEFAULT (getutcdate()) FOR [inserttsutc]
GO
