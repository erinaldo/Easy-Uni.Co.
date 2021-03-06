if exists (select * from dbo.sysobjects where id = object_id(N'[rpt_registrounico]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [rpt_registrounico]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

-- setuser 'amm'
-- exec rpt_registrounico 1, 543, null ,null ,null ,null ,null   

CREATE    PROCEDURE rpt_registrounico
	@nbegin int,
	@nend int,
	@idsor01 int,
	@idsor02 int,
	@idsor03 int,
	@idsor04 int,
	@idsor05 int
AS
BEGIN

CREATE TABLE #registro
(
	iduniqueregister int ,				--	1)	Il codice progressivo di registrazione
	arrivalprotocolnum varchar(20),		--	2)  Il numero di protocollo di entrata
	doc varchar(35),					--  3)	Il numero della fattura o del documento contabile equivalente
	dataemissione datetime,				--4)	La data di emissione della fattura o del documento contabile equivalente
	dataricezione datetime,
	idreg int,							--5)	Il nome del creditore e il relativo codice fiscale
	description varchar(150),			--	6)	L’oggetto della fornitura
	amount decimal(19,2),				--	7)	L’importo totale, al lordo di IVA e di eventuali altri oneri e spese indicati
	scadenza datetime,					--8)	La scadenza della fattura
	impegno varchar(400),				-- 	9)	Nel caso di enti in contabilità finanziaria, gli estremi dell’impegno indicato nella fattura o nel documento contabile equivalente oppure il capitolo 	e il piano gestionale, o analoghe unità gestionali del bilancio sul quale verrà effettuato il pagamento.
	rilevanteiva char(1),				--10)	Se la spesa è rilevante ai fini IVA
	cigcode varchar(200),				--11)	Il CIG tranne i casi di esclusione
	cupcode varchar(200),				--12)	Il CUP ove è previsto
	annotations varchar(400),				--	13)	Qualsiasi altra informazione che si ritiene necessaria.)
	idinvkind int,
	yinv smallint,
	ninv int,
	ycon smallint,
	ncon int,
	idmankind varchar(20),
	yman smallint,
	nman int,
	tipodocumento varchar(50)
	
)

-- Fattura
insert into #registro(
	idinvkind, yinv, ninv,
	iduniqueregister,
	arrivalprotocolnum,
	doc,
	dataemissione,
	dataricezione,
	idreg,
	description,
	amount,
	scadenza,
	rilevanteiva,
--	cupcode,
--	cigcode,
	annotations,
	tipodocumento
)
SELECT 
	I.idinvkind, I.yinv, I.ninv,
	U.iduniqueregister,
	I.arrivalprotocolnum,
	I.doc,
	I.docdate,	
	I.protocoldate,
	I.idreg,
	I.description,
	isnull(SDI_A.total,I.total) ,	-- ImportoTotaleDocumento, ora lo prendo dalla fatt.elettronica ove presente, vedi task 7360
	-- scadenza,
		case 
		-- Data contabile(data registrazione)  = Numero gg D.R.F.
		when (I.idexpirationkind = 1 AND isnull(I.paymentexpiring,0)>0) then DATEADD(day, paymentexpiring, I.adate)
		when (I.idexpirationkind = 1 AND isnull(I.paymentexpiring,0)=0) then I.adate
		-- Data documento = Numero gg  D.F.
		when (I.idexpirationkind = 2 AND I.docdate is not null AND isnull(I.paymentexpiring,0)>0) then DATEADD(day, paymentexpiring, I.docdate)
		when (I.idexpirationkind = 2 AND isnull(I.paymentexpiring,0)=0) then I.docdate
		-- Fine mese data documento = Numero gg F.M.D.F.
		when (I.idexpirationkind = 3 AND I.docdate is not null and isnull(I.paymentexpiring,0)>0) then DATEADD(day, paymentexpiring,  DATEADD(day, -1, DATEADD(month, 1, DATEADD(day, 1 - DAY(I.docdate) ,I.docdate))) ) 
		when (I.idexpirationkind = 3 AND I.docdate is not null and isnull(I.paymentexpiring,0)=0) then DATEADD(day, -1, DATEADD(month, 1, DATEADD(day, 1 - DAY(I.docdate) ,I.docdate)))
		-- Fine mese data contabile = Numero gg F.M.D.R.F.
		when (I.idexpirationkind = 4  and isnull(I.paymentexpiring,0)>0) then DATEADD(day, paymentexpiring,     DATEADD(day, -1, DATEADD(month, 1, DATEADD(day, 1 - DAY(I.adate) ,I.adate))) )
		when (I.idexpirationkind = 4  and isnull(I.paymentexpiring,0)=0) then DATEADD(day, -1, DATEADD(month, 1, DATEADD(day, 1 - DAY(I.adate) ,I.adate)))
		--	Pagamento Immediato  = data registrazione
		when I.idexpirationkind = 5 then I.adate
		-- Data ricezione
		when (I.idexpirationkind = 6 AND I.protocoldate is not null AND isnull(I.paymentexpiring,0)>0) then DATEADD(day, paymentexpiring, I.protocoldate)
		when (I.idexpirationkind = 6 AND isnull(I.paymentexpiring,0)=0) then I.protocoldate
	else null
	end ,
	-- 	rilevanteiva : per le fatture interrogheremo l''attività del registro associata al documento, 
	-- se commerciale = è rilevante, 
	-- se istituzionale e di tipo intra/extra = rilevante, 
	-- se istituzionale e tipo Italia = non rilevante, 
	-- se promiscua = rilevante, perchè assimiliamo l''attività promiscua a quella commerciale.
	--I 1, C 2, P 3, Q 4
	case	when (IRK.flagactivity = 2) then 'S'
			when (IRK.flagactivity = 3) then 'S'
			when (IRK.flagactivity = 1 and flagintracom <> 'N')  then 'S'
			when (IRK.flagactivity = 1 and flagintracom = 'N') then 'N'
			else 'S'
	end,
