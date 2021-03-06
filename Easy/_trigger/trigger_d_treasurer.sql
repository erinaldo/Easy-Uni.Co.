SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[trigger_d_treasurer]') and OBJECTPROPERTY(id, N'IsTrigger') = 1)
drop trigger [trigger_d_treasurer]
GO

CREATE TRIGGER [trigger_d_treasurer] ON treasurer FOR DELETE
AS BEGIN
	IF @@ROWCOUNT > 0
	BEGIN
		DECLARE @idtreasurer int
		SELECT @idtreasurer = idtreasurer FROM deleted
		DELETE FROM treasurerstart WHERE idtreasurer = @idtreasurer
	END
END


GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

