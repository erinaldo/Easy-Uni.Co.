IF  EXISTS (SELECT * FROM sys.triggers WHERE object_id = OBJECT_ID(N'[trigger_i_stocklocation]'))
DROP TRIGGER [trigger_i_stocklocation]
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TRIGGER [trigger_i_stocklocation] ON [stocklocation] FOR INSERT
AS BEGIN
IF (@@ROWCOUNT = 0) RETURN
DECLARE @nrowinserted int
SET @nrowinserted = ISNULL((SELECT COUNT(*) FROM inserted),0)

IF (@nrowinserted > 1)
BEGIN
	CREATE TABLE #stocklocation (idstocklocation int, nlevel tinyint)
	
	INSERT INTO #stocklocation (idstocklocation, nlevel)
	SELECT idstocklocation, nlevel FROM inserted
	
	INSERT INTO stocklocationlink (idchild, nlevel, idparent)
	SELECT idstocklocation, nlevel, idstocklocation
	FROM #stocklocation
	
	WHILE(@@ROWCOUNT > 0)
	BEGIN
		INSERT INTO stocklocationlink (idchild, nlevel, idparent)
		SELECT IL.idchild, (I.nlevel - 1), I.paridstocklocation
		FROM stocklocationlink IL
		JOIN stocklocation I
		ON IL.idparent = I.idstocklocation
		WHERE IL.nlevel > 1
		AND NOT EXISTS(SELECT * FROM stocklocationlink IL2 WHERE IL2.idchild = IL.idchild AND IL2.nlevel = (IL.nlevel - 1))
		AND EXISTS(SELECT * FROM #stocklocation WHERE #stocklocation.idstocklocation = IL.idchild)
	END
END
ELSE
BEGIN
	DECLARE @idstocklocation int
	DECLARE @nlevel tinyint
	DECLARE @paridstocklocation int
	SELECT @idstocklocation = idstocklocation, @nlevel = nlevel, @paridstocklocation = paridstocklocation FROM inserted

	INSERT INTO stocklocationlink (idchild, nlevel, idparent)
	VALUES(@idstocklocation, @nlevel, @idstocklocation)

	DECLARE @currlevel tinyint
	SET @currlevel = @nlevel - 1

	DECLARE @currpar int
	SET @currpar = @paridstocklocation

	WHILE (@currlevel >= 1)
	BEGIN
		INSERT INTO stocklocationlink (idchild, nlevel, idparent)
		VALUES(@idstocklocation, @currlevel, @currpar)

		SET @currpar = (SELECT paridstocklocation FROM stocklocation WHERE idstocklocation = @currpar)
		SET @currlevel = @currlevel - 1
	END
END
END