--	cupcode,
--	cigcode,
	I.annotations,
	'Fattura'
FROM uniqueregister U
join invoiceview I					on U.idinvkind = I.idinvkind	and U.yinv = I.yinv	and U.ninv = I.ninv
JOIN invoicekind IK					ON I.idinvkind = IK.idinvkind
JOIN ivaregister IR					ON IR.idinvkind = I.idinvkind	AND IR.yinv = I.yinv	AND IR.ninv = I.ninv
JOIN ivaregisterkind IRK			ON IRK.idivaregisterkind = IR.idivaregisterkind	and IRK.registerclass = 'A'
left outer join sdi_acquisto SDI_A	on SDI_A.idsdi_acquisto = I.idsdi_acquisto
where U.iduniqueregister between @nbegin and @nend 
	AND (I.idsor01 = @idsor01 OR @idsor01 IS NULL)
	AND (I.idsor02 = @idsor02 OR @idsor02 IS NULL)
	AND (I.idsor03 = @idsor03 OR @idsor03 IS NULL)
	AND (I.idsor04 = @idsor04 OR @idsor04 IS NULL)
	AND (I.idsor05 = @idsor05 OR @idsor05 IS NULL)


DECLARE @idinvkind int
DECLARE @yinv smallint
DECLARE @ninv int
declare @cupcode varchar(15)
declare @cigcode varchar(10)
declare @idexp_iva int
declare @ymov_iva smallint
declare @nmov_iva int
declare @idexp_taxable int
declare @ymov_taxable smallint
declare @nmov_taxable int
declare @idexp int
declare @ymov smallint
declare @nmov int

-- CUP: letto dal dettaglio contratto passivo
	DECLARE cursore_fatture01 CURSOR FORWARD_ONLY for 
	SELECT distinct invdett.idinvkind, invdett.yinv, invdett.ninv, mandett.cupcode
	FROM invoicedetail invdett
	join #registro R			on invdett.idinvkind = R.idinvkind		and invdett.yinv = R.yinv	and invdett.ninv = R.ninv
	join mandatedetail mandett	on invdett.idmankind = mandett.idmankind		and invdett.yman = mandett.yman		and invdett.nman = mandett.nman
		AND ISNULL(INVDETT.rounding,'N') <>'S'  --salta i dettagli di arrotondamento, task 7360
			 and (isnull(INVDETT.flagbit,0) & 4) = 0
	where mandett.cupcode is not null

	OPEN cursore_fatture01
	FETCH NEXT FROM cursore_fatture01 
	INTO @idinvkind, @yinv, @ninv, @cupcode
 
	WHILE (@@fetch_status=0) BEGIN
	
	UPDATE 	#registro set
	  cupcode = case when @cupcode is not null then isnull(cupcode,'') +'' +isnull(convert(varchar(15),@cupcode),'')+'. '
							else isnull(cupcode,'')
							end
	 WHERE idinvkind = @idinvkind and yinv = @yinv and ninv = @ninv

		FETCH NEXT FROM cursore_fatture01 
		INTO  @idinvkind, @yinv, @ninv, @cupcode 
	END
