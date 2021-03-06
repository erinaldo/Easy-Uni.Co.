if exists (select * from dbo.sysobjects where id = object_id(N'[rpt_partitario_classificazione_sub_variazioni]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [rpt_partitario_classificazione_sub_variazioni]
GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

CREATE                    PROCEDURE rpt_partitario_classificazione_sub_variazioni
	@ayear int,	
	@stop datetime,		
	@idsorkind int,
	@idsor int
AS
BEGIN

DECLARE @firstday datetime
SET @firstday = CONVERT(datetime, '01-01-' + CONVERT(varchar(4),@ayear), 105)


DECLARE @MostraVarprevisione varchar(50)
SELECT @MostraVarprevisione = isnull(paramvalue,'N') 
FROM reportadditionalparam WHERE paramname='MostraVarPrevisione'
and reportname='partitarioperclassificazione'

IF ( @MostraVarprevisione='S')
BEGIN
	SELECT
		sortingprevexpensevar.yvar,
		sortingprevexpensevar.nvar,
		sortingkind.codesorkind,
		sortingprevexpensevar.idsor,
		sorting.sortcode,
		sortingprevexpensevar.description,
		sortingprevexpensevar.amount,
		sortingprevexpensevar.adate
	FROM sortingprevexpensevar 
	JOIN sorting 
		ON sortingprevexpensevar.idsor = sorting.idsor
	JOIN sortingkind
		ON sortingkind.idsorkind = sorting.idsorkind
	WHERE sortingprevexpensevar.adate BETWEEN @firstday AND @stop
		AND (sorting.idsorkind  = @idsorkind)
		AND (sortingprevexpensevar.idsor = @idsor)
	ORDER BY sortingprevexpensevar.adate,sortingprevexpensevar.idsor

END

ELSE
Begin
	SELECT 										
	null as yvar,
	null as nvar,
	null as codesorkind,
	null as idsor,
	null as sortcode,
	null as description,
	null as amount,
	null as adate
End
END


GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO


