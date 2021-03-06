if exists (select * from dbo.sysobjects where id = object_id(N'[rpt_contabcompensodip]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [rpt_contabcompensodip]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO


CREATE   PROCEDURE [rpt_contabcompensodip]
@ayear      int,  
@ycon 	    int,
@ncon	    int
AS
BEGIN
	
	
CREATE TABLE #accounting_contract
(
	expensephase varchar(50),
	ymov int,
	nmov int,
	adate datetime,
	description varchar(150),	
	codefin varchar(50),
	codeupb varchar(50),
	amount decimal(19,2)	
)


DECLARE @accountingphase tinyint
SELECT 	@accountingphase = expensephase FROM config WHERE ayear = @ayear
		
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
FROM expensewageaddition
JOIN expense
	ON expense.idexp = expensewageaddition.idexp
	AND expense.nphase = @accountingphase 
JOIN expenseyear
	ON expenseyear.idexp = expensewageaddition.idexp
	AND expenseyear.ayear = @ayear
JOIN expensephase
	ON expensephase.nphase = expense.nphase
LEFT OUTER JOIN fin
	ON fin.idfin = expenseyear.idfin
LEFT OUTER JOIN upb
	ON upb.idupb = expenseyear.idupb
WHERE expensewageaddition.ycon = @ycon
	AND expensewageaddition.ncon = @ncon
	
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
	ORDER BY expensephase ASC,
 	ymov ASC,
	nmov ASC
END



GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

