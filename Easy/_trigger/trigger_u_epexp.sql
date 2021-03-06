SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[trigger_u_epexp]') and OBJECTPROPERTY(id, N'IsTrigger') = 1)
drop trigger [trigger_u_epexp]
GO


CREATE                   TRIGGER [trigger_u_epexp] ON [epexp] FOR UPDATE
AS BEGIN
	
	DECLARE @idepexp int
	DECLARE @nphase tinyint
	DECLARE @newidaccmotive varchar(36)

	SELECT
		@idepexp = INS.idepexp,
		@nphase = INS.nphase,
		@newidaccmotive = INS.idaccmotive
	FROM inserted INS
	

	DECLARE @oldidaccmotive varchar(36)

	SELECT @oldidaccmotive = idaccmotive		
	FROM deleted


	IF	(isnull(@newidaccmotive,'') <> isnull( @oldidaccmotive,'') and @nphase=1)
	BEGIN
		update epexp set idaccmotive=@newidaccmotive where paridepexp=@idepexp
	END
END




GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

