SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[trg_upd_curr_floatfundfin]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [trg_upd_curr_floatfundfin]
GO

CREATE PROCEDURE [trg_upd_curr_floatfundfin]
(
	@ayear int,
	@oldamount decimal(19,2),
	@newamount decimal(19,2)
)
AS BEGIN
DECLARE @diff decimal(19,2)
SELECT @diff = - ISNULL(@oldamount,0) + ISNULL(@newamount,0)
UPDATE currentcashtotal SET currentfloatfund = ISNULL(currentfloatfund,0) + @diff
WHERE ayear = @ayear
END



GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

