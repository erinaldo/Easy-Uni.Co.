
SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[rpt_missione_anticipo]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [rpt_missione_anticipo]
GO
--setuser 'amministrazione'
--rpt_missione_anticipo 2018,194
CREATE   PROCEDURE [rpt_missione_anticipo]

	@yitineration smallint, 
	@nitineration int
AS
BEGIN

CREATE TABLE #rls
(
	idreg int,
	idposition varchar(20),
	incomeclass int
)

DECLARE @it_start datetime
DECLARE @idreg int
DECLARE @idregistrylegalstatus int
DECLARE @iditineration int
SELECT @it_start = start, @idreg = idreg, @idregistrylegalstatus = idregistrylegalstatus, @iditineration=iditineration
	FROM itineration 
	WHERE yitineration = @yitineration AND nitineration = @nitineration


INSERT INTO #rls (idreg, idposition, incomeclass)
SELECT @idreg, RLS.idposition, RLS.incomeclass
FROM registrylegalstatus RLS
WHERE RLS.idreg = @idreg AND RLS.idregistrylegalstatus = @idregistrylegalstatus

DECLARE @curr_fgn int

SET @curr_fgn =
	(SELECT TOP 1 det.foreigngroupnumber
	FROM foreigngroupruledetail det
	JOIN #rls
		ON det.idposition = #rls.idposition
		AND #rls.incomeclass BETWEEN det.minincomeclass AND det.maxincomeclass
	JOIN foreigngrouprule f
		ON f.idforeigngrouprule = det.idforeigngrouprule
	WHERE f.start <= @it_start
	ORDER BY f.start DESC)

SELECT 
	itineration.yitineration,
	itineration.nitineration,
	itineration.description,
	registry.title as registry,
	registry.extmatricula AS matricula,
	service.description as service,
	itineration.authorizationdate,
	itineration.start,
	itineration.stop,
	itineration.adate,
	position.description as position,
	#rls.incomeclass AS currentclass,
	@curr_fgn AS foreigngroupnumber,
	(select sum(I.totadvance) from itineration I where ISNULL(I.iditineration_ref,I.iditineration)= @iditineration) as totadvance,
	(select SUM(ISNULL(IR.linkedanpag,0) + ISNULL(IR.linkedangir,0)) from itinerationresidual IR
							join itineration I on IR.iditineration=I.iditineration
							where ISNULL(I.iditineration_ref,I.iditineration)= @iditineration)	 as payedadvance
FROM itineration
JOIN itinerationresidual ON itineration.nitineration = itinerationresidual.nitineration 	AND itineration.yitineration = itinerationresidual.yitineration
JOIN registry	ON registry.idreg = itineration.idreg
LEFT OUTER JOIN #rls 	ON registry.idreg = #rls.idreg
LEFT OUTER JOIN position	ON position.idposition = #rls.idposition
JOIN service	ON service.idser = itineration.idser
WHERE   (itineration.yitineration = @yitineration and itineration.nitineration = @nitineration) 
	AND itineration.iditineration_ref is null

END


GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

