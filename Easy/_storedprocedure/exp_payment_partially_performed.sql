if exists (select * from dbo.sysobjects where id = object_id(N'[exp_payment_partially_performed]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [exp_payment_partially_performed]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

CREATE  PROCEDURE [exp_payment_partially_performed]
@date smalldatetime,
@ayear  smallint
AS BEGIN

/* Versione 1.0.0 del 14/09/2007 ultima modifica: PIERO */

	SELECT p.ypay AS 'Esercizio Mandato',
	p.npay AS 'Numero Mandato',
	P.adate AS 'Data Mandato',
	SUM(ET.curramount) AS 'Importo totale' ,
	ISNULL(
		(SELECT SUM(pd.amount)
		FROM banktransaction pd
		WHERE pd.kpay = el.kpay
		AND pd.transactiondate <= @date)
	,0) AS 'Importo Esitato',
	(SUM(ET.curramount) -
	ISNULL(
		(SELECT SUM(pd.amount)
		FROM banktransaction pd
		WHERE pd.kpay = el.kpay
		AND pd.transactiondate <= @date)
	,0)) AS 'Importo Non Esitato'
	FROM expensetotal et 
	JOIN expense e
		ON et.idexp=e.idexp
	JOIN expenselast el
		ON el.idexp=e.idexp
	JOIN payment p
		ON  p.kpay = el.kpay
	JOIN paymenttransmission pt
		ON pt.kpaymenttransmission = p.kpaymenttransmission
	WHERE pt.transmissiondate <= @date
		AND p.ypay = @ayear
	GROUP BY P.ypay,P.npay,P.adate,el.kpay 
	HAVING ISNULL(SUM(ET.curramount),0)>0
		AND ISNULL(SUM(ET.curramount),0) - 
	ISNULL(
		(SELECT SUM(pd.amount)
		FROM banktransaction pd
		WHERE pd.kpay = el.kpay
		AND pd.transactiondate <= @date)
	,0) > 0
	AND
	ISNULL(
		(SELECT SUM(pd.amount)
		FROM banktransaction pd
		WHERE pd.kpay = el.kpay
		AND pd.transactiondate <= @date)
	,0) > 0
	

END


GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

