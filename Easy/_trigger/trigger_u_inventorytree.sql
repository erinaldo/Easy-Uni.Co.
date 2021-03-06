SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[trigger_u_inventorytree]') and OBJECTPROPERTY(id, N'IsTrigger') = 1)
drop trigger [dbo].[trigger_u_inventorytree]
GO



CREATE TRIGGER [dbo].[trigger_u_inventorytree] ON [dbo].inventorytree FOR UPDATE
AS BEGIN
DECLARE @idinv int
DECLARE @nlevel tinyint

IF UPDATE(paridinv)
BEGIN
	DECLARE @newidparent int
	SELECT @idinv = idinv, @newidparent = paridinv, @nlevel = nlevel FROM inserted
	
	IF (@newidparent IS NULL) RETURN
	CREATE TABLE #inventorytreelink (idchild int)
	
	INSERT INTO #inventorytreelink
	SELECT idchild
	FROM inventorytreelink
	WHERE inventorytreelink.idparent = @idinv
	
	UPDATE inventorytreelink
	SET idparent = (SELECT idparent FROM inventorytreelink EL2 WHERE EL2.idchild = @newidparent AND EL2.nlevel = inventorytreelink.nlevel)
	FROM #inventorytreelink T
	WHERE inventorytreelink.idchild = T.idchild
	AND nlevel < @nlevel
END
END

SET QUOTED_IDENTIFIER OFF



GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

