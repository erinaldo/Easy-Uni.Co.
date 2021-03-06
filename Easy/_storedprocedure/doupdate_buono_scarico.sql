SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[doupdate_buono_scarico]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [doupdate_buono_scarico]
GO


CREATE PROCEDURE [doupdate_buono_scarico]
(
	@ayear int,
	@printkind char(1),
	@idassetunloadkind int,
	@startassetunload int,
	@stopassetunload int,
	@printdate datetime
)
AS BEGIN
CREATE TABLE #printingdoc (idassetunload int, num int)
IF @printkind = 'A' 
BEGIN
	INSERT INTO #printingdoc (num,idassetunload)
	SELECT nassetunload,idassetunload FROM assetunload
	WHERE yassetunload = @ayear
		AND printdate IS NULL
		AND idassetunloadkind = @idassetunloadkind
END
	
IF @printkind <> 'A'
BEGIN
	INSERT INTO #printingdoc (num,idassetunload) 
	SELECT nassetunload,idassetunload FROM assetunload
	WHERE yassetunload = @ayear
		AND nassetunload BETWEEN @startassetunload AND @stopassetunload
		AND idassetunloadkind = @idassetunloadkind
END
UPDATE assetunload 
SET printdate = @printdate
WHERE yassetunload = @ayear 
	AND nassetunload IN (SELECT num FROM #printingdoc)
	AND idassetunloadkind = @idassetunloadkind
	AND printdate IS NULL

UPDATE asset set flag = flag & 0xFB 
		where idassetunload in (SELECT idassetunload FROM #printingdoc)

END


GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

