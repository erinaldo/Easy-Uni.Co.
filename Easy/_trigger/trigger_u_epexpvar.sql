SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[trigger_u_epexpvar]') and OBJECTPROPERTY(id, N'IsTrigger') = 1)
drop trigger [trigger_u_epexpvar]
GO


CREATE                   TRIGGER [trigger_u_epexpvar] ON [epexpvar] FOR UPDATE
AS BEGIN
		

	
	DECLARE @yvar int
	DECLARE @newamount decimal(19,2)
	DECLARE @newamount2 decimal(19,2)
	DECLARE @newamount3 decimal(19,2)
	DECLARE @newamount4 decimal(19,2)
	DECLARE @newamount5 decimal(19,2)	
	DECLARE @lu varchar(64)
	DECLARE @lt datetime
	DECLARE @idepexp int
	
	SELECT
		@yvar = yvar, 
		@idepexp = idepexp, 
		@newamount = amount,
		@newamount2 = isnull(amount2,0),
		@newamount3 = isnull(amount3,0),
		@newamount4 = isnull(amount4,0),
		@newamount5 = isnull(amount5,0),
		@lu = lu,
		@lt = lt
	FROM inserted

	DECLARE @oldamount decimal(19,2)
	DECLARE @oldamount2 decimal(19,2)
	DECLARE @oldamount3 decimal(19,2)
	DECLARE @oldamount4 decimal(19,2)
	DECLARE @oldamount5 decimal(19,2)
	
	SELECT @oldamount = -amount, 
			@oldamount2 = - isnull(amount2,0),
			@oldamount3 = - isnull(amount3,0),
			@oldamount4 = - isnull(amount4,0),
			@oldamount5 = - isnull(amount5,0)
	FROM deleted

	DECLARE @nphase tinyint
	DECLARE @idacc varchar(38)
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

	declare @diff decimal(19,2)
	declare @diff2 decimal(19,2)
	declare @diff3 decimal(19,2)
	declare @diff4 decimal(19,2)
	declare @diff5 decimal(19,2)
	set @diff=@newamount+@oldamount;
	set @diff2=@newamount2+@oldamount2;
	set @diff3=@newamount3+@oldamount3;
	set @diff4=@newamount4+@oldamount4;
	set @diff5=@newamount5+@oldamount5;
	

	EXECUTE trg_amount_epexpvariation 	@yvar,	@idepexp,@parentidepexp,@nphase,	@diff,@diff2,@diff3,@diff4,@diff5
		
	declare @is_variation char(1) 
	SET @is_variation = isnull((SELECT isnull(epexp.flagvariation,'N') FROM epexp WHERE idepexp = @idepexp),'N')

	if (@is_variation = 'N' )
	Begin
		EXECUTE trg_upd_upbepexptotal  	@idacc, @idupb,@nphase,		@diff,@diff2,@diff3,@diff4,@diff5
	End
	Else
	Begin
		DECLARE @amount_ofvar decimal(19,2)
		DECLARE @amount2_ofvar decimal(19,2)
		DECLARE @amount3_ofvar decimal(19,2)
		DECLARE @amount4_ofvar decimal(19,2)
		DECLARE @amount5_ofvar decimal(19,2)
		set @amount_ofvar  = - @diff
		set @amount2_ofvar = - @diff2
		set @amount3_ofvar = - @diff3
		set @amount4_ofvar = - @diff4
		set @amount5_ofvar = - @diff5

		EXECUTE trg_upd_upbepexptotal  	@idacc, @idupb,@nphase,	@amount_ofvar, @amount2_ofvar, @amount3_ofvar, @amount4_ofvar, @amount5_ofvar
	End

	DECLARE @ybalance int	
	EXECUTE trg_yearbalance 'E', @ybalance OUTPUT	

	DECLARE @paymentphase tinyint	
	SET @paymentphase = 2

	IF @yvar = @ybalance
	BEGIN
		EXECUTE trg_evaluatearrearsepexp @idepexp, @yvar
	END


END




GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

