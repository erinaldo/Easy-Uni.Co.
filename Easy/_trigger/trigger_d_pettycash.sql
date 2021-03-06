SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[trigger_d_pettycash]') and OBJECTPROPERTY(id, N'IsTrigger') = 1)
drop trigger [trigger_d_pettycash]
GO

CREATE TRIGGER [trigger_d_pettycash] ON [pettycash] FOR DELETE
AS BEGIN
IF @@ROWCOUNT > 0
BEGIN
	DECLARE @idpettycash int

	SELECT @idpettycash = idpettycash
	FROM deleted
	DELETE FROM pettycashsetup WHERE idpettycash = @idpettycash
END
END


GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