CLOSE cursore_fatture01

-- CIG: letto dal dettaglio contratto passivo
	DECLARE cursore_fatture02 CURSOR FORWARD_ONLY for 
	SELECT distinct invdett.idinvkind, invdett.yinv, invdett.ninv, isnull(mandett.cigcode, M.cigcode)
	FROM invoicedetail invdett
	join #registro R		on invdett.idinvkind = R.idinvkind	and invdett.yinv = R.yinv	and invdett.ninv = R.ninv
	join mandate M			on invdett.idmankind = M.idmankind	and invdett.yman = M.yman	and invdett.nman = M.nman
	join mandatedetail mandett		on invdett.idmankind = mandett.idmankind	and invdett.yman = mandett.yman		and invdett.nman = mandett.nman
	where (mandett.cigcode is not null OR M.cigcode is not null)
		 AND ISNULL(INVDETT.rounding,'N') <>'S'  --salta i dettagli di arrotondamento, task 7360
		 and (isnull(INVDETT.flagbit,0) & 4) = 0

	OPEN cursore_fatture02
	FETCH NEXT FROM cursore_fatture02 
	INTO @idinvkind, @yinv, @ninv,  @cigcode
 
	WHILE (@@fetch_status=0) BEGIN
	
	UPDATE 	#registro set
	  cigcode = case when @cigcode is not null then isnull(cigcode,'') +'' +isnull(convert(varchar(15),@cigcode),'')+' '
							else isnull(cigcode,'')
							end
	 WHERE idinvkind = @idinvkind and yinv = @yinv and ninv = @ninv

		FETCH NEXT FROM cursore_fatture02 
		INTO  @idinvkind, @yinv, @ninv,  @cigcode
	END
CLOSE cursore_fatture02


-- IMPEGNI letti da dettagli contratto passivo
	DECLARE cursore_fatture03 CURSOR FORWARD_ONLY for 
	SELECT distinct invdett.idinvkind, invdett.yinv, invdett.ninv, 
		E.ymov, E.nmov
	FROM invoicedetail invdett
	join #registro R			on invdett.idinvkind = R.idinvkind	and invdett.yinv = R.yinv and invdett.ninv = R.ninv
	join mandatedetail mandett	on invdett.idmankind = mandett.idmankind	and invdett.yman = mandett.yman	and invdett.nman = mandett.nman
	join expensemandate EM		on EM.idmankind = mandett.idmankind		and EM.yman = mandett.yman		and EM.nman = mandett.nman
	join expense E				on EM.idexp = E.idexp
	where  ISNULL(INVDETT.rounding,'N') <>'S'  --salta i dettagli di arrotondamento, task 7360
			 and (isnull(INVDETT.flagbit,0) & 4) = 0

	OPEN cursore_fatture03
	FETCH NEXT FROM cursore_fatture03 
	INTO @idinvkind, @yinv, @ninv, 
		@ymov,		@nmov
 
	WHILE (@@fetch_status=0) BEGIN
	
	UPDATE 	#registro set
		impegno = isnull(impegno,'') + 'Eserc.'+convert(varchar(10),@ymov) + ' Num.'+convert(varchar(20),@nmov)+'. '
	WHERE idinvkind = @idinvkind and yinv = @yinv and ninv = @ninv

		FETCH NEXT FROM cursore_fatture03 
		INTO  @idinvkind, @yinv, @ninv, @ymov,		@nmov
	END
CLOSE cursore_fatture03

--------------------------------------------------------------------------- Fatture associate a Contratti Professionali -------------------------------------------------

