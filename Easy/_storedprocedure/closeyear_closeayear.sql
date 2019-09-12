if exists (select * from dbo.sysobjects where id = object_id(N'[closeyear_closeayear]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [closeyear_closeayear]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO



CREATE         PROCEDURE [closeyear_closeayear]
(
	@ayear int
)
AS BEGIN
--azzero i bit da 0 a 3 e poi imposto il valore 6 su questi flag
UPDATE accountingyear SET flag = flag&0xF0 WHERE ayear = @ayear
UPDATE accountingyear SET flag = flag|0x06 WHERE ayear = @ayear
END



GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO



