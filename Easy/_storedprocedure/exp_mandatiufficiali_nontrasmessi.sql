if exists (select * from dbo.sysobjects where id = object_id(N'[exp_mandatiufficiali_nontrasmessi]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [exp_mandatiufficiali_nontrasmessi]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO




CREATE  PROCEDURE [exp_mandatiufficiali_nontrasmessi] 
@ayear	int
AS
BEGIN


	SELECT 
		ypay AS 'Esercizio',
		npay AS 'Numero Mandato',
		printdate AS 'Data di Stampa',
		adate AS 'Data Contabile'
	FROM payment WHERE printdate IS NOT NULL
	AND kpaymenttransmission IS NULL
	AND ((ypay = @ayear) OR (@ayear is null))
	
END

SET QUOTED_IDENTIFIER ON 


GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO
