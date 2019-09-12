if exists (select * from dbo.sysobjects where id = object_id(N'[closeyear_undocreateesercizio]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [closeyear_undocreateesercizio]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO


CREATE         PROCEDURE closeyear_undocreateesercizio
(
	@ayear int
)
AS BEGIN
DECLARE @nextayear int
SET @nextayear = @ayear + 1
DELETE FROM accountingyear WHERE ayear = @nextayear
DELETE FROM config WHERE ayear = @nextayear
		
UPDATE accountingyear
SET flagyearcreate = 'N'
WHERE ayear = @ayear
END



GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

