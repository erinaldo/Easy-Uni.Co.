SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[trigger_u_incomesorted]') and OBJECTPROPERTY(id, N'IsTrigger') = 1)
drop trigger [trigger_u_incomesorted]
GO

CREATE   TRIGGER [trigger_u_incomesorted] ON [incomesorted] FOR UPDATE
AS BEGIN
	IF UPDATE(amount)
	BEGIN
 		DECLARE @newayear int
 		DECLARE @oldayear int
		DECLARE @idinc int
		DECLARE @idsor int
 		DECLARE @newamount decimal(19,2)
 		DECLARE @oldamount decimal(19,2)
	
 		SELECT 
			@idinc = idinc, 
			@idsor = idsor, 
			@newamount = amount,
			@newayear = ayear
		FROM inserted
	
		IF (@newayear IS NULL)
		BEGIN
			SELECT @newayear = ymov FROM income WHERE idinc = @idinc
		END
	
 		SELECT @oldamount = -amount,
		@oldayear = ayear
		FROM deleted
	
		IF (@oldayear IS NULL)
		BEGIN
			SELECT @oldayear = ymov FROM income WHERE idinc = @idinc
		END
	
		EXECUTE trg_upd_sorttotal 
		@idsor, 
		@newayear, 
		'totalincome', 
		@newamount
	
		EXECUTE trg_upd_sorttotal 
		@idsor, 
		@oldayear, 
		'totalincome', 
		@oldamount
	END
END




GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

