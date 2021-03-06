IF  EXISTS (SELECT * FROM sys.triggers WHERE object_id = OBJECT_ID(N'[trigger_d_stocklocation]'))
DROP TRIGGER [trigger_d_stocklocation]
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  TRIGGER [trigger_d_stocklocation] ON [stocklocation] FOR DELETE
AS BEGIN
IF @@ROWCOUNT > 0
BEGIN
	CREATE TABLE #stocklocation (idstocklocation int)

	INSERT INTO #stocklocation (idstocklocation)
	SELECT idstocklocation FROM deleted

	DELETE FROM stocklocationlink
	WHERE idchild IN (SELECT idstocklocation FROM #stocklocation)
END
END


