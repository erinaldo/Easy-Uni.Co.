/* Versione 1.0.0 del 11/09/2007 ultima modifica: PIERO */

if exists (select * from dbo.sysobjects where id = object_id(N'[rpt_reversale_incasso_siope_subclasssup]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [rpt_reversale_incasso_siope_subclasssup]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO


CREATE  PROCEDURE [rpt_reversale_incasso_siope_subclasssup]
@y int,
@n int
AS
BEGIN
DECLARE @idsorkind int
DECLARE @codesorkind varchar(20)
SELECT  @codesorkind = paramvalue FROM reportadditionalparam
WHERE reportname = 'reversale_incasso' AND paramname = 'ClassSup'

select @idsorkind = idsorkind from sortingkind where codesorkind = @codesorkind
CREATE TABLE #sorting
(
	idsor int,
	sortcode varchar(20),
	sort varchar(200),
	amount decimal(19,2)
)
IF (@idsorkind IS NULL) OR (@idsorkind =0)
BEGIN
	select sortcode,sort,NULL AS amount
	FROM #sorting
	RETURN
END
INSERT INTO #sorting
SELECT 	incomesorted.idsor,
		sorting.sortcode,
		sorting.description,
		incomesorted.amount
FROM incomesorted
JOIN income 
	ON incomesorted.idinc = income.idinc
JOIN incomelast 
	ON incomelast.idinc = income.idinc
JOIN proceeds 
	ON incomelast.kpro = proceeds.kpro
JOIN sorting
	ON sorting.idsor = incomesorted.idsor
WHERE incomesorted.ayear = @y
	AND sorting.idsorkind = @idsorkind
	AND income.ymov = @y
	AND proceeds.npro = @n
SELECT sortcode,
	sort,
	SUM(amount) as amount
FROM #sorting
GROUP BY sortcode,sort
ORDER BY sortcode
END


GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO



