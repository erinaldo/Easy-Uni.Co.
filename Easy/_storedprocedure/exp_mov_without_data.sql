if exists (select * from dbo.sysobjects where id = object_id(N'[exp_mov_without_data]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [exp_mov_without_data]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO


CREATE              PROCEDURE [exp_mov_without_data]
(@ayear int
)
AS 
BEGIN
IF (@ayear IS NULL)
BEGIN
	SELECT 	ypay AS Esercizio,
		npay AS Numero,
		yban AS 'Esercizio Transazione',
		nban AS 'N.Transazione',
		amount AS 'Importo Esitato',
		'Mandato' AS 'Tipo Documento'
	FROM banktransaction 
	JOIN payment
		ON banktransaction.kpay = banktransaction.kpay
	WHERE (transactiondate IS NULL) AND (banktransaction.kpay IS NOT NULL)
	UNION
	SELECT 	ypro AS Esercizio,
		npro AS Numero,
		yban AS 'Esercizio Transazione',
		nban AS 'N.Transazione',
		amount AS 'Importo Esitato',
		'Reversale' AS 'Tipo Documento'
	FROM banktransaction
	JOIN proceeds
		ON banktransaction.kpro = banktransaction.kpro 
	WHERE (transactiondate IS NULL) AND (banktransaction.kpro IS NOT NULL)
	ORDER BY 'Tipo Documento', 'Esercizio','Numero'
 END
ELSE
BEGIN
	SELECT  ypay as Esercizio,
		npay as Numero,
		yban as 'Esercizio Transazione',
		nban as 'N.Transazione',
		amount as 'Importo Esitato',
		'Mandato' as 'Tipo Documento'
	FROM banktransaction 
	JOIN payment
		ON banktransaction.kpay = banktransaction.kpay
	WHERE (transactiondate IS NULL) AND (ypay = @ayear)
	
	UNION
	
	SELECT  ypro as Esercizio,
		npro as Numero,
		yban as 'Esercizio Transazione',
		nban as 'N.Transazione',
		amount as 'Importo Esitato',
		'Reversale' as 'Tipo Documento'
	FROM banktransaction 
	JOIN proceeds
		ON banktransaction.kpro = banktransaction.kpro 
	WHERE (transactiondate IS NULL) AND (ypro = @ayear)
	ORDER  BY 'Tipo Documento', 'Esercizio','Numero'
END
END


GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

