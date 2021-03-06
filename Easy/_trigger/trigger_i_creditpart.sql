SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[trigger_i_creditpart]') and OBJECTPROPERTY(id, N'IsTrigger') = 1)
drop trigger [trigger_i_creditpart]
GO


CREATE TRIGGER [trigger_i_creditpart] ON [creditpart] FOR INSERT
AS BEGIN
 	DECLARE @idinc int
 	DECLARE @ycreditpart int
 	DECLARE @idfin int
	DECLARE @idupb varchar(36)
 	DECLARE @amount decimal(19,2)
 	DECLARE @idunderwriting int

 	SELECT
		@ycreditpart = ycreditpart, 
		@idinc = idinc, 
		@idfin = idfin, 
		@idupb = idupb,
		@amount = amount
 	FROM inserted
	
	SELECT
		@idunderwriting = idunderwriting
	FROM income  
	WHERE idinc = @idinc
	
	
	EXECUTE trg_upd_partitioned
	@ycreditpart,
	@idinc,
	@amount,
	0

	IF @idfin IS NOT NULL
	BEGIN
		EXECUTE trg_upd_upbtotal 
		@idfin, 
		@idupb,
		'totcreditpart', 
		@amount
	END
	
	IF (@idfin IS NOT NULL) AND (@idupb IS NOT NULL) AND (@idunderwriting IS NOT NULL)
	BEGIN
		EXECUTE trg_upd_upbunderwritingtotal 
		@idfin,
		@idupb,
		@idunderwriting,
		'totcreditpart',
		@amount
	END
END






GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

