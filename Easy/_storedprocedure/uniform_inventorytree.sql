if exists (select * from dbo.sysobjects where id = object_id(N'[uniform_inventorytree]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [uniform_inventorytree]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO





CREATE   PROCEDURE uniform_inventorytree
(
	@idsorkind int
)
AS BEGIN
	-- Tabelle da modificare
	-- 1. ASSETVARDETAIL
	-- 2. MANDATEDETAIL
	-- 3. ASSETACQUIRE
	-- 4. INVENTORYSORTINGAMORTIZATIONYEAR
	-- 5. INVENTORYTREESORTING (per IDSORKIND <> @IDSORKIND)

	UPDATE assetvardetail
	SET idinv = inventorytreesorting.idsor
	FROM inventorytreesorting
	JOIN sorting
		ON sorting.idsor = inventorytreesorting.idsor
	WHERE assetvardetail.idinv = inventorytreesorting.idinv
	AND sorting.idsorkind = @idsorkind

	UPDATE mandatedetail
	SET idinv = inventorytreesorting.idsor
	FROM inventorytreesorting
	JOIN sorting
		ON sorting.idsor = inventorytreesorting.idsor
	WHERE mandatedetail.idinv = inventorytreesorting.idinv
	AND sorting.idsorkind = @idsorkind

	UPDATE assetacquire
	SET idinv = inventorytreesorting.idsor
	FROM inventorytreesorting
	JOIN sorting
		ON sorting.idsor = inventorytreesorting.idsor
	WHERE assetacquire.idinv = inventorytreesorting.idinv
	AND sorting.idsorkind = @idsorkind

	UPDATE inventorysortingamortizationyear
	SET idinv = inventorytreesorting.idsor
	FROM inventorytreesorting
	JOIN sorting
		ON sorting.idsor = inventorytreesorting.idsor
	WHERE inventorysortingamortizationyear.idinv = inventorytreesorting.idinv
	AND sorting.idsorkind = @idsorkind

	UPDATE inventorytreesorting
	SET idinv =
		(SELECT ITS.idsor
		FROM inventorytreesorting ITS
		JOIN sorting
			ON sorting.idsor = ITS.idsor
		JOIN sorting EXT
			ON EXT.idsor = inventorytreesorting.idsor
		WHERE inventorytreesorting.idinv = ITS.idinv
		AND sorting.idsorkind = @idsorkind
		AND EXT.idsorkind <> @idsorkind)
END




GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

