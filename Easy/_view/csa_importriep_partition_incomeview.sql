-- CREAZIONE VISTA [csa_importriep_partition_incomeview]
IF EXISTS(select * from sysobjects where id = object_id(N'[csa_importriep_partition_incomeview]') and OBJECTPROPERTY(id, N'IsView') = 1)
DROP VIEW [csa_importriep_partition_incomeview]
GO  
 
 --setuser 'amministrazione'
--setuser'amm'
--SELECT * FROM [csa_importriep_partition_incomeview]
--DROP VIEW [csa_importriep_partition_incomeview]
CREATE VIEW  [csa_importriep_partition_incomeview]
(

	idcsa_import,
	yimport,
	nimport,
	idcsa_contract,
	ycontract,
	ncontract,
	idcsa_contractkind,
	csa_contractkindcode,
	csa_contractkind,
	idriep,
	importo,
	ndetail,
	amount,
	idinc,
	ymov,
	nmov,
	descrmov,
	paridinc,
	nphaseincome,
	phase,
	movkind,
	descrmovkind,
	idreg ,
	registry ,
	idreg_main,
	registry_main,
	lu,	lt,cu,ct
)
AS SELECT 
	RE.idcsa_import,
	I.yimport,
	I.nimport,
	IR.idcsa_contract,
	C.ycontract,
	C.ncontract,
	IR.idcsa_contractkind,
	CK.contractkindcode,
	CK.description,
	RE.idriep,
	IR.importo,
	RE.ndetail,
	RPI.amount,
	INC.idinc,
	INC.ymov,
	INC.nmov,
	INC.parentidinc,
	INC.nphase,
	INC.description,
	F.description,
	RPI.movkind,
	MK.description,
	REG.idreg ,
	REG.title ,
	REG_MAIN.idreg,
	REG_MAIN.title,
	RE.lu,	RE.lt,RE.cu,RE.ct
FROM csa_importriep_partition_income RPI
JOIN csa_importriep_partition RE ON RPI.idcsa_import = RE.idcsa_import  AND RPI.idriep = RE.idriep AND RPI.ndetail = RE.ndetail
JOIN csa_importriep IR 	ON RE.idcsa_import = IR.idcsa_import and RE.idriep = IR.idriep 
LEFT OUTER JOIN income INC on RPI.idinc=INC.idinc
LEFT OUTER JOIN registry REG_MAIN on REG_MAIN.idreg=INC.idreg
LEFT OUTER JOIN registry REG on REG.idreg=IR.idreg
JOIN csa_import I
	ON I.idcsa_import = IR.idcsa_import
LEFT OUTER JOIN csa_contractkind CK
	ON IR.idcsa_contractkind = CK.idcsa_contractkind
LEFT OUTER JOIN csa_contract C
	ON C.idcsa_contract = IR.idcsa_contract
	AND C.idcsa_contractkind = CK.idcsa_contractkind
	AND C.ayear = IR.ayear
LEFT OUTER JOIN csa_contractkindyear CKY
	ON C.idcsa_contractkind = CKY.idcsa_contractkind
	AND CKY.ayear = C.ayear
LEFT OUTER JOIN incomephase F ON 
	F.nphase = INC.nphase
LEFT OUTER JOIN csa_movkind MK ON 
	MK.movkind = RPI.movkind


GO


