if exists (select * from dbo.sysobjects where id = object_id(N'[compute_idnation_from_cf]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [compute_idnation_from_cf]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO



CREATE          PROCEDURE [compute_idnation_from_cf] (
	@codenation varchar(4), 
	@idnation int output
)
AS BEGIN
DECLARE @ultimadatafine datetime
SELECT @ultimadatafine = MAX(ISNULL(stop, {d '2079-06-06'}))
FROM geo_nation_agency g2
WHERE idcode = 1
	AND idagency=1
	AND value = @codenation
SELECT @idnation = idnation 
FROM geo_nation_agency 
WHERE idcode = 1
	AND idagency = 1
	AND value = @codenation
	AND ISNULL(stop, {d '2079-06-06'}) = @ultimadatafine
END



GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

