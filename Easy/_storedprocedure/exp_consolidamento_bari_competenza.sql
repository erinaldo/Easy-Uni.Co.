if exists (select * from dbo.sysobjects where id = object_id(N'[exp_consolidamento_bari_competenza]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [exp_consolidamento_bari_competenza]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO



CREATE PROCEDURE exp_consolidamento_bari_competenza
(
	@ayear int,
	@date datetime,
	@finpart char(1),
	@levelusable tinyint
)
AS 
BEGIN

/* Versione 1.0.0 del 12/09/2007 ultima modifica: PIERO */

-- exec exp_consolidamento_bari_competenza 2006,{ts '2006-08-30 00:00:00'},'S',3
CREATE   TABLE #competency(
	printingorder varchar(50),
	code varchar(50),
	fintitle varchar(150),
	mov_finphase_C_univ decimal(19,2),
	mov_finphase_C_direct decimal(19,2),
	mov_finphase_C_internal decimal(19,2),
	var_finphase_C_univ decimal(19,2),
	var_finphase_C_direct decimal(19,2),
	var_finphase_C_internal decimal(19,2),
	mov_maxphase_C_univ decimal(19,2),
	mov_maxphase_C_direct decimal(19,2),
	mov_maxphase_C_internal decimal(19,2),
	var_maxphase_C_univ decimal(19,2),
	var_maxphase_C_direct decimal(19,2),
	var_maxphase_C_internal decimal(19,2),
	mov_finphase_R_univ decimal(19,2),
	mov_finphase_R_direct decimal(19,2),
	mov_finphase_R_internal decimal(19,2),
	var_finphase_R_univ decimal(19,2),
	var_finphase_R_direct decimal(19,2),
	var_finphase_R_internal decimal(19,2),
	mov_maxphase_R_univ decimal(19,2),
	mov_maxphase_R_direct decimal(19,2),
	mov_maxphase_R_internal decimal(19,2),
	var_maxphase_R_univ decimal(19,2),
	var_maxphase_R_direct decimal(19,2),
	var_maxphase_R_internal decimal(19,2),
	supposed_ff_jan01 decimal(19,2),
	supposed_aa_jan01 decimal(19,2),
	ff_jan01 decimal(19,2),
	aa_jan01 decimal(19,2)
)

INSERT INTO #competency(
	printingorder,
	code,
	fintitle,
	mov_finphase_C_univ ,
	mov_finphase_C_direct ,
	mov_finphase_C_internal ,
	var_finphase_C_univ ,
	var_finphase_C_direct ,
	var_finphase_C_internal,
	mov_maxphase_C_univ ,
	mov_maxphase_C_direct,
	mov_maxphase_C_internal ,
	var_maxphase_C_univ ,
	var_maxphase_C_direct ,
	var_maxphase_C_internal ,
	mov_finphase_R_univ ,
	mov_finphase_R_direct ,
	mov_finphase_R_internal ,
	var_finphase_R_univ ,
	var_finphase_R_direct ,
	var_finphase_R_internal ,
	mov_maxphase_R_univ ,
	mov_maxphase_R_direct ,
	mov_maxphase_R_internal ,
	var_maxphase_R_univ ,
	var_maxphase_R_direct ,
	var_maxphase_R_internal ,
	supposed_ff_jan01,
	supposed_aa_jan01,
	ff_jan01 , -- fondo cassa
	aa_jan01  -- avanzo di amministrazione
	)
	EXEC  exp_consolidamento @ayear, @date,@finpart,@levelusable
        
IF @finpart = 'E'
BEGIN
	SELECT
		code as 'Codice di Bilancio',
   		fintitle as 'Denominazione',
		mov_finphase_C_univ + var_finphase_C_univ as 'Accertamenti di entrate da Amm.ne Centrale (1)',
		mov_finphase_C_internal + var_finphase_C_internal as 'Accertamenti di entrate da altri Dip. e Centri (2)',
		mov_finphase_C_direct + var_finphase_C_direct as 'Accertamenti da entrate proprie (3)' ,
		mov_finphase_C_univ + var_finphase_C_univ + mov_finphase_C_internal + var_finphase_C_internal + 
			mov_finphase_C_direct + var_finphase_C_direct  as 'Totali Accertamenti di COMPETENZA (1+2+3) (4)' 
	FROM #competency
	ORDER BY printingorder ASC,code ASC
END
	
ELSE

BEGIN
	SELECT 
		code as 'Codice di Bilancio',
		fintitle as 'Denominazione',		
		mov_finphase_C_univ + var_finphase_C_univ as 'Somme impegnate a favore della Amm.ne Centrale (1)'	,
		mov_finphase_C_internal + var_finphase_C_internal as 'Somme impegnate a favore di Dip. e Centri (2)',
		mov_finphase_C_direct + var_finphase_C_direct as 'Altri impegni di competenza (3)'	,
		mov_finphase_C_univ + var_finphase_C_univ + mov_finphase_C_internal + var_finphase_C_internal 
			+ mov_finphase_C_direct + var_finphase_C_direct as 'Totale impegni di competenza (1+2+3) (4)'
	FROM #competency
    	ORDER BY printingorder ASC,code ASC
END

END


GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

