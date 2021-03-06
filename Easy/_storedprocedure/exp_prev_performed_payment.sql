if exists (select * from dbo.sysobjects where id = object_id(N'[exp_prev_performed_payment]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [exp_prev_performed_payment]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO


CREATE                    procedure [exp_prev_performed_payment]
@date datetime,
@ayear int 
AS 
BEGIN
/* Versione 1.0.0 del 05/09/2007 ultima modifica: SARA */
DECLARE @DEC_31_ayearprevious datetime
SET @DEC_31_ayearprevious = CONVERT(datetime,'31-12-' + CONVERT(varchar(4),(@ayear-1)), 105)
	
SELECT 
	P.ypay AS 'Esercizio Mandato',
	P.npay AS 'Numero Mandato',
	P.adate AS 'Data Mandato',
	SUM(ET.curramount) AS 'Importo totale',
	ISNULL(
		(SELECT SUM(PD.amount)
		FROM banktransaction PD 
		WHERE PD.kpay = EL.kpay
		AND PD.transactiondate > @DEC_31_ayearprevious
		AND PD.transactiondate <= @date)
	,0) AS 'Importo esitato nell''esercizio corrente, alla data'
FROM expensetotal ET 
JOIN expense E 
	ON ET.idexp = E.idexp
JOIN expenselast EL 
	ON ET.idexp = E.idexp
JOIN payment P 
	ON  P.kpay = EL.kpay 
JOIN paymenttransmission PT
	ON PT.kpaymenttransmission = P.kpaymenttransmission
WHERE PT.transmissiondate <= @date
	AND P.ypay = (@ayear - 1)
GROUP BY P.ypay, P.npay, P.adate, EL.kpay 
HAVING ISNULL(SUM(ET.curramount),0)>0
	AND ISNULL(
		(SELECT SUM(PD.amount)
		FROM banktransaction PD 
		WHERE PD.kpay = EL.kpay
		AND PD.transactiondate > @DEC_31_ayearprevious
		AND PD.transactiondate <= @date)
	,0) >0
END



GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

