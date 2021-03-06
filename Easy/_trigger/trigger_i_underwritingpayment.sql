
SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[trigger_i_underwritingpayment]') and OBJECTPROPERTY(id, N'IsTrigger') = 1)
drop trigger [trigger_i_underwritingpayment]
GO

CREATE    TRIGGER [trigger_i_underwritingpayment] ON [underwritingpayment] FOR INSERT
AS BEGIN

	DECLARE @idexp int
	DECLARE @ayear int
	DECLARE @nphase tinyint
	DECLARE @idfin int
	DECLARE @idupb varchar(36)
	DECLARE @amount decimal(19,2)
	DECLARE @idunderwriting int
	DECLARE @flagarrear char(1)

	SELECT 
			@idunderwriting = W.idunderwriting,
			@idupb = EY.idupb,
			@idfin = EY.idfin,
			@amount = W.amount,
			@flagarrear =
			CASE
				WHEN ((ET.flag&1)=0) THEN 'C'
				WHEN ((ET.flag&1)=1) THEN 'R'
			END,
			@nphase = E.nphase
	FROM inserted W
	JOIN expense E
		ON W.idexp = E.idexp
	JOIN expenseyear EY
		ON EY.idexp = E.idexp
		AND EY.ayear = E.ymov	
	JOIN expensetotal ET
		ON ET.idexp = E.idexp
		AND ET.ayear = E.ymov

	EXECUTE trg_upd_underwritingmovtotal 
	'E', 
	@idunderwriting,
	@idupb,
	@idfin,
	@flagarrear, 
	@nphase, 
	@amount
			
		
END

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

