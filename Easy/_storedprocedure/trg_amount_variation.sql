SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[trg_amount_variation]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [trg_amount_variation]
GO


CREATE  PROCEDURE [trg_amount_variation]
(
	@ayear int,
	@movkind char(1),
	@idmov int,
	@parentidmovement int,
	@nphase tinyint,
	@newamount decimal(19,2),
	@oldamount decimal(19,2)
)
AS BEGIN
IF @movkind = 'I' -- Income
BEGIN
	UPDATE incometotal SET
	curramount = ISNULL(curramount,0) + @oldamount + @newamount,
	available = ISNULL(available,0) + @oldamount + @newamount
	WHERE idinc = @idmov AND ayear = @ayear
	
	IF @parentidmovement IS NOT NULL
	BEGIN
		UPDATE incometotal SET
		available = ISNULL(available,0) - @oldamount - @newamount
		WHERE idinc = @parentidmovement AND ayear = @ayear
	END
END
ELSE -- Expense
BEGIN
	DECLARE @maxexpensephase tinyint
	SELECT @maxexpensephase = MAX(nphase) FROM expensephase

	-- Ricalcolo del Fondo di Cassa Corrente
	IF (@nphase = @maxexpensephase)
	EXEC trg_curr_floatfund_variation
	@ayear,
	'E',
	@idmov,
	@oldamount,
	@newamount

	UPDATE expensetotal SET
	curramount = ISNULL(curramount,0) + @oldamount + @newamount,
	available = ISNULL(available,0) + @oldamount + @newamount
	WHERE idexp = @idmov AND ayear = @ayear
	
	IF @parentidmovement IS NOT NULL
	BEGIN
		UPDATE expensetotal SET
		available = ISNULL(available,0) - @oldamount - @newamount
		WHERE idexp = @parentidmovement AND ayear = @ayear
	END
END
END



GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

