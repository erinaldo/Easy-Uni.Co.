if exists (select * from dbo.sysobjects where id = object_id(N'[rpt_anagrafedelleprestazioni]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [rpt_anagrafedelleprestazioni]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO


-- rpt_anagrafedelleprestazioni 2011, 0 ,{ts '1900-01-01 00:00:00'},{ts '2011-12-31 00:00:00'},'N'


CREATE   PROCEDURE [rpt_anagrafedelleprestazioni]
(
	@ayear smallint, 
	@idreg int, 
	@start datetime,
	@stop datetime,
	@show_addr_anagp char(1),
	@idsor01 int=null,
	@idsor02 int=null,
	@idsor03 int=null,
	@idsor04 int=null,
	@idsor05 int=null
)
AS BEGIN

/* Versione 1.0.1 del 13/11/2007 ultima modifica: GIUSEPPE */
CREATE TABLE #expensetax
(
	idexp int,
	idreg int,
	registry varchar(100),
	cf varchar(16),
	birthdate smalldatetime,
	taxcode int,   
	description varchar(50),
	commondetail char(1),
	taxablenet decimal(19,2),
	employtax decimal(19,2),
	grossamount decimal (19,2),
	service varchar(50),
	idser int,
	upb varchar(150),
	fin varchar(150),
	codefin varchar(50),
	npay int,
	manager varchar(150),
	descriptioncontract varchar(150),
	start smalldatetime,
	stop smalldatetime,

	authdoc	varchar(35),
	authdocdate	smalldatetime,
	authneeded	char(1),
	noauthreason varchar(1000)
)

CREATE TABLE #address_to_send
(
	idaddresskind int,
	idreg int,
	officename varchar(50),
	address varchar(100),
	location varchar(120),
	cap varchar(20),
	province varchar(2),
	nation varchar(65),
	recipientagency varchar(50)
)

CREATE TABLE #address_residence
(
	idaddresskind int,
	idreg int,
	officename varchar(50),
	address varchar(100),
	location varchar(120),
	cap varchar(20),
	province varchar(2),
	nation varchar(65)
)

CREATE TABLE #registry_birth
(	idreg int,
	city_title varchar(120),
	province varchar(2),
	nation_title varchar(65),
)

IF @ayear = 0
BEGIN
	SET @ayear='1900'
END

DECLARE @dateaddress datetime
SELECT  @dateaddress = CONVERT(datetime, '31-12-'+ CONVERT(varchar(4),@ayear), 105)


INSERT INTO #expensetax
(
	idexp,
	idreg,
	registry,
	birthdate,
	cf,
	taxcode,
	description,
	taxablenet,
	employtax, 
	grossamount,
	service,
	idser,
	upb,
	fin,
	codefin,
	npay,
	manager
 
)
SELECT
	T.idexp,
	T.idreg,
	registry.title,
	registry.birthdate,
	registry.cf,
	T.taxcode,
	T.description,
	SUM(T.taxablenet),
	SUM(T.employtax),
	expensetotal.curramount,
	service.description,
	service.idser,
	upb.title,
	fin.title,
	fin.codefin,
	payment.npay,
	manager.title

FROM
	(SELECT
		SUM(ISNULL(E.taxablenet,0)) AS taxablenet,
		SUM(ISNULL(E.employtax,0)) AS employtax,
		E.idexp,
		E.taxcode,
		expense.idreg,
		E.description,
		expense.idman,
		expenselast.idser,
		expenselast.kpay
	FROM expensetaxview AS E
	JOIN expense 
		ON expense.idexp = E.idexp
	JOIN expenselast
		ON expense.idexp = expenselast.idexp
	WHERE expense.ymov = @ayear  
		AND E.taxcode IN (SELECT taxcode FROM tax WHERE taxkind = 1 AND isnull(geoappliance,'N')='N')
		AND (expense.idreg=@idreg OR @idreg=0)
	GROUP BY expense.idreg,E.idexp,E.taxcode,E.description,
	expense.idman, expenselast.idser, expense.ymov, expenselast.kpay) AS T
JOIN registry 
	ON T.idreg = registry.idreg  
JOIN expensetotal
	ON T.idexp = expensetotal.idexp  
JOIN expenseyear
	ON T.idexp = expenseyear.idexp
JOIN fin
	ON expenseyear.idfin = fin.idfin
JOIN upb
	ON expenseyear.idupb = upb.idupb
JOIN service
	ON T.idser = service.idser 
JOIN payment 
	ON T.kpay = payment.kpay  
JOIN paymenttransmission
	ON payment.kpaymenttransmission = paymenttransmission.kpaymenttransmission  
LEFT OUTER JOIN manager
	on T.idman = manager.idman
WHERE (paymenttransmission.transmissiondate BETWEEN @start AND @stop)
	AND expensetotal.ayear = @ayear
	AND expenseyear.ayear = @ayear
	AND (@idsor01 IS NULL OR upb.idsor01 = @idsor01)
	AND (@idsor02 IS NULL OR upb.idsor02 = @idsor02)
	AND (@idsor03 IS NULL OR upb.idsor03 = @idsor03)
	AND (@idsor04 IS NULL OR upb.idsor04 = @idsor04)
	AND (@idsor05 IS NULL OR upb.idsor05 = @idsor05)

GROUP BY T.idreg, T.idexp, registry.title, registry.birthdate, registry.cf,
	T.taxcode, T.description, expensetotal.curramount, service.description,
	service.idser, upb.title, fin.title, fin.codefin, payment.npay, manager.title
    
-- A partire dall'idexp del pagamento risale alla contabilizzazione e quindi al contratto. Dal contratto legge le info relative all'autorizzazione.
DECLARE  @appropriation tinyint
SELECT  @appropriation = expensephase FROM config WHERE ayear =@ayear

UPDATE #expensetax
		SET authdoc = casualcontract.authdoc,
			authdocdate = casualcontract.authdocdate,
			authneeded = casualcontract.authneeded,
			noauthreason = casualcontract.noauthreason
		FROM casualcontract 
		join expensecasualcontract
			ON expensecasualcontract.ycon = casualcontract.ycon
			and expensecasualcontract.ncon = casualcontract.ncon
		join expense
			ON expense.idexp = expensecasualcontract.idexp
		join expenselink 
			on expenselink.idparent = expense.idexp 
 		WHERE 
			expenselink.nlevel = @appropriation
			and casualcontract.idreg = #expensetax.idreg
			AND casualcontract.idser = #expensetax.idser
			AND expenselink.idchild = #expensetax.idexp

UPDATE #expensetax
		SET authdoc	 = profservice.authdoc,
			authdocdate = profservice.authdocdate,
			authneeded = profservice.authneeded,
			noauthreason = profservice.noauthreason
		FROM profservice 
		join expenseprofservice
			ON expenseprofservice.ycon = profservice.ycon
			and expenseprofservice.ncon = profservice.ncon
		join expense
			ON expense.idexp = expenseprofservice.idexp
		join expenselink 
			on expenselink.idparent = expense.idexp 
 		WHERE 
			expenselink.nlevel = @appropriation
			and profservice.idreg = #expensetax.idreg
			AND profservice.idser = #expensetax.idser
			AND expenselink.idchild = #expensetax.idexp

UPDATE #expensetax
		SET authdoc	 = itineration.authdoc,
			authdocdate = itineration.authdocdate,
			authneeded = itineration.authneeded,
			noauthreason = itineration.noauthreason
		FROM itineration 
		join expenseitineration
			ON expenseitineration.iditineration = itineration.iditineration
		join expense
			ON expense.idexp = expenseitineration.idexp
		join expenselink 
			on expenselink.idparent = expense.idexp 
 		WHERE 
			expenselink.nlevel = @appropriation
			and itineration.idreg = #expensetax.idreg
			AND itineration.idser = #expensetax.idser
			AND expenselink.idchild = #expensetax.idexp

UPDATE #expensetax
		SET authdoc	 = wageaddition.authdoc,
			authdocdate = wageaddition.authdocdate,
			authneeded = wageaddition.authneeded,
			noauthreason = wageaddition.noauthreason
		FROM wageaddition 
		join expensewageaddition
			ON expensewageaddition.ycon = wageaddition.ycon
			and expensewageaddition.ncon = wageaddition.ncon
		join expense
			ON expense.idexp = expensewageaddition.idexp
		join expenselink 
			on expenselink.idparent = expense.idexp 
 		WHERE 
			expenselink.nlevel = @appropriation
			and wageaddition.idreg = #expensetax.idreg
			AND wageaddition.idser = #expensetax.idser
			AND expenselink.idchild = #expensetax.idexp

-----------------------------------------------------------------------------------------------------------------------------------------------------

DECLARE @codenostand varchar(20)
SET @codenostand = '07_SW_ANP'

DECLARE @codestand varchar(20)
SET @codestand = '07_SW_DEF'

DECLARE @STAND int
SELECT @STAND = idaddress FROM address WHERE codeaddress = @codestand

DECLARE @NOSTAND int
SELECT @NOSTAND = idaddress FROM address WHERE codeaddress = @codenostand

-- Inizio calcolo indirizzi
INSERT INTO #address_to_send
(
	idaddresskind,
	idreg,
	officename,
	address,
	location,
	cap,
	province,
	nation,
	recipientagency
)
SELECT 
	idaddresskind,
	idreg, 
	officename, 
	address,
	ISNULL(geo_city.title,'') + ' ' + ISNULL(registryaddress.location,''),
	registryaddress.cap,
	geo_country.province,
	CASE
		WHEN flagforeign = 'N' THEN 'Italia'
		ELSE geo_nation.title
	END,
	recipientagency
FROM registryaddress
LEFT OUTER JOIN geo_city
	ON geo_city.idcity = registryaddress.idcity
LEFT OUTER JOIN geo_country
	ON geo_city.idcountry = geo_country.idcountry
LEFT OUTER JOIN geo_nation
	ON geo_nation.idnation = registryaddress.idnation
WHERE (registryaddress.active <>'N' 
	AND registryaddress.start = 
		(SELECT MAX(cdi.start) 
		FROM registryaddress cdi 
		WHERE cdi.idaddresskind = registryaddress.idaddresskind
			AND cdi.active <>'N' 
			AND cdi.start <= @dateaddress
			AND cdi.idreg = registryaddress.idreg)
)
AND registryaddress.idreg in (select idreg from #expensetax)


DELETE #address_to_send
WHERE #address_to_send.idaddresskind <> @nostand  -- Restano solo 07_SW_ANP
AND EXISTS(
	SELECT * FROM #address_to_send r2 
	WHERE #address_to_send.idreg = r2.idreg
		AND r2.idaddresskind = @nostand
	)  

DELETE #address_to_send
WHERE #address_to_send.idaddresskind NOT IN (@NOSTAND, @STAND)
AND EXISTS(
	SELECT * FROM #address_to_send r2 
	WHERE #address_to_send.idreg = r2.idreg
		AND r2.idaddresskind = @STAND
	)  --restano solo 07_SW_ANP  o solo 07_SW_DEF

DELETE #address_to_send
WHERE (
	SELECT COUNT(*) FROM #address_to_send r2 
	WHERE #address_to_send.idreg = r2.idreg
)>1  -- cancello quelli con più  indirizzi

		

SET @codenostand = '07_SW_DOM'
SELECT @NOSTAND = idaddress FROM address WHERE codeaddress = @codestand

INSERT INTO #address_residence
(
	idaddresskind,
	idreg,
	officename,
	address,
	location,
	cap,
	province,
	nation
)
SELECT 
	idaddresskind,
	idreg, 
	officename, 
	address,
	ISNULL(geo_city.title,'') + ' ' + ISNULL(registryaddress.location,''),
	registryaddress.cap,
	geo_country.province,
	CASE
		WHEN flagforeign = 'N' THEN 'Italia'
		ELSE geo_nation.title
	END
	FROM registryaddress
	LEFT OUTER JOIN geo_city
		ON geo_city.idcity = registryaddress.idcity
	LEFT OUTER JOIN geo_country
		ON geo_city.idcountry = geo_country.idcountry
	LEFT OUTER JOIN geo_nation
		ON geo_nation.idnation = registryaddress.idnation
	WHERE (registryaddress.active <>'N' 
		AND registryaddress.start = 
			(SELECT MAX(cdi.start) 
			FROM registryaddress cdi 
			WHERE cdi.idaddresskind = registryaddress.idaddresskind
				AND cdi.active <>'N' 
				AND cdi.start <= @dateaddress
				AND cdi.idreg = registryaddress.idreg)
			)
	AND registryaddress.idreg in (select idreg from #expensetax)

DELETE #address_residence
WHERE #address_residence.idaddresskind <> @NOSTAND
AND EXISTS (
	SELECT * FROM #address_residence r2 
	WHERE #address_residence.idreg = r2.idreg
		AND r2.idaddresskind = @NOSTAND
	)

DELETE #address_residence
WHERE #address_residence.idaddresskind NOT IN (@nostand, @stand)
AND EXISTS (
	SELECT * FROM #address_residence r2 
	WHERE #address_residence.idreg = r2.idreg
		AND r2.idaddresskind = @STAND
	)

DELETE #address_residence
WHERE (
	SELECT COUNT(*) FROM #address_residence r2 
	WHERE #address_residence.idreg = r2.idreg
	)>1
	
-- Fine calcolo indirizzi

INSERT INTO #registry_birth
(
	idreg,
	city_title,
	province,
	nation_title
)
SELECT
	registry.idreg,
	ISNULL(geo_city.title, '') + ' ' + ISNULL(registry.location,''),
	ISNULL(geo_country.province, ''),
	ISNULL(geo_nation.title, 'ITALIA')
FROM registry
LEFT OUTER JOIN geo_city
	ON registry.idcity = geo_city.idcity  
LEFT OUTER JOIN geo_country
	ON geo_city.idcountry = geo_country.idcountry
LEFT OUTER JOIN geo_nation
	ON registry.idnation = geo_nation.idnation  
WHERE (registry.idreg = @idreg OR @idreg = 0)

update #expensetax set
descriptioncontract=(select description from expense where  expense.idexp=#expensetax.idexp),
start=(select servicestart from expenselast where  expenselast.idexp=#expensetax.idexp),
stop=(select servicestop from expenselast where  expenselast.idexp=#expensetax.idexp)


DECLARE @departmentname varchar(500)

SET  @departmentname  = ISNULL( (SELECT top 1 paramvalue from
    generalreportparameter where idparam='DenominazioneUniversita' 
    and  (ISNULL(start, {d '1900-01-01'}) = {d '1900-01-01'} or year(start) <= @ayear) 
    and  (ISNULL(stop, {d '2079-06-06'}) = {d '2079-06-06'}  or year(stop) >= @ayear)
    order by ISNULL(stop, {d '2079-06-06'}) desc
    ),'Manca Cfg. Parametri Tutte le stampe')



IF (ISNULL(@show_addr_anagp,'N') = 'N' )
BEGIN	
	SELECT
		@departmentname as departmentname,
		#expensetax.idexp,
		#expensetax.idreg,
		#expensetax.registry,
		#registry_birth.city_title AS b_city,
		#expensetax.birthdate,
		#registry_birth.province AS b_province,
		#registry_birth.nation_title AS b_nation,
		#expensetax.cf,
		tax.taxref, --#expensetax.taxcode,   
		#expensetax.description,
		#expensetax.service,
		service.codeser, ----#expensetax.idser,
		#expensetax.upb,
		#expensetax.fin,
		#expensetax.codefin,
		#expensetax.npay,
		#expensetax.manager,
		#expensetax.taxablenet,
		#expensetax.grossamount,
		employtax,
		#address_to_send.officename AS sent_office,
		#address_to_send.recipientagency AS sent_agency,
		#address_to_send.address AS sent_address,
		add_sen.codeaddress AS sent_idaddresskind, 
		#address_to_send.location AS sent_location,
		#address_to_send.cap AS sent_cap,
		#address_to_send.province AS sent_province,
		#address_to_send.nation AS sent_nation,
		#address_residence.address AS residence_address,
		add_res.codeaddress AS residence_idaddresskind,
		#address_residence.location AS residence_location,
		#address_residence.cap AS residence_cap,
		#address_residence.province AS residence_province,
		#address_residence.nation AS residence_nation,
		#expensetax.descriptioncontract as descriptioncontract,
		#expensetax.start,
		#expensetax.stop,
		#expensetax.authdoc,
		#expensetax.authdocdate,
		isnull(#expensetax.authneeded,'X') as authneeded,
		#expensetax.noauthreason
	FROM #expensetax
	JOIN tax
		ON #expensetax.taxcode= tax.taxcode
	JOIN service
		ON #expensetax.idser = service.idser
	JOIN #registry_birth
		ON #expensetax.idreg = #registry_birth.idreg
	LEFT OUTER JOIN #address_to_send
		ON #address_to_send.idreg = #expensetax.idreg
	LEFT OUTER JOIN address add_sen
		ON add_sen.idaddress = #address_to_send.idaddresskind
	LEFT OUTER JOIN #address_residence
		ON #address_residence.idreg = #expensetax.idreg
	LEFT OUTER JOIN address add_res
		ON add_res.idaddress = #address_to_send.idaddresskind
END
ELSE
BEGIN
		SELECT
		@departmentname as departmentname,
		#expensetax.idexp,
		#expensetax.idreg,
		#expensetax.registry,
		#registry_birth.city_title AS b_city,
		#expensetax.birthdate,
		#registry_birth.province AS b_province,
		#registry_birth.nation_title AS b_nation,
		#expensetax.cf,
		tax.taxref, --#expensetax.taxcode,   
		#expensetax.description,
		#expensetax.service,
		service.codeser, ----#expensetax.idser,
		#expensetax.upb,
		#expensetax.fin,
		#expensetax.codefin,
		#expensetax.npay,
		#expensetax.manager,
		#expensetax.taxablenet,
		#expensetax.grossamount,
		employtax,
		#address_to_send.officename AS sent_office,
		#address_to_send.recipientagency AS sent_agency,
		#address_to_send.address AS sent_address,
		add_sen.codeaddress AS sent_idaddresskind, 
		#address_to_send.location AS sent_location,
		#address_to_send.cap AS sent_cap,
		#address_to_send.province AS sent_province,
		#address_to_send.nation AS sent_nation,
		#address_residence.address AS residence_address,
		add_res.codeaddress AS residence_idaddresskind,
		#address_residence.location AS residence_location,
		#address_residence.cap AS residence_cap,
		#address_residence.province AS residence_province,
		#address_residence.nation AS residence_nation,
		#expensetax.descriptioncontract as descriptioncontract,
		#expensetax.start,
		#expensetax.stop,
		#expensetax.authdoc,
		#expensetax.authdocdate,
		isnull(#expensetax.authneeded,'X') as authneeded,
		#expensetax.noauthreason
	FROM #expensetax
	JOIN tax
		ON #expensetax.taxcode= tax.taxcode
	JOIN service
		ON #expensetax.idser = service.idser
	JOIN #registry_birth
		ON #expensetax.idreg = #registry_birth.idreg
	LEFT OUTER JOIN #address_to_send
		ON #address_to_send.idreg = #expensetax.idreg
	LEFT OUTER JOIN address add_sen
		ON add_sen.idaddress = #address_to_send.idaddresskind
	LEFT OUTER JOIN #address_residence
		ON #address_residence.idreg = #expensetax.idreg
	LEFT OUTER JOIN address add_res
		ON add_res.idaddress = #address_to_send.idaddresskind
	WHERE ISNULL(add_sen.codeaddress,'07_SW_DEF') =  '07_SW_ANP'
END
END

GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO
