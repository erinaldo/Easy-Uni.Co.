if exists (select * from dbo.sysobjects where id = object_id(N'[exp_payment_not_performed]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [exp_payment_not_performed]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO


-- ELENCO MANDATI NON ESITATI
CREATE                          PROCEDURE [exp_payment_not_performed]
@date datetime,  -- data in cui si effettua l'interrogazione
@ayear  int 	 -- anno dei mandati da controllare
AS 
BEGIN
SELECT  P.ypay AS 'Esercizio Mandato',
	P.npay AS 'Numero Mandato',
	P.adate AS 'Data Mandato',
	E.nmov AS 'Num. Movimento',
	E.description AS Descrizione,
	E.registry AS Percipiente,
	E.curramount AS Importo
FROM expenseview E
JOIN payment P
	ON E.ypay = P.ypay
	AND E.npay = P.npay
JOIN paymenttransmission PT
	ON PT.kpaymenttransmission = P.kpaymenttransmission
WHERE (E.ayear IS NULL OR p.ypay = @ayear)
	AND PT.transmissiondate <= @date
	AND
		ISNULL((SELECT SUM(amount)from banktransaction PD
		where PD.kpay=P.kpay and
		PD.transactiondate <= @date),0) =0
ORDER BY E.ypay,E.npay,E.nmov
END


GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

