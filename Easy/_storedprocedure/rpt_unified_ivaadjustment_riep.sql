if exists (select * from dbo.sysobjects where id = object_id(N'[rpt_unified_ivaadjustment_riep]') 
and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure rpt_unified_ivaadjustment_riep
GO


SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO


CREATE     PROCEDURE rpt_unified_ivaadjustment_riep
(
	@ayear int
)
AS BEGIN
	-- rpt_unified_ivaadjustment_riep 2011
		
	CREATE TABLE #outtable
	(
        departmentname varchar(500),
		ayear int,
		prorata_rate_provv decimal(19,6),
		prorata_rate decimal(19,6),
		saldo_iniziale decimal(19,2),
		kind char(1),
		flagcurrent char(1),
		flagintracom char(1),
		idivakind varchar(20),
	    ivakinddescr varchar(50),
		rate decimal(19,6),
		flagdeferred char(1),
		unabatabilitypercentage decimal(19,6),
		taxabletotal_imm decimal(19,2), -- Imponibile (dei documenti immediati)
		ivatotal_imm decimal(19,2), -- Iva Totale dei documenti immediati
		ivaunabatable_imm decimal(19,2), -- IVA Indetraibile (dei documenti immediati)
		ivaabatable_imm decimal(19,2), -- IVA Detraibile (dei documenti immediati)
		ivaunabatable_defin_imm decimal(19,2), -- IVA Indetraibile prorata definitivo (dei documenti immediati)
		ivaabatable_defin_imm decimal(19,2),   -- IVA Detraibile prorata definitivo (dei documenti immediati)
		
		-- DIFFERITE DIVENUTE IMMEDIATE REGISTRATE IN ESERCIZIO CORRENTE
		taxabletotal_dif_current decimal(19,2), -- Imponibile (dei documenti differiti divenuti immediati)
		ivatotal_dif_current decimal(19,2), -- Iva Totale dei documenti differiti divenuti immediati
		ivaunabatable_dif_current decimal(19,2), -- IVA Indetrabile (dei documenti differiti divenuti immediati)
		ivaabatable_dif_current decimal(19,2), -- IVA Detraibile (dei documenti differiti divenuti immediati)
		ivaunabatable_defin_dif_current decimal(19,2), -- IVA Indetraibile prorata definitivo (dei documenti differiti divenuti immediati)
		ivaabatable_defin_dif_current decimal(19,2),   -- IVA Detraibile prorata definitivo (dei documenti differiti divenuti immediati)
		
		-- DIFFERITE DIVENUTE IMMEDIATE REGISTRATE IN ESERCIZI PRECEDENTI
		taxabletotal_dif_prec decimal(19,2), -- Imponibile (dei documenti differiti divenuti immediati)
		ivatotal_dif_prec decimal(19,2), -- Iva Totale dei documenti differiti divenuti immediati
		ivaunabatable_dif_prec decimal(19,2), -- IVA Indetrabile (dei documenti differiti divenuti immediati)
		ivaabatable_dif_prec decimal(19,2), -- IVA Detraibile (dei documenti differiti divenuti immediati)
		ivaunabatable_defin_dif_prec decimal(19,2), -- IVA Indetraibile prorata definitivo (dei documenti differiti divenuti immediati)
		ivaabatable_defin_dif_prec decimal(19,2),   -- IVA Detraibile prorata definitivo (dei documenti differiti divenuti immediati)
	
		)

	declare @iddbdepartment varchar(50)
	declare @crsdepartment cursor
	set 	@crsdepartment = cursor for select  iddbdepartment from dbdepartment
	where   (start is null or start <= @ayear ) AND (stop is null or stop >= @ayear)
	open 	@crsdepartment
	fetch next from @crsdepartment into @iddbdepartment
	while @@fetch_status=0 begin
		declare @dip_nomesp varchar(300)
		set @dip_nomesp = @iddbdepartment + '.rpt_ivaadjustment'
		insert into #outtable 
			(
                    departmentname,
					ayear,
					prorata_rate_provv,
					prorata_rate,
					saldo_iniziale,
					kind,
					flagdeferred,
					flagcurrent,
					flagintracom,
					idivakind,
					ivakinddescr,
					rate,
					unabatabilitypercentage,
					taxabletotal_imm, -- Imponibile (dei documenti immediati)
					ivatotal_imm, -- Iva Totale dei documenti immediati
					ivaunabatable_imm, -- IVA Indetraibile (dei documenti immediati)
					ivaabatable_imm, -- IVA Detraibile (dei documenti immediati)
					ivaunabatable_defin_imm, -- IVA Indetraibile prorata definitivo (dei documenti immediati)
					ivaabatable_defin_imm,   -- IVA Detraibile prorata definitivo (dei documenti immediati)
					
					taxabletotal_dif_current, -- Imponibile (dei documenti differiti divenuti immediati)
					ivatotal_dif_current, -- Iva Totale dei documenti differiti divenuti immediati
					ivaunabatable_dif_current, -- IVA Indetrabile (dei documenti differiti divenuti immediati)
					ivaabatable_dif_current, -- IVA Detraibile (dei documenti differiti divenuti immediati)
					ivaunabatable_defin_dif_current, -- IVA Indetraibile prorata definitivo (dei documenti differiti divenuti immediati)
					ivaabatable_defin_dif_current,   -- IVA Detraibile prorata definitivo (dei documenti differiti divenuti immediati)
			
					taxabletotal_dif_prec, -- Imponibile (dei documenti differiti divenuti immediati)
					ivatotal_dif_prec, -- Iva Totale dei documenti differiti divenuti immediati
					ivaunabatable_dif_prec, -- IVA Indetrabile (dei documenti differiti divenuti immediati)
					ivaabatable_dif_prec, -- IVA Detraibile (dei documenti differiti divenuti immediati)
					ivaunabatable_defin_dif_prec, -- IVA Indetraibile prorata definitivo (dei documenti differiti divenuti immediati)
					ivaabatable_defin_dif_prec--,   -- IVA Detraibile prorata definitivo (dei documenti differiti divenuti immediati)

			)

			exec @dip_nomesp  @ayear
			
		fetch next from @crsdepartment into @iddbdepartment
	END
	
		SELECT 
					null as departmentname,
					ayear,
					prorata_rate_provv,
					prorata_rate,
					saldo_iniziale,
					kind,
					flagdeferred,
					flagcurrent,
					flagintracom,
					idivakind,
					ivakinddescr,
					rate,
					unabatabilitypercentage,
					SUM(ISNULL(taxabletotal_imm,0)) AS taxabletotal_imm, -- Imponibile (dei documenti immediati)
					SUM(ISNULL(ivatotal_imm,0)) AS ivatotal_imm, -- Iva Totale dei documenti immediati
					SUM(ISNULL(ivaunabatable_imm,0)) AS ivaunabatable_imm, -- IVA Indetraibile (dei documenti immediati)
					SUM(ISNULL(ivaabatable_imm,0)) AS ivaabatable_imm, -- IVA Detraibile (dei documenti immediati)
					SUM(ISNULL(ivaunabatable_defin_imm,0)) AS ivaunabatable_defin_imm, -- IVA Indetraibile prorata definitivo (dei documenti immediati)
					SUM(ISNULL(ivaabatable_defin_imm,0)) AS ivaabatable_defin_imm,   -- IVA Detraibile prorata definitivo (dei documenti immediati)
					-- DIFFERITE DIVENUTE IMMEDIATE REGISTRATE IN ESERCIZIO CORRENTE
					SUM(ISNULL(taxabletotal_dif_current,0)) AS taxabletotal_dif_current, -- Imponibile (dei documenti differiti divenuti immediati)
					SUM(ISNULL(ivatotal_dif_current,0)) AS ivatotal_dif_current, -- Iva Totale dei documenti differiti divenuti immediati
					SUM(ISNULL(ivaunabatable_dif_current,0)) AS ivaunabatable_dif_current, -- IVA Indetrabile (dei documenti differiti divenuti immediati)
					SUM(ISNULL(ivaabatable_dif_current,0)) AS ivaabatable_dif_current, -- IVA Detraibile (dei documenti differiti divenuti immediati)
					SUM(ISNULL(ivaunabatable_defin_dif_current,0)) AS ivaunabatable_defin_dif_current, -- IVA Indetraibile prorata definitivo (dei documenti differiti divenuti immediati)
					SUM(ISNULL(ivaabatable_defin_dif_current,0)) AS ivaabatable_defin_dif_current,   -- IVA Detraibile prorata definitivo (dei documenti differiti divenuti immediati)
					-- DIFFERITE DIVENUTE IMMEDIATE REGISTRATE IN ESERCIZI PRECEDENTI
					SUM(ISNULL(taxabletotal_dif_prec,0)) AS taxabletotal_dif_prec, -- Imponibile (dei documenti differiti divenuti immediati)
					SUM(ISNULL(ivatotal_dif_prec,0)) AS ivatotal_dif_prec, -- Iva Totale dei documenti differiti divenuti immediati
					SUM(ISNULL(ivaunabatable_dif_prec,0)) AS ivaunabatable_dif_prec, -- IVA Indetrabile (dei documenti differiti divenuti immediati)
					SUM(ISNULL(ivaabatable_dif_prec,0)) AS ivaabatable_dif_prec, -- IVA Detraibile (dei documenti differiti divenuti immediati)
					SUM(ISNULL(ivaunabatable_defin_dif_prec,0)) AS ivaunabatable_defin_dif_prec, -- IVA Indetraibile prorata definitivo (dei documenti differiti divenuti immediati)
					SUM(ISNULL(ivaabatable_defin_dif_prec,0)) AS ivaabatable_defin_dif_prec --,   -- IVA Detraibile prorata definitivo (dei documenti differiti divenuti immediati)

					FROM #outtable
					GROUP BY 		ayear,
					kind, flagdeferred,
					flagcurrent,flagintracom,
					saldo_iniziale,
					idivakind,
					ivakinddescr,
					rate,
					unabatabilitypercentage,
					prorata_rate_provv,
					prorata_rate
					order by kind desc, rate asc
END
GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO
