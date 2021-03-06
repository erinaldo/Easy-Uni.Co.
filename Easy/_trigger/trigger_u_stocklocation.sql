IF  EXISTS (SELECT * FROM sys.triggers WHERE object_id = OBJECT_ID(N'[trigger_u_stocklocation]'))
DROP TRIGGER [trigger_u_stocklocation]
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE    TRIGGER [trigger_u_stocklocation] ON [stocklocation] FOR UPDATE
AS BEGIN
DECLARE @idstocklocation int
DECLARE @nlevel tinyint

IF UPDATE(paridstocklocation)
BEGIN
	DECLARE @newidparent int
	SELECT @idstocklocation = idstocklocation, @newidparent = paridstocklocation, @nlevel = nlevel FROM inserted
	
	IF (@newidparent IS NULL) RETURN
	CREATE TABLE #stocklocationlink (idchild int)
	
	INSERT INTO #stocklocationlink
	SELECT idchild
	FROM stocklocationlink
	WHERE stocklocationlink.idparent = @idstocklocation
	
	UPDATE stocklocationlink
	SET idparent = (SELECT idparent FROM stocklocationlink EL2 WHERE EL2.idchild = @newidparent AND EL2.nlevel = stocklocationlink.nlevel)
	FROM #stocklocationlink T
	WHERE stocklocationlink.idchild = T.idchild
	AND nlevel < @nlevel
END
END

SET QUOTED_IDENTIFIER OFF



