SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[rpt_buono_scarico_sub1]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [rpt_buono_scarico_sub1]
GO

CREATE PROCEDURE [rpt_buono_scarico_sub1]
@ayear int,
@idassetunloadkind int,
@nassetunload int
AS
BEGIN
SELECT
	assetunload.idassetunloadkind,
	assetunload.yassetunload,
	assetunload.nassetunload,
	assetunloadincome.idinc,
	income.ymov,
	proceeds.npro,
	proceeds.printdate 
FROM assetunloadincome
JOIN assetunload
	ON assetunload.idassetunload = assetunloadincome.idassetunload
JOIN income 
	ON assetunloadincome.idinc = income.idinc
JOIN incomelast
	ON income.idinc = incomelast.idinc
JOIN proceeds
	ON incomelast.kpro = proceeds.kpro
WHERE assetunload.idassetunloadkind = @idassetunloadkind
	AND assetunload.yassetunload = @ayear
	AND assetunload.nassetunload = @nassetunload
ORDER BY income.ymov, proceeds.printdate, proceeds.npro
END




GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO