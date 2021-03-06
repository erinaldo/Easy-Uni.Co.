SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[rebuild_locationlink]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [rebuild_locationlink]
GO

CREATE PROCEDURE rebuild_locationlink
AS BEGIN
	DELETE FROM locationlink

	INSERT INTO locationlink (idchild, nlevel, idparent)
	SELECT idlocation, nlevel, idlocation
	FROM location

	WHILE(@@ROWCOUNT > 0)
	BEGIN
		INSERT INTO locationlink (idchild, nlevel, idparent)
		SELECT idchild, (EL.nlevel - 1), paridlocation
		FROM locationlink EL
		JOIN location E
		ON EL.idparent = E.idlocation
		WHERE EL.nlevel > 1 AND paridlocation IS NOT NULL
		AND NOT EXISTS(SELECT * FROM locationlink EL2 WHERE EL2.idchild = EL.idchild AND EL2.nlevel = (EL.nlevel - 1))
	END
END


GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

