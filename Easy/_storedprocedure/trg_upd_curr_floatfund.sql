SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[trg_upd_curr_floatfund]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [trg_upd_curr_floatfund]
GO

CREATE  PROCEDURE [trg_upd_curr_floatfund]
(
	@ayear int,
	@movkind char(1),
	@idmov int,
	@oldamount decimal(19,2),
	@newamount decimal(19,2)
)
AS BEGIN

IF ISNULL( (SELECT locked from surplus where  ayear = @ayear),'N') = 'S' return

if (ISNULL(@newamount,0) = -ISNULL(@oldamount,0)) RETURN

DECLARE @diff decimal(19,2)
SET @diff =  ISNULL(@newamount,0)+ ISNULL(@oldamount,0) 
IF (@movkind = 'E')
BEGIN
	--spesa:  sottraiamo la differenza tra nuovo e vecchio
	UPDATE currentcashtotal SET currentfloatfund = ISNULL(currentfloatfund,0) - @diff
		WHERE ayear = @ayear

END
ELSE
BEGIN
	---entrata:  sommiamo la differenza tra nuovo e vecchio
	UPDATE currentcashtotal SET currentfloatfund = ISNULL(currentfloatfund,0) + @diff
		WHERE ayear = @ayear
 
END


END




GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

