if exists (select * from dbo.sysobjects where id = object_id(N'[esporta_carichi_amortizzati_senza_buono_flaggati]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [esporta_carichi_amortizzati_senza_buono_flaggati]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO




create         procedure esporta_carichi_amortizzati_senza_buono_flaggati

AS BEGIN

-- carichi bene senza assetload faggati con 'includi in buono di carico' che posseggono ammortamenti

SELECT AQ.nassetacquire AS 'Num. Carico',AQ.description AS 'DESCRIZIONE' , AE.ninventory as 'Num. Inventario',
	I.codeinventory AS 'Tipo Inventario', AM.namortization AS 'Num. Op. Ammortamento' 
	FROM assetacquire AQ 
	JOIN inventory I
		ON AQ.idinventory=I.idinventory
	JOIN asset AE
		ON AQ.nassetacquire = AE.nassetacquire
	JOIN assetamortization AM
		ON AE.idasset=AM.idasset
WHERE
	AQ.idassetload IS NULL
	AND AQ.flag & 1 != 0

END





GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO


