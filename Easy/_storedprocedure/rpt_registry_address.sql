/* Versione 1.0.0 del 10/09/2007 ultima modifica: PIERO */

if exists (select * from dbo.sysobjects where id = object_id(N'[rpt_registry_address]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [rpt_registry_address]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO



CREATE     PROCEDURE [rpt_registry_address]
(
	@idreg int
)
AS BEGIN




SELECT 
	registryaddress.idaddresskind,
	address.codeaddress,
	address.description as address,
	registry.idreg, 
-- residenza
	officename, --ubicazione nel form
	registryaddress.address as registryaddress,
	registryaddress.start,registryaddress.stop,
	ISNULL(geo_city_address.title,'') + ' ' + ISNULL(registryaddress.location,'') as geo_city_address,
	registryaddress.cap,
	geo_country_address.province,
	CASE
		WHEN flagforeign = 'N' THEN 'Italia'
		ELSE geo_nation_address.title
	END as geo_nation_address

FROM registry
join registryaddress
	ON registry.idreg = registryaddress.idreg AND isnull(registryaddress.active,'N') ='S'
join address
	on registryaddress.idaddresskind =address.idaddress
LEFT OUTER JOIN geo_city as geo_city_address
	ON geo_city_address.idcity = registryaddress.idcity
LEFT OUTER JOIN geo_country as geo_country_address
	ON geo_city_address.idcountry = geo_country_address.idcountry
LEFT OUTER JOIN geo_nation as geo_nation_address
	ON geo_nation_address.idnation = registryaddress.idnation
WHERE (registry.idreg = @idreg OR @idreg = 0)
	order by registryaddress.start desc
		


END






GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

