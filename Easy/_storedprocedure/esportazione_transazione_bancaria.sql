if exists (select * from dbo.sysobjects where id = object_id(N'[esportazione_transazione_bancaria]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [esportazione_transazione_bancaria]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO


--esportazione_transazione_bancaria 2007 ,'D'

CREATE        PROCEDURE [esportazione_transazione_bancaria]
@year smallint,
@kind char


AS BEGIN
/* Versione 1.0.0 del 05/09/2007 ultima modifica: SARA */
IF @kind='C'  --Movimenti a credito


SELECT  a.nban as 'Progressivo' ,
	a.transactiondate as 'Data transazione',
	a.valuedate as 'Data Valuta',
	p.npro as 'Numero Reversale',
	p.ypro as 'Esercizio Reversale',
	--r.title 'Creditore',
	a.amount 'Importo Esitato'
FROM banktransaction a           
JOIN proceeds p
	on a.kpro = p.kpro
LEFT OUTER JOIN incomelast b
	on a.idpro = b.idpro 
	and b.kpro = p.kpro
LEFT OUTER JOIN income i 
	on a.idinc = i.idinc 
left outer join registry r
	on i.idreg = r.idreg
WHERE a.kind = @kind and p.ypro=@year
ELSE   --Movimenti a debito
SELECT  a.nban as 'Progressivo' ,
	a.transactiondate as 'Data transazione' ,
	a.valuedate as 'Data Valuta',
	p.npay as 'Numero Mandato' ,
	p.ypay as 'Esercizio Mandato' ,
	c.title 'Creditore', 	
	a.amount 'Importo Esitato'
FROM banktransaction a 
JOIN payment p
	on a.kpay = p.kpay
LEFT OUTER JOIN expenselast b 
	on a.idpay =b.idpay 
	and b.kpay = p.kpay
LEFT OUTER JOIN expense e
	on  e.idexp = b.idexp
LEFT OUTER join registry c 
	on e.idreg= c.idreg
WHERE a.kind=@kind and p.ypay=@year
END

GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

