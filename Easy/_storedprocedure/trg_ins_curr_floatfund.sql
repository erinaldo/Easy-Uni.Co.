SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[trg_ins_curr_floatfund]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [trg_ins_curr_floatfund]
GO


CREATE  PROCEDURE [trg_ins_curr_floatfund]
(
	@ayear int,
	@movkind char(1),
	@idmov int,
	@amount decimal(19,2)
)
AS BEGIN


IF ISNULL( (SELECT locked from surplus where  ayear = @ayear),'N') = 'S' return

set @amount = isnull(@amount,0)

IF (@movkind = 'I' and @amount<>0)
BEGIN
	UPDATE currentcashtotal SET currentfloatfund = ISNULL(currentfloatfund,0) + @amount
				WHERE ayear = @ayear
END
IF (@movkind = 'E' and @amount<>0)
BEGIN
	UPDATE currentcashtotal SET currentfloatfund = ISNULL(currentfloatfund,0) - @amount
				WHERE ayear = @ayear

END
END




GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

