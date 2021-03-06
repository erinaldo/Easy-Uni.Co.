SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[trigger_u_underwritingpayment]') and OBJECTPROPERTY(id, N'IsTrigger') = 1)
drop trigger [trigger_u_underwritingpayment]
GO

CREATE    TRIGGER [trigger_u_underwritingpayment] ON [underwritingpayment] FOR UPDATE
AS BEGIN
IF UPDATE(amount)
BEGIN


	DECLARE @ayear int
	DECLARE @idexp int
	DECLARE @flagarrear char(1)
	DECLARE @nphase tinyint
	DECLARE @idfin int
	DECLARE @idupb varchar(36)
	DECLARE @newamount decimal(19,2)
	DECLARE @idunderwriting int

	SELECT
		@idunderwriting = INS.idunderwriting,
		@idexp = INS.idexp, 
		@ayear = E.ymov, 
		@nphase = E.nphase, 
		@idfin = EY.idfin, 
		@idupb = EY.idupb,
		@newamount = INS.amount,
		@flagarrear =
 		CASE
			WHEN ((ET.flag&1)=0) THEN 'C'
			WHEN ((ET.flag&1)<>1) THEN 'R'
		END
	FROM inserted INS
	JOIN expense E
		ON INS.idexp = E.idexp
	JOIN expenseyear EY
		ON EY.idexp = E.idexp
		AND EY.ayear = E.ymov	
	JOIN expensetotal ET
		ON ET.idexp = E.idexp
		AND ET.ayear = E.ymov

	DECLARE @oldamount decimal(19,2)
	SELECT 	@oldamount = -amount
	FROM deleted

	DECLARE @variationsamount decimal(19,2)
	SELECT @variationsamount = curramount + @oldamount 
	FROM expensetotal 
	WHERE idexp = @idexp AND ayear = @ayear

	DECLARE @oldcurrentamount decimal(19,2)
	SELECT @oldcurrentamount = @oldamount - @variationsamount

	DECLARE @newcurrentamount decimal(19,2)
	SELECT @newcurrentamount = @newamount + @variationsamount


	
	
	IF (ABS(@oldcurrentamount) <> @newcurrentamount)
	BEGIN
		DECLARE @diff decimal(19,2)
		SET @diff = @oldcurrentamount + @newcurrentamount
	
		EXECUTE trg_upd_underwritingmovtotal		
		'E', 
		@idunderwriting, 
		@idupb,
		@idfin,
		@flagarrear, 
		@nphase, 
		@diff
	END
	



END
END



GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