-- Impegni letti dalla contabilizzazione di Contratti Professionali
	DECLARE cursore_fatture04 CURSOR FORWARD_ONLY for 
	SELECT distinct P.idinvkind, P.yinv, P.ninv, 
		E.idexp, E.ymov, E.nmov
	FROM profservice P
	join #registro R				on P.idinvkind = R.idinvkind and P.yinv = R.yinv	and P.ninv = R.ninv
	join expenseprofservice EPS		on EPS.ycon = P.ycon	and EPS.ncon = P.ncon
	join expense E					on EPS.idexp = E.idexp
	where not exists (select * from invoicedetail ID where  ID.idinvkind = R.idinvkind and ID.yinv = R.yinv and ID.ninv = R.ninv and ID.ycon is not null)  
	
	OPEN cursore_fatture04
	FETCH NEXT FROM cursore_fatture04 
	INTO @idinvkind, @yinv, @ninv, 
		@idexp,		@ymov,		@nmov
 
	WHILE (@@fetch_status=0) BEGIN
	
	UPDATE 	#registro set
		impegno = isnull(impegno,'') + 'Eserc.'+convert(varchar(10),@ymov) + ' Num.'+convert(varchar(20),@nmov)+'. '
	WHERE idinvkind = @idinvkind and yinv = @yinv and ninv = @ninv

		FETCH NEXT FROM cursore_fatture04 
		INTO  @idinvkind, @yinv, @ninv, 
		@idexp,		@ymov,		@nmov
	END
CLOSE cursore_fatture04

-- CUP: letto dall'impegno che contabilizza il professionale
	DECLARE cursore_fatture11 CURSOR FORWARD_ONLY for 
	SELECT distinct P.idinvkind, P.yinv, P.ninv, E.cupcode
	FROM profservice P
	join #registro R			on P.idinvkind = R.idinvkind	and P.yinv = R.yinv	and P.ninv = R.ninv
	join expenseprofservice EPS	on EPS.ycon = P.ycon	and EPS.ncon = P.ncon
	join expense E				on EPS.idexp = E.idexp
	where E.cupcode is not null
		
	OPEN cursore_fatture11
	FETCH NEXT FROM cursore_fatture11 
	INTO @idinvkind, @yinv, @ninv, @cupcode
 
	WHILE (@@fetch_status=0) BEGIN
	
	UPDATE 	#registro set
	  cupcode = case when @cupcode is not null then isnull(cupcode,'') +'' +isnull(convert(varchar(15),@cupcode),'')+'. '
							else isnull(cupcode,'')
							end
	 WHERE idinvkind = @idinvkind and yinv = @yinv and ninv = @ninv

		FETCH NEXT FROM cursore_fatture11 
		INTO  @idinvkind, @yinv, @ninv, @cupcode 
	END
CLOSE cursore_fatture11

-- CIG: letto dall'impegno che contabilizza il professionale
	DECLARE cursore_fatture12 CURSOR FORWARD_ONLY for 
	SELECT distinct P.idinvkind, P.yinv, P.ninv, E.cigcode
	FROM profservice P
	join #registro R				on P.idinvkind = R.idinvkind	and P.yinv = R.yinv	and P.ninv = R.ninv
	join expenseprofservice EPS		on EPS.ycon = P.ycon		and EPS.ncon = P.ncon
	join expense E					on EPS.idexp = E.idexp
	where E.cigcode is not null

	OPEN cursore_fatture12
	FETCH NEXT FROM cursore_fatture12 
	INTO @idinvkind, @yinv, @ninv,  @cigcode
 
	WHILE (@@fetch_status=0) BEGIN
	
	UPDATE 	#registro set
	  cigcode = case when @cigcode is not null then isnull(cigcode,'') +'' +isnull(convert(varchar(15),@cigcode),'')+' '
							else isnull(cigcode,'')
							end
	 WHERE idinvkind = @idinvkind and yinv = @yinv and ninv = @ninv

		FETCH NEXT FROM cursore_fatture12 
		INTO  @idinvkind, @yinv, @ninv,  @cigcode
	END
CLOSE cursore_fatture12

----------------------------------------------------------- Fatture non collegate ne a Contratti Passivi ne a Contratti Professionali -------------------------------

-- IMPEGNI dei Pagamenti della fattura, ove la fatture non fosse collegata ne a Contratto Passivo , e dett. fatt. non associati o associati a Prestazione professionale

