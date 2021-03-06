SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[trigger_d_sorting]') and OBJECTPROPERTY(id, N'IsTrigger') = 1)
drop trigger [trigger_d_sorting]
GO

CREATE TRIGGER [trigger_d_sorting] ON [sorting] FOR DELETE
AS BEGIN
IF @@ROWCOUNT > 0
BEGIN
	CREATE TABLE #sorting (idsor int)

	INSERT INTO #sorting (idsor)
	SELECT idsor FROM deleted

	DELETE FROM sortinglink
	WHERE idchild IN (SELECT idsor FROM #sorting)

	DELETE FROM sortingprev WHERE idsor IN (SELECT idsor FROM #sorting)
END
END

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

