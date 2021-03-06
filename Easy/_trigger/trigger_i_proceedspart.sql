SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[trigger_i_proceedspart]') and OBJECTPROPERTY(id, N'IsTrigger') = 1)
drop trigger [trigger_i_proceedspart]
GO


CREATE TRIGGER [trigger_i_proceedspart] ON [proceedspart] FOR INSERT
AS BEGIN
	DECLARE @idinc int
	DECLARE @yproceedspart int
	DECLARE @idfin int
	DECLARE @amount decimal(19,2)
	DECLARE @idupb varchar(36)
	DECLARE @idunderwriting int

	
	SELECT
		@yproceedspart = yproceedspart, 
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
	@yproceedspart,
	@idinc,
	@amount,
	0
	
	IF @idfin IS NOT NULL
	BEGIN
		EXECUTE trg_upd_upbtotal 
		@idfin,
		@idupb, 
		'totproceedspart', 
		@amount
	END
	
	IF (@idfin IS NOT NULL) AND (@idupb IS NOT NULL) AND (@idunderwriting IS NOT NULL)
	BEGIN
		EXECUTE trg_upd_upbunderwritingtotal 
		@idfin,
		@idupb,
		@idunderwriting,
		'totproceedspart',
		@amount
	END
END





GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

