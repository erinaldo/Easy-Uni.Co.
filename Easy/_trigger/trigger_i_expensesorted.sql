SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[trigger_i_expensesorted]') and OBJECTPROPERTY(id, N'IsTrigger') = 1)
drop trigger [trigger_i_expensesorted]
GO

CREATE TRIGGER [trigger_i_expensesorted] ON [expensesorted] FOR INSERT
AS BEGIN
	DECLARE @idexp int
	DECLARE @idsor int
 	DECLARE @ayear int
	DECLARE @amount decimal(19,2)
 	SELECT 
	@idexp = idexp, 
	@idsor = idsor, 
	@amount = amount, 
	@ayear = ayear
	FROM inserted
	
	IF (@ayear IS NULL)
	BEGIN
		SELECT @ayear = ymov 
		FROM expense 
		WHERE idexp = @idexp
	END

	EXECUTE trg_upd_sorttotal 
	@idsor, 
	@ayear, 
	'totexpense', 
	@amount
END





GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

