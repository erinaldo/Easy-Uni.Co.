SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[trigger_d_incomeestimate]') and OBJECTPROPERTY(id, N'IsTrigger') = 1)
drop trigger [trigger_d_incomeestimate]
GO

CREATE    TRIGGER [trigger_d_incomeestimate] ON incomeestimate 
FOR DELETE 
AS
	DECLARE @idinc int
	SELECT @idinc = idinc
	FROM deleted
	UPDATE estimatedetail SET idinc_iva = NULL
	WHERE idinc_iva = @idinc
	UPDATE estimatedetail SET idinc_taxable = NULL
	WHERE idinc_taxable = @idinc


GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

