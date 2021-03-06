USE [DBA_t01_00]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE TRIGGER [dbo].[tr_insert_sales] 
   ON  [dbo].[SHIP_WIKI]
   INSTEAD OF INSERT
AS 
BEGIN
	SET NOCOUNT ON;
	
	declare @mmsi int
	declare @sale_price int
	declare @sale_contact nvarchar(255)
	declare @sale_days smallint
	declare @sale_posted smalldatetime
	declare @sale_email varchar(128)
	
	select @mmsi=MMSI, @sale_price=SALE_PRICE, @sale_contact=SALE_CONTACT, @sale_days=SALE_DAYS, @sale_posted=SALE_POSTED, @sale_email=SALE_EMAIL
	from inserted
	
	update SHIP_WIKI set SALE_PRICE=@sale_price, SALE_CONTACT=@sale_contact, SALE_DAYS=@sale_days, SALE_POSTED=@sale_posted, 
	SALE_EMAIL=@sale_email, EMAIL=@sale_email
	where MMSI=@mmsi
END



GO
ALTER TABLE [dbo].[SHIP_WIKI] ENABLE TRIGGER [tr_insert_sales]
GO
