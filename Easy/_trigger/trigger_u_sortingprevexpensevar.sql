SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[trigger_u_sortingprevexpensevar]') and OBJECTPROPERTY(id, N'IsTrigger') = 1)
drop trigger [trigger_u_sortingprevexpensevar]
GO

CREATE TRIGGER [trigger_u_sortingprevexpensevar] ON [sortingprevexpensevar] FOR UPDATE
AS BEGIN
	IF UPDATE(idsor) OR
	UPDATE(amount)
	BEGIN
		DECLARE @ayear int
		DECLARE @newidsor int
		DECLARE @newamount decimal(19,2)
		DECLARE @oldidsor int
		DECLARE @oldamount decimal(19,2)
	
		SELECT
			@newidsor = idsor, 
			@ayear = ayear, 
			@newamount = amount
		FROM inserted
	
		SELECT
			@oldidsor = idsor,
			@oldamount = -amount
		FROM deleted
	
		EXECUTE trg_upd_sorttotal 
		@newidsor, 
		@ayear, 
		'totexpensevariation', 
		@newamount
	
		EXECUTE trg_upd_sorttotal 
		@oldidsor, 
		@ayear, 
		'totexpensevariation', 
		@oldamount
	END
END



GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

