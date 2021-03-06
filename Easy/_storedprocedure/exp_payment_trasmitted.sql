if exists (select * from dbo.sysobjects where id = object_id(N'[exp_payment_trasmitted]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [exp_payment_trasmitted]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO



CREATE                     PROCEDURE [exp_payment_trasmitted]
@date datetime,
@ayear int
AS 
BEGIN
/* Versione 1.0.0 del 05/09/2007 ultima modifica: SARA */
SELECT  P.ypay  AS 'Esercizio Mandato',
	P.npay AS 'Numero Mandato',
	P.adate AS 'Data Mandato',
	SUM(ET.curramount) AS 'Importo totale',
	ISNULL(
		(SELECT SUM(amount)
		FROM banktransaction B
		WHERE B.kpay = EL.kpay
		AND B.transactiondate <= @date)
	,0) AS 'Importo Esitato',
	(SUM(ET.curramount) -
	ISNULL(
		(SELECT SUM(amount)
		FROM banktransaction B
		WHERE B.kpay = EL.kpay
		AND B.transactiondate <= @date)
	,0)) AS 'Importo Non Esitato'
FROM expensetotal ET 
JOIN expense E 
	ON ET.idexp = E.idexp  	AND ET.ayear = @ayear
JOIN expenselast EL 
	ON EL.idexp = E.idexp  
JOIN payment P 
	ON P.kpay = EL.kpay
JOIN paymenttransmission pt
	ON PT.kpaymenttransmission = P.kpaymenttransmission
WHERE P.ypay = @ayear
	AND PT.transmissiondate <= @date
	AND PT.ypaymenttransmission = @ayear
GROUP BY P.ypay,P.npay,P.adate,EL.kpay 
HAVING ISNULL(SUM(ET.curramount),0)>0 
END



GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

