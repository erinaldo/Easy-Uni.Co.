if exists (select * from dbo.sysobjects where id = object_id(N'[rpt_compensoparasub_impegni]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [rpt_compensoparasub_impegni]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO



CREATE   PROCEDURE [rpt_compensoparasub_impegni]
(
	@ayear smallint, 
	@ycon smallint, 
	@ncon int
)
AS BEGIN

DECLARE @expensephase tinyint
SELECT @expensephase = expensephase FROM config WHERE ayear = @ayear
			
SELECT
	@ycon,
	@ncon,
	payroll.npayroll,
	expensephase.description,
	expense.ymov,
	expense.nmov,
	expense.adate,
	expense.description,
	fin.codefin,
	upb.codeupb,
	expenseyear.amount
FROM expensepayroll
JOIN expense
	ON expense.idexp = expensepayroll.idexp
JOIN expenseyear
	ON expenseyear.idexp = expensepayroll.idexp
JOIN expensephase
	ON expensephase.nphase = expense.nphase
JOIN fin
	ON fin.idfin = expenseyear.idfin
LEFT OUTER JOIN upb
	ON upb.idupb = expenseyear.idupb
LEFT OUTER JOIN payroll
	ON payroll.idpayroll = expensepayroll.idpayroll
LEFT OUTER JOIN parasubcontract
	ON  parasubcontract.idcon = payroll.idcon
WHERE parasubcontract.ycon = @ycon
	AND parasubcontract.ncon = @ncon
	AND expense.nphase = @expensephase
	AND expenseyear.ayear = @ayear
ORDER BY expensephase.description ASC, expense.ymov ASC, expense.nmov ASC
END






GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