declare @finphase tinyint
SET @finphase = (SELECT top 1 expensephase
FROM config
order by ayear desc)

	DECLARE cursore_fatture05 CURSOR FORWARD_ONLY for 
	SELECT distinct R.idinvkind, R.yinv, R.ninv, 
		E.idexp, E.ymov, E.nmov
	FROM #registro R
	JOIN invoicedetail ID			ON   ID.idinvkind = R.idinvkind and	 ID.yinv = R.yinv and	 ID.ninv = R.ninv
	JOIN expenseinvoice EI			ON   EI.idinvkind = R.idinvkind and	 EI.yinv = R.yinv and	 EI.ninv = R.ninv
	JOIN expenselink				ON expenselink.idchild = EI.idexp
	JOIN expense E					on expenselink.idparent = E.idexp and E.nphase = @finphase
	where ID.idmankind is null
		AND ISNULL(ID.rounding,'N') <>'S'  --salta i dettagli di arrotondamento, task 7360
		 and (isnull(ID.flagbit,0) & 4) = 0
		 AND (ID.ycon is null AND NOT EXISTS (SELECT * FROM profservice 
									WHERE profservice.idinvkind = R.idinvkind 
										and profservice.yinv = R.yinv 
										and profservice.ninv = R.ninv)
				or ID.ycon  is not null)

	OPEN cursore_fatture05
	FETCH NEXT FROM cursore_fatture05 
	INTO @idinvkind, @yinv, @ninv, 
		@idexp,		@ymov,		@nmov
 
	WHILE (@@fetch_status=0) BEGIN
	
	UPDATE 	#registro set
		impegno = isnull(impegno,'') + 'Eserc.'+convert(varchar(10),@ymov) + ' Num.'+convert(varchar(20),@nmov)+'. '
	 WHERE idinvkind = @idinvkind and yinv = @yinv and ninv = @ninv

		FETCH NEXT FROM cursore_fatture05 
		INTO  @idinvkind, @yinv, @ninv, 
		@idexp,		@ymov,		@nmov
	END
CLOSE cursore_fatture05

-- CIG e CUP letti dall'impegno del pagamento della fattura, ove la fattura non fosse collegata ne a Contratto Passivo ce a prestazione Professionale
declare @CupCigInvoice table   (idinvkind int, yinv smallint, ninv int, cupcode varchar(15), cigcode varchar(10) )

insert into @CupCigInvoice(idinvkind, yinv, ninv, cupcode, cigcode)
SELECT distinct R.idinvkind, R.yinv, R.ninv, E.cupcode, E.cigcode
FROM #registro R	
JOIN invoicedetail ID		ON   ID.idinvkind = R.idinvkind and	ID.yinv = R.yinv and	ID.ninv = R.ninv
JOIN expenseinvoice EI		ON   EI.idinvkind = R.idinvkind and	EI.yinv = R.yinv and	EI.ninv = R.ninv
JOIN expenselink			ON expenselink.idchild = EI.idexp
JOIN expense E				on expenselink.idparent = E.idexp and E.nphase = @finphase
where ID.idmankind is null and (E.cupcode is not null or E.cigcode is not null )
		AND ISNULL(ID.rounding,'N') <>'S'  --salta i dettagli di arrotondamento, task 7360
		 and (isnull(ID.flagbit,0) & 4) = 0

insert into @CupCigInvoice(idinvkind, yinv, ninv, cupcode, cigcode)
SELECT distinct R.idinvkind, R.yinv, R.ninv, ID.cupcode, ID.cigcode
FROM #registro R
JOIN invoicedetail ID
	ON   ID.idinvkind = R.idinvkind and
		ID.yinv = R.yinv and
		ID.ninv = R.ninv
where ID.cupcode is not null or ID.cigcode is not null
		AND ISNULL(ID.rounding,'N') <>'S'  --salta i dettagli di arrotondamento, task 7360
		 and (isnull(ID.flagbit,0) & 4) = 0

	DECLARE cursore_fatture13 CURSOR FORWARD_ONLY for 
	SELECT distinct idinvkind, yinv, ninv, cupcode
	FROM @CupCigInvoice
	where cupcode is not null

	OPEN cursore_fatture13
	FETCH NEXT FROM cursore_fatture13 
	INTO @idinvkind, @yinv, @ninv, @cupcode
 
	WHILE (@@fetch_status=0) BEGIN
	
	UPDATE 	#registro set
	  cupcode = case when @cupcode is not null then isnull(cupcode,'') +'' +isnull(convert(varchar(15),@cupcode),'')+' '
							else isnull(cupcode,'')
							end
	 WHERE idinvkind = @idinvkind and yinv = @yinv and ninv = @ninv

		FETCH NEXT FROM cursore_fatture13 
		INTO  @idinvkind, @yinv, @ninv, @cupcode
	END
CLOSE cursore_fatture13


	DECLARE cursore_fatture14 CURSOR FORWARD_ONLY for 
	SELECT distinct idinvkind, yinv, ninv, cigcode
	FROM @CupCigInvoice
	where cigcode is not null

	OPEN cursore_fatture14
	FETCH NEXT FROM cursore_fatture14 
	INTO @idinvkind, @yinv, @ninv, @cigcode
 
	WHILE (@@fetch_status=0) BEGIN
	
	UPDATE 	#registro set
	  cigcode = case when @cigcode is not null then isnull(cigcode,'') +'' +isnull(convert(varchar(15),@cigcode),'')+' '
							else isnull(cigcode,'')
							end
	 WHERE idinvkind = @idinvkind and yinv = @yinv and ninv = @ninv

		FETCH NEXT FROM cursore_fatture14 
		INTO  @idinvkind, @yinv, @ninv, @cigcode
	END
CLOSE cursore_fatture14


-- Contratto Passivo NON collegabile a Fattura
insert into #registro(
	idmankind, yman, nman,
	iduniqueregister,
	arrivalprotocolnum,
	doc,
	dataemissione,
	dataricezione,
	idreg,
	description,
	amount,
	scadenza,
	rilevanteiva,
	--cigcode,
	annotations,
	tipodocumento
)
SELECT 
	M.idmankind, M.yman, M.nman,
	U.iduniqueregister,
	M.arrivalprotocolnum,
	M.doc,
	M.docdate,
	M.arrivaldate,
	M.idreg,
	M.description,
	M.total,
	-- scadenza,
		case 
		-- Data contabile(data registrazione)  = Numero gg D.R.F.
		when (M.idexpirationkind = 1 AND isnull(M.paymentexpiring,0)>0) then DATEADD(day, M.paymentexpiring, M.adate)
		when (M.idexpirationkind = 1 AND isnull(M.paymentexpiring,0)=0) then M.adate
		-- Data documento = Numero gg  D.F.
		when (M.idexpirationkind = 2 AND M.docdate is not null AND isnull(M.paymentexpiring,0)>0) then DATEADD(day, M.paymentexpiring, M.docdate)
		when (M.idexpirationkind = 2 AND isnull(M.paymentexpiring,0)=0) then M.docdate
		-- Fine mese data documento = Numero gg F.M.D.F.
		when (M.idexpirationkind = 3 AND M.docdate is not null and isnull(M.paymentexpiring,0)>0) then DATEADD(day, paymentexpiring,  DATEADD(day, -1, DATEADD(month, 1, DATEADD(day, 1 - DAY(M.docdate) ,M.docdate))) ) 
		when (M.idexpirationkind = 3 AND M.docdate is not null and isnull(M.paymentexpiring,0)=0) then DATEADD(day, -1, DATEADD(month, 1, DATEADD(day, 1 - DAY(M.docdate) ,M.docdate)))
		-- Fine mese data contabile = Numero gg F.M.D.R.F.
		when (M.idexpirationkind = 4  and isnull(M.paymentexpiring,0)>0) then DATEADD(day, paymentexpiring,     DATEADD(day, -1, DATEADD(month, 1, DATEADD(day, 1 - DAY(M.adate) ,M.adate))) )
		when (M.idexpirationkind = 4  and isnull(M.paymentexpiring,0)=0) then DATEADD(day, -1, DATEADD(month, 1, DATEADD(day, 1 - DAY(M.adate) ,M.adate)))
		--	Pagamento Immediato  = data registrazione
		when M.idexpirationkind = 5 then M.adate
		-- Data ricezione
		when (M.idexpirationkind = 6 AND M.arrivaldate is not null AND isnull(M.paymentexpiring,0)>0) then DATEADD(day, paymentexpiring, M.arrivaldate)
		when (M.idexpirationkind = 6 AND isnull(M.paymentexpiring,0)=0) then M.arrivaldate

	else null
	end ,
	-- 	rilevanteiva : per le fatture interrogheremo l''attività del registro associata al documento, 
	-- se commerciale = è rilevante, 
	-- se istituzionale e di tipo intra/extra = rilevante, 
	-- se istituzionale e tipo Italia = non rilevante, 
	-- se promiscua = rilevante, perchè assimiliamo l''attività promiscua a quella commerciale.
	--I 1, C 2, P 3, Q 4
	case	when (MK.flagactivity = 2) then 'S'
			when (MK.flagactivity = 3) then 'S'
			when (MK.flagactivity = 1 and flagintracom <> 'N')  then 'S'
			when (MK.flagactivity = 1 and flagintracom = 'N') then 'N'
			else 'S'
	end,
	--cigcode,
	M.annotations,
	'Contratto passivo'
FROM uniqueregister U
join mandateview M		on U.idmankind = M.idmankind	and U.yman = M.yman	and U.nman = M.nman
JOIN mandatekind MK		ON M.idmankind = MK.idmankind
where U.iduniqueregister between @nbegin and @nend 
	AND (isnull(M.idsor01,MK.idsor01) = @idsor01 OR @idsor01 IS NULL)
	AND (isnull(M.idsor02,MK.idsor02) = @idsor02 OR @idsor02 IS NULL)
	AND (isnull(M.idsor03,MK.idsor03) = @idsor03 OR @idsor03 IS NULL)
	AND (isnull(M.idsor04,MK.idsor04) = @idsor04 OR @idsor04 IS NULL)
	AND (isnull(M.idsor05,MK.idsor05) = @idsor05 OR @idsor05 IS NULL)

-- Ciclo per concatenare gli impegni, e CIG e CUP
DECLARE @idmankind varchar(20)
DECLARE @yman int
DECLARE @nman int
-- CIG
DECLARE cursore_conpassivo01 CURSOR FORWARD_ONLY for 
	SELECT mandett.idmankind, mandett.yman, mandett.nman,  isnull(mandett.cigcode, M.cigcode)
	FROM  #registro R
	join mandatedetail mandett			on R.idmankind = mandett.idmankind	and R.yman = mandett.yman	and R.nman = mandett.nman
	join mandate M						on R.idmankind = M.idmankind		and R.yman = M.yman			and R.nman = M.nman
	where (mandett.cigcode is not null OR M.cigcode is not null)
	group by mandett.idmankind, mandett.yman, mandett.nman, isnull(mandett.cigcode, M.cigcode)

	OPEN cursore_conpassivo01
	FETCH NEXT FROM cursore_conpassivo01 
	INTO @idmankind, @yman, @nman, @cigcode
		 
	WHILE (@@fetch_status=0) BEGIN
	
	UPDATE 	#registro set
	  cigcode = case when @cigcode is not null then isnull(cigcode,'') +'' +isnull(convert(varchar(15),@cigcode),'')+' '
							else isnull(cigcode,'')
							end
	 WHERE idmankind = @idmankind and yman = @yman and nman = @nman

		FETCH NEXT FROM cursore_conpassivo01 
		INTO @idmankind, @yman, @nman, @cigcode
	END
CLOSE cursore_conpassivo01

-- CUP
DECLARE cursore_conpassivo02 CURSOR FORWARD_ONLY for 
	SELECT distinct mandett.idmankind, mandett.yman, mandett.nman, mandett.cupcode 
	FROM  #registro R
	join mandatedetail mandett		on R.idmankind = mandett.idmankind	and R.yman = mandett.yman	and R.nman = mandett.nman
	where mandett.cupcode is not null

	OPEN cursore_conpassivo02
	FETCH NEXT FROM cursore_conpassivo02 
	INTO @idmankind, @yman, @nman, @cupcode 
		 
	WHILE (@@fetch_status=0) BEGIN
	
	UPDATE 	#registro set
	  cupcode = case when @cupcode is not null then isnull(cupcode,'') +'' +isnull(convert(varchar(15),@cupcode),'')+' '
							else isnull(cupcode,'')
							end
	 WHERE idmankind = @idmankind and yman = @yman and nman = @nman

		FETCH NEXT FROM cursore_conpassivo02 
		INTO @idmankind, @yman, @nman, @cupcode
	END
CLOSE cursore_conpassivo02


-- IMPEGNI
DECLARE cursore_conpassivo03 CURSOR FORWARD_ONLY for 
	SELECT distinct R.idmankind, R.yman, R.nman,
		E.idexp,		E.ymov,			E.nmov
	FROM  #registro R
	join expensemandate EM
		on R.idmankind = EM.idmankind
		and R.yman = EM.yman
		and R.nman = EM.nman
	join expense E
		on E.idexp = EM.idexp

	OPEN cursore_conpassivo03
	FETCH NEXT FROM cursore_conpassivo03 
	INTO @idmankind, @yman, @nman, 
		@idexp,		@ymov,		@nmov
		 
	WHILE (@@fetch_status=0) BEGIN
	
	UPDATE 	#registro set
		impegno = isnull(impegno,'') + 'Eserc.'+convert(varchar(10),@ymov) + ' Num.'+convert(varchar(20),@nmov)+'. '
	 WHERE idmankind = @idmankind and yman = @yman and nman = @nman

		FETCH NEXT FROM cursore_conpassivo03 
		INTO @idmankind, @yman, @nman, 
			@idexp,		@ymov,		@nmov
	END
