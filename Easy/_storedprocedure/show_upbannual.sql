if exists (select * from dbo.sysobjects where id = object_id(N'[show_upbannual]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [show_upbannual]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO





CREATE            PROCEDURE [show_upbannual]
	@date datetime,
	@idupb varchar(36)
	AS
	BEGIN
		DECLARE @fin_kind tinyint
		DECLARE @ayear int
		SELECT  @ayear = YEAR(@date)
		SELECT  @fin_kind = fin_kind
		FROM config
		WHERE ayear = @ayear
		IF (@fin_kind = 1)
			EXEC show_upbannual_comp @date,@idupb
		IF (@fin_kind = 3)
			EXEC show_upbannual_compcash @date,@idupb
		IF (@fin_kind = 2)
			EXEC show_upbannual_onlycash @date,@idupb
	END



GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

