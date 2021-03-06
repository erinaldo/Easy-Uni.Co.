if exists (select * from dbo.sysobjects where id = object_id(N'[rpt_missione_spese]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [rpt_missione_spese]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO


--setuser 'amministrazione'
--rpt_missione_spese 2018,204

CREATE  PROCEDURE [rpt_missione_spese]
	@yitineration smallint, 
	@nitineration int
AS BEGIN
DECLARE @iditineration int
SELECT  @iditineration=iditineration
	FROM itineration 
	WHERE yitineration = @yitineration AND nitineration = @nitineration

SELECT 
	nrefund=row_number() over(order by ISNULL(itineration.iditineration_ref,itineration.iditineration)), --itinerationrefund.nrefund,
	itinerationrefundkind.description AS itinerationrefundkind,
	itinerationrefund.description,
	itinerationrefund.extraallowance,
	--itinerationrefund.amount,
	CASE 
		WHEN exchangerate > 0 THEN
			ROUND(amount / exchangerate, 2)
		ELSE
  			amount 
		END as 'amount',
	itinerationrefund.advancepercentage*100 AS advancepercentage,
	itinerationrefund.starttime,
	itinerationrefund.stoptime,
	currency.codecurrency as idcurrency,
	itinerationrefund.exchangerate,
	foreigncountry.description as foreigncountry
FROM itinerationrefund
join itineration on itineration.iditineration = itinerationrefund.iditineration
LEFT OUTER JOIN itinerationrefundkind	ON itinerationrefundkind.iditinerationrefundkind = itinerationrefund.iditinerationrefundkind
LEFT OUTER JOIN currency		ON currency.idcurrency  = itinerationrefund.idcurrency
LEFT OUTER JOIN foreigncountry	ON foreigncountry.idforeigncountry  = itinerationrefund.idforeigncountry
WHERE ISNULL(itineration.iditineration_ref,itineration.iditineration) = @iditineration
	AND itinerationrefund.flagadvancebalance = 'S'
ORDER BY nrefund
END



GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO
