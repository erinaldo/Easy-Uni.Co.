SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[trigger_d_asset]') and OBJECTPROPERTY(id, N'IsTrigger') = 1)
drop trigger [trigger_d_asset]
GO

CREATE                                     TRIGGER [trigger_d_asset] ON asset FOR DELETE
AS BEGIN
	IF @@ROWCOUNT > 0
	BEGIN
		
 		DECLARE @idasset int
 		DECLARE @idpiece int
		SELECT @idasset = idasset, @idpiece=idpiece
		FROM deleted
		if (@idpiece=1) BEGIN
 			DELETE FROM assetmanager WHERE idasset = @idasset
 			DELETE FROM assetlocation WHERE idasset = @idasset
		END
	END
END



GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

