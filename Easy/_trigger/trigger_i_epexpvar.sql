SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[trigger_i_epexpvar]') and OBJECTPROPERTY(id, N'IsTrigger') = 1)
drop trigger [trigger_i_epexpvar]
GO


create                   TRIGGER [trigger_i_epexpvar] ON [epexpvar] FOR INSERT
AS BEGIN
	DECLARE @idepexp int
	DECLARE @yvar int
	DECLARE @amount decimal(19,2)
	DECLARE @amount2 decimal(19,2)
	DECLARE @amount3 decimal(19,2)
	DECLARE @amount4 decimal(19,2)
	DECLARE @amount5 decimal(19,2)
	DECLARE @lu varchar(64)
	DECLARE @lt datetime
	DECLARE @nphase tinyint
	
	SELECT
		@yvar = yvar, 
		@idepexp = idepexp, 
		@amount = amount,
		@amount2 = isnull(amount2,0),
		@amount3 = isnull(amount3,0),
		@amount4 = isnull(amount4,0),
		@amount5 = isnull(amount5,0),
		@lu = lu,
		@lt = lt
	FROM inserted

	DECLARE @idacc  varchar(38)
	DECLARE @idupb varchar(36)
	DECLARE @parentidepexp int
	
	SELECT
		@idacc = epexpyear.idacc,
		@idupb = epexpyear.idupb,
		@nphase = epexp.nphase,
		@parentidepexp = epexp.paridepexp
	FROM epexpyear
	JOIN epexp
		ON epexp.idepexp = epexpyear.idepexp
	WHERE epexp.idepexp = @idepexp
	AND ayear = @yvar

	EXECUTE trg_amount_epexpvariation 	@yvar,	@idepexp,@parentidepexp,@nphase,
					@amount,@amount2,@amount3,@amount4,@amount5
	
	declare @is_variation char(1) 
	SET @is_variation = isnull((SELECT isnull(epexp.flagvariation,'N') FROM epexp WHERE idepexp = @idepexp),'N')

	if (@is_variation = 'N' )
	Begin
		EXECUTE trg_upd_upbepexptotal @idacc, @idupb, @nphase, 
						@amount,@amount2,@amount3,@amount4,@amount5
	End
	Else
	Begin
		DECLARE @amount_ofvar decimal(19,2)
		DECLARE @amount2_ofvar decimal(19,2)
		DECLARE @amount3_ofvar decimal(19,2)
		DECLARE @amount4_ofvar decimal(19,2)
		DECLARE @amount5_ofvar decimal(19,2)
		set @amount_ofvar  = - @amount
		set @amount2_ofvar = - @amount2
		set @amount3_ofvar = - @amount3
		set @amount4_ofvar = - @amount4
		set @amount5_ofvar = - @amount5

		EXECUTE trg_upd_upbepexptotal @idacc, @idupb, @nphase, 
						@amount_ofvar, @amount2_ofvar, @amount3_ofvar, @amount4_ofvar, @amount5_ofvar
	End
	
		
	DECLARE @ybalance int	
	EXECUTE trg_yearbalance 'E', @ybalance OUTPUT	

	DECLARE @paymentphase tinyint	
	SET @paymentphase = 2
	IF @yvar = @ybalance
	BEGIN
		EXECUTE trg_evaluatearrearsepexp @idepexp,@yvar
	END


END


GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

