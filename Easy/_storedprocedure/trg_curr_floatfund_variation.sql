SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[trg_curr_floatfund_variation]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [trg_curr_floatfund_variation]
GO

CREATE  PROCEDURE [trg_curr_floatfund_variation]
(
	@ayear int,
	@movkind char(1),
	@idmov int,
	@oldamount decimal(19,2),
	@newamount decimal(19,2)
)
AS BEGIN
DECLARE @diff decimal(19,2)
IF (@movkind = 'E')
BEGIN
	IF ((ISNULL(@newamount,0) <> ISNULL(ABS(@oldamount),0)) OR
	   (@newamount IS NOT NULL AND @oldamount IS NULL)
	   OR (@newamount IS NULL AND @oldamount IS NOT NULL))
	BEGIN
		SELECT @diff = - ISNULL(@oldamount,0) - ISNULL(@newamount,0)
		UPDATE currentcashtotal SET currentfloatfund = ISNULL(currentfloatfund,0) + @diff
		WHERE ayear = @ayear
	END
END
END




GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

