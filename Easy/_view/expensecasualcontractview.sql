-- CREAZIONE VISTA expensecasualcontractview
IF EXISTS(select * from sysobjects where id = object_id(N'[expensecasualcontractview]') and OBJECTPROPERTY(id, N'IsView') = 1)
DROP VIEW [expensecasualcontractview]
GO


--setuser 'amm'
--clear_table_info 'expensecasualcontractview'
--select * from expensecasualcontractview

CREATE   VIEW [expensecasualcontractview]
(
	ycon,
	ncon,
	idexp,
	nphase,
	phase,
	ymov,
	nmov,
	parentidexp,
	parentymov,
	parentnmov,
	formerymov,
	formernmov,
	ayear,
	idfin,
	codefin,
	finance,
	idupb,
	codeupb,
	upb,
	idreg,
	registry,
	idman,
	manager,
	kpay,
	ypay,
	npay,
	doc,
	docdate,
	description,
	amount,
	ayearstartamount,
	curramount,
	available,
	idpaymethod,
	iban,
	cin,
	idbank,
	idcab,
	cc,
	paymentdescr,
	idser,
	service,
	codeser,
	servicestart,
	servicestop,
	ivaamount,
	flag,
	autokind,
	idpayment,
	totflag, 
	flagarrear,
	expiration,
	adate,
	cu, ct, lu, lt,
	idaccmotive,
	idsor01,
	idsor02,
	idsor03,
	idsor04,
	idsor05
)
AS SELECT
	expensecasualcontract.ycon,
	expensecasualcontract.ncon,
	expense.idexp,
	expense.nphase,
	expensephase.description,
	expense.ymov,
	expense.nmov,
	expense.parentidexp,
	parentexpense.ymov,
	parentexpense.nmov,
	former.ymov,
	former.nmov,
	expenseyear.ayear,
	expenseyear.idfin,
	fin.codefin,
	fin.title,
	upb.idupb,
	upb.codeupb,
	upb.title,
	expense.idreg,
	registry.title,
	expense.idman,
	manager.title,
	expenselast.kpay,
	payment.ypay,
	payment.npay,
	expense.doc,
	expense.docdate,
	expense.description,
	expenseyear_starting.amount, 
	expenseyear.amount,
	expensetotal.curramount,
	expensetotal.available,
	expenselast.idpaymethod,
	expenselast.iban,
	expenselast.cin,
	expenselast.idbank,
	expenselast.idcab,
	expenselast.cc,
	expenselast.paymentdescr,
	expenselast.idser,
	service.description,
	service.codeser,
	expenselast.servicestart,
	expenselast.servicestop,
	expenselast.ivaamount,
	expenselast.flag,
	expense.autokind,
	expense.idpayment,
	expensetotal.flag,
	CASE
		WHEN ((expensetotal.flag&1)=0) THEN 'C'
		WHEN ((expensetotal.flag&1)=1) THEN 'R'
	END, 
	expense.expiration,
	expense.adate,
	expensecasualcontract.cu,
	expensecasualcontract.ct,
	expensecasualcontract.lu,
	expensecasualcontract.lt,
	casualcontract.idaccmotive,
	upb.idsor01,
	upb.idsor02,
	upb.idsor03,
	upb.idsor04,
	upb.idsor05
FROM expensecasualcontract
JOIN casualcontract		ON expensecasualcontract.ycon = casualcontract.ycon	AND expensecasualcontract.ncon = casualcontract.ncon
JOIN config				ON config.ayear=expensecasualcontract.ycon 
JOIN expense			ON expense.idexp = expensecasualcontract.idexp
JOIN expensephase		ON expensephase.nphase = expense.nphase
JOIN expenseyear		ON expenseyear.idexp = expense.idexp
JOIN expensetotal		ON expensetotal.idexp = expenseyear.idexp
								AND expensetotal.ayear = expenseyear.ayear
LEFT OUTER JOIN expense parentexpense	ON parentexpense.idexp = expense.parentidexp
LEFT OUTER JOIN expense former			ON expense.idformerexpense = former.idexp
LEFT OUTER JOIN expenseyear expenseyear_starting		ON expenseyear_starting.idexp = expense.idexp
										AND expenseyear_starting.ayear = expense.ymov
LEFT OUTER JOIN expenselast				ON expenselast.idexp = expense.idexp
LEFT OUTER JOIN fin				ON fin.idfin = expenseyear.idfin
LEFT OUTER JOIN upb				on upb.idupb = expenseyear.idupb
LEFT OUTER JOIN registry		ON registry.idreg = expense.idreg
LEFT OUTER JOIN manager			ON manager.idman = expense.idman
LEFT OUTER JOIN service			ON service.idser = expenselast.idser
LEFT OUTER JOIN payment			ON payment.kpay = expenselast.kpay


GO

