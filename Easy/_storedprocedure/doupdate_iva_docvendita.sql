SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[doupdate_iva_docvendita]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [doupdate_iva_docvendita]
GO

CREATE PROCEDURE [doupdate_iva_docvendita]
(
	@ayear int,
	@printkind char(1),
	@idinvkind int,
	@ninv_start int,
	@ninv_stop int
)
AS BEGIN
CREATE TABLE #printingdoc (num int)
IF @printkind = 'A'
BEGIN
	INSERT INTO #printingdoc (num) 
	SELECT ninv FROM invoice
	JOIN invoicekind
		ON invoicekind.idinvkind = invoice.idinvkind
	WHERE invoicekind.flagbuysell = 'V'
		AND invoice.yinv = @ayear
		AND invoice.officiallyprinted <> 'S'
		AND invoicekind.idinvkind  = @idinvkind 
END
IF @printkind <> 'A'
BEGIN
	INSERT INTO #printingdoc (num) 
	SELECT ninv FROM invoice
	WHERE yinv = @ayear
		AND ninv BETWEEN @ninv_start AND @ninv_stop
		AND idinvkind  = @idinvkind
END
UPDATE invoice SET officiallyprinted = 'S'
WHERE yinv = @ayear 
	AND ninv IN (SELECT num FROM #printingdoc)
	AND idinvkind = @idinvkind
END



GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

