
SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[rpt_anticipo_missione]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [rpt_anticipo_missione]
GO

CREATE  PROCEDURE [rpt_anticipo_missione]
	@ayear smallint, 
	@numberbegin int,
	@numberend int,
	@idsor01 int=null,
	@idsor02 int=null,
	@idsor03 int=null,
	@idsor04 int=null,
	@idsor05 int=null
AS
BEGIN

CREATE TABLE #rls
(
	idreg int,
	idposition int,
	incomeclass int,
	yitineration smallint,
	nitineration int,
	foreigngroupnumber smallint,
	start datetime
)

INSERT INTO #rls (idreg, idposition, incomeclass, yitineration, nitineration, start)
SELECT RLS.idreg, RLS.idposition, RLS.incomeclass, I.yitineration, I.nitineration, I.start
FROM registrylegalstatus RLS
JOIN itineration I
	ON I.idreg = RLS.idreg
	AND I.idregistrylegalstatus = RLS.idregistrylegalstatus
WHERE I.yitineration = @ayear
	AND I.nitineration BETWEEN @numberbegin AND @numberend
	AND (@idsor01 IS NULL OR I.idsor01 = @idsor01)
	AND (@idsor02 IS NULL OR I.idsor02 = @idsor02)
	AND (@idsor03 IS NULL OR I.idsor03 = @idsor03)
	AND (@idsor04 IS NULL OR I.idsor04 = @idsor04)
	AND (@idsor05 IS NULL OR I.idsor05 = @idsor05)

UPDATE #rls
SET foreigngroupnumber =
(SELECT DET.foreigngroupnumber
FROM foreigngroupruledetail DET
JOIN foreigngrouprule F
	ON F.idforeigngrouprule = DET.idforeigngrouprule
WHERE DET.idposition = #rls.idposition
	AND #rls.incomeclass BETWEEN DET.minincomeclass AND DET.maxincomeclass
	AND F.start =
		(SELECT MAX(F2.start)
		FROM foreigngrouprule F2
		JOIN foreigngroupruledetail DET2
			ON F.idforeigngrouprule = DET.idforeigngrouprule
		WHERE DET2.idposition = #rls.idposition
			AND #rls.incomeclass BETWEEN DET.minincomeclass AND DET.maxincomeclass
			AND start <= #rls.start)
)

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
	#rls.foreigngroupnumber AS foreigngroupnumber,
	itineration.totadvance,
	ISNULL(itinerationresidual.linkedanpag,0) + ISNULL(itinerationresidual.linkedangir,0) AS payedadvance
FROM itineration
JOIN itinerationresidual
	ON itineration.nitineration = itinerationresidual.nitineration AND
	itineration.yitineration = itinerationresidual.yitineration
JOIN registry
	ON registry.idreg = itineration.idreg
JOIN #rls
	ON itineration.yitineration = #rls.yitineration
	AND itineration.nitineration = #rls.nitineration
JOIN position
	ON position.idposition = #rls.idposition
JOIN service
	ON service.idser = itineration.idser
WHERE itineration.yitineration = @ayear
	AND itineration.nitineration BETWEEN @numberbegin AND @numberend
ORDER BY itineration.nitineration ASC
	END



GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO
