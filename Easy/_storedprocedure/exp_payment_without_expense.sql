if exists (select * from dbo.sysobjects where id = object_id(N'[exp_payment_without_expense]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [exp_payment_without_expense]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO



CREATE      PROCEDURE [exp_payment_without_expense]
@ayear smallint,
@date smalldatetime

AS BEGIN
--	mov. bancari a debito non collegati a mandati o collegati a mandati  trasmessi dopo la data
SELECT  			
	PD.yban as 'Esercizio Transazione', 
	PD.nban as 'Numero Transazione' ,
	P.ypay as 'Esercizio del Mandato' ,       
	P.npay as 'Numero Mandato',                
	isnull( ET.curramount,0) as 'Importo',
	isnull(PD.amount,0) as 'Importo Esitato',
	PD.transactiondate as 'Data Operazione' 
FROM    banktransaction PD 
JOIN    payment P
	ON P.kpay = PD.kpay
JOIN expensetotal ET 
	ON ET.idexp = PD.idexp 
WHERE PD.transactiondate <= @date 
	AND ET.ayear=@ayear 
	AND kind = 'D'
	AND (pd.kpay is null 
		OR NOT EXISTS
			(SELECT *	--PT.transmissiondate 
			FROM paymenttransmission PT  
				
			WHERE PD.kpay = P.kpay 
			AND PT.kpaymenttransmission = P.kpaymenttransmission 
			AND PT.transmissiondate <=@date
			)
		)
END


GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

