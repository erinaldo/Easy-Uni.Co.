if exists (select * from dbo.sysobjects where id = object_id(N'[esporta_accessori_senza_beni]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [esporta_accessori_senza_beni]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO





CREATE         PROCEDURE [esporta_accessori_senza_beni]  
AS BEGIN
SELECT 
	accessorio.idpiece 		AS 'Idpiece',
	accessorio.idasset 		AS 'Idasset',
	accessorio.nassetacquire	AS 'Carico Accessorio', 
	assetloadkind.codeassetloadkind 	AS 'Tipo Buono Carico',
	assetload.yassetload 	AS 'Eserc. Buono Carico',
	assetload.nassetload 	AS 'Num. Buono Carico',
	assetunloadkind.codeassetunloadkind 	AS 'Tipo Buono Scarico',
	assetunload.yassetunload 	AS 'Eserc. Buono Scarico',
	assetunload.nassetunload 	AS 'Num. Buono Scarico'
FROM asset accessorio 
	LEFT OUTER JOIN assetacquire on accessorio.nassetacquire=assetacquire.nassetacquire
	left outer join assetload on assetacquire.idassetload=assetload.idassetload
	left outer join assetloadkind on assetloadkind.idassetloadkind=assetload.idassetloadkind
	left outer join assetunload on assetunload.idassetunload=accessorio.idassetunload
	left outer join assetunloadkind on assetunloadkind.idassetunloadkind=assetunload.idassetunloadkind
WHERE 	accessorio.idpiece>1
	AND accessorio.idasset not in (select idasset from asset where idpiece = 1)
ORDER BY accessorio.idasset,accessorio.idpiece
END


GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO
