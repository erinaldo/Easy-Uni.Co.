SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[trigger_d_invoicekind]') and OBJECTPROPERTY(id, N'IsTrigger') = 1)
drop trigger [trigger_d_invoicekind]
GO

CREATE       TRIGGER [trigger_d_invoicekind] ON invoicekind FOR DELETE
AS BEGIN
	IF @@ROWCOUNT > 0
	BEGIN
		DECLARE @idinvkind int
		SELECT @idinvkind = idinvkind FROM deleted
		DELETE FROM invoicekindregisterkind WHERE idinvkind = @idinvkind
	END
END



GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

