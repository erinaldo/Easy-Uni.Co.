if exists (select * from dbo.sysobjects where id = object_id(N'[esporta_carichi_accessori_quantita_errata]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [esporta_carichi_accessori_quantita_errata]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO


CREATE         PROCEDURE [esporta_carichi_accessori_quantita_errata]  
AS BEGIN
SELECT 
	assetacquire.nassetacquire AS 'Num. Carico Accessorio',
	yman   	      		   AS 'Esercizio Ordine',
	nman          		   AS 'Numero Ordine',
	rownum	      		   AS 'Riga Ordine',
	description   		   AS 'Descrizione',
	number        		   AS 'Quantita',
	(select count(*) 
	   from asset 
	  where nassetacquire= assetacquire.nassetacquire
	  and asset.idpiece>1)  AS 'Accessori',
	adate AS 'Data Contabile'
FROM    assetacquire  
JOIN    asset 
	ON asset.nassetacquire = assetacquire.nassetacquire
	AND asset.idpiece > 1
WHERE   (number is null or number<1 OR 
	(select count(*) from asset accessorio 
	 where accessorio.nassetacquire=assetacquire.nassetacquire
	 AND   idpiece >1) not in (0,number))
ORDER BY assetacquire.nassetacquire
END



GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

