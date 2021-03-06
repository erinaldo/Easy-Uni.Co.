if exists (select * from dbo.sysobjects where id = object_id(N'[exp_proceeds_trasmitted]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [exp_proceeds_trasmitted]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO
-- exec exp_proceeds_trasmitted {ts '2006-10-07 00:00:00'},2006


CREATE  PROCEDURE [exp_proceeds_trasmitted]
@date smalldatetime,
@ayear smallint
AS BEGIN

/* Versione 1.0.0 del 14/09/2007 ultima modifica: PIERO */

SELECT
	P.ypro AS 'Esercizio Reversale',
	P.npro AS 'Numero Reversale',
	p.adate AS 'Data Reversale',
	SUM(it.curramount) AS 'Importo Totale',
	ISNULL(
		(SELECT SUM(amount)
		FROM banktransaction b
		WHERE b.kpro = il.kpro
			AND b.transactiondate <= @date)
	,0) AS 'Importo Esitato',
	(SUM(it.curramount) - 
	ISNULL(
		(SELECT SUM(amount)
		FROM banktransaction b
		WHERE b.kpro = il.kpro
			AND b.transactiondate <= @date)
	,0)) AS 'Importo Non Esitato'	
	FROM incometotal it 
	JOIN income i 
		ON it.idinc=i.idinc
	JOIN incomelast il 
		ON il.idinc = i.idinc
	JOIN proceeds p 
		ON p.kpro = il.kpro
	JOIN proceedstransmission pt
		ON pt.kproceedstransmission = p.kproceedstransmission
	WHERE p.ypro = @ayear
		AND pt.transmissiondate <= @date
	group by P.ypro, P.npro, p.adate, il.kpro
	HAVING ISNULL(SUM(it.curramount),0)>0 
END


GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

