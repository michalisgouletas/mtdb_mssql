USE [zdk_blendo00]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[xerocontacts](
	[accountnumber] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[accountspayabletaxtype] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[accountsreceivabletaxtype] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[addresses_addressline1] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[addresses_addressline2] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[addresses_addressline3] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[addresses_addressline4] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[addresses_addresstype] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[addresses_attentionto] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[addresses_city] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[addresses_country] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[addresses_postalcode] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[addresses_region] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[balances_accountspayable_outstanding] [float] NULL,
	[balances_accountspayable_overdue] [float] NULL,
	[balances_accountsreceivable_outstanding] [float] NULL,
	[balances_accountsreceivable_overdue] [float] NULL,
	[bankaccountdetails] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[blendo_imported_at] [bigint] NULL,
	[contactid] [varchar](256) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[contactstatus] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[defaultcurrency] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[emailaddress] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[firstname] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[hasattachments] [bit] NULL,
	[hasvalidationerrors] [bit] NULL,
	[iscustomer] [bit] NULL,
	[issupplier] [bit] NULL,
	[lastname] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[name] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[phones_phoneareacode] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[phones_phonecountrycode] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[phones_phonenumber] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[phones_phonetype] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[skypeusername] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[taxnumber] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[updateddateutc] [datetime] NULL
) ON [FG_DATA_00] TEXTIMAGE_ON [FG_DATA_00]

GO
