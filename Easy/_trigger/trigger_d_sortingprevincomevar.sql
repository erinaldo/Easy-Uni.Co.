SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[trigger_d_sortingprevincomevar]') and OBJECTPROPERTY(id, N'IsTrigger') = 1)
drop trigger [trigger_d_sortingprevincomevar]
GO

CREATE TRIGGER [trigger_d_sortingprevincomevar] ON [sortingprevincomevar] FOR DELETE
AS BEGIN
IF @@ROWCOUNT > 0
BEGIN
	DECLARE @idsor varchar(32)
	DECLARE @ayear int
	DECLARE @amount float

	SELECT 
	@idsor = idsor, 
	@ayear = ayear, 
	@amount = -amount FROM deleted

	EXECUTE trg_upd_sorttotal 
	@idsor, 
	@ayear, 
	'totincomevariation', 
	@amount
END
END



GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

