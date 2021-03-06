SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[doupdate_buono_carico]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [doupdate_buono_carico]
GO

CREATE  PROCEDURE [doupdate_buono_carico]
(
	@ayear int,
	@printkind char(1),
	@idassetloadkind int,
	@startnassetload int,
	@stopnassetload int,
	@printdate datetime
)
AS BEGIN
CREATE TABLE #printingdoc (num int)
IF @printkind = 'A' 
BEGIN
	INSERT INTO #printingdoc (num)
	SELECT nassetload FROM assetload
	WHERE yassetload = @ayear
		AND printdate IS NULL
		AND idassetloadkind = @idassetloadkind
END
	
IF @printkind <> 'A'
BEGIN
	INSERT INTO #printingdoc (num) 
	SELECT nassetload FROM assetload
	WHERE yassetload = @ayear
		AND nassetload BETWEEN @startnassetload AND @stopnassetload
		AND idassetloadkind = @idassetloadkind
END
UPDATE assetload 
SET printdate = @printdate
WHERE yassetload = @ayear 
	AND nassetload IN (SELECT num FROM #printingdoc)
	AND idassetloadkind = @idassetloadkind
	AND printdate IS NULL
END



GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

