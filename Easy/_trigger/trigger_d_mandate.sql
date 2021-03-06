SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[trigger_d_mandate]') and OBJECTPROPERTY(id, N'IsTrigger') = 1)
drop trigger [trigger_d_mandate]
GO

CREATE   TRIGGER [trigger_d_mandate] ON mandate FOR DELETE
AS BEGIN
IF @@ROWCOUNT > 0
BEGIN
	DECLARE @idmankind varchar(20)
	DECLARE @yman int
	DECLARE @nman int

	SELECT 
		@idmankind = idmankind,
		@yman = yman,
		@nman = nman
	FROM deleted

	DELETE FROM expensemandate 
	WHERE idmankind = @idmankind
	AND yman = @yman
	AND nman = @nman
END
END

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

