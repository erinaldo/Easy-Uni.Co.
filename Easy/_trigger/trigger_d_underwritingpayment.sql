SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[trigger_d_underwritingpayment]') and OBJECTPROPERTY(id, N'IsTrigger') = 1)
drop trigger [trigger_d_underwritingpayment]
GO

CREATE      TRIGGER [trigger_d_underwritingpayment] ON [underwritingpayment] FOR DELETE
AS BEGIN
IF @@ROWCOUNT > 0
BEGIN

	DECLARE @idexp int
	DECLARE @ayear int
	DECLARE @amount decimal(19,2)
	DECLARE @idfin int
	DECLARE @idupb varchar(36)
	DECLARE @flagarrear char(1)
	DECLARE @nphase tinyint
	DECLARE @idunderwriting int 
-- Questo codice funziona se cancelliamo la riga di underwritingpayment
-- se invece cancelliamo direttamente il pagamento agisce il trigger in D/expenseyear
	SELECT
		@idunderwriting = idunderwriting	,
		@amount = -amount,
		@idexp = idexp
	FROM deleted
	
	SELECT
		@ayear = EY.ayear, 
		@idfin = EY.idfin, 
		@idupb = EY.idupb,
		@nphase = E.nphase
	FROM expenseyear EY
	JOIN expense E
		ON EY.idexp = E.idexp
		AND EY.ayear = E.ymov
	WHERE E.idexp = @idexp
		
	DECLARE @maxphase tinyint
	SET @maxphase = (SELECT MAX(nphase) FROM expensephase)
		
	DECLARE @ymovpar int
	SELECT @ymovpar = expense.ymov 
	FROM expenselink
	JOIN expense
		ON expenselink.idparent = expense.idexp
	WHERE idchild = @idexp
		AND nlevel = @maxphase

		IF (@ymovpar = @ayear)
		BEGIN
			EXECUTE trg_upd_underwritingmovtotal 
			'E', 
			@idunderwriting,
			@idupb,
			@idfin,
			'C', 
			@nphase, 
			@amount
		END
		ELSE
		BEGIN
			EXECUTE trg_upd_underwritingmovtotal 
			'E', 
			@idunderwriting,
			@idupb,
			@idfin,
			'R', 
			@nphase, 
			@amount
		END


END
END





GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