CLOSE cursore_conpassivo03

-- Contratto Occasionale
insert into #registro(
	ycon, ncon,	iduniqueregister,	arrivalprotocolnum,	doc,	dataemissione,	dataricezione,	idreg,
	description,	amount,	scadenza,	rilevanteiva,	cupcode,	cigcode,	annotations,	tipodocumento
)
SELECT 
	C.ycon, C.ncon,	U.iduniqueregister,	C.arrivalprotocolnum,	convert(varchar(4),C.ycon)+'/'+convert(varchar(10),C.ncon),
	C.adate,	C.arrivaldate,	C.idreg,
	C.description,	C.total,	C.expiration,	'N',	C.cupcode,	C.cigcode,	C.annotations,	'Contratto Occasionale'
FROM uniqueregister U
join casualcontractview C
	on U.ycon = C.ycon
	and U.ncon = C.ncon
where U.iduniqueregister between @nbegin and @nend 
	AND (C.idsor01 = @idsor01 OR @idsor01 IS NULL)
	AND (C.idsor02 = @idsor02 OR @idsor02 IS NULL)
	AND (C.idsor03 = @idsor03 OR @idsor03 IS NULL)
	AND (C.idsor04 = @idsor04 OR @idsor04 IS NULL)
	AND (C.idsor05 = @idsor05 OR @idsor05 IS NULL)
DECLARE @ycon smallint
DECLARE @ncon int


DECLARE cursore_occasionale CURSOR FORWARD_ONLY for 
	SELECT ECC.ycon, ECC.ncon, E.idexp, E.ymov, E.nmov
	FROM  #registro R
	join expensecasualcontract ECC
		on R.ycon = ECC.ycon
		and R.ncon = ECC.ncon
	join expense E
		on E.idexp = ECC.idexp

	OPEN cursore_occasionale
	FETCH NEXT FROM cursore_occasionale 
	INTO @ycon, @ncon, 	@idexp,	@ymov, @nmov
		 
	WHILE (@@fetch_status=0) BEGIN
	
	UPDATE 	#registro set
		impegno = isnull(impegno,'') + 'Eserc.'+convert(varchar(10),@ymov) + ' Num.'+convert(varchar(20),@nmov)+'. '
	 WHERE ycon = @ycon and ncon = @ncon

		FETCH NEXT FROM cursore_occasionale 
		INTO @ycon, @ncon, 	@idexp,	@ymov, @nmov
	END
CLOSE cursore_occasionale

declare @headertreasurer varchar(150)
if (select count(*) from treasurer where 
					(idsor01 = @idsor01 OR @idsor01 IS NULL)
				AND (idsor02 = @idsor02 OR @idsor02 IS NULL)
				AND (idsor03 = @idsor03 OR @idsor03 IS NULL)
				AND (idsor04 = @idsor04 OR @idsor04 IS NULL)
				AND (idsor05 = @idsor05 OR @idsor05 IS NULL)
			)=1
	Begin
		select @headertreasurer = header
		from treasurer 
		where 	(idsor01 = @idsor01 OR @idsor01 IS NULL)
				AND (idsor02 = @idsor02 OR @idsor02 IS NULL)
				AND (idsor03 = @idsor03 OR @idsor03 IS NULL)
				AND (idsor04 = @idsor04 OR @idsor04 IS NULL)
				AND (idsor05 = @idsor05 OR @idsor05 IS NULL)
	End


SELECT 
	iduniqueregister ,	arrivalprotocolnum ,	doc ,	dataemissione ,	dataricezione ,	R.idreg ,	description,amount ,
	scadenza ,impegno ,	rilevanteiva ,	cigcode ,	cupcode ,	annotations,	idinvkind ,	yinv ,	ninv ,
	ycon ,	ncon ,	idmankind,	yman ,	nman,	A.title as registry,	A.cf ,	tipodocumento,
	@headertreasurer as headertreasurer
 FROM #registro R
join registry A
	on R.idreg = A.idreg

order by iduniqueregister
END







GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

 