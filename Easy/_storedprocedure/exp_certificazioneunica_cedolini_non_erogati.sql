if exists (select * from dbo.sysobjects where id = object_id(N'[exp_certificazioneunica_cedolini_non_erogati]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [exp_certificazioneunica_cedolini_non_erogati]
GO
 
 --sp_help parasubcontract
CREATE PROCEDURE [exp_certificazioneunica_cedolini_non_erogati]
 
--exec [exp_certificazioneunica_cedolini_non_erogati]  2015, NULL

(
	@annodichiarazione int,
	@cf varchar(20)
 ) 
 AS BEGIN
	declare @annoredditi int
	set @annoredditi = @annodichiarazione -1
 

	SELECT S01.sortcode as 'Cod. Dip.', S01.description as 'Dipartimento',  registry.title as 'Anagrafica', cf as 'CF', co.ycon as 'Eserc. Contratto', co.ncon as 'Num. Contratto',     
	npayroll as 'N. Cedolino', feegross as 'Comp. Lordo',   ce.start as 'Inizio', ce.stop as 'Fine'
	FROM payroll ce 
		JOIN parasubcontract co ON co.idcon = ce.idcon
                JOIN parasubcontractyear im ON co.idcon = im.idcon AND im.ayear = @annoredditi
		JOIN service ON service.idser = co.idser
		JOIN registry ON registry.idreg = co.idreg
		LEFT OUTER JOIN sorting S01
				ON co.idsor01 = S01.idsor
		LEFT OUTER JOIN sortingkind SK
				ON SK.idsorkind = S01.idsorkind
	WHERE -- ce.flagbalance = 'S'
		ce.fiscalyear=@annoredditi 		AND ce.flagbalance = 'N'
		AND NOT EXISTS (SELECT idlinkedcon from exhibitedcud where idlinkedcon = ce.idcon and fiscalyear = @annoredditi)
		AND NOT EXISTS (SELECT * from  expensepayroll  
				join expenselink ON expenselink.idparent = expensepayroll.idexp
				join expenselast on expenselast.idexp = expenselink.idchild--expense.idexp
				join payment on payment.kpay=expenselast.kpay
				where  ce.idpayroll = expensepayroll.idpayroll and payment.kpaymenttransmission is not null
				 )
		AND service.rec770kind='G'
		AND (registry.cf = @cf OR @cf IS NULL)
		AND (ISNULL(im.flagexcludefromcertificate,'N') = 'N')
	
		ORDER BY registry.title , co.ycon, co.ncon, ce.stop
END
 
GO
 
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO
