if exists (select * from dbo.sysobjects where id = object_id(N'[stampa_logo]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [stampa_logo]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO


--Pino Rana, elaborazione del 10/08/2005 15:27:23


CREATE           PROCEDURE [stampa_logo]
	@codicelogo varchar(10)
AS						      
	BEGIN	
	IF isnull(@codicelogo,'') = ''  SET @codicelogo = 'UNIV'
		SELECT 
		logo,
		idlogo 
		FROM logo	
		WHERE idlogo = @codicelogo
	END


GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

