SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[trigger_d_surplus]') and OBJECTPROPERTY(id, N'IsTrigger') = 1)
drop trigger [trigger_d_surplus]
GO

CREATE TRIGGER [trigger_d_surplus] ON [surplus] FOR DELETE
AS BEGIN
	DECLARE @ayear int
	DECLARE @newayear int
	
	SELECT @ayear = ayear FROM inserted
	SET @newayear = @ayear + 1

	DECLARE @idfinincomesurplus int
	SELECT @idfinincomesurplus = idfinincomesurplus FROM config WHERE ayear = @newayear

	IF EXISTS(SELECT * FROM accountingyear WHERE ayear = @newayear) AND (@idfinincomesurplus IS NULL)
	BEGIN
		EXEC rebuild_currentfloatfund @newayear
	END
END


GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO
