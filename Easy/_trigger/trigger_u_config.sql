SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[trigger_u_config]') and OBJECTPROPERTY(id, N'IsTrigger') = 1)
drop trigger [trigger_u_config]
GO


CREATE   TRIGGER [trigger_u_config] ON [config] FOR UPDATE
AS
BEGIN

declare @oldidfin int
declare @oldfinkind int
declare @newidfin int
declare @newfinkind int
declare @ayear smallint

SELECT	@oldidfin=idfinincomesurplus,
		@oldfinkind= isnull(fin_kind,0)
	FROM deleted

set @oldfinkind=isnull(@oldfinkind,99)
set @oldidfin= isnull(@oldidfin,0)


SELECT	@newidfin= isnull(idfinincomesurplus,0),
		@newfinkind= isnull(fin_kind,0),
		@ayear=ayear
	FROM inserted


if       (@oldfinkind<2 and @newfinkind>=2) OR  (@oldfinkind>=2 and @newfinkind<2)  OR 
		(@newfinkind>=2 AND @oldidfin<>@newidfin)
BEGIN
			EXEC rebuild_currentfloatfund @ayear
END


END

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO


