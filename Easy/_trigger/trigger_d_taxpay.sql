SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[trigger_d_taxpay]') and OBJECTPROPERTY(id, N'IsTrigger') = 1)
drop trigger [trigger_d_taxpay]
GO

CREATE TRIGGER [trigger_d_taxpay] ON [taxpay] FOR DELETE
AS BEGIN
	IF @@ROWCOUNT > 0
	BEGIN
		DECLARE @ytaxpay int
		DECLARE @ntaxpay integer
		DECLARE @taxcode int
	
		SELECT @ytaxpay = ytaxpay,
		@ntaxpay = ntaxpay,
		@taxcode = taxcode
		FROM deleted
	
		DELETE FROM taxpayexpense
		WHERE ytaxpay = @ytaxpay
		AND ntaxpay = @ntaxpay
		AND taxcode = @taxcode
		
	END
END




GO
setuser
GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

