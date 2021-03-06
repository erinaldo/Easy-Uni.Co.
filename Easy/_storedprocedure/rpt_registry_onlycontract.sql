if exists (select * from dbo.sysobjects where id = object_id(N'[rpt_registry_onlycontract]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [rpt_registry_onlycontract]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

-- exec rpt_registry_onlycontract 'RAPITI ELEONORA',  {d '2016-01-01'},  {d '2016-12-31'}
CREATE     PROCEDURE [rpt_registry_onlycontract]
(
	@registry varchar(100),
	@start  datetime, 
	@stop  datetime
)
AS BEGIN

DECLARE @idreg int

IF @registry = '%' 
BEGIN
	SET  @idreg = null
END
ELSE
BEGIN
	SET  @idreg = (SELECT idreg FROM registry WHERE title like @registry and active = 'S')
END

SELECT DISTINCT
	registry.idreg, 
	registry.title, 
	registry.surname, 
	registry.forename, 
	registry.cf, 
	registry.p_iva, 
	registry.birthdate, 
	registry.foreigncf,
-- birth
	ISNULL(geo_city_birth.title, '') + ' ' + ISNULL(registry.location,'') as geo_city_birth,
	ISNULL(geo_country_birth.province, '') as geo_province_birth,
	ISNULL(geo_nation_birth.title, 'ITALIA') as geo_nation_birth
FROM registry
join expense 
	ON registry.idreg = expense.idreg 
join expenselast 
	ON expenselast.idexp = expense.idexp AND expenselast.idser is not null
-- citta di nascita
LEFT OUTER JOIN geo_city as geo_city_birth
	ON registry.idcity = geo_city_birth.idcity  
LEFT OUTER JOIN geo_country as geo_country_birth
	ON geo_city_birth.idcountry = geo_country_birth.idcountry
LEFT OUTER JOIN geo_nation as geo_nation_birth
	ON registry.idnation = geo_nation_birth.idnation  
WHERE (registry.idreg = @idreg OR @idreg is null)
	and expense.adate between @start and @stop
	
		
END

GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

