SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[trigger_u_incomevar]') and OBJECTPROPERTY(id, N'IsTrigger') = 1)
drop trigger [trigger_u_incomevar]
GO

CREATE TRIGGER [trigger_u_incomevar] ON [incomevar] FOR UPDATE
AS BEGIN
IF UPDATE(amount)
BEGIN
	DECLARE @ybalance int
	EXECUTE trg_yearbalance 'I', @ybalance OUTPUT	

	DECLARE @finphase tinyint
	SELECT @finphase = incomefinphase FROM uniconfig

	DECLARE @proceedsphase tinyint
	SELECT @proceedsphase = MAX(nphase) FROM incomephase

	DECLARE @yvar int
	DECLARE @newamount decimal(19,2)
	DECLARE @lu varchar(64)
	DECLARE @lt datetime
	DECLARE @idinc int

	SELECT
		@yvar = yvar, 
		@idinc = idinc, 
		@newamount = amount,
		@lu = lu,
		@lt = lt
	FROM inserted

	DECLARE @oldamount decimal(19,2)
	DECLARE @origamount decimal(19,2)
	SELECT @oldamount = -amount, @origamount = amount
	FROM deleted

	DECLARE @nphase tinyint
	DECLARE @idfin int
	DECLARE @idupb varchar(36)
	DECLARE @parentidinc int
	DECLARE @idunderwriting int

	SELECT
		@idfin = incomeyear.idfin,
		@idupb = incomeyear.idupb,
		@nphase = income.nphase,
		@parentidinc = income.parentidinc,
		@idunderwriting = income.idunderwriting	
	FROM incomeyear
	JOIN income
		ON income.idinc = incomeyear.idinc
	WHERE income.idinc = @idinc
		AND ayear = @yvar

	EXECUTE trg_amount_variation
	@yvar,
	'I',
	@idinc,
	@parentidinc,
	@nphase,
	@oldamount,
	@newamount
		
	DECLARE @kpro int
	DECLARE @idtreasurer int
	
	SELECT @kpro = kpro FROM incomelast 
	WHERE idinc = @idinc
	
	SELECT @idtreasurer = idtreasurer 
	FROM proceeds WHERE kpro = @kpro
	
	IF (@kpro IS NOT NULL AND @idtreasurer IS NOT NULL) 
	BEGIN
		-- Ricalcolo del Fondo di Cassa del Tesoriere corrispondente
		EXEC trg_upd_treasurercashtotal
		@yvar,
		@idtreasurer,
		'I',
		@origamount,
		@newamount
	END
	
	
	DECLARE @ymovpar int
	SELECT @ymovpar = income.ymov 
	FROM incomelink
	JOIN income
	ON incomelink.idparent = income.idinc
	WHERE idchild = @idinc
		AND nlevel = @finphase

	IF @idfin IS NOT NULL
	BEGIN
		IF (@ymovpar = @yvar)
		BEGIN
			EXECUTE trg_upd_upbmovtotal 
			'I', 
			@idfin, 
			@idupb,
			'C', 
			@nphase, 
			@oldamount

			EXECUTE trg_upd_upbmovtotal 
			'I',
			@idfin, 
			@idupb,
			'C', 
			@nphase, 
			@newamount
		END
		ELSE
		BEGIN
			EXECUTE trg_upd_upbmovtotal 
			'I',
			@idfin, 
			@idupb,
			'R', 
			@nphase, 
			@oldamount

			EXECUTE trg_upd_upbmovtotal 
			'I', 
			@idfin, 
			@idupb,
			'R', 
			@nphase, 
			@newamount
		END
	END

	IF @idunderwriting IS NOT NULL
	BEGIN
		IF (@ymovpar = @yvar)
		BEGIN
			EXECUTE trg_upd_underwritingmovtotal 
			'I', 
			@idunderwriting,
			@idupb,
			@idfin,
			'C', 
			@nphase, 
			@oldamount

			EXECUTE trg_upd_underwritingmovtotal 
			'I',
			@idunderwriting,
			@idupb,
			@idfin,
			'C', 
			@nphase, 
			@newamount
		END
		ELSE
		BEGIN
			EXECUTE trg_upd_underwritingmovtotal 
			'I',
			@idunderwriting,
			@idupb,
			@idfin,
			'R', 
			@nphase, 
			@oldamount

			EXECUTE trg_upd_underwritingmovtotal 
			'I', 
			@idunderwriting,
			@idupb,
			@idfin,
			'R', 
			@nphase, 
			@newamount
		END
	END
	
	IF @yvar = @ybalance
	BEGIN
		IF @nphase < @proceedsphase
		BEGIN
			EXECUTE trg_evaluatearrears
			'I',
			@idinc,
			@yvar,
			@nphase
		END
		ELSE
		BEGIN
			DECLARE @currentphase tinyint
			DECLARE @idcurrentinc int
			SET @idcurrentinc = @idinc
			SELECT @currentphase = (@proceedsphase - 1)
			WHILE @currentphase > 0 
			BEGIN
				SELECT @idcurrentinc = idparent FROM incomelink WHERE idchild = @idcurrentinc
					AND nlevel = @currentphase

				EXECUTE trg_evaluatearrears
				'I',
				@idcurrentinc,
				@yvar,
				@currentphase
	
				SELECT @currentphase = @currentphase - 1
			END
/*
			DECLARE @currentphase tinyint
			DECLARE @idcurrentinc int
			SET @idcurrentinc = @idinc
			SELECT @currentphase = 1
			WHILE @currentphase < @proceedsphase
			BEGIN
				SELECT @idcurrentinc = idparent FROM incomelink WHERE idchild = @idinc
					AND nlevel = @currentphase

				EXECUTE trg_evaluatearrears
				'I',
				@idcurrentinc,
				@yvar,
				@currentphase
	
				SELECT @currentphase = @currentphase + 1
			END
*/
		END
	END
END
END



GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

