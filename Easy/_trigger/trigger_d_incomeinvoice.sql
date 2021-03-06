SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[trigger_d_incomeinvoice]') and OBJECTPROPERTY(id, N'IsTrigger') = 1)
drop trigger [trigger_d_incomeinvoice]
GO

CREATE    TRIGGER [trigger_d_incomeinvoice] ON incomeinvoice 
FOR DELETE 
AS
	DECLARE @idinc int
	SELECT @idinc = idinc
	FROM deleted
	UPDATE invoicedetail SET idinc_iva = NULL
	WHERE idinc_iva = @idinc
	UPDATE invoicedetail SET idinc_taxable = NULL
	WHERE idinc_taxable = @idinc


GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

