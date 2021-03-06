SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[trg_del_amount]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [trg_del_amount]
GO


CREATE  PROCEDURE [trg_del_amount]
(
	@ayear int,
	@movkind char(1),
	@idmov int,
	@paridmov int,
	@nphase tinyint,
	@amount decimal(19,2)
)
AS BEGIN
IF @movkind = 'I'
BEGIN
	IF (@paridmov IS NOT NULL)
	BEGIN
		UPDATE incometotal SET
		available = ISNULL(available,0) - @amount
		WHERE idinc = @paridmov
		AND ayear = @ayear
	END
	DELETE FROM incometotal
	WHERE idinc = @idmov
	AND ayear = @ayear
END
ELSE
BEGIN
	DECLARE @maxexpensephase tinyint
	SELECT @maxexpensephase = MAX(nphase) FROM expensephase
	IF (@nphase = @maxexpensephase)
	BEGIN
		EXEC trg_del_curr_floatfund
		@ayear,
		'E',
		@idmov,
		@amount
	END

	IF (@paridmov IS NOT NULL)
	BEGIN
		UPDATE expensetotal SET
		available = ISNULL(available,0) - @amount
		WHERE idexp = @paridmov
		AND ayear = @ayear
	END
	DELETE FROM expensetotal
	WHERE idexp = @idmov
	AND ayear = @ayear
END
END



GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

