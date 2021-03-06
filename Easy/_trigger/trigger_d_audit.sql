SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[trigger_d_audit]') and OBJECTPROPERTY(id, N'IsTrigger') = 1)
drop trigger [trigger_d_audit]
GO

CREATE     TRIGGER [trigger_d_audit] ON [audit] FOR DELETE
AS BEGIN
	IF @@ROWCOUNT > 0
	BEGIN
		DECLARE @idaudit varchar(25)
		SELECT @idaudit = idaudit FROM deleted
		DELETE FROM	auditcheck 
		WHERE idaudit = @idaudit 
	END
END


GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

