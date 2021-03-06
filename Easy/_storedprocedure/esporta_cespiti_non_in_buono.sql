if exists (select * from dbo.sysobjects where id = object_id(N'[esporta_cespiti_non_in_buono]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [esporta_cespiti_non_in_buono]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO






create  PROCEDURE esporta_cespiti_non_in_buono

AS BEGIN

SELECT AQ.nassetacquire as 'Num. carico cespite', AQ.description as 'Descrizione', 
	AQ.startnumber as 'Num. Inv. Iniziale',AQ.number as 'Quantità', I.codeinventory as 'Codice Inventario'
	FROM assetacquire AQ 
	JOIN inventory I
		ON I.idinventory = AQ.idinventory
WHERE 	AQ.idassetload IS NULL
	AND AQ.flag & 1 !=0

ORDER BY AQ.nassetacquire

END






GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO


