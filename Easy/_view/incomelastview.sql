-- CREAZIONE VISTA incomelastview
IF EXISTS(select * from sysobjects where id = object_id(N'[incomelastview]') and OBJECTPROPERTY(id, N'IsView') = 1)
DROP VIEW [incomelastview]
GO



CREATE    VIEW [incomelastview]
(
	idinc,
	nphase,
	phase,
	ymov,
	nmov,
	parentymov,
	parentnmov,
	parentidinc,
	ayear,
	idfin,
	codefin,
	finance,
	idupb,
	codeupb,
	upb,
	idsor01,
	idsor02,
	idsor03,
	idsor04,
	idsor05,	
	idreg,
	registry,
	idman,
	manager,
	kpro,
	ypro,
	npro,
	doc,
	docdate,
	description,
	amount,
	ayearstartamount,
	curramount,
	available,
  	unpartitioned,
	flag,
	totflag,
	flagarrear,
	autokind,
	autocode,
	idpayment,
	expiration,
	adate,
	nbill,
	idpro,
	cu,
	ct,
	lu,
	lt,
	idtreasurer_main,
	idtreasurer
)
AS SELECT
	income.idinc,
	income.nphase,
	incomephase.description,
	income.ymov,
	income.nmov,
	parentincome.ymov,
	parentincome.nmov,
	--income.ycreation,
	income.parentidinc,
	incomeyear.ayear,
	incomeyear.idfin,
	fin.codefin,
	fin.title,
	upb.idupb,
	upb.codeupb,
	upb.title,
	upb.idsor01,
	upb.idsor02,
	upb.idsor03,
	upb.idsor04,
	upb.idsor05,
	income.idreg,
	registry.title,
	income.idman,
	manager.title,
	proceeds.kpro,
	proceeds.ypro,
	proceeds.npro,
	income.doc,
	income.docdate,
	income.description,
	--income.amount,
	incomeyear_starting.amount,
	incomeyear.amount,
	incometotal.curramount,
	incometotal.available,
	-- Modificato da Francesco per correggere la visualizzazione dell'importo da assegnare su movimenti residui
        case income.nphase 
	 WHEN (SELECT incomefinphase FROM uniconfig) THEN
		CASE   
			WHEN ((incometotal.flag&1) = 0) THEN  ISNULL(incometotal.curramount,0)-ISNULL(incometotal.partitioned,0)
			ELSE
			0
		END
	ELSE
		  ISNULL(incometotal.curramount,0)-ISNULL(incometotal.partitioned,0)
	END,
	incomelast.flag,
	incometotal.flag, 
	CASE
		WHEN ((incometotal.flag&1)=0) THEN 'C'
		WHEN ((incometotal.flag&1)=1) THEN 'R'
	END, 
	income.autokind,
	income.autocode,
	--income.idproceeds,
	income.idpayment,
	income.expiration,
	income.adate,
	incomelast.nbill,
	incomelast.idpro,
	incomelast.cu,
	incomelast.ct,
	incomelast.lu,
	incomelast.lt,
	payment.idtreasurer,
	proceeds.idtreasurer
	FROM income (NOLOCK)
	JOIN incomephase (NOLOCK)
	ON incomephase.nphase = income.nphase
	JOIN incomeyear (NOLOCK)
	ON incomeyear.idinc = income.idinc 
	JOIN incometotal (NOLOCK)
	ON incometotal.idinc = income.idinc
	AND incometotal.ayear = incomeyear.ayear
	LEFT OUTER JOIN income parentincome (NOLOCK)
	ON income.parentidinc = parentincome.idinc
	JOIN incomelast  (NOLOCK)
	ON incomelast.idinc = income.idinc
	LEFT OUTER JOIN proceeds  (NOLOCK)
	ON incomelast.kpro = proceeds.kpro
	LEFT OUTER JOIN fin (NOLOCK)
	ON fin.idfin = incomeyear.idfin
	LEFT OUTER JOIN upb (NOLOCK)
	ON upb.idupb=incomeyear.idupb
	LEFT OUTER JOIN registry (NOLOCK)
	ON registry.idreg = income.idreg
	LEFT OUTER JOIN manager (NOLOCK)
	ON manager.idman = income.idman
	LEFT OUTER JOIN incometotal incometotal_firstyear(NOLOCK)
  	ON incometotal_firstyear.idinc = income.idinc
  	AND ((incometotal_firstyear.flag & 2) <> 0 )
 	LEFT OUTER JOIN incomeyear incomeyear_starting(NOLOCK) 
	ON incomeyear_starting.idinc = incometotal_firstyear.idinc
  	AND incomeyear_starting.ayear = incometotal_firstyear.ayear
	LEFT OUTER JOIN expenselast  (NOLOCK)
			ON expenselast.idexp = income.idpayment
	LEFT OUTER JOIN payment (NOLOCK)
		 ON payment.kpay = expenselast.kpay

GO
