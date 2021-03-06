-- CREAZIONE VISTA accountvardetailview
IF EXISTS(select * from sysobjects where id = object_id(N'[accountvardetailview]') and OBJECTPROPERTY(id, N'IsView') = 1)
DROP VIEW [accountvardetailview]
GO

-- clear_table_info'accountvardetailview'
-- select  * from accountvardetailview
CREATE      VIEW accountvardetailview
(
	yvar,
	nvar,
	rownum,
	variationdescription,
	enactment,
	nenactment,
	enactmentdate,
	idupb,
	codeupb,
	upb,
	idacc,
	ayear,
	codeacc,
	account,
	idplaccount,
	codeplaccount,
	placcount,
	idpatrimony,
	codepatrimony,
	patrimony,
	description,
	amount,
	amount2,
	amount3,
	amount4,
	amount5,
	idaccountvarstatus,
	accountvarstatus,
	variationkind,
	variationkinddescr,
	idsor01,
	idsor02,
	idsor03,
	idsor04,
	idsor05,
	annotation,
	adate,
	idsor1,	sortcode1,
	idsor2, sortcode2,
	idsor3, sortcode3,
	idcostpartition,
	costpartitioncode,
	underwritingkind,
	underwritingkind_desc,
	flagaccountusage,
	cu,
	ct,
	lu,
	lt,
	idsor_economicbudget,
	sortcode_economicbudget,
	idsor_investmentbudget,
	sortcode_investmentbudget,
	idenactment,
	enactmentnumber,
	prevcassa
)
AS SELECT
	accountvardetail.yvar,
	accountvardetail.nvar,
	accountvardetail.rownum,
	accountvar.description,
	accountvar.enactment,
	accountvar.nenactment,
	accountvar.enactmentdate,
	accountvardetail.idupb,
	upb.codeupb,
	upb.title,
	accountvardetail.idacc,
	account.ayear,
	account.codeacc,
	account.title,
	placcount.idplaccount,
	placcount.codeplaccount,
	placcount.title,
	patrimony.idpatrimony,
	patrimony.codepatrimony,
	patrimony.title,
	accountvardetail.description,
	accountvardetail.amount,
	accountvardetail.amount2,
	accountvardetail.amount3,
	accountvardetail.amount4,
	accountvardetail.amount5,
	accountvar.idaccountvarstatus,
	accountvarstatus.description,
	accountvar.variationkind,
	variationkind.description,
	accountvar.idsor01,
	accountvar.idsor02,
	accountvar.idsor03,
	accountvar.idsor04,
	accountvar.idsor05,
	accountvardetail.annotation,
	accountvar.adate,
	accountvardetail.idsor1,
	S1.sortcode,
	accountvardetail.idsor2,
	S2.sortcode,
	accountvardetail.idsor3,
	S3.sortcode,
	costpartition.idcostpartition,
	costpartition.costpartitioncode,
	accountvardetail.underwritingkind,
	CASE accountvardetail.underwritingkind
		WHEN 'C' THEN 'CONTRIBUTI DA TERZI FINALIZZATI(IN CONTO CAPITALE E/O CONTO IMPIANTI)'
		WHEN 'I' THEN 'RISORSE DA INDEBITAMENTO'
		WHEN 'P' THEN 'RISORSE PROPRIE'
	END,
	account.flagaccountusage,
	accountvardetail.cu,
	accountvardetail.ct,
	accountvardetail.lu,
	accountvardetail.lt,
	SE.idsor, SE.sortcode,
	SI.idsor,SI.sortcode,
	accountvar.idenactment,
	accountenactment.nenactment,
	accountvardetail.prevcassa
FROM accountvardetail
JOIN accountvar with (nolock)			ON accountvardetail.yvar = accountvar.yvar	AND accountvardetail.nvar = accountvar.nvar
JOIN account with (nolock)			ON accountvardetail.idacc = account.idacc
JOIN upb with (nolock)				ON accountvardetail.idupb = upb.idupb
JOIN accountvarstatus with (nolock)	ON accountvarstatus.idaccountvarstatus = accountvar.idaccountvarstatus
JOIN variationkind with (nolock)	ON variationkind.idvariationkind = accountvar.variationkind
LEFT OUTER JOIN patrimony		    ON account.idpatrimony=patrimony.idpatrimony
LEFT OUTER JOIN placcount		   ON account.idplaccount = placcount.idplaccount
left outer join sorting S1			on accountvardetail.idsor1 = S1.idsor
left outer join sorting S2			on accountvardetail.idsor2 = S2.idsor
left outer join sorting S3			on accountvardetail.idsor3 = S3.idsor
left outer join costpartition		on costpartition.idcostpartition = accountvardetail.idcostpartition
LEFT OUTER JOIN sorting SE	(NOLOCK)	ON account.idsor_economicbudget = SE.idsor
LEFT OUTER JOIN sorting SI	(NOLOCK)	ON account.idsor_investmentbudget = SI.idsor
LEFT OUTER JOIN accountenactment with (nolock)	ON accountenactment.idenactment = accountvar.idenactment


GO

 
 