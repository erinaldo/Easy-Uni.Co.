SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[trigger_d_sortingprev]') and OBJECTPROPERTY(id, N'IsTrigger') = 1)
drop trigger [trigger_d_sortingprev]
GO

CREATE TRIGGER trigger_d_sortingprev ON sortingprev FOR DELETE AS 
BEGIN
IF @@ROWCOUNT > 0
BEGIN
	DECLARE @idsor int

	SELECT @idsor = idsor
	FROM deleted

	DELETE FROM sortedmovementtotal 
	WHERE idsor = @idsor
	END
END



GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

