SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[trigger_d_expensemandate]') and OBJECTPROPERTY(id, N'IsTrigger') = 1)
drop trigger [trigger_d_expensemandate]
GO

CREATE TRIGGER [trigger_d_expensemandate] ON expensemandate 
FOR DELETE 
AS
BEGIN
	DECLARE @idexp int
	SELECT @idexp = idexp
	FROM deleted
	UPDATE mandatedetail SET idexp_iva = NULL
	WHERE idexp_iva = @idexp
	UPDATE mandatedetail SET idexp_taxable = NULL
	WHERE idexp_taxable = @idexp

END


GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

