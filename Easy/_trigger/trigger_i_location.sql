SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[trigger_i_location]') and OBJECTPROPERTY(id, N'IsTrigger') = 1)
drop trigger [trigger_i_location]
GO

CREATE TRIGGER [trigger_i_location] ON [location] FOR INSERT
AS BEGIN
IF (@@ROWCOUNT = 0) RETURN
DECLARE @nrowinserted int
SET @nrowinserted = ISNULL((SELECT COUNT(*) FROM inserted),0)

IF (@nrowinserted > 1)
BEGIN
	CREATE TABLE #location (idlocation int, nlevel tinyint)
	
	INSERT INTO #location (idlocation, nlevel)
	SELECT idlocation, nlevel FROM inserted
	
	INSERT INTO locationlink (idchild, nlevel, idparent)
	SELECT idlocation, nlevel, idlocation
	FROM #location
	
	WHILE(@@ROWCOUNT > 0)
	BEGIN
		INSERT INTO locationlink (idchild, nlevel, idparent)
		SELECT IL.idchild, (I.nlevel - 1), I.paridlocation
		FROM locationlink IL
		JOIN location I
		ON IL.idparent = I.idlocation
		WHERE IL.nlevel > 1
		AND NOT EXISTS(SELECT * FROM locationlink IL2 WHERE IL2.idchild = IL.idchild AND IL2.nlevel = (IL.nlevel - 1))
		AND EXISTS(SELECT * FROM #location WHERE #location.idlocation = IL.idchild)
	END
END
ELSE
BEGIN
	DECLARE @idlocation int
	DECLARE @nlevel tinyint
	DECLARE @paridlocation int
	SELECT @idlocation = idlocation, @nlevel = nlevel, @paridlocation = paridlocation FROM inserted

	INSERT INTO locationlink (idchild, nlevel, idparent)
	VALUES(@idlocation, @nlevel, @idlocation)

	DECLARE @currlevel tinyint
	SET @currlevel = @nlevel - 1

	DECLARE @currpar int
	SET @currpar = @paridlocation

	WHILE (@currlevel >= 1)
	BEGIN
		INSERT INTO locationlink (idchild, nlevel, idparent)
		VALUES(@idlocation, @currlevel, @currpar)

		SET @currpar = (SELECT paridlocation FROM location WHERE idlocation = @currpar)
		SET @currlevel = @currlevel - 1
	END
END
END



GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

