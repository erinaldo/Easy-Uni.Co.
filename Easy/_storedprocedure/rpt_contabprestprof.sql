if exists (select * from dbo.sysobjects where id = object_id(N'[rpt_contabprestprof]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [rpt_contabprestprof]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO



CREATE                                        PROCEDURE [rpt_contabprestprof]
	@ayear smallint,
	@ycon  smallint,  
	@ncon  int
AS
BEGIN

DECLARE @phasebilancio		tinyint
DECLARE @phasecontrattocont	tinyint

CREATE TABLE #impcontratto
(
	eserccontratto		smallint,
	numcontratto		integer,
	fasespesa		varchar(35),
	esercmovimento		smallint,
	nummovimento		integer,
	datacontabile		smalldatetime,
	descrizione		varchar(150),	
	codicebilancio		varchar(30),
	codicefondo		varchar(10),
	codiceripartizione	varchar(10),
	codicecentrospesa	varchar(30),
	importo			decimal(19,2)
)

SELECT @phasebilancio = expensefinphase 
	FROM uniconfig
SELECT @phasecontrattocont = expensephase FROM config WHERE ayear = @ayear
			
	
		INSERT INTO #impcontratto
		(
			eserccontratto,
			numcontratto,
			fasespesa,
			esercmovimento,
			nummovimento,
			datacontabile,
			descrizione,
			codicebilancio,
			codiceupb,
			importo
		)
		SELECT
		@ycon,
		@ncon,
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
		AND expense.nphase = @phasecontrattocont 
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
		SELECT * 
      FROM #impcontratto
      ORDER BY fasespesa ASC,
      esercmovimento ASC,
      nummovimento ASC
	END






GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

