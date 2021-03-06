SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[doupdate_reversale_incasso]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [doupdate_reversale_incasso]
GO

CREATE PROCEDURE [doupdate_reversale_incasso]
(
	@ayear int,
	@printkind char(1),
	@startnpro int,
	@stopnpro int,
	@printdate datetime,
	@idtreasurer INT
)
AS BEGIN
CREATE TABLE #printingdoc (npro int)
IF @printkind = 'A' 
BEGIN
	INSERT INTO #printingdoc (npro) 
	SELECT npro FROM proceeds 
	WHERE (ypro=@ayear) AND (printdate IS NULL) AND idtreasurer = @idtreasurer
END
IF @printkind <> 'A'
BEGIN
	INSERT INTO #printingdoc (npro) 
	SELECT npro FROM proceeds 
	WHERE (ypro=@ayear) AND (npro BETWEEN @startnpro AND @stopnpro)AND idtreasurer = @idtreasurer
END
UPDATE proceeds
SET printdate =	@printdate
WHERE ypro = @ayear
	AND npro IN (SELECT npro FROM #printingdoc)
	AND idtreasurer = @idtreasurer
	AND printdate IS NULL
END



GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

