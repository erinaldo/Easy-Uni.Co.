-- CREAZIONE VISTA entrydetailview
IF EXISTS(select * from sysobjects where id = object_id(N'[entrydetailview]') and OBJECTPROPERTY(id, N'IsView') = 1)
DROP VIEW [entrydetailview]
GO
 
 
CREATE    VIEW entrydetailview
(
	yentry,
	nentry,
	ndetail,
	idacc,
	idreg,
	idupb,
	amount,
	give,
	have,
	idsor1,sortcode1,
	idsor2,sortcode2,
	idsor3,sortcode3,
	cu,
	ct,
	lu,
	lt,
	codeupb,
	codeacc,
	account,
	registry, 
	upb,
	idepupbkind,
	idaccountkind,
	flagregistry,
	flagupb, 
	idplaccount,
	idpatrimony,
	patpart,
	codepatrimony,
	placcpart,
	codeplaccount,
	idrelated,
	description,
	detaildescription,
	adate,
	doc,
	docdate,
	idaccmotive,
	accmotive,
	codemotive,
	identrykind,
	official,
	competencystart,
	competencystop,
	idsor01,
	idsor02,
	idsor03,
	idsor04,
	idsor05,
	importcode,
	autogenerated,
	idrelateddetail,
	idepexp,
	yepexp,
	nepexp,
	idepacc,
	flagaccountusage ,
	nepacc,
	yepacc
)
AS SELECT
entrydetail.yentry,
entrydetail.nentry,
entrydetail.ndetail,
entrydetail.idacc,
entrydetail.idreg,
entrydetail.idupb,
entrydetail.amount,
CASE
	WHEN ISNULL(amount,0) < 0 THEN -amount
	ELSE NULL
END,
CASE
	WHEN ISNULL(amount,0) >= 0 THEN amount
	ELSE NULL
END,
entrydetail.idsor1, S1.sortcode,
entrydetail.idsor2, S2.sortcode,
entrydetail.idsor3, S3.sortcode,
entrydetail.cu,
entrydetail.ct,
entrydetail.lu,
entrydetail.lt,
upb.codeupb,
account.codeacc,
account.title,
registry.title, 
upb.title,
upb.idepupbkind,
account.idaccountkind,
account.flagregistry,
account.flagupb,
account.idplaccount,
account.idpatrimony,
patrimony.patpart,
patrimony.codepatrimony,
placcount.placcpart,
placcount.codeplaccount,
entry.idrelated,
entry.description,
entrydetail.description,
entry.adate,
entry.doc,
entry.docdate,
entrydetail.idaccmotive,
accmotive.title,
accmotive.codemotive,
entry.identrykind,
entry.official,
entrydetail.competencystart,
entrydetail.competencystop,
COALESCE (entry.idsor01, upb.idsor01),
COALESCE (entry.idsor02, upb.idsor02),
COALESCE (entry.idsor03, upb.idsor03),
COALESCE (entry.idsor04, upb.idsor04),
COALESCE (entry.idsor05, upb.idsor05),
entrydetail.importcode,
entrydetail.autogenerated,
entrydetail.idrelated,
entrydetail.idepexp,
epexp.yepexp,
epexp.nepexp,
entrydetail.idepacc,
account.flagaccountusage ,
epacc.nepacc,
epacc.yepacc
FROM entrydetail
INNER JOIN entry			ON entrydetail.yentry = entry.yentry AND entrydetail.nentry = entry.nentry
LEFT OUTER JOIN registry	ON entrydetail.idreg = registry.idreg
LEFT OUTER JOIN upb			ON entrydetail.idupb = upb.idupb
LEFT OUTER JOIN account		ON entrydetail.idacc = account.idacc
LEFT OUTER JOIN  accmotive	ON entrydetail.idaccmotive = accmotive.idaccmotive
LEFT OUTER JOIN  epexp		ON entrydetail.idepexp= epexp.idepexp
LEFT OUTER JOIN  epacc		ON entrydetail.idepacc= epacc.idepacc
LEFT OUTER JOIN  patrimony	ON account.idpatrimony= patrimony.idpatrimony
LEFT OUTER JOIN  placcount	ON account.idplaccount= placcount.idplaccount
LEFT OUTER JOIN sorting S1 ON entrydetail.idsor1 = S1.idsor
LEFT OUTER JOIN sorting S2 ON entrydetail.idsor2 = S2.idsor
LEFT OUTER JOIN sorting S3 ON entrydetail.idsor3 = S3.idsor

GO
 
 