SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[rebuild_sortinglink]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [rebuild_sortinglink]
GO

CREATE PROCEDURE rebuild_sortinglink
AS BEGIN
	DELETE FROM sortinglink

	INSERT INTO sortinglink (idchild, nlevel, idparent)
	SELECT idsor, nlevel, idsor
	FROM sorting

	WHILE(@@ROWCOUNT > 0)
	BEGIN
		INSERT INTO sortinglink (idchild, nlevel, idparent)
		SELECT idchild, (EL.nlevel - 1), paridsor
		FROM sortinglink EL
		JOIN sorting E
			ON EL.idparent = E.idsor
		WHERE EL.nlevel > 1 AND paridsor IS NOT NULL
		AND NOT EXISTS(SELECT * FROM sortinglink EL2 WHERE EL2.idchild = EL.idchild AND EL2.nlevel = (EL.nlevel - 1))
	END
END


GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

