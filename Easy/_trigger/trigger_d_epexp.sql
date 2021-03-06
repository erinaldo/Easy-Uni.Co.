SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[trigger_d_epexp]') and OBJECTPROPERTY(id, N'IsTrigger') = 1)
drop trigger [trigger_d_epexp]
GO


CREATE                   TRIGGER [trigger_d_epexp] ON [epexp] FOR DELETE
AS BEGIN

	DECLARE @idepexp int

	SELECT	@idepexp = idepexp
                
	FROM deleted
	
	DELETE FROM  epexptotal WHERE idepexp = @idepexp

	-- copiato da trigger_delete_expenseyear
	
	CREATE TABLE #epexp (idepexp int,  nphase tinyint)
	INSERT INTO #epexp (idepexp, nphase)
	SELECT idepexp,  nphase FROM deleted

    DELETE FROM epexpyear WHERE idepexp IN 
	(SELECT idepexp FROM #epexp) AND amount = 0

END




GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

