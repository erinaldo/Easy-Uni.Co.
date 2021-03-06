if exists (select * from dbo.sysobjects where id = object_id(N'[exp_proceeds_without_income]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [exp_proceeds_without_income]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO



CREATE      PROCEDURE [exp_proceeds_without_income]
@ayear smallint,
@date smalldatetime

AS BEGIN
--	mov. bancari a credito non collegati a reversali o collegati a reversali trasmesse dopo la data
SELECT 		
	PD.yban as 'Esercizio Transazione' ,
	PD.nban as 'Numero Transazione',
	P.ypro as 'Esercizio Reversale',       
	P.npro as 'Numero Reversale',                
	isnull( IT.curramount,0) as 'Importo',
	isnull(PD.amount,0) as 'Importo Esitato',
	PD.transactiondate as 'Data Operazione' 
FROM  banktransaction PD 
JOIN  proceeds P
	ON P.kpro = PD.kpro
JOIN incometotal IT 
	ON IT.idinc = PD.idinc 
WHERE PD.transactiondate <= @date 
	AND IT.ayear=@ayear
	--AND ISNULL(PD.amount,0) = ISNULL( IT.curramount,0) 
	AND kind = 'C'
	AND (PD.kpro is null 
		OR NOT EXISTS
			(SELECT *	--PT.transmissiondate 
			FROM proceedstransmission PT  
				
			WHERE PD.kpro = P.kpro
			AND PT.kproceedstransmission = P.kproceedstransmission 
				AND PT.transmissiondate <=@date
			)
		)

END


GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

