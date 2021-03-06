SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[trigger_i_epexp]') and OBJECTPROPERTY(id, N'IsTrigger') = 1)
drop trigger [trigger_i_epexp]
GO


CREATE                   TRIGGER [trigger_i_epexp] ON [epexp] FOR INSERT
AS BEGIN
	DECLARE @yepexp smallint
	DECLARE	@nepexp int
	DECLARE	@amount decimal(19, 2)

	SELECT	@yepexp=yepexp,
                @nepexp=nepexp,
                @amount=amount
	FROM inserted

	INSERT INTO epexptotal
	(
		yepexp,
		nepexp,
		amount
	)
	VALUES
	(
		@yepexp,
		@nepexp,
		@amount
	)

END



GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

