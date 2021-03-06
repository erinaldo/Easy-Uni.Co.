SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[trigger_u_epacc]') and OBJECTPROPERTY(id, N'IsTrigger') = 1)
drop trigger [trigger_u_epacc]
GO


CREATE                   TRIGGER [trigger_u_epacc] ON [epacc] FOR UPDATE
AS BEGIN
	DECLARE @idepacc int
	DECLARE @nphase tinyint
	DECLARE @newidaccmotive varchar(36)

	SELECT
		@idepacc = INS.idepacc,
		@nphase = INS.nphase,
		@newidaccmotive = INS.idaccmotive
	FROM inserted INS
	

	DECLARE @oldidaccmotive varchar(36)

	SELECT @oldidaccmotive = idaccmotive		
	FROM deleted


	IF	(isnull(@newidaccmotive,'') <> isnull( @oldidaccmotive,'') and @nphase=1)
	BEGIN
		update epacc set idaccmotive=@newidaccmotive where paridepacc=@idepacc
	END

END




GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

