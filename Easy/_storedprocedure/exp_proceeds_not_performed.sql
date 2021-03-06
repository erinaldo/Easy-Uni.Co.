if exists (select * from dbo.sysobjects where id = object_id(N'[exp_proceeds_not_performed]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [exp_proceeds_not_performed]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO




CREATE                               PROCEDURE [exp_proceeds_not_performed]
@date datetime,
@ayear int
AS 
BEGIN
SELECT  P.ypro AS 'Esercizio Reversale',
	P.npro AS 'Numero Reversale',
	P.adate AS 'Data Reversale',
	I.nmov AS 'Num.Movimento',
	I.description AS Descrizione,
	I.registry AS Versante,
	I.curramount AS Importo
FROM incomeview I
JOIN proceeds P
	ON I.ypro = P.ypro
	AND I.npro = P.npro
JOIN proceedstransmission pt
	ON pt.kproceedstransmission = p.kproceedstransmission
WHERE (I.ayear IS NULL OR p.ypro=@ayear)
	AND pt.transmissiondate <= @date
	AND
		ISNULL((SELECT SUM(amount)from banktransaction PD
		where PD.kpro=P.kpro and 
		PD.transactiondate <= @date),0) =0
ORDER BY P.ypro,P.npro,I.nmov
END





GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

