if exists (select * from dbo.sysobjects where id = object_id(N'[show_fin]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [show_fin]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO




CREATE PROCEDURE [show_fin]
(
	@date datetime,
	@idfin int ,
	@finpart char(1)
)
AS BEGIN
--DECLARE @prevision char(1)
--DECLARE @secondaryprev char(1)
DECLARE @fin_kind tinyint
DECLARE @ayear int
SELECT @ayear = YEAR(@date)
SELECT @fin_kind = fin_kind
FROM config
WHERE ayear = @ayear
IF (@fin_kind = 1)
BEGIN
	EXEC show_fin_comp @date,@idfin,@finpart
END
IF (@fin_kind = 3)
BEGIN
	EXEC show_fin_compcash @date,@idfin,@finpart
END
IF (@fin_kind = 2)
BEGIN
	EXEC show_fin_onlycash @date,@idfin,@finpart
END
END


GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

