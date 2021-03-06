SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[trigger_i_incomesorted]') and OBJECTPROPERTY(id, N'IsTrigger') = 1)
drop trigger [trigger_i_incomesorted]
GO

CREATE TRIGGER [trigger_i_incomesorted] ON [incomesorted] FOR INSERT
AS BEGIN
	DECLARE @idinc int
	DECLARE @idsor int
	DECLARE @ayear int
 	DECLARE @amount decimal(19,2)
	
	SELECT 
		@idinc = idinc, 
		@idsor = idsor, 
		@ayear= ayear,
		@amount = amount 
	FROM inserted
	
	IF (@ayear IS NULL)
	BEGIN
		SELECT @ayear = ymov FROM income WHERE idinc = @idinc
	END
	
	EXECUTE trg_upd_sorttotal 
	@idsor, 
	@ayear, 
	'totalincome', 
	@amount
	END





GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

