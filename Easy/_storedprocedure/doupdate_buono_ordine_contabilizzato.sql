/* Versione 1.0.0 del 11/09/2007 ultima modifica: PIERO */

if exists (select * from dbo.sysobjects where id = object_id(N'[doupdate_buono_ordine_contabilizzato]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [doupdate_buono_ordine_contabilizzato]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO



CREATE PROCEDURE [doupdate_buono_ordine_contabilizzato]
(
	@ayear int,
	@printkind char(1),
	@mandatekind varchar(20),
	@startnman int,
	@stopnman int
)
AS BEGIN
CREATE TABLE #printingdoc (nman int)
IF @printkind = 'A' 
BEGIN
	INSERT INTO #printingdoc (nman) 
	SELECT nman FROM mandate
	WHERE yman = @ayear
		AND idmankind = @mandatekind
		AND officiallyprinted <>'S'
END
IF @printkind <> 'A'
BEGIN
	INSERT INTO #printingdoc (nman) 
	SELECT nman FROM mandate
	WHERE yman=@ayear
		AND idmankind = @mandatekind
		AND (nman BETWEEN @startnman AND @stopnman)
END
DECLARE @nphase tinyint
SELECT @nphase = expensephase FROM config WHERE ayear = @ayear
DELETE FROM #printingdoc
WHERE #printingdoc.nman NOT IN
	(SELECT mandate.nman
	FROM mandate
	INNER JOIN mandatedetail
		ON mandate.yman = mandatedetail.yman
		AND mandate.nman = mandatedetail.nman
	WHERE mandate.yman = @ayear
		AND mandate.idmankind = @mandatekind
	GROUP BY mandate.yman,mandate.nman, mandate.idmankind
	HAVING SUM(ISNULL(mandatedetail.taxable, 0) * ISNULL(mandatedetail.npackage,0)
		* (1 - ISNULL(mandatedetail.discount,0)) * (1 + ISNULL(mandatedetail.tax,0)))
		IN
			(SELECT ISNULL(SUM(o.curramount), 0)
			FROM  expensemandateview o 
			WHERE o.yman=mandate.yman
				AND o.nman = mandate.nman
				AND o.idmankind = mandate.idmankind
				AND o.nphase = @nphase
			GROUP BY o.nman, o.yman, o.idmankind)
	)
UPDATE mandate SET officiallyprinted = 'S'
WHERE yman = @ayear 
	AND idmankind = @mandatekind
	AND nman IN (SELECT nman from #printingdoc)
END



GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

