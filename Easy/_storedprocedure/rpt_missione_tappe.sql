if exists (select * from dbo.sysobjects where id = object_id(N'[rpt_missione_tappe]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [rpt_missione_tappe]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

--setuser 'amm'
--rpt_missione_tappe 2015,1


CREATE  PROCEDURE [rpt_missione_tappe]
	@yitineration smallint, 
	@nitineration int
AS BEGIN
DECLARE @iditineration int
SELECT  @iditineration=iditineration
	FROM itineration 
	WHERE yitineration = @yitineration AND nitineration = @nitineration


SELECT 
	itinerationlap.lapnumber,
	itinerationlap.flagitalian,
	foreigncountry.description as foreigncountry,
	itinerationlap.description,
	itinerationlap.starttime,
	itinerationlap.stoptime,
	itinerationlap.days,
	itinerationlap.hours,
	reduction.description as riduzione,
	itinerationlap.reductionpercentage*100 as reductionpercentage,
	itinerationlap.allowance,
	itinerationlap.advancepercentage*100 as advancepercentage
FROM itinerationlap
join itineration						on itineration.iditineration = itinerationlap.iditineration
LEFT OUTER JOIN foreigncountry			ON foreigncountry.idforeigncountry = itinerationlap.idforeigncountry
LEFT OUTER JOIN reduction				ON reduction.idreduction = itinerationlap.idreduction
WHERE ISNULL(itineration.iditineration_ref,itineration.iditineration) = @iditineration
ORDER BY lapnumber
END

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO
