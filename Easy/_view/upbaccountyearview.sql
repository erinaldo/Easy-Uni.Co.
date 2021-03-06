-- CREAZIONE VISTA [upbaccountyearview]
IF EXISTS(select * from sysobjects where id = object_id(N'[upbaccountyearview]') and OBJECTPROPERTY(id, N'IsView') = 1)
DROP VIEW [upbaccountyearview]
GO
 -- clear_table_info'upbaccountyearview'
 CREATE    VIEW [upbaccountyearview] (
	idupb,
	codeupb,	
	upb,
	idacc,
	codeacc,
	account,
	--active,
	ayear,
	currentprev,
	previsionvariation,
	currentprev2,
	previsionvariation2,
	currentprev3,
	previsionvariation3,
	currentprev4,
	previsionvariation4,
	currentprev5,
	previsionvariation5,
	appropriation,
	appropriation2,
	appropriation3,
	appropriation4,
	appropriation5,
	idsor01,
	idsor02,
	idsor03,
	idsor04,
	idsor05,
	revenueprevision,
	costprevision
)

AS SELECT
	upbaccounttotal.idupb,
	upb.codeupb,
	upb.title,
	upbaccounttotal.idacc,
	account.codeacc,
	account.title,
	--account.active,
	account.ayear,
	upbaccounttotal.currentprev,
	upbaccounttotal.previsionvariation,
	upbaccounttotal.currentprev2,
	upbaccounttotal.previsionvariation2,
	upbaccounttotal.currentprev3,
	upbaccounttotal.previsionvariation3,
	upbaccounttotal.currentprev4,
	upbaccounttotal.previsionvariation4,
	upbaccounttotal.currentprev5,
	upbaccounttotal.previsionvariation5,
	nphase1.total,
	nphase1.total2,
	nphase1.total3,
	nphase1.total4,
	nphase1.total5,
	UPB.idsor01,
	UPB.idsor02,
	UPB.idsor03,
	UPB.idsor04,
	UPB.idsor05,
	upbyear.revenueprevision,
	upbyear.costprevision
FROM upbaccounttotal 
JOIN upb
	ON upbaccounttotal.idupb = upb.idupb
JOIN account
	ON upbaccounttotal.idacc = account.idacc
LEFT OUTER JOIN upbepexptotal  nphase1
	ON  nphase1.idupb = upbaccounttotal.idupb
	AND nphase1.idacc = upbaccounttotal.idacc
	AND nphase1.nphase = 1
LEFT OUTER JOIN upbyear
	on upbyear.idupb = upb.idupb and upbyear.ayear = account.ayear 
 
