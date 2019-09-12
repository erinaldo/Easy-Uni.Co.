if exists (select * from dbo.sysobjects where id = object_id(N'[trasmele_income_unicredit]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [trasmele_income_unicredit]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO


CREATE        PROCEDURE [trasmele_income_unicredit]
(
	@y int,
	@n int
)
AS BEGIN

	DECLARE @transmissionkind char(1)

	SELECT @transmissionkind = isnull(transmissionkind,'I') FROM proceedstransmission
	WHERE yproceedstransmission = @y and nproceedstransmission = @n

	IF(@transmissionkind = 'I')
	Begin
		EXEC trasmele_income_unicredit_ins @y, @n
	End
	Else
	Begin
		EXEC trasmele_income_unicredit_var @y, @n
	End

END





GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO


