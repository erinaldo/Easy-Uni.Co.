SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[rebuild_upbexpensetotal]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [rebuild_upbexpensetotal]
GO

CREATE  PROCEDURE [rebuild_upbexpensetotal]
(
	@ayear int = null
)
AS BEGIN
DECLARE @arrearsphase tinyint
SELECT @arrearsphase = 1
SELECT @arrearsphase = expensefinphase FROM uniconfig

IF (@ayear IS NULL) 
BEGIN
	DELETE FROM upbexpensetotal
	INSERT INTO upbexpensetotal 
	(
		idupb, idfin, nphase,
		totalcompetency,
		totalarrears
	)
	SELECT 
		EY.idupb, F.idfin, E.nphase,
		ISNULL(
			(SELECT SUM(ET1.curramount)
			FROM expensetotal ET1
			JOIN expenseyear EY1
				ON EY1.ayear = ET1.ayear
				AND EY1.idexp = ET1.idexp
			JOIN expense E1
				ON E1.idexp = ET1.idexp
			JOIN finlink FL
				ON EY1.idfin = FL.idchild
			WHERE EY1.idupb = EY.idupb
				AND F.idfin = FL.idparent
				AND E1.nphase = E.nphase
				AND ((ET1.flag & 1) = 0))
		,0),
		ISNULL(
			(SELECT SUM(ET1.curramount)
			FROM expensetotal ET1
			JOIN expenseyear EY1
				ON EY1.ayear = ET1.ayear
				AND EY1.idexp = ET1.idexp
			JOIN expense E1
				ON E1.idexp = ET1.idexp
			JOIN finlink FL1
				ON EY1.idfin = FL1.idchild
			WHERE EY1.idupb = EY.idupb
				AND F.idfin = FL1.idparent
				AND E1.nphase = E.nphase
				AND ((ET1.flag & 1) = 1))
		,0)
	FROM expenseyear EY
	JOIN expense E
		ON E.idexp = EY.idexp
	LEFT OUTER JOIN expensetotal ET
		ON ET.idexp = EY.idexp
		AND ET.ayear = EY.ayear
	JOIN finlink 
		ON finlink.idchild = EY.idfin
	JOIN fin F
		ON finlink.idparent = F.idfin
	WHERE E.nphase >= @arrearsphase
		AND ((F.flag & 1) = 1)
	GROUP BY EY.idupb, F.idfin, E.nphase
END	
ELSE
BEGIN
	DELETE FROM upbexpensetotal WHERE EXISTS(SELECT fin.idfin FROM fin WHERE fin.idfin = upbexpensetotal.idfin
		AND fin.ayear = @ayear)

	INSERT INTO upbexpensetotal 
	(
		idupb,
		idfin,
		nphase,
		totalcompetency,
		totalarrears			
	)
	SELECT 
		EY.idupb,F.idfin,E.nphase,
		ISNULL(
			(SELECT SUM(ET1.curramount)
			FROM expensetotal ET1
			JOIN expenseyear EY1
				ON EY1.ayear = ET1.ayear
				AND EY1.idexp = ET1.idexp
			JOIN expense E1
				ON E1.idexp = ET1.idexp
			JOIN finlink FL
				ON EY1.idfin = FL.idchild
			WHERE EY1.idupb = EY.idupb
				AND F.idfin = FL.idparent
				AND E1.nphase = E.nphase
				AND ((ET1.flag & 1) = 0))
		,0),
		ISNULL(
			(SELECT SUM(ET1.curramount)
			FROM expensetotal ET1
			JOIN expenseyear EY1
				ON EY1.ayear = ET1.ayear
				AND EY1.idexp = ET1.idexp
			JOIN expense E1
				ON E1.idexp = ET1.idexp
			JOIN finlink FL1
				ON EY1.idfin = FL1.idchild
			WHERE EY1.idupb = EY.idupb
				AND F.idfin = FL1.idparent
				AND E1.nphase = E.nphase
				AND ((ET1.flag & 1) = 1))
		,0)
	FROM expenseyear EY
	JOIN expense E
		ON E.idexp = EY.idexp
	LEFT OUTER JOIN expensetotal ET
		ON ET.idexp = EY.idexp
		AND ET.ayear = EY.ayear
	JOIN finlink 
		ON finlink.idchild = EY.idfin
	JOIN fin F
		ON finlink.idparent = F.idfin
	WHERE E.nphase >= @arrearsphase
		AND F.ayear = @ayear
		AND EY.ayear = @ayear
		AND ((F.flag & 1) = 1)
	GROUP BY EY.idupb,F.idfin,E.nphase

END
	
END




GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

