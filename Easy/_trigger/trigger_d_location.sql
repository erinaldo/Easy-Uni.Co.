SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[trigger_d_location]') and OBJECTPROPERTY(id, N'IsTrigger') = 1)
drop trigger [trigger_d_location]
GO

CREATE TRIGGER [trigger_d_location] ON [location] FOR DELETE
AS BEGIN
IF @@ROWCOUNT > 0
BEGIN
	CREATE TABLE #location (idlocation int)

	INSERT INTO #location (idlocation)
	SELECT idlocation FROM deleted

	DELETE FROM locationlink
	WHERE idchild IN (SELECT idlocation FROM #location)
END
END


GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

