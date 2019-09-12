if exists (select * from dbo.sysobjects where id = object_id(N'[exp_prevavailable_upb_fin]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [exp_prevavailable_upb_fin]
GO


SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO


CREATE PROCEDURE exp_prevavailable_upb_fin
(
	@ayear int,
	@finpart char(1),
	@idman int,
	@idsor01 int,
	@idsor02 int,
	@idsor03 int,
	@idsor04 int,
	@idsor05 int
)
AS BEGIN
DECLARE @finphase tinyint
DECLARE @maxphase tinyint
DECLARE @fin_kind tinyint
SELECT  @fin_kind = fin_kind 
FROM    config WHERE ayear = @ayear
CREATE TABLE #previsionupbfin
(
	ayear int,
	idupb varchar(36),
	codeupb varchar(50),
	upb varchar(150),
	idfin int,
	codefin varchar(50),
	fin varchar(150),
	finlevel varchar(50),
	manager varchar(150),
	incomeprevavailable_comp decimal(19,2),	
	incomeprevavailable_cash decimal(19,2),
	expenseprevavailable_comp decimal(19,2),
	expenseprevavailable_cash decimal(19,2),

	varprevprinc decimal(19,2),
	varprevsec decimal(19,2),
	incomeprevavailableNonApprovato_comp decimal(19,2),	
	incomeprevavailableNonApprovato_cash decimal(19,2),
	expenseprevavailableNonApprovato_comp decimal(19,2),
	expenseprevavailableNonApprovato_cash decimal(19,2)
)

--sp_help upb
INSERT INTO #previsionupbfin
(
	ayear,
	idupb,
	codeupb,
	upb,
	idfin,
	codefin,
	fin,
	finlevel,
	manager
)
SELECT @ayear,
       U.idupb,
       U.codeupb,
       U.title,
       F.idfin,
       F.codefin,
       F.title,
       L.description,
	   M.title
FROM   upb U 
CROSS  JOIN   fin F
JOIN finlast FL 
	ON FL.idfin = F.idfin 
JOIN finlevel L
	ON L.nlevel = F.nlevel 
left outer join manager M
	on M.idman = U.idman
WHERE  F.ayear = @ayear AND L.ayear = @ayear
AND    (((@finpart = 'S') AND ((F.flag & 1) <> 0))  OR
       	((@finpart = 'E') AND ((F.flag & 1) = 0)))
AND ((U.idman = @idman) or (@idman is null )) 
AND (@idsor01 IS NULL OR U.idsor01 = @idsor01)
AND (@idsor02 IS NULL OR U.idsor02 = @idsor02)
AND (@idsor03 IS NULL OR U.idsor03 = @idsor03)
AND (@idsor04 IS NULL OR U.idsor04 = @idsor04)
AND (@idsor05 IS NULL OR U.idsor05 = @idsor05)
ORDER BY codeupb, codefin

IF (@finpart = 'S') 
BEGIN
	SELECT @finphase = expensefinphase FROM uniconfig
	SELECT @maxphase = MAX (nphase) FROM expensephase
	
	-- Competenza / Competenza e Cassa
	IF (@fin_kind IN (1,3))  
	UPDATE #previsionupbfin 
	SET expenseprevavailable_comp = 
	(SELECT
		ISNULL(UT.currentprev,0) + 
		ISNULL(UT.previsionvariation,0) - 
		ISNULL(UET.totalcompetency,0) 
	FROM  upbtotal UT 
	LEFT OUTER JOIN upbexpensetotal UET 
		ON UET.idfin = UT.idfin
		AND UET.idupb = UT.idupb
		AND UET.nphase = @finphase
	WHERE UT.idupb = #previsionupbfin.idupb AND
	      UT.idfin = #previsionupbfin.idfin) 

	-- Cassa
	IF (@fin_kind = 2 )   
	UPDATE #previsionupbfin 
	SET expenseprevavailable_cash = 
	(SELECT
		ISNULL(UT.currentprev,0) + 
		ISNULL(UT.previsionvariation,0) - 
		ISNULL(UET.totalcompetency,0) -
		ISNULL(UET.totalarrears, 0)
	FROM  upbtotal UT 
	LEFT OUTER JOIN upbexpensetotal UET 
		ON UET.idfin = UT.idfin
		AND UET.idupb = UT.idupb
		AND UET.nphase = @maxphase
	WHERE UT.idupb = #previsionupbfin.idupb AND
	      UT.idfin = #previsionupbfin.idfin) 
	
	-- Competenza e Cassa	
	IF (@fin_kind = 3 )   
	UPDATE #previsionupbfin 
	SET expenseprevavailable_cash = 
	(SELECT
		ISNULL(UT.currentsecondaryprev,0) + 
		ISNULL(UT.secondaryvariation,0) - 
		ISNULL(UET.totalcompetency,0) -
		ISNULL(UET.totalarrears, 0)
	FROM  upbtotal UT 
	LEFT OUTER JOIN upbexpensetotal UET 
		ON UET.idfin = UT.idfin
		AND UET.idupb = UT.idupb
		AND UET.nphase = @maxphase
	WHERE UT.idupb = #previsionupbfin.idupb AND
	      UT.idfin = #previsionupbfin.idfin) 

-- Competenza / Competenza e Cassa
		UPDATE #previsionupbfin 
		SET varprevprinc = 
		(SELECT sum(D.amount)  
		FROM finvar V
		JOIN finvardetail D 	
			ON V.yvar = D.yvar
			AND V.nvar = D.nvar	
		join upb 
			on upb.idupb = D.idupb	
		join fin
			on D.idfin = fin.idfin	
		left outer JOIN finlink FLK
			ON FLK.idchild = D.idfin
		WHERE  V.yvar = @ayear
		--AND V.adate <= @date
		AND V.flagprevision = 'S'
		AND ( (fin.flag & 1)<>0 )-- Parte spesa
		AND V.idfinvarstatus < 5 -- 5=approvata, 6=Annullata
		AND V.variationkind <> 5
		AND D.idupb = #previsionupbfin.idupb 
		AND isnull(FLK.idparent,D.idfin) = #previsionupbfin.idfin) 

	-- Competenza e Cassa
	IF (@fin_kind =3)  
	Begin
		UPDATE #previsionupbfin 
		SET varprevsec = 
		(SELECT sum(D.amount)  
		FROM finvar V
		JOIN finvardetail D 	
			ON V.yvar = D.yvar
			AND V.nvar = D.nvar	
		join upb 
			on upb.idupb = D.idupb	
		join fin
			on D.idfin = fin.idfin	
		left outer JOIN finlink FLK
			ON FLK.idchild = D.idfin
		WHERE 	V.yvar = @ayear
		--AND V.adate <= @date
		AND V.flagsecondaryprev = 'S'
		AND ( (fin.flag & 1)<>0 )-- Parte spesa
		AND V.idfinvarstatus < 5 -- 5=approvata, 6=Annullata
		AND V.variationkind <> 5
		AND D.idupb = #previsionupbfin.idupb 
		AND isnull(FLK.idparent,D.idfin) = #previsionupbfin.idfin) 
	End
/*
	--Competenza / Competenza e cassa
	IF (@fin_kind IN (1,3))  
	UPDATE #previsionupbfin SET expenseprevavailableNonApprovato_comp = isnull(varprevprinc,0)+ isnull(expenseprevavailable_comp,0)

	-- Cassa
	IF (@fin_kind = 2 )   
	UPDATE #previsionupbfin SET expenseprevavailableNonApprovato_cash = isnull(varprevprinc,0)+ isnull(expenseprevavailable_cash,0)
	
	-- Competenza e Cassa	
	IF (@fin_kind = 3 )   
	UPDATE #previsionupbfin  SET expenseprevavailableNonApprovato_cash = isnull(varprevsec,0)+ isnull(expenseprevavailable_cash,0)
	*/
END
ELSE -- @finpart = 'E'
BEGIN 
	SELECT @finphase = incomefinphase FROM uniconfig
	SELECT @maxphase = MAX (nphase)  FROM  incomephase

	-- Competenza / Competenza e Cassa
	IF (@fin_kind IN (1,3))  
	UPDATE #previsionupbfin 
	SET incomeprevavailable_comp = 
	(SELECT
		ISNULL(UT.currentprev,0) + 
		ISNULL(UT.previsionvariation,0) - 
		ISNULL(UET.totalcompetency,0) 
	FROM  upbtotal UT 
	LEFT OUTER JOIN upbincometotal UET 
		ON UET.idfin = UT.idfin
		AND UET.idupb = UT.idupb
		AND UET.nphase = @finphase
	WHERE UT.idupb = #previsionupbfin.idupb AND
	      UT.idfin = #previsionupbfin.idfin) 

	-- Cassa
	IF (@fin_kind = 2 )   
	UPDATE #previsionupbfin 
	SET incomeprevavailable_cash = 
	(SELECT
		ISNULL(UT.currentprev,0) + 
		ISNULL(UT.previsionvariation,0) - 
		ISNULL(UET.totalcompetency,0) -
		ISNULL(UET.totalarrears, 0)
	FROM  upbtotal UT 
	LEFT OUTER JOIN upbincometotal UET 
		ON UET.idfin = UT.idfin
		AND UET.idupb = UT.idupb
		AND UET.nphase = @maxphase
	WHERE UT.idupb = #previsionupbfin.idupb AND
	      UT.idfin = #previsionupbfin.idfin) 

	-- Competenza e Cassa		
	IF (@fin_kind = 3 )   
	UPDATE #previsionupbfin 
	SET incomeprevavailable_cash = 
	(SELECT
		ISNULL(UT.currentsecondaryprev,0) + 
		ISNULL(UT.secondaryvariation,0) - 
		ISNULL(UET.totalcompetency,0)-
		ISNULL(UET.totalarrears, 0)
	FROM  upbtotal UT 
	LEFT OUTER JOIN upbincometotal UET 
		ON UET.idfin = UT.idfin
		AND UET.idupb = UT.idupb
		AND UET.nphase = @maxphase
	WHERE UT.idupb = #previsionupbfin.idupb AND
	      UT.idfin = #previsionupbfin.idfin) 

	UPDATE #previsionupbfin 
		SET varprevprinc = 
		(SELECT sum(D.amount)  
		FROM finvar V
		JOIN finvardetail D 	
			ON V.yvar = D.yvar
			AND V.nvar = D.nvar	
		join upb 
			on upb.idupb = D.idupb	
		join fin
			on D.idfin = fin.idfin	
		left outer JOIN finlink FLK
			ON FLK.idchild = D.idfin
		WHERE  V.yvar = @ayear
		--AND V.adate <= @date
		AND V.flagprevision = 'S'
		AND ( (fin.flag & 1) =0 )-- Parte entrata
		AND V.idfinvarstatus < 5 -- 5=approvata, 6=Annullata
		AND V.variationkind <> 5
		AND D.idupb = #previsionupbfin.idupb 
		AND isnull(FLK.idparent,D.idfin) = #previsionupbfin.idfin) 

	-- Competenza e Cassa
	IF (@fin_kind = 3)  
	Begin
		UPDATE #previsionupbfin 
		SET varprevsec = 
		(SELECT sum(D.amount)  
		FROM finvar V
		JOIN finvardetail D 	
			ON V.yvar = D.yvar
			AND V.nvar = D.nvar	
		join upb 
			on upb.idupb = D.idupb	
		join fin
			on D.idfin = fin.idfin	
		left outer JOIN finlink FLK
			ON FLK.idchild = D.idfin
		WHERE 	V.yvar = @ayear
		--AND V.adate <= @date
		AND V.flagsecondaryprev = 'S'
		AND ( (fin.flag & 1)=0 )-- Parte entrata
		AND V.idfinvarstatus < 5 -- 5=approvata, 6=Annullata
		AND V.variationkind <> 5
		AND D.idupb = #previsionupbfin.idupb 
		AND isnull(FLK.idparent,D.idfin) = #previsionupbfin.idfin) 
	End
/*	
	--Competenza / Competenza e cassa
	IF (@fin_kind IN (1,3))  
	UPDATE #previsionupbfin SET incomeprevavailableNonApprovato_comp = isnull(varprevprinc,0)+ isnull(incomeprevavailable_comp,0)

	-- Cassa
	IF (@fin_kind = 2 )   
	UPDATE #previsionupbfin SET incomeprevavailableNonApprovato_cash = isnull(varprevprinc,0)+ isnull(incomeprevavailable_cash,0)
	
	-- Competenza e Cassa	
	IF (@fin_kind = 3 )   
	UPDATE #previsionupbfin  SET incomeprevavailableNonApprovato_cash = isnull(varprevsec,0)+ isnull(incomeprevavailable_cash,0)
	*/
END

	IF (@finpart = 'S') 
	BEGIN
		IF (@fin_kind = 1)  BEGIN
			SELECT 
			'Spesa' AS 'Parte Bil.',
			codeupb AS 'Cod. U.P.B.',
			upb AS 'U.P.B.',
			manager as 'Responsabile',
			finlevel AS 'Livello',
			codefin AS 'Cod. Bilancio',
			fin AS 'Bilancio',
			expenseprevavailable_comp AS 'DisponibilitÓ ad Impegnare',
			( isnull(varprevprinc,0)+ isnull(expenseprevavailable_comp,0)) AS 'Disp.ad Impegnare Non Approvato'
			FROM #previsionupbfin
			WHERE ISNULL(expenseprevavailable_comp,0)<>0 or isnull(varprevprinc,0)<>0
		END
		IF (@fin_kind = 2)   BEGIN
			SELECT 'Spesa' AS 'Parte Bil.',
			codeupb AS 'Cod. U.P.B.',
			manager as 'Responsabile',
			upb AS 'U.P.B.',
			finlevel AS 'Livello',
			codefin AS 'Cod. Bilancio',
			fin AS 'Bilancio',
			expenseprevavailable_cash AS 'DisponibilitÓ a Pagare',
			isnull(varprevprinc,0)+ isnull(expenseprevavailable_cash,0) as 'Disp.a Pagare Non Approvato'
			FROM #previsionupbfin
			WHERE ISNULL(expenseprevavailable_cash,0)<>0 or isnull(varprevprinc,0)<>0
		END
		IF (@fin_kind = 3)   BEGIN
			SELECT 'Spesa' AS 'Parte Bil.',
			codeupb AS 'Cod. U.P.B.',
			upb AS 'U.P.B.',
			manager as 'Responsabile',
			finlevel AS 'Livello',
			codefin AS 'Cod. Bilancio',
			fin AS 'Bilancio',
			expenseprevavailable_comp AS 'DisponibilitÓ ad Impegnare',
			( isnull(varprevprinc,0)+ isnull(expenseprevavailable_comp,0))  AS 'Disp.ad Impegnare Non Approvato',
			expenseprevavailable_cash AS 'DisponibilitÓ a Pagare',
			isnull(varprevsec,0)+ isnull(expenseprevavailable_cash,0) as 'Disp.a Pagare Non Approvato'
			FROM #previsionupbfin
			WHERE ISNULL(expenseprevavailable_cash,0)<>0 OR  isnull(varprevprinc,0)<>0
				or ISNULL(expenseprevavailable_comp,0)<>0 or isnull(varprevsec,0)<>0
		END
	END
	ELSE
	BEGIN

		IF (@fin_kind = 1)  BEGIN
			SELECT 
			'Entrata' AS 'Parte Bil.',
			codeupb AS 'Cod. U.P.B.',
			upb AS 'U.P.B.',
			manager as 'Responsabile',
			finlevel AS 'Livello',
			codefin AS 'Cod. Bilancio',
			fin AS 'Bilancio',
			incomeprevavailable_comp AS 'DisponibilitÓ ad Accertare',
			 (isnull(varprevprinc,0)+ isnull(incomeprevavailable_comp,0)) AS 'Disp.ad Accertare Non Approvato'
			FROM #previsionupbfin
			WHERE ISNULL(incomeprevavailable_comp,0)<>0 OR isnull(varprevprinc,0)<>0
		END
		IF (@fin_kind = 2)   BEGIN
			SELECT 'Entrata' AS 'Parte Bil.',
			codeupb AS 'Cod. U.P.B.',
			upb AS 'U.P.B.',
			manager as 'Responsabile',
			finlevel AS 'Livello',
			codefin AS 'Cod. Bilancio',
			fin AS 'Bilancio',
			incomeprevavailable_cash AS 'DisponibilitÓ ad Incassare',
			isnull(varprevprinc,0)+ isnull(incomeprevavailable_cash,0) AS 'Disp. ad Incassare Non Approvato'
			FROM #previsionupbfin
			WHERE ISNULL(incomeprevavailable_cash,0)<>0 OR isnull(varprevprinc,0)<>0
		END
		IF (@fin_kind = 3)   BEGIN
			SELECT 'Entrata' AS 'Parte Bil.',
			codeupb AS 'Cod. U.P.B.',
			upb AS 'U.P.B.',
			manager as 'Responsabile',
			finlevel AS 'Livello',
			codefin AS 'Cod. Bilancio',
			fin AS 'Bilancio',
			incomeprevavailable_comp AS 'DisponibilitÓ ad Accertare',
			( isnull(varprevprinc,0)+ isnull(incomeprevavailable_comp,0)) AS 'Disp.ad Accertare Non Approvato',
			incomeprevavailable_cash AS 'DisponibilitÓ a Incassare',
			 isnull(varprevsec,0)+ isnull(incomeprevavailable_cash,0) AS 'Disp. ad Incassare Non Approvato'
			FROM #previsionupbfin
			WHERE ISNULL(incomeprevavailable_cash,0)<>0 OR isnull(varprevprinc,0)<>0
				or ISNULL(incomeprevavailable_comp,0)<>0  OR isnull(varprevsec,0)<>0
		END
	END
	
END


GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO



