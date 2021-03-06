-- CREAZIONE VISTA estimatedetailview
IF EXISTS(select * from sysobjects where id = object_id(N'[estimatedetailview]') and OBJECTPROPERTY(id, N'IsView') = 1)
DROP VIEW [estimatedetailview]
GO

 --setuser 'amministrazione'
 -- clear_table_info 'estimatedetailview'
--select * from estimatedetailview
CREATE  VIEW [estimatedetailview]
(
	idestimkind,
	yestim,
	nestim,
	rownum,
	idgroup,
	estimkind,
  	idreg,
  	idreg_main,
  	registry,
	detaildescription,
	annotations,
	number,
	taxable,
	taxrate,
	tax,
  	discount,
	start,
	stop,
	competencystart,
	competencystop,
	idinc_taxable,
	idinc_iva,	
	taxable_euro,
	iva_euro,
	rowtotal,
	idupb,
	codeupb,
	upb,
	idupb_iva, 
	codeupb_iva,	
	upb_iva, 
	idman,	manager,
	cu,
	ct,
	lu,
	lt,
	idaccmotive,
	codemotive,
	idaccmotiveannulment,
	codemotiveannulment,
	idsor1,
	idsor2,
	idsor3,
	sortcode1,
	sortcode2,
	sortcode3,
	idivakind,
	ivakind,
	toinvoice,
	exchangerate,
	description,
	flagintracom,
	ninvoiced,
	idsor01,
	idsor02,
	idsor03,
	idsor04,
	idsor05,
	idrevenuepartition,
	epkind,
	idepacc,
	yepacc,
	nepacc,
	idlist,
	intcode, list,
	cigcode,
	idfinmotive,
	iduniqueformcode,
	idflussocrediti,
	idflussocreditidetail,
	flag,
	proceedsexpiring,
	nform,
	idsor_siope,
	flagbankitaliaproceeds,
	idepacc_pre,
	yepacc_pre,
	nepacc_pre
	)
	AS SELECT
	estimatedetail.idestimkind,
	estimatedetail.yestim,
	estimatedetail.nestim,
	estimatedetail.rownum,
	estimatedetail.idgroup,
	estimatekind.description,
 	estimatedetail.idreg,
 	estimatedetail.idreg,
  	registry.title,
	estimatedetail.detaildescription,
	estimatedetail.annotations,
	estimatedetail.number,
	estimatedetail.taxable,
	estimatedetail.taxrate,
	estimatedetail.tax,
  	estimatedetail.discount,
	estimatedetail.start,
	estimatedetail.stop,
	estimatedetail.competencystart,
	estimatedetail.competencystop,
	estimatedetail.idinc_taxable,
	estimatedetail.idinc_iva,
 	    ROUND(estimatedetail.taxable * estimatedetail.number * 
		  CONVERT(DECIMAL(19,6),estimate.exchangerate) *
		  (1 - CONVERT(DECIMAL(19,6),ISNULL(estimatedetail.discount, 0.0))),2
		),
	ROUND(estimatedetail.tax,2),
 	    ROUND(estimatedetail.taxable * estimatedetail.number * 
		  CONVERT(DECIMAL(19,6),estimate.exchangerate) *
		  (1 - CONVERT(DECIMAL(19,6),ISNULL(estimatedetail.discount, 0.0))),2
		)+
	ROUND(estimatedetail.tax ,2),
	estimatedetail.idupb,	upb.codeupb,	upb.title,
	estimatedetail.idupb_iva, 	upb_iva.codeupb,	upb_iva.title, 
	estimate.idman,	manager.title,
	estimatedetail.cu,
	estimatedetail.ct,
	estimatedetail.lu,
	estimatedetail.lt,
	estimatedetail.idaccmotive,
	accmotive.codemotive,
	estimatedetail.idaccmotiveannulment,
	accmotiveannulment.codemotive,
	estimatedetail.idsor1,
	estimatedetail.idsor2,
	estimatedetail.idsor3,
	sorting1.sortcode,
	sorting2.sortcode,
	sorting3.sortcode,
	estimatedetail.idivakind,
	ivakind.description,
	estimatedetail.toinvoice,
	estimate.exchangerate,
	estimate.description,
	estimate.flagintracom,
	estimatedetail.ninvoiced,
	estimate.idsor01,
	estimate.idsor02,
	estimate.idsor03,
	estimate.idsor04,
	estimate.idsor05,
	estimatedetail.idrevenuepartition,
	estimatedetail.epkind,
	estimatedetail.idepacc,
	epacc.yepacc,
	epacc.nepacc,
	estimatedetail.idlist,
	list.intcode, list.description,
		isnull(estimatedetail.cigcode,estimate.cigcode),
			estimatedetail.idfinmotive,
	estimatedetail.iduniqueformcode,
	(select min(idflusso) from flussocreditidetail where flussocreditidetail.idestimkind = estimatedetail.idestimkind and flussocreditidetail.yestim = estimatedetail.yestim 
	 and flussocreditidetail.nestim = estimatedetail.nestim and flussocreditidetail.rownum = estimatedetail.rownum and flussocreditidetail.annulment is null and flussocreditidetail.stop is null),
	(select min(iddetail) from flussocreditidetail where flussocreditidetail.idestimkind = estimatedetail.idestimkind and flussocreditidetail.yestim = estimatedetail.yestim 
	 and flussocreditidetail.nestim = estimatedetail.nestim and flussocreditidetail.rownum = estimatedetail.rownum and flussocreditidetail.annulment is null and flussocreditidetail.stop is null),
	estimatedetail.flag,
	estimatedetail.proceedsexpiring,
	estimatedetail.nform,
	estimatedetail.idsor_siope,
	registry.flagbankitaliaproceeds,
	estimatedetail.idepacc_pre,
	epacc_pre.yepacc,
	epacc_pre.nepacc
FROM estimatedetail WITH (NOLOCK)
JOIN estimatekind WITH (NOLOCK)				ON estimatekind.idestimkind = estimatedetail.idestimkind
JOIN estimate WITH (NOLOCK)					ON estimate.yestim = estimatedetail.yestim
												AND estimate.nestim = estimatedetail.nestim	
												AND estimate.idestimkind = estimatedetail.idestimkind
left outer JOIN ivakind WITH (NOLOCK)					ON ivakind.idivakind = estimatedetail.idivakind
LEFT OUTER JOIN manager with (nolock)		ON manager.idman = estimate.idman
LEFT OUTER JOIN registry WITH (NOLOCK)		ON registry.idreg = estimatedetail.idreg
LEFT OUTER JOIN upb WITH (NOLOCK)			ON upb.idupb = estimatedetail.idupb
LEFT OUTER JOIN upb upb_iva  WITH (NOLOCK)	ON upb_iva.idupb = estimatedetail.idupb_iva
LEFT OUTER JOIN accmotive WITH (NOLOCK)		ON accmotive.idaccmotive = estimatedetail.idaccmotive
LEFT OUTER JOIN accmotive accmotiveannulment WITH (NOLOCK)		ON accmotiveannulment.idaccmotive = estimatedetail.idaccmotiveannulment
LEFT OUTER JOIN sorting sorting1 WITH (NOLOCK)		ON sorting1.idsor = estimatedetail.idsor1
LEFT OUTER JOIN sorting sorting2 WITH (NOLOCK)		ON sorting2.idsor = estimatedetail.idsor2
LEFT OUTER JOIN sorting sorting3 WITH (NOLOCK)		ON sorting3.idsor = estimatedetail.idsor3
LEFT OUTER JOIN  epacc								ON estimatedetail.idepacc= epacc.idepacc
LEFT OUTER JOIN  epacc	epacc_pre					ON estimatedetail.idepacc= epacc_pre.idepacc
LEFT OUTER JOIN list with (nolock)					ON list.idlist = estimatedetail.idlist

GO
 