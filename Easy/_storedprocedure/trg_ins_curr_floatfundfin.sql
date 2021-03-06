SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[trg_ins_curr_floatfundfin]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [trg_ins_curr_floatfundfin]
GO

CREATE  PROCEDURE [trg_ins_curr_floatfundfin]
(
	@ayear int,
	@amount decimal(19,2)
)
AS BEGIN
UPDATE currentcashtotal SET currentfloatfund = ISNULL(currentfloatfund,0) + @amount
WHERE ayear = @ayear
END



GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

