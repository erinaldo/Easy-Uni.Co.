if exists (select * from dbo.sysobjects where id = object_id(N'[esporta_accessori_non_caricati]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [esporta_accessori_non_caricati]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO



CREATE         PROCEDURE [esporta_accessori_non_caricati]  
AS BEGIN
SELECT 
	accessorio.idasset 		AS 'Idasset',
	accessorio.idpiece 		AS 'Idpiece',
	accessorio.lifestart 		AS 'Data Creazione Cespite', 
	accessorio.cu 			AS 'Creato da' , 
	b.idinventory   		AS 'Codice Inventario', 
	ti.description			AS 'Tipo Inventario',
	cespite.ninventory 		AS 'Num. inventario Cespite',
	accessorio.nassetacquire 	AS 'Carico Accessorio', 
	assetunloadkind.codeassetunloadkind 	AS 'Tipo Buono Scarico',
	assetunload.yassetunload 	AS 'Eserc. Buono Scarico',
	assetunload.nassetunload 	AS 'Num. Buono Scarico'
FROM  asset accessorio 
left outer join assetunload on accessorio.idassetunload=assetunload.idassetunload
left outer join assetunloadkind on assetunloadkind.idassetunloadkind=assetunload.idassetunloadkind
JOIN  asset cespite ON accessorio.idasset = cespite.idasset
JOIN  assetacquire b ON cespite.nassetacquire=b.nassetacquire
LEFT  OUTER JOIN inventory  
	ON b.idinventory=inventory.idinventory
LEFT  OUTER JOIN inventorykind ti
	ON inventory.idinventorykind= ti.idinventorykind   
WHERE accessorio.idpiece >1 and cespite.idpiece = 1
     	AND accessorio.nassetacquire IS NULL
ORDER BY accessorio.idasset,accessorio.idpiece
END


GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO
