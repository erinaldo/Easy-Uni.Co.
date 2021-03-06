if exists (select * from dbo.sysobjects where id = object_id(N'[esporta_carichi_senza_beni]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [esporta_carichi_senza_beni]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO




CREATE         PROCEDURE [esporta_carichi_senza_beni]  
AS BEGIN
SELECT 
	nassetacquire AS 'Num. Carico Bene',
	yman   	      AS 'Esercizio Ordine',
	nman          AS 'Numero Ordine',
	rownum	      AS 'Riga Ordine',
	description   AS 'Descrizione',
	adate AS 'Data Contabile',
	CASE flag&2
		WHEN 0 THEN 'Nuova acquisizione'
		else 'Posseduto'
	END 	      AS 'Tipo Carico'
FROM    assetacquire  
WHERE   (select count(*) from asset where asset.nassetacquire =assetacquire.nassetacquire) = 0
ORDER BY nassetacquire
END



GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO
