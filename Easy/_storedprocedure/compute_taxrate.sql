SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[compute_taxrate]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [compute_taxrate]
GO



CREATE       PROCEDURE [compute_taxrate]
(
	@idreg integer,
	@idser int, 
	@servicestart datetime
)
AS BEGIN
CREATE TABLE #taxratebracket
(
	taxcode	int, 
	idtaxratestart int,
	nbracket int
)
DECLARE @supposedincome decimal(19,2)
SELECT TOP 1 @supposedincome=supposedincome 
	FROM registrytaxablestatus 
	WHERE idreg = @idreg AND start <= @servicestart ORDER BY start DESC

IF @supposedincome IS NULL
BEGIN
	SET @supposedincome = 0
END
		
-- Sceglie quali ritenute applicare e per ogni ritenuta sceglie la riga in taxratestart, ossia il gruppo di aliquote da applicare
INSERT INTO #taxratebracket (taxcode)
	select taxcode FROM servicetax
	WHERE servicetax.idser = @idser

update #taxratebracket set 
	idtaxratestart = (SELECT MAX(idtaxratestart) FROM taxratestart
	   WHERE taxcode = #taxratebracket.taxcode
      		AND start <= @servicestart
	)

-- Per ogni ritenuta sceglie lo scaglione in base alla validità calcolata
UPDATE #taxratebracket SET 
	#taxratebracket.nbracket = taxratebracket.nbracket
	FROM taxratebracket
	WHERE taxratebracket.taxcode = #taxratebracket.taxcode
	AND taxratebracket.idtaxratestart = #taxratebracket.idtaxratestart
	AND ( 
		(minamount < @supposedincome OR (minamount = 0 AND @supposedincome = 0))
		AND (maxamount >= @supposedincome OR maxamount IS NULL)
		)
SELECT 
	tax.taxkind,
	#taxratebracket.taxcode,
	tax.description,
	taxratestart.taxablenumerator,
	taxratestart.taxabledenominator,
	taxratebracket.employrate,
	taxratebracket.employnumerator,
	taxratebracket.employdenominator,
	taxratebracket.adminrate,
	taxratebracket.adminnumerator, 
	taxratebracket.admindenominator,
	tax.flagunabatable
FROM #taxratebracket
JOIN tax
	ON #taxratebracket.taxcode=tax.taxcode
JOIN taxratestart
	ON #taxratebracket.taxcode = taxratestart.taxcode
	AND #taxratebracket.idtaxratestart = taxratestart.idtaxratestart
JOIN taxratebracket
	ON #taxratebracket.taxcode = taxratebracket.taxcode
	AND #taxratebracket.idtaxratestart = taxratebracket.idtaxratestart
	AND #taxratebracket.nbracket = taxratebracket.nbracket
WHERE taxratebracket.employrate > 0 OR taxratebracket.adminrate > 0
ORDER BY tax.taxkind,#taxratebracket.taxcode
END





GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO
