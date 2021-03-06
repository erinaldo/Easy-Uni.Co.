
/* Versione 1.0.0 del 10/09/2007 ultima modifica: PIERO */

if exists (select * from dbo.sysobjects where id = object_id(N'[rpt_registry_legalstatus]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [rpt_registry_legalstatus]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO




CREATE     PROCEDURE [rpt_registry_legalstatus]
(
		@idreg int
)
AS BEGIN


SELECT 
	
-- pos giuridica 
	registrylegalstatus.idreg,
	registrylegalstatus.start, -- data delibera
	
	position.description as position,
	registrylegalstatus.incomeclass, -- classe stipendiale
	registrylegalstatus.incomeclassvalidity, -- data decorrenza
	registrylegalstatus.idregistrylegalstatus
FROM registry
-- posizione giuridica
LEFT OUTER JOIN registrylegalstatus 
	ON registrylegalstatus.idreg = registry.idreg AND isnull(registrylegalstatus.active,'N')='S'
JOIN position 
	ON registrylegalstatus.idposition = position.idposition 

WHERE (registry.idreg = @idreg OR @idreg is null)
	
	

END







GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

