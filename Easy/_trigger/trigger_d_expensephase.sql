SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[trigger_d_expensephase]') and OBJECTPROPERTY(id, N'IsTrigger') = 1)
drop trigger [trigger_d_expensephase]
GO

CREATE TRIGGER [trigger_d_expensephase] ON [expensephase] FOR DELETE
AS BEGIN
	IF @@ROWCOUNT > 0
	BEGIN
		DECLARE @nphase tinyint
		SELECT @nphase = nphase FROM deleted
		DELETE FROM upbexpensetotal WHERE nphase = @nphase
	END
END

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

