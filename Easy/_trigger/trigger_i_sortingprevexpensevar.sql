SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[trigger_i_sortingprevexpensevar]') and OBJECTPROPERTY(id, N'IsTrigger') = 1)
drop trigger [trigger_i_sortingprevexpensevar]
GO

CREATE TRIGGER [trigger_i_sortingprevexpensevar] ON [sortingprevexpensevar] FOR INSERT
AS BEGIN
	DECLARE @idsor int
	DECLARE @ayear int
	DECLARE @amount decimal(19,2)
	SELECT 
		@idsor = idsor, 
		@ayear = ayear, 
		@amount = amount 
	FROM inserted

	EXECUTE trg_upd_sorttotal 
	@idsor, 
	@ayear, 
	'totexpensevariation', 
	@amount
END



GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

