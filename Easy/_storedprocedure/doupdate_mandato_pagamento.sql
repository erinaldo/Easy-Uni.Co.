SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[doupdate_mandato_pagamento]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [doupdate_mandato_pagamento]
GO

CREATE PROCEDURE [doupdate_mandato_pagamento] 
(
	@ayear int,
	@printkind char(1),
	@startnpay int,
	@stopnpay int,
	@printdate datetime,
	@idtreasurer INT
)
AS BEGIN
CREATE TABLE #printingdoc(npay int)
IF @printkind = 'A' 
BEGIN
	INSERT INTO #printingdoc (npay) 
	SELECT npay FROM payment 
	WHERE (ypay=@ayear) AND (printdate IS NULL) AND idtreasurer = @idtreasurer
END
IF @printkind <> 'A'
BEGIN
	INSERT INTO #printingdoc (npay) 
	SELECT npay FROM payment 
	WHERE (ypay=@ayear) AND (npay BETWEEN @startnpay AND @stopnpay) AND idtreasurer = @idtreasurer
END
UPDATE payment
SET printdate =	@printdate
WHERE ypay = @ayear
	AND npay IN (SELECT npay FROM #printingdoc)
	AND idtreasurer = @idtreasurer
	AND printdate IS NULL
END


GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

