-- CREAZIONE VISTA expensetaxcorrigeview
IF EXISTS(select * from sysobjects where id = object_id(N'[expensetaxcorrigeview]') and OBJECTPROPERTY(id, N'IsView') = 1)
DROP VIEW [expensetaxcorrigeview]
GO

--clear_table_info 'expensetaxcorrigeview'
-- select * from expensetaxcorrigeview
CREATE  VIEW expensetaxcorrigeview
(
	idexp,
	idexpensetaxcorrige,
	taxcode,
	taxref,
	tax,
	ayear,
	employamount,
	adminamount,
	idcity,
	city,
	provincecode,
	idfiscaltaxregion,
	fiscaltaxregion,
	linkedidinc,
	incomelinkedymov, 
	incomelinkednmov,
	linkedidexp,
	expenselinkedymov, 
	expenselinkednmov,
	ytaxpay,
	ntaxpay,
	adate,
	ymov,
	nmov,
	idreg,
	registry,
	expensedescription,
	expenseadate,
	ct,
	cu,
	lt,
	lu,
	phasedescription,
	descriptionrenumeration,
	idtreasurer,
	department
)
AS SELECT
	expensetaxcorrige.idexp,
	expensetaxcorrige.idexpensetaxcorrige,
	expensetaxcorrige.taxcode,
	tax.taxref,
	tax.description,
	expensetaxcorrige.ayear,
	expensetaxcorrige.employamount,
	expensetaxcorrige.adminamount,
	expensetaxcorrige.idcity,
	geo_city.title,
	geo_country.province,
	expensetaxcorrige.idfiscaltaxregion,
	fiscaltaxregion.title,
	expensetaxcorrige.linkedidinc,
	incomelinked.ymov, 
	incomelinked.nmov,
	expensetaxcorrige.linkedidexp,
	expenselinked.ymov, 
	expenselinked.nmov,
	expensetaxcorrige.ytaxpay,
	expensetaxcorrige.ntaxpay,
	expensetaxcorrige.adate,
	expense.ymov, 
	expense.nmov, 
	expense.idreg,
	registry.title, 
	expense.description,
	expense.adate, 
	expensetaxcorrige.ct,
	expensetaxcorrige.cu,
	expensetaxcorrige.lt,
	expensetaxcorrige.lu,
	expensephase.description,
	service.description,
	payment.idtreasurer,
	isnull(treasurer.header,treasurer.description)
FROM expensetaxcorrige
JOIN tax
	ON tax.taxcode = expensetaxcorrige.taxcode
JOIN expense
	ON expense.idexp = expensetaxcorrige.idexp
JOIN expensephase
	ON expense.nphase = expensephase.nphase
JOIN expenselast
	ON expense.idexp = expenselast.idexp
LEFT OUTER JOIN service
	ON expenselast.idser = service.idser
LEFT OUTER JOIN payment
	ON payment.kpay = expenselast.kpay
JOIN registry
	ON registry.idreg = expense.idreg
LEFT OUTER JOIN expense expenselinked
	ON expenselinked.idexp = expensetaxcorrige.linkedidexp
LEFT OUTER JOIN income incomelinked
	ON incomelinked.idinc = expensetaxcorrige.linkedidinc
LEFT OUTER JOIN geo_city
	ON geo_city.idcity = expensetaxcorrige.idcity
LEFT OUTER JOIN geo_country
	ON geo_country.idcountry = geo_city.idcountry
LEFT OUTER JOIN fiscaltaxregion
	ON fiscaltaxregion.idfiscaltaxregion = expensetaxcorrige.idfiscaltaxregion
LEFT OUTER JOIN treasurer 
	ON payment.idtreasurer=treasurer.idtreasurer

GO
