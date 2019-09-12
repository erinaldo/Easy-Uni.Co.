if exists (select * from dbo.sysobjects where id = object_id(N'[rpt_partitario_generale_sub_assegnazioni_confin]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure[rpt_partitario_generale_sub_assegnazioni_confin]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO


-- EXEC rpt_partitario_generale_sub_assegnazioni_confiN 2013, {ts '2013-07-16 00:00:00'}, 'I', '%', NULL, 3, NULL
-- exec rpt_partitario_generale_sub_assegnazioni_confin 2013, {ts '2013-07-16 00:00:00'}, 'C', '00010007', 35, 3, 15110

CREATE                  PROCEDURE rpt_partitario_generale_sub_assegnazioni_confin
	@ayear int,			
	@stop datetime,
	@kind char(1),
	@idupb	varchar(36),
	@idunderwriting int,  
	@codelevel tinyint,	---come sempre è il livello di bilancio da cui posso capire se devo visualizzare crediti o incassi..	
	@idfin int
AS
BEGIN

declare @flagcredit varchar(1)
declare @flagproceeds varchar(1)
select	@flagcredit = isnull(flagcredit,'N'),
	@flagproceeds = isnull(flagproceeds,'N')
from config
where ayear=@ayear

DECLARE @MostraAssegnazioni varchar(50)
SELECT @MostraAssegnazioni=isnull(paramvalue,'N') FROM reportadditionalparam
WHERE paramname='MostraAssegnazioni'

DECLARE @firstday datetime
SET @firstday = CONVERT(datetime, '01-01-' + CONVERT(varchar(4),@ayear), 105)
-- Caricamento delle assegnazioni crediti/incassi
IF ( @kind ='C' and @MostraAssegnazioni='S' and @flagcredit='S') 	--> nel caso  in cui devo elencare le assegnazioni crediti
BEGIN
	SELECT 
		finexpense.codefin as idfin_S,
		finincome.codefin as idfin_E,
		income.idinc as idmov_E,
		income.nphase as nphase,
		creditpart.adate as operationdate,
		creditpart.ycreditpart as ymov,
		creditpart.ncreditpart as nmov,		
		income.ymov as ymov_E,
		income.nmov as nmov_E,
		creditpart.description ,
		creditpart.amount ,
		incomephase.description incomedescription,
		underwriting.codeunderwriting,
		underwriting.title as underwriting
	FROM creditpart
	JOIN incomeyear
		ON creditpart.idinc = incomeyear.idinc
		AND creditpart.ycreditpart = incomeyear.ayear  
	JOIN income 
		ON creditpart.idinc=income.idinc
	JOIN incomephase
		ON incomephase.nphase=income.nphase
	JOIN fin finexpense
		ON creditpart.idfin=finexpense.idfin
	JOIN fin finincome
		ON incomeyear.idfin=finincome.idfin
	JOIN finlink 
		ON finlink.idchild = creditpart.idfin
	JOIN underwriting 
		ON income.idunderwriting = underwriting.idunderwriting 
	WHERE creditpart.adate between @firstday AND @stop
		AND creditpart.ycreditpart=@ayear
 		AND finlink.nlevel = @codelevel
		AND isnull(finlink.idparent,creditpart.idfin) = @idfin 	
		AND incomeyear.idupb = @idupb
		AND (income.idunderwriting = @idunderwriting OR @idunderwriting is null)
	ORDER BY operationdate,ymov,nmov
	RETURN
END

IF (@kind ='I' and @MostraAssegnazioni='S' and @flagproceeds='S')  
BEGIN
	SELECT 
		finexpense.codefin as idfin_S,
		finincome.codefin as idfin_E,
		income.idinc as idmov_E,
		income.nphase as nphase,
		proceedspart.adate as operationdate,
		proceedspart.yproceedspart as ymov,
		proceedspart.nproceedspart as nmov,		
		income.ymov as ymov_E,
		income.nmov as nmov_E,
		proceedspart.description ,
		proceedspart.amount  ,
		incomephase.description as incomedescription,
		underwriting.codeunderwriting,
		underwriting.title as underwriting
	FROM proceedspart
	JOIN incomeyear
		ON proceedspart.idinc = incomeyear.idinc
		AND proceedspart.yproceedspart = incomeyear.ayear  
	JOIN income 
		ON proceedspart.idinc=income.idinc
	JOIN incomephase
		ON incomephase.nphase=income.nphase
	JOIN fin finexpense
		ON proceedspart.idfin=finexpense.idfin
	JOIN finlink FK
		ON FK.idchild=proceedspart.idfin
		AND FK.nlevel=@codelevel
	JOIN fin finincome
		ON incomeyear.idfin=finincome.idfin
	JOIN underwriting 
		ON income.idunderwriting = underwriting.idunderwriting 
	WHERE proceedspart.adate between @firstday AND @stop
		AND isnull(FK.idparent,proceedspart.idfin) = @idfin 	
		AND (income.idunderwriting = @idunderwriting OR @idunderwriting is null)
		and proceedspart.yproceedspart=@ayear
		AND incomeyear.idupb = @idupb
	ORDER BY operationdate,ymov,nmov
	RETURN
END

SELECT 
	null as idfin_S,
	null as idfin_E,
	null as idmov_E,
	null as nphase,
	null as operationdate,
	null as ymov,
	null as nmov,		
	null as ymov_E,
	null as nmov_E,
	null as description,
	null as amount,
	null as incomedescription,
	null as codeunderwriting,
	null as underwriting

END























GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO



