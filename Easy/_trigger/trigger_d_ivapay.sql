SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[trigger_d_ivapay]') and OBJECTPROPERTY(id, N'IsTrigger') = 1)
drop trigger [trigger_d_ivapay]
GO

CREATE TRIGGER [trigger_d_ivapay] ON ivapay FOR DELETE
AS BEGIN
	DECLARE @yivapay int
	DECLARE @nivapay int
	
	SELECT	
	@yivapay = yivapay,
	@nivapay = nivapay
	FROM deleted
	
	DELETE FROM ivapayincome
	WHERE yivapay = @yivapay
	AND nivapay = @nivapay
	
	DELETE FROM ivapayexpense
	WHERE yivapay = @yivapay
	AND nivapay = @nivapay
	
END


GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

