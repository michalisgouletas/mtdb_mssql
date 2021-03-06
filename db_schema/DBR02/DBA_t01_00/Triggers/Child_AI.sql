USE [DBA_t01_00]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TRIGGER [dbo].[Child_AI]
ON [dbo].[Child]
AFTER INSERT
AS
BEGIN
    -- Child rows with CheckMe = true
    -- must have an associated parent row
    IF EXISTS
    (
        SELECT ins.ParentID
        FROM inserted AS ins
        WHERE ins.CheckMe = 1
        EXCEPT
        SELECT P.ParentID
        FROM dbo.Parent AS P WITH (READCOMMITTEDLOCK) -- NEW!!
    )
    BEGIN
        RAISERROR ('Integrity violation!', 16, 1);
        ROLLBACK TRANSACTION;
    END
END;

GO
ALTER TABLE [dbo].[Child] ENABLE TRIGGER [Child_AI]
GO
