if exists (select * from dbo.sysobjects where id = object_id(N'[rpt_compensoprestprof_impegni]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [rpt_compensoprestprof_impegni]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO


/*
exec rpt_compensoprestprof_impegni 2006,2006,3
*/
CREATE  PROCEDURE [rpt_compensoprestprof_impegni]
(
	@ayear 	int,
	@ycon 	int,  
	@ncon 	int
)
AS BEGIN
	
CREATE TABLE #accounting_contract
(
	expensephase 	varchar(60),
	ymov 		int,
	nmov 		int,
	adate 		datetime,
	description 	varchar(200),	
	codefin 	varchar(50),
	codeupb 	varchar(50),
	amount 		decimal(19,2)
)

DECLARE @accountingphase tinyint
SELECT @accountingphase =  expensephase 
FROM config
WHERE ayear = @ayear

INSERT INTO #accounting_contract
(
	expensephase,
	ymov,
	nmov,
	adate,
	description,
	codefin,
	codeupb,
	amount
)
SELECT
	expensephase.description,
	expense.ymov,
	expense.nmov,
	expense.adate,
	expense.description,
	fin.codefin,
	upb.codeupb,
	expenseyear.amount
FROM expenseprofservice
JOIN expense
	ON expense.idexp = expenseprofservice.idexp
	AND expense.nphase = @accountingphase
JOIN expenseyear
	ON expenseyear.idexp = expenseprofservice.idexp
	AND expenseyear.ayear = @ayear
JOIN expensephase
	ON expensephase.nphase = expense.nphase
LEFT OUTER JOIN fin
	ON fin.idfin = expenseyear.idfin
LEFT OUTER JOIN upb
	ON upb.idupb = expenseyear.idupb
WHERE expenseprofservice.ycon = @ycon
	AND expenseprofservice.ncon = @ncon

INSERT INTO #accounting_contract
(
	expensephase,
	ymov,
	nmov,
	adate,
	description,
	codefin,
	codeupb,
	amount
)
SELECT 
	pettycash.description,
	pettycashoperation.yoperation,
	pettycashoperation.noperation,
	pettycashoperation.adate,
	pettycashoperation.description,
	ISNULL(f2.codefin, fin.codefin),
	ISNULL(u2.codeupb,upb.codeupb),
	pettycashoperation.amount
FROM pettycashoperationprofservice
JOIN pettycashoperation
	ON pettycashoperation.idpettycash = pettycashoperationprofservice.idpettycash
	AND pettycashoperation.yoperation = pettycashoperationprofservice.yoperation
	AND pettycashoperation.noperation = pettycashoperationprofservice.noperation
JOIN pettycash 
	ON pettycash.idpettycash = pettycashoperation.idpettycash
LEFT OUTER JOIN expenseyear
	ON pettycashoperation.idexp = expenseyear.idexp
	AND expenseyear.ayear = @ayear
LEFT OUTER JOIN fin f2
	ON f2.idfin = expenseyear.idfin
LEFT OUTER JOIN upb u2
	ON u2.idupb = expenseyear.idupb
LEFT OUTER JOIN fin
	ON fin.idfin = pettycashoperation.idfin
LEFT OUTER JOIN upb
	ON upb.idupb = pettycashoperation.idupb
WHERE pettycashoperationprofservice.ycon = @ycon
	AND pettycashoperationprofservice.ncon = @ncon

SELECT 
	@ycon as 'ycon',
	@ncon as 'ncon',
	expensephase,
	ymov,
	nmov,
	adate,
	description,
	codefin,
	codeupb,
	amount
FROM #accounting_contract
ORDER BY adate, expensephase ASC,
ymov ASC,
nmov ASC

END






GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

