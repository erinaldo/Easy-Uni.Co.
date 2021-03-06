SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[trigger_i_upbyear]') and OBJECTPROPERTY(id, N'IsTrigger') = 1)
drop trigger [trigger_i_upbyear]
GO

CREATE TRIGGER [trigger_i_upbyear] ON [upbyear] FOR INSERT
AS BEGIN
	
	DECLARE @idupb varchar(36)
 	DECLARE @ayear int
	declare @revenueprevision decimal(19,2)
	declare @costprevision decimal(19,2)

	SELECT 
	@idupb = idupb, 
	@ayear = ayear, 
	@revenueprevision = revenueprevision, 
	@costprevision = costprevision
	FROM inserted

	if not exists (select * from account where ayear =@ayear+1) return
	if exists (select * from upbyear where ayear =@ayear+1 and idupb=@idupb) return


 	insert into upbyear (ayear,idupb,revenueprevision,costprevision,
								ct,cu,lt,lu) 
					values ( @ayear+1,@idupb,@revenueprevision,@costprevision,									
									getdate(),'trigger',getdate(),'trigger')

END





GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

