SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[rebuild_inventorytreelink]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [rebuild_inventorytreelink]
GO

CREATE PROCEDURE rebuild_inventorytreelink
AS BEGIN
	DELETE FROM inventorytreelink

	INSERT INTO inventorytreelink (idchild, nlevel, idparent)
	SELECT idinv, nlevel, idinv
	FROM inventorytree

	WHILE(@@ROWCOUNT > 0)
	BEGIN
		INSERT INTO inventorytreelink (idchild, nlevel, idparent)
		SELECT idchild, (EL.nlevel - 1), paridinv
		FROM inventorytreelink EL
		JOIN inventorytree E
		ON EL.idparent = E.idinv
		WHERE EL.nlevel > 1 AND paridinv IS NOT NULL
		AND NOT EXISTS(SELECT * FROM inventorytreelink EL2 WHERE EL2.idchild = EL.idchild AND EL2.nlevel = (EL.nlevel - 1))
	END
END


GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

