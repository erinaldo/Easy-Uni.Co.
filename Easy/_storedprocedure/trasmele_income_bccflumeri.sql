--setuser 'amm'
if exists (select * from dbo.sysobjects where id = object_id(N'[trasmele_income_bccflumeri]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [trasmele_income_bccflumeri]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO
 
CREATE PROCEDURE [trasmele_income_bccflumeri]
(
	@y int,
	@n int
)
AS BEGIN
DECLARE @transmissionkind char(1)
SELECT @transmissionkind      = transmissionkind
FROM   proceedstransmission 
WHERE  nproceedstransmission = @n
AND    yproceedstransmission = @y

IF (ISNULL(@transmissionkind, 'I') = 'I')
BEGIN
	EXEC trasmele_income_bccflumeri_ins @y,@n
END
IF (ISNULL(@transmissionkind, 'I') = 'V')
BEGIN
	EXEC trasmele_income_bccflumeri_var @y,@n
END


END
 

GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO
