SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[trigger_d_bank]') and OBJECTPROPERTY(id, N'IsTrigger') = 1)
drop trigger [dbo].[trigger_d_bank]
GO

CREATE TRIGGER [dbo].[trigger_d_bank] ON [dbo].[bank] FOR DELETE
AS BEGIN
	IF @@ROWCOUNT > 0
	BEGIN
		DECLARE @idbank varchar(20)
		SELECT @idbank = idbank FROM deleted
		DELETE FROM cab WHERE idbank = @idbank
	END
END

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

