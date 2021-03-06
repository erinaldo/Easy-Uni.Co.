SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[trigger_i_sortingprev]') and OBJECTPROPERTY(id, N'IsTrigger') = 1)
drop trigger [trigger_i_sortingprev]
GO

CREATE TRIGGER trigger_i_sortingprev ON sortingprev FOR INSERT AS 
BEGIN
IF @@ROWCOUNT > 0
BEGIN
	DECLARE @idsor int
	DECLARE @ayear smallint
	SELECT @idsor = idsor, @ayear = ayear FROM inserted

	IF ( EXISTS (SELECT * FROM accountingyear WHERE ayear = @ayear + 1)
		AND 
		(((SELECT flag FROM accountingyear  where ayear = @ayear) & 0x0F)>=2)
		)
	BEGIN
		INSERT INTO sortingprev (idsor, ayear, incomeprevision, expenseprevision, cu, ct, lu, lt)
		VALUES (@idsor, @ayear + 1, NULL, NULL, 'TRIGGER', GETDATE(), 'TRIGGER', GETDATE())
	END
END
END

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

