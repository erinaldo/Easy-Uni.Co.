SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[trigger_d_moneytransfer]') and OBJECTPROPERTY(id, N'IsTrigger') = 1)
drop trigger [trigger_d_moneytransfer]
GO

CREATE TRIGGER [trigger_d_moneytransfer] ON [moneytransfer] FOR DELETE
AS BEGIN

DECLARE @idtreasurerSource int
DECLARE @idtreasurerDest int
DECLARE @oldamount decimal(19,2)
DECLARE @newamount decimal(19,2)
DECLARE @ayear int

SELECT  @idtreasurerSource = idtreasurersource, 
		@idtreasurerDest = idtreasurerdest, 
		@ayear = ytransfer,
		@oldamount = amount FROM deleted


UPDATE treasurercashtotal SET currentfloatfund = isnull(currentfloatfund,0) + @oldamount WHERE idtreasurer = @idtreasurerSource and ayear = @ayear

UPDATE treasurercashtotal SET currentfloatfund = isnull(currentfloatfund,0) - @oldamount WHERE idtreasurer = @idtreasurerDest and ayear = @ayear




END
GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

