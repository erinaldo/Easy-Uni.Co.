if exists (select * from dbo.sysobjects where id = object_id(N'[exp_payment_proceeds_without_date]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [exp_payment_proceeds_without_date]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO




CREATE       PROCEDURE [exp_payment_proceeds_without_date]
@date datetime,
@ayear int
AS 
BEGIN
-- Attenzione! le transazioni bancarie considerate sono tutte quelle legate a documenti trasmessi entro la data @date
-- se invece si vuole vedere tutte le transazioni senza transactiondate bisogna eliminare tale filtro e, contestualmente
-- anche il parametro @date che non servirebbe più
SELECT
	B.yban AS 'Esercizio Transazione',
	B.nban AS 'Numero Transazione',
	P.ypay AS 'Esercizio Documento',
	P.npay AS 'Numero Documento',
	ISNULL(B.amount,0) AS 'Importo',
	'Mandato' AS 'Tipo Movimento'
FROM banktransaction B
JOIN payment P
	ON P.kpay = B.kpay
JOIN paymenttransmission PT
	ON PT.kpaymenttransmission = P.kpaymenttransmission
WHERE B.yban = @ayear 
	AND PT.transmissiondate <= @date
	AND B.transactiondate IS NULL
UNION
SELECT
	B.yban AS 'Esercizio Transazione',
	B.nban AS 'Numero Transazione',
	P.ypro AS 'Esercizio Documento',
	P.npro AS 'Numero Documento',
	ISNULL(B.amount,0) AS 'Importo',
	'Reversale' AS 'Tipo Movimento'
FROM banktransaction B
JOIN proceeds P
	ON P.kpro = B.kpro
JOIN proceedstransmission PT
	ON PT.kproceedstransmission = P.kproceedstransmission	
WHERE B.yban = @ayear 
	AND PT.transmissiondate <= @date
	AND B.transactiondate IS NULL
ORDER BY 'Tipo Movimento', 'Esercizio Documento','Numero Documento'
END





GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

