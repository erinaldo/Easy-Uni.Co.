/* Versione 1.0.1 del 16/11/2007 ultima modifica: MARIA */

if exists (select * from dbo.sysobjects where id = object_id(N'[rpt_residui_per_anno]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [rpt_residui_per_anno]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO



CREATE   PROCEDURE [rpt_residui_per_anno]
	@ayear 		int,
	@date		datetime,
	@finpart 	char(1),
	@levelusable 	tinyint,
	@idupb		varchar(36),
	@showupb 	char(1),
	@showchildupb 	char(1)
AS
BEGIN

DECLARE @idupboriginal varchar(36)
SET @idupboriginal= @idupb
IF (@showchildupb = 'S') set @idupb=@idupb + '%' 


DECLARE @cash_phase tinyint
DECLARE @finphase   tinyint
IF @finpart = 'E'
	BEGIN
		SELECT @finphase = assessmentphasecode
		FROM config
		WHERE ayear = @ayear
		IF @finphase IS NULL
			BEGIN
				SELECT @finphase = incomefinphase
				FROM uniconfig
			END

		SELECT @cash_phase = MAX(nphase)
		FROM incomephase
	END
ELSE
	BEGIN
		SELECT @finphase = appropriationphasecode
			FROM config
			WHERE ayear = @ayear
		IF @finphase IS NULL
			BEGIN
				SELECT @finphase = expensefinphase
				FROM uniconfig
			END
		SELECT @cash_phase = MAX(nphase)
		FROM expensephase
	END

CREATE TABLE #initial_residual
	(ayear int, idfin int, idupb varchar(36), total decimal(19,2))
CREATE TABLE #var_residual
	(ayear int, idfin int, idupb varchar(36), total decimal(19,2))
	
CREATE TABLE #cash_residual
	(ayear int, idfin int, idupb varchar(36), total decimal(19,2))

CREATE TABLE #var_cash_residual
    	(ayear int, idfin int, idupb varchar(36), total decimal(19,2))

IF @finpart = 'E'
BEGIN
	INSERT INTO #initial_residual
		(
		ayear,
		idfin,
		idupb,
		total
		)
	SELECT
		income.ymov,
		finlink.idparent, 
		incomeyear.idupb,
		SUM(ISNULL(incomeyear.amount, 0.0))
	FROM incomeyear
	JOIN income
		ON income.idinc = incomeyear.idinc
	JOIN finlink
		ON finlink.idchild = incomeyear.idfin  AND finlink.nlevel = @levelusable
	JOIN incometotal
		ON  incomeyear.idinc = incometotal.idinc
		AND incomeyear.ayear = incometotal.ayear			
	WHERE incomeyear.ayear = @ayear
		AND (incomeyear.idupb like @idupb )
		AND income.adate <= @date
		AND ((incometotal.flag&1) = 1) -- Residuo
		AND income.nphase = @finphase
	GROUP BY income.ymov,incomeyear.idupb,finlink.idparent
	INSERT INTO #var_residual
		(
		ayear,
		idfin,
		idupb,
		total
		)
	SELECT
		income.ymov,
		finlink.idparent,
		incomeyear.idupb,
		SUM(ISNULL(incomevar.amount, 0.0))
	FROM incomevar
	JOIN incomeyear
		ON incomeyear.idinc = incomevar.idinc
		AND incomeyear.ayear = @ayear
	JOIN income
		ON incomeyear.idinc = income.idinc
	JOIN finlink
		ON finlink.idchild = incomeyear.idfin  AND finlink.nlevel = @levelusable
	JOIN incometotal
		ON  incomeyear.idinc = incometotal.idinc
		AND incomeyear.ayear = incometotal.ayear			
	WHERE incomevar.yvar = @ayear
		AND incomevar.adate <= @date 
		and (incomeyear.idupb like @idupb )
		AND ((incometotal.flag&1) = 1) -- Residuo
		AND income.nphase = @finphase
	GROUP BY income.ymov,incomeyear.idupb, finlink.idparent

	INSERT INTO #cash_residual
		(
		ayear,
		idfin,
		idupb,
		total
		)
	SELECT
		I.ymov,
		FL1.idparent,
		IY.idupb,
		SUM(HPV.amount)
	FROM historyproceedsview HPV
	JOIN incomeyear IY
		ON IY.idinc = HPV.idinc
		AND HPV.ymov = @ayear
	JOIN incomelink IL 
		ON IL.idchild = IY.idinc AND IL.nlevel = @finphase
	JOIN finlink  FL1
		ON FL1.idchild = IY.idfin AND FL1.nlevel = @levelusable
	JOIN income I
		ON IL.idparent = I.idinc 
	JOIN income I1
		ON IY.idinc = I1.idinc 
	JOIN incometotal
		ON  IY.idinc = incometotal.idinc
		AND IY.ayear = incometotal.ayear
	WHERE HPV.competencydate <= @date
		AND IY.idupb LIKE @idupb 
		AND IY.ayear = @ayear
		AND ((incometotal.flag&1) = 1) -- Residuo
		AND I1.nphase = @cash_phase
	GROUP BY I.ymov, IY.idupb,FL1.idparent

	INSERT INTO #var_cash_residual
	    	(
	   	ayear,
	    	idfin,
		idupb,
	    	total
	    	)
	SELECT
			I.ymov,
			FL1.idparent,
			IY.idupb,
			SUM(ISNULL(IV.amount, 0.0))
		FROM incomevar IV
		JOIN incomeyear IY
			ON  IY.idinc = IV.idinc
			AND IY.ayear = @ayear
		JOIN incomelink IL 
			ON IL.idchild = IY.idinc AND IL.nlevel = @finphase
		JOIN finlink  FL1
			ON FL1.idchild = IY.idfin AND FL1.nlevel = @levelusable
		JOIN income I
			ON I.idinc = IL.idparent
		JOIN income I1
			ON I1.idinc = IY.idinc 
		JOIN incometotal
			ON  IY.idinc = incometotal.idinc
			AND IY.ayear = incometotal.ayear
		JOIN historyproceedsview HPV
			ON HPV.idinc = IV.idinc
			AND HPV.ymov = @ayear
		WHERE IV.yvar = @ayear
			AND IV.adate <= @date
			AND IY.idupb like @idupb
			AND ((incometotal.flag&1) = 1) -- Residuo
			AND I1.nphase = @cash_phase
			AND HPV.competencydate <= @date
		GROUP BY I.ymov, IY.idupb,FL1.idparent
END
IF @finpart = 'S'
BEGIN
	INSERT INTO #initial_residual
		(
		ayear,
		idfin,
		idupb,
		total
		)
	SELECT
		expense.ymov,
		finlink.idparent,
		expenseyear.idupb,
		SUM(ISNULL(expenseyear.amount, 0.0))
	FROM expenseyear
	JOIN expense
		ON expense.idexp = expenseyear.idexp
	JOIN finlink
		ON finlink.idchild = expenseyear.idfin  AND finlink.nlevel = @levelusable
	JOIN expensetotal
		ON  expenseyear.idexp = expensetotal.idexp
		AND expenseyear.ayear = expensetotal.ayear			
	WHERE expenseyear.ayear = @ayear
		AND (expenseyear.idupb like @idupb )
		AND ((expensetotal.flag&1) = 1) -- Residuo
		AND expense.nphase = @finphase
		AND expense.adate <= @date
	GROUP BY expense.ymov,expenseyear.idupb, finlink.idparent
	INSERT INTO #var_residual
		(
		ayear,
		idfin,idupb,
		total
		)
	SELECT
	  	expense.ymov,
		finlink.idparent, 
		expenseyear.idupb,
		SUM(ISNULL(expensevar.amount, 0.0))
	FROM expensevar
	JOIN expenseyear
		ON expenseyear.idexp = expensevar.idexp
		AND expenseyear.ayear = @ayear
	JOIN expense
		ON expenseyear.idexp = expense.idexp
	JOIN finlink
		ON finlink.idchild = expenseyear.idfin  AND finlink.nlevel = @levelusable
	JOIN expensetotal
		ON  expenseyear.idexp = expensetotal.idexp
		AND expenseyear.ayear = expensetotal.ayear			
	WHERE expensevar.yvar = @ayear
		AND (expenseyear.idupb like @idupb )
		AND expensevar.adate <= @date 
		AND ((expensetotal.flag&1) = 1) -- Residuo
		AND expense.nphase = @finphase
		GROUP BY expense.ymov, expenseyear.idupb,finlink.idparent
	
	INSERT INTO #cash_residual
		(
		ayear,
		idfin,
		idupb,
		total
		)
	SELECT
		E.ymov,
		FL1.idparent, 
		EY.idupb,
		SUM(HPV.amount)
	FROM historypaymentview HPV
	JOIN expenseyear EY
		ON  EY.idexp = HPV.idexp
		AND HPV.ymov = @ayear
	JOIN expenselink EL 
		ON EL.idchild = EY.idexp AND EL.nlevel = @finphase
	JOIN finlink  FL1
		ON FL1.idchild = EY.idfin AND FL1.nlevel = @levelusable
	JOIN expense E
		ON EL.idparent = E.idexp
	JOIN expense E1
		ON EY.idexp = E1.idexp 
	JOIN expensetotal
		ON  EY.idexp = expensetotal.idexp
		AND EY.ayear = expensetotal.ayear
	WHERE 	HPV.competencydate <= @date
		AND EY.idupb like @idupb
		AND EY.ayear = @ayear
		AND ((expensetotal.flag&1) = 1) -- Residuo
		AND E1.nphase = @cash_phase
	GROUP BY E.ymov, EY.idupb, FL1.idparent

	INSERT INTO #var_cash_residual
		    (
			ayear,
			idfin,
			idupb,
			total
		    )
	SELECT 
			E.ymov,
			FL1.idparent,
			EY.idupb,
			SUM(ISNULL(EV.amount, 0.0))
		FROM expensevar EV
		JOIN expenseyear EY 
			ON EY.idexp = EV.idexp
			AND EY.ayear = @ayear
		JOIN expenselink EL 
			ON EL.idchild = EY.idexp AND EL.nlevel = @finphase
		JOIN finlink  FL1
			ON FL1.idchild = EY.idfin AND FL1.nlevel = @levelusable
		JOIN expense E
			ON EL.idparent = E.idexp
		JOIN expense E1
			ON EY.idexp = E1.idexp 
		JOIN expensetotal
			ON  EY.idexp = expensetotal.idexp
			AND EY.ayear = expensetotal.ayear
		JOIN historypaymentview HPV
			ON HPV.idexp = EV.idexp
			AND HPV.ymov = @ayear
		WHERE EV.yvar = @ayear
			AND EV.adate <= @date
			AND ((expensetotal.flag&1) = 1) -- Residuo
			AND E1.nphase = @cash_phase
			AND HPV.competencydate <= @date
			AND (EY.idupb like @idupb )
		GROUP BY E.ymov, EY.idupb,FL1.idparent
END
	

CREATE TABLE #report_residual
(
	ayear			int,
	codeupb			varchar(50),
	idupb 			varchar(36),
	upb   			varchar(100),
	upbprintingorder	varchar(36),
	idfin			varchar(39),
	codefin			varchar(12),
	title			varchar(100),
	finprintingorder	varchar(12),
	initial_residual	decimal(19,2),
	var_residual		decimal(19,2),
	cash_residual		decimal(19,2),
	var_cash_residual	decimal(19,2)				
)

INSERT INTO #report_residual
	(ayear, idfin,idupb)
SELECT DISTINCT ayear,idfin,idupb 
	FROM #initial_residual

INSERT INTO #report_residual
	(ayear, idfin,idupb)
SELECT DISTINCT ayear,idfin,idupb 
	FROM #var_residual
	WHERE (	
		#var_residual.idfin	
		) 
		NOT IN (
			SELECT 	#report_residual.idfin  
			FROM #report_residual	
			)

INSERT INTO #report_residual
 (ayear, idfin,idupb)
SELECT DISTINCT ayear,idfin,idupb
	FROM #cash_residual
	WHERE (
		#cash_residual.idfin
		) 
		NOT IN (
			SELECT 
		 	#report_residual.idfin  
			FROM #report_residual)
		
INSERT INTO #report_residual
(ayear, idfin, idupb)
SELECT DISTINCT ayear,idfin ,idupb
	FROM #var_cash_residual
	WHERE (
		#var_cash_residual.idfin
		) 
		NOT IN (
			SELECT 
		 	#report_residual.idfin  
			FROM #report_residual
			)

UPDATE #report_residual 
SET initial_residual = ISNULL((SELECT #initial_residual.total FROM #initial_residual
		WHERE #initial_residual.idfin = #report_residual.idfin
		and #initial_residual.idupb = #report_residual.idupb
		AND #initial_residual.ayear = #report_residual.ayear), 0.0)

UPDATE #report_residual 
SET var_residual = ISNULL((SELECT #var_residual.total FROM #var_residual
	WHERE #var_residual.idfin = #report_residual.idfin
	and #var_residual.idupb = #report_residual.idupb
	AND #var_residual.ayear = #report_residual.ayear), 0.0)

UPDATE #report_residual
SET cash_residual =	ISNULL((SELECT #cash_residual.total FROM #cash_residual
	WHERE #cash_residual.idfin = #report_residual.idfin
	and #cash_residual.idupb = #report_residual.idupb
	AND #cash_residual.ayear = #report_residual.ayear), 0.0)

UPDATE #report_residual
SET var_cash_residual =	ISNULL((SELECT #var_cash_residual.total FROM #var_cash_residual
	WHERE #var_cash_residual.idfin = #report_residual.idfin
	and #var_cash_residual.idupb = #report_residual.idupb
	AND #var_cash_residual.ayear = #report_residual.ayear), 0.0)

	UPDATE #report_residual SET title = fin.title ,
			finprintingorder = fin.printingorder,
			codefin = fin.codefin	
		 	from fin where fin.idfin = #report_residual.idfin

	UPDATE #report_residual SET codeupb = upb.codeupb ,
			upbprintingorder = upb.printingorder,			
			upb = upb.title
		 from upb where upb.idupb = #report_residual.idupb


	IF (@showupb <>'S') AND (@idupboriginal <> '%' ) AND (@showchildupb = 'S')
			UPDATE #report_residual SET  
				upbprintingorder = (SELECT TOP 1 upbprintingorder
					FROM #report_residual
					WHERE idupb = @idupboriginal),
				upb = (SELECT TOP 1 upb
					FROM #report_residual
					WHERE idupb = @idupboriginal),
				idupb = @idupboriginal,
				codeupb =(SELECT TOP 1 codeupb
					FROM #report_residual	
					WHERE idupb = @idupboriginal)
	
	IF (@showupb <>'S') and (@idupboriginal = '%') 
				UPDATE #report_residual SET  
				upbprintingorder = null	,
				upb =  null,
				idupb = null,
				codeupb = null

IF (@showupb <>'S') 
BEGIN

	SELECT 
		ayear,
		idfin,
		codefin,
		title,
		finprintingorder,
		codeupb,		
		idupb,	
		upb,
		upbprintingorder,
		SUM(ISNULL(initial_residual,0.0)) 	as 'initial_residual',
		SUM(ISNULL(var_residual,0.0)) 		as 'var_residual',
		SUM(ISNULL(cash_residual,0.0)) 		as 'cash_residual',
		SUM(ISNULL(var_cash_residual,0.0)) 	as 'var_cash_residual'
	FROM #report_residual
	group by upbprintingorder,finprintingorder,
	ayear,idfin,codefin,title,codeupb,idupb,upb   			
	ORDER BY ayear ASC,upbprintingorder ASC,finprintingorder ASC
END 
ELSE
	SELECT 
		ayear,
		idfin,
		codefin,
		title,
		finprintingorder,
		codeupb,		
		idupb,	
		upb,
		upbprintingorder,
		initial_residual,
		var_residual,
		cash_residual,
		var_cash_residual
	FROM #report_residual
	ORDER BY ayear ASC,upbprintingorder ASC,finprintingorder ASC
END



GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

