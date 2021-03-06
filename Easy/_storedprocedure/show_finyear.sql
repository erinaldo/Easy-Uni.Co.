if exists (select * from dbo.sysobjects where id = object_id(N'[show_finyear]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [show_finyear]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO




CREATE PROCEDURE [show_finyear]
(
	@date datetime,
	@idupb varchar(36),
	@idfin int,
	@finpart char(1)
)
AS BEGIN
DECLARE @fin_kind tinyint
DECLARE @ayear int
SELECT @ayear = YEAR(@date)

SELECT @fin_kind = ISNULL(fin_kind,0)
FROM config
WHERE ayear = @ayear
IF (@fin_kind = 1)
BEGIN
	EXEC show_finyear_comp @date,@idupb,@idfin,@finpart
END
IF (@fin_kind = 3)
BEGIN
	EXEC show_finyear_compcash @date,@idupb,@idfin,@finpart
END
IF (@fin_kind = 2)
BEGIN
	EXEC show_finyear_onlycash @date,@idupb,@idfin,@finpart
END
END


GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

