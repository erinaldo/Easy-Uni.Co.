SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[trigger_d_sortingprevexpensevar]') and OBJECTPROPERTY(id, N'IsTrigger') = 1)
drop trigger [trigger_d_sortingprevexpensevar]
GO

CREATE TRIGGER [trigger_d_sortingprevexpensevar] ON [sortingprevexpensevar] FOR DELETE
AS BEGIN
	IF @@ROWCOUNT > 0
	BEGIN
		DECLARE @idsor int
		DECLARE @ayear int
		DECLARE @amount decimal(19,2)
	
		SELECT 
			@idsor = idsor, 
			@ayear = ayear, 
			@amount = -amount 
		FROM deleted
	
		EXECUTE trg_upd_sorttotal 
		@idsor, 
		@ayear, 
		'totexpensevariation', 
		@amount
	END
END



GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

