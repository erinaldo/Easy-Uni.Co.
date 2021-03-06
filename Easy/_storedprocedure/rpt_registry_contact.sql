/* Versione 1.0.0 del 10/09/2007 ultima modifica: PIERO */

if exists (select * from dbo.sysobjects where id = object_id(N'[rpt_registry_contact]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [rpt_registry_contact]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO


CREATE     PROCEDURE [rpt_registry_contact]
(
		@idreg int
)
AS BEGIN
SELECT 
	
-- contatto
	registryreference.idreg,
	idregistryreference,
	email,
	faxnumber,
	mobilenumber,
	phonenumber,
	referencename,--nome
	registryreferencerole--funzione
FROM registry
-- posizione giuridica
JOIN registryreference
	ON registryreference.idreg = registry.idreg  

WHERE (registry.idreg = @idreg OR @idreg is null)
	
	
END


GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

