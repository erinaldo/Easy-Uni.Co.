SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[trigger_u_proceedspart]') and OBJECTPROPERTY(id, N'IsTrigger') = 1)
drop trigger [trigger_u_proceedspart]
GO

CREATE TRIGGER [trigger_u_proceedspart] ON [proceedspart] FOR UPDATE
AS BEGIN
	(IF UPDATE(amount) OR
	UPDATE(idfin) OR
	UPDATE(idupb))
	BEGIN			
		DECLARE @idinc int
		DECLARE @yproceedspart int
		DECLARE @newidfin int
		DECLARE @oldidfin int
		DECLARE @newamount decimal(19,2)
		DECLARE @oldamount decimal(19,2)
		DECLARE @oldidupb varchar(36)
		DECLARE @newidupb varchar(36)
		DECLARE @idunderwriting int
		
		SELECT @yproceedspart = yproceedspart, 
		@idinc = idinc, 
		@newidfin = idfin, 
		@newidupb = idupb, 
		@newamount = amount
		FROM inserted

		SELECT @oldidfin = idfin, 
		@oldamount = -amount,
		@oldidupb = idupb
		FROM deleted
		
		SELECT
			@idunderwriting = idunderwriting
		FROM income  
		WHERE idinc = @idinc
		
		IF @newamount <> @oldamount
		BEGIN
			EXECUTE trg_upd_partitioned
			@yproceedspart,
			@idinc,
			@newamount,
			@oldamount
		END
		IF (@newidfin IS NOT NULL) AND (@newidupb IS NOT NULL) 
		BEGIN				
			EXECUTE trg_upd_upbtotal 
			@newidfin, 
			@newidupb,
			'totproceedspart', 
			@newamount
		END
		IF (@oldidfin IS NOT NULL) AND  (@oldidupb IS NOT NULL) 
		BEGIN
			EXECUTE trg_upd_upbtotal 
			@oldidfin, 
			@oldidupb,
			'totproceedspart', 
			@oldamount
		END
		
		IF (@newidfin IS NOT NULL) AND (@newidupb IS NOT NULL) AND (@idunderwriting IS NOT NULL)
		BEGIN
		EXECUTE trg_upd_upbunderwritingtotal 
			@newidfin,
			@newidupb,
			@idunderwriting,
			'totproceedspart',
			@newamount
		END
		
		IF (@oldidfin IS NOT NULL) AND (@oldidupb IS NOT NULL) AND (@idunderwriting IS NOT NULL)
		BEGIN
		EXECUTE trg_upd_upbunderwritingtotal 
			@oldidfin,
			@oldidupb,
			@idunderwriting,
			'totproceedspart',
			@oldamount
		END
	END
END





GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

