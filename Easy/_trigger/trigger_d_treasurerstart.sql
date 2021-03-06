SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[trigger_d_treasurerstart]') and OBJECTPROPERTY(id, N'IsTrigger') = 1)
drop trigger [trigger_d_treasurerstart]
GO

CREATE TRIGGER [trigger_d_treasurerstart] ON [treasurerstart] FOR DELETE
AS BEGIN

DECLARE @idtreasurer int
DECLARE @oldamount decimal(19,2)
DECLARE @newamount decimal(19,2)
DECLARE @ayear int

SELECT  @idtreasurer = idtreasurer, 
		@ayear = ayear,
		@oldamount = amount FROM deleted


UPDATE treasurercashtotal SET currentfloatfund = isnull(currentfloatfund,0) - @oldamount WHERE idtreasurer = @idtreasurer and ayear = @ayear




END
GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

