SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[trigger_i_expensepayroll]') and OBJECTPROPERTY(id, N'IsTrigger') = 1)
drop trigger [trigger_i_expensepayroll]
GO


CREATE         TRIGGER [trigger_i_expensepayroll] ON [expensepayroll] 
FOR INSERT
AS BEGIN
	DECLARE @idexp int
	DECLARE @idpayroll int
	DECLARE @adate datetime
	DECLARE @start datetime
	DECLARE @idcon varchar(8)
	DECLARE @fiscalyear int
	
	SELECT @idpayroll = idpayroll,
	@idexp = idexp
	FROM inserted
	
	SELECT @adate = adate FROM expense WHERE idexp = @idexp
	UPDATE payroll SET disbursementdate = @adate,
	lt = GETDATE(),
	lu = 'TRIGGER'
	WHERE idpayroll = @idpayroll
	SELECT 
	@start = start,
	@fiscalyear = fiscalyear,
	@idcon = idcon
	FROM payroll
	WHERE idpayroll = @idpayroll
	DECLARE @otherpayrolls int
	SELECT @otherpayrolls = COUNT(*) FROM payroll 
	WHERE idcon = @idcon
	AND fiscalyear = @fiscalyear
	AND start > @start
	AND flagbalance = 'N'
	
	IF (@otherpayrolls = 0)
	BEGIN
		DECLARE @idpayrollbalance int
		SELECT @idpayrollbalance = idpayroll FROM payroll
		WHERE idcon = @idcon
		AND fiscalyear = @fiscalyear
		AND flagbalance = 'S'

		UPDATE payroll SET disbursementdate = @adate,
		lt = GETDATE(),
		lu = 'TRIGGER'
		WHERE idpayroll = @idpayrollbalance

		UPDATE parasubcontractlist
		SET balanced = 'S'
		WHERE idcon = @idcon
			AND ayear = @fiscalyear
			AND iddbdepartment = USER
	END
END




GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

