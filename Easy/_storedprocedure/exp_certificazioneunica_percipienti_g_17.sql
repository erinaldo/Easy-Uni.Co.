if exists (select * from dbo.sysobjects where id = object_id(N'[exp_certificazioneunica_percipienti_g_17]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [exp_certificazioneunica_percipienti_g_17]
GO
 
--exec [exp_certificazioneunica_percipienti_g_17]  NULL
CREATE PROCEDURE [exp_certificazioneunica_percipienti_g_17]
(
	@cf varchar(20)
 )
 -- estraggo l'elenco dei percipienti, autonomi, che hanno eseguito prestazioni mappate con il Record H
 
AS BEGIN
	declare @annodichiarazione int
	set @annodichiarazione = 2017

	declare @annoredditi int
	set @annoredditi = 2016

	declare @31dic16 datetime
	set @31dic16 = dateadd(yy, @annoredditi-2000, {d '2000-12-31'})

	CREATE TABLE #percipienti_record_G_2016
	(
		idreg int,
		progrCom int identity(1,1)
	)

	-----------------------------------------------------------------------------
    --- Estrazione dati relativi ai percipienti collabortori parasubordinati ----
    -----------------------------------------------------------------------------
    
	INSERT INTO #percipienti_record_G_2016
		(
			idreg
		)
		
		SELECT DISTINCT co.idreg         
	FROM payroll ce 
		JOIN parasubcontract co ON co.idcon = ce.idcon
                JOIN parasubcontractyear im ON co.idcon = im.idcon AND im.ayear = @annoredditi
		JOIN service ON service.idser = co.idser
		JOIN registry ON registry.idreg = co.idreg
	WHERE ce.flagbalance = 'S'
		AND ce.fiscalyear=@annoredditi
		AND NOT EXISTS (SELECT idlinkedcon from exhibitedcud where idlinkedcon = ce.idcon and fiscalyear = @annoredditi)
		AND EXISTS (SELECT payroll.idpayroll from payroll 
				join expensepayroll on payroll.idpayroll = expensepayroll.idpayroll
				join expenselink ON expenselink.idparent = expensepayroll.idexp
				join expenselast on expenselast.idexp = expenselink.idchild--expense.idexp
				join payment on payment.kpay=expenselast.kpay
				where payroll.idcon = co.idcon and payment.kpaymenttransmission is not null
				AND payroll.fiscalyear = @annoredditi)
		AND service.rec770kind='G'
		AND ce.disbursementdate is not null
	--------------------------------------------------------------------------------
	----- da rimuovere non appena sar� corretto l'errore dal software SOGEI --------
	--------------------------------------------------------------------------------
		AND (registry.cf IS NOT NULL) 
		AND (registry.cf = @cf OR @cf IS NULL)
		AND (ISNULL(im.flagexcludefromcertificate,'N') = 'N')
	SELECT * FROM	#percipienti_record_G_2016
 
END
 
GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO


 