if exists (select * from dbo.sysobjects where id = object_id(N'[exp_electronicinvoice]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [exp_electronicinvoice]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO
--setuser 'amministrazione'

CREATE procedure exp_electronicinvoice(@yelectronicinvoice smallint, @nelectronicinvoice int) as
begin
declare @idreg int
select @idreg = idreg from electronicinvoice where yelectronicinvoice = @yelectronicinvoice and nelectronicinvoice = @nelectronicinvoice
-- exec exp_electronicinvoice 2019, 291
--  exec exp_electronicinvoicedetail 2019, 291
declare @cf varchar(11)
declare @p_iva varchar(11)
select @cf = case when upper(substring(cf,1,2)) ='IT' then substring(cf,3,(len(cf)-2))
			else cf
			end, 
	@p_iva = case when upper(substring(p_iva,1,2)) ='IT' then substring(p_iva,3,(len(p_iva)-2))
			else p_iva
			end
	from license

	DECLARE @phonenumber varchar(12)
	DECLARE @comune varchar(60)
	DECLARE @provincia varchar(2)
	DECLARE @indirizzo varchar(60)
	DECLARE @cap varchar(5)
	SELECT
		@phonenumber = substring(ltrim(rtrim(license.phonenumber)),1,12),
		@comune = SUBSTRING(isnull(geo_city.title, license.location), 1, 60),
		@provincia = license.country,
		@indirizzo = isnull(license.address1,'') + SUBSTRING(isnull(license.address2,''), 1, 10),
		@cap = license.cap
	FROM license
	left outer join geo_city 
		on geo_city.idcity = license.idcity

----------------- Calcola la Sede del Cliente ------------------------------------------
DECLARE @dateindi datetime
SELECT @dateindi = CONVERT(datetime, '31-12-'+ CONVERT(varchar(4),@yelectronicinvoice), 105)

DECLARE @codenostand varchar(20)
SET @codenostand = '07_SW_FAT'

DECLARE @codestand varchar(20)
SET @codestand = '07_SW_DEF'

DECLARE @codestabileorg varchar(20)
SET @codestabileorg = '18_FE_STABILE_ORG'

DECLARE @STAND int
SELECT @STAND = idaddress FROM address WHERE codeaddress = @codestand

DECLARE @NOSTAND int
SELECT @NOSTAND = idaddress FROM address WHERE codeaddress = @codenostand


DECLARE @stabileorg int
SELECT @stabileorg = idaddress FROM address WHERE codeaddress = @codestabileorg

CREATE TABLE #SedeCliente
(
	idaddresskind int,
    idreg int,
	address varchar(60),	
	location varchar(60),
	cap varchar(5),		
	province varchar(2),
	nation varchar(2)
)
/*
--1.4.4   <RappresentanteFiscale>       Blocco da valorizzare se e solo se l'elemento informativo 1.1.3 <FormatoTrasmissione> = "FPR12" (fattura tra privati), nel caso di cessionario/committente che si avvale di rappresentante fiscale in Italia
--1.4.4.1   <IdFiscaleIVA>				
--    1.4.4.1.1   <IdPaese>			
--    1.4.4.1.2   <IdCodice>        (campo assente nella scheda indirizzi dell'anagrafica)			
--1.4.4.2   <Denominazione>			(campo assente nella scheda indirizzi dell'anagrafica)				
--1.4.4.3   <Nome>					(campo assente nella scheda indirizzi dell'anagrafica)			
--1.4.4.4   <Cognome>				(campo assente nella scheda indirizzi dell'anagrafica)			
*/

CREATE TABLE #StabileOrganizzazione
(
	idaddresskind int,
    idreg int,
	address varchar(60),	
	location varchar(60),
	cap varchar(5),		
	province varchar(2),
	nation varchar(2)
)

INSERT INTO #StabileOrganizzazione(idaddresskind, idreg, address,	location, cap, province, nation)
SELECT 
	idaddresskind,
	idreg, 
	substring(address,1,60),
	SUBSTRING(isnull(geo_city.title, registryaddress.location), 1, 60),
	registryaddress.cap,
	geo_country.province,
	ISNULL(geo_nation_agency.value,'IT')
FROM registryaddress
LEFT OUTER JOIN geo_city
	ON geo_city.idcity = registryaddress.idcity
LEFT OUTER JOIN geo_country
	ON geo_city.idcountry = geo_country.idcountry
LEFT OUTER JOIN geo_nation_agency
	 ON geo_nation_agency.idnation = registryaddress.idnation 
	 AND geo_nation_agency.idagency = 6 -- ente ISO   
	 AND geo_nation_agency.idcode = 1 -- codifica nazioni ISO
	 AND geo_nation_agency.version = 1
	 AND geo_nation_agency.stop IS NULL
WHERE registryaddress.active <>'N' 
	AND registryaddress.start = 
		(SELECT MAX(cdi.start) 
		FROM registryaddress cdi 
		WHERE cdi.idaddresskind = registryaddress.idaddresskind
			AND cdi.active <>'N' 
			AND cdi.start <= @dateindi
			AND cdi.idreg = registryaddress.idreg)
	AND idreg = @idreg AND registryaddress.idaddresskind = @stabileorg

INSERT INTO #SedeCliente(idaddresskind, idreg, address,	location, cap, province, nation)
SELECT 
	idaddresskind,
	idreg, 
	substring(address,1,60),
	SUBSTRING(isnull(geo_city.title, registryaddress.location), 1, 60),
	registryaddress.cap,
	case when geo_nation_agency.value is null then geo_country.province else 'EE' end,
	ISNULL(geo_nation_agency.value,'IT')
FROM registryaddress
LEFT OUTER JOIN geo_city
	ON geo_city.idcity = registryaddress.idcity
LEFT OUTER JOIN geo_country
	ON geo_city.idcountry = geo_country.idcountry
--LEFT OUTER JOIN geo_nation
--	ON geo_nation.idnation = registryaddress.idnation
LEFT OUTER JOIN geo_nation_agency
	 ON geo_nation_agency.idnation = registryaddress.idnation 
	 AND geo_nation_agency.idagency = 6 -- ente ISO   
	 AND geo_nation_agency.idcode = 1 -- codifica nazioni ISO
	 AND geo_nation_agency.version = 1
	 AND geo_nation_agency.stop IS NULL
WHERE registryaddress.active <>'N' 
	AND registryaddress.start = 
		(SELECT MAX(cdi.start) 
		FROM registryaddress cdi 
		WHERE cdi.idaddresskind = registryaddress.idaddresskind
			AND cdi.active <>'N' 
			AND cdi.start <= @dateindi
			AND cdi.idreg = registryaddress.idreg)
	AND idreg = @idreg

DELETE #SedeCliente
	WHERE #SedeCliente.idaddresskind != @nostand
	AND EXISTS (
		SELECT * FROM #SedeCliente r2 
		WHERE #SedeCliente.idreg = r2.idreg
		AND r2.idaddresskind = @nostand
	)
DELETE #SedeCliente
	WHERE #SedeCliente.idaddresskind not in (@nostand, @stand)
	AND EXISTS (
		SELECT * FROM #SedeCliente r2 
		WHERE #SedeCliente.idreg = r2.idreg
		AND r2.idaddresskind = @stand
	)
DELETE #SedeCliente
	WHERE (
		SELECT COUNT(*) FROM #SedeCliente r2 
		WHERE #SedeCliente.idreg = r2.idreg
	)>1

-------------------- Fine calcolo della Sede del Cliente -------------------------------------------------
--- Lettura dell'indirizzo RappresentanteFiscale
--  Blocco da valorizzare se e solo se l'elemento informativo 1.1.3 <FormatoTrasmissione> = "FPR12" (fattura tra privati), 
--  nel caso di cessionario/committente che si avvale di rappresentante fiscale in Italia 
declare @rea_provinceoffice	varchar(2)
declare @rea_number	varchar(20)
declare @rea_socialcapital	decimal(19,2)
declare @rea_partner	varchar(2)
declare @rea_closingstatus	varchar(2)
select	@rea_provinceoffice= rea_provinceoffice,
		@rea_number	= rea_number,
		@rea_socialcapital= rea_socialcapital,
		@rea_partner = case when rea_partner='X' then null else rea_partner end,
		@rea_closingstatus = rea_closingstatus
from uniconfig

select 
ROW_NUMBER() OVER(PARTITION BY  I.ipa_ven_cliente, I.rifamm_ven_cliente,  I.email_ven_cliente, I.pec_ven_cliente
      ORDER BY   I.ipa_ven_cliente, I.rifamm_ven_cliente,  I.email_ven_cliente, I.pec_ven_cliente) as 'position',

	CASE
		WHEN ((IK.flag&4)=0) THEN 'F'--fattura
		WHEN ((IK.flag&4)<>0) THEN 'V'-- nota di credito
	END as 'tipofattura',
	I.idinvkind, I.yinv, I.ninv,
--	<CEDENTE PRESTATORE> � l' Universit�
	@cf as 'IdTrasmittenteCodice',
	-- n 1 del 2014 => 1400000001
	substring(convert(varchar(4),@yelectronicinvoice),3,2)+ replicate('0',8-len(convert(varchar(8),@nelectronicinvoice ))) + convert(varchar(8),@nelectronicinvoice )
	as 'ProgressivoInvio',
	replicate('0',5-len(convert(varchar(5),@nelectronicinvoice ))) + convert(varchar(5),@nelectronicinvoice )
	as 'ProgressivoFile',
	--R.ipa_fe as 'CodiceDestinatario',  // per i privati , in assenza di codice destinatario, valorizzare la stringa con 7 zeri. Se non residente in Italia valorizzare la stringa con 7 X
	case when I.ipa_ven_cliente IS NOT NULL then I.ipa_ven_cliente 
		 when (I.ipa_ven_cliente IS NULL AND (RR.coderesidence = 'J'  OR RR.coderesidence = 'X')) THEN 'XXXXXXX' 
		 when (I.ipa_ven_cliente IS NULL AND (RR.coderesidence = 'I')) THEN '0000000' 
		 else '0000000'
    end  as 'CodiceDestinatario',
	I.rifamm_ven_cliente as 'RiferimentoAmministrazione',
	I.ipa_ven_emittente,-- da scrivere in sdi_vendita
	I.rifamm_ven_emittente,-- da scrivere in sdi_vendita
	I.email_ven_cliente, 
	I.pec_ven_cliente, 
	@p_iva as 'IdFiscaleIvaCodiceDip',
	E.departmentname_fe as 'DenominazioneDip',
	case when isnull(I.flagdeferred,'N')='S' then 'RF16'else 'RF01' end as 'RegimeFiscale',
	@indirizzo as 'indirizzoDip',
	@cap as 'capDip',
	@comune as 'comuneDip',
	@provincia as 'provinciaDip',
	'IT' as 'nazioneDip',
	
-- Se I-Italia, leggiamo la piva
-- Se J-UE, leggiamo la p.iva, che sar� valorizzata con la p.iva estera
-- Se X-Extra UE, leggiamo foreigncf, che sar� valorizzato con il codice identificativo estero

--<CESSIONARIO COMMITTENTE>  � il cliente inserito in fattura		-- FARE UN CHECK PER CONTROLLARE CHE questa select dia l'info del paese
	case when RR.coderesidence = 'I' then 'IT' 
		 when RR.coderesidence = 'J' and ASCII(SUBSTRING(R.p_iva,1,1)) BETWEEN 48 AND 57 /* 0..9 */ then #SedeCliente.nation
		 when RR.coderesidence = 'J' then substring(R.p_iva,1,2)
		 when RR.coderesidence = 'X' and ASCII(SUBSTRING(R.foreigncf,1,1)) BETWEEN 48 AND 57 /* 0..9*/then #SedeCliente.nation
		 when RR.coderesidence = 'X' then substring(R.foreigncf,1,2)
		 else null
		 end
	as 'IdFiscaleIvaPaeseCliente'	,
	case when RR.coderesidence = 'I' then R.p_iva
		 when RR.coderesidence = 'J' then R.p_iva
		 when RR.coderesidence = 'X' then substring(R.foreigncf,1,28)
		 else null
		 end
	as 'IdFiscaleIvaCodiceCliente'	,
	R.cf as 'CFCliente',
	isnull(RC.flaghuman,'N') as 'flaghuman',
	case when isnull(RC.flaghuman,'N') = 'N' then substring(ltrim(rtrim(title)),1,60)	else null	end as 'DenominazioneCliente',
	case when isnull(RC.flaghuman,'N') = 'S' then ltrim(rtrim(forename))	else null end as 'nomeCliente',
	case when isnull(RC.flaghuman,'N') = 'S' then ltrim(rtrim(surname))else null end as 'cognomeCliente',
	
	#SedeCliente.address as 'indirizzoCliente', 
	#SedeCliente.location as 'comuneCliente', 
	#SedeCliente.cap as 'capCliente',
	#SedeCliente.province as 'provinciaCliente',  
	#SedeCliente.nation as 'nazioneCliente', 
	/*
	1.4.3	  <StabileOrganizzazione>					
	1.4.3.1   <Indirizzo>				
	1.4.3.2   <NumeroCivico>				
	1.4.3.3   <CAP>				
	1.4.3.4   <Comune>				
	1.4.3.5   <Provincia>				
	1.4.3.6   <Nazione>		
	*/		
	#StabileOrganizzazione.address as 'indirizzoStabileOrg', 
	#StabileOrganizzazione.location as 'comuneStabileOrg', 
	#StabileOrganizzazione.cap as 'capStabileOrg',
	#StabileOrganizzazione.province as 'provinciaStabileOrg',  
	#StabileOrganizzazione.nation as 'nazioneStabileOrg', 
	/*
	1.4.4   <RappresentanteFiscale>       Blocco da valorizzare se e solo se l'elemento informativo 1.1.3 <FormatoTrasmissione> = "FPR12" (fattura tra privati), nel caso di cessionario/committente che si avvale di rappresentante fiscale in Italia
	1.4.4.1   <IdFiscaleIVA>				
		1.4.4.1.1   <IdPaese>			
		1.4.4.1.2   <IdCodice>  (campo assente nella scheda indirizzi dell'anagrafica)			
	1.4.4.2   <Denominazione>	(campo assente nella scheda indirizzi dell'anagrafica)				
	1.4.4.3   <Nome>			(campo assente nella scheda indirizzi dell'anagrafica)			
	1.4.4.4   <Cognome>			(campo assente nella scheda indirizzi dell'anagrafica)			
	*/
	CASE WHEN (I.idreg_sostituto IS NOT NULL) THEN 'IT' ELSE NULL END  as 'IdPaeseRappresentante', 
	CASE WHEN (I.idreg_sostituto IS NOT NULL) THEN I.p_iva_sostituto ELSE NULL END as 'IdCodiceRappresentante',
	CASE WHEN I.flaghuman_sostituto ='N' THEN I.registry_sostituto  ELSE NULL END as 'DenominazioneRappresentante',  
	CASE WHEN I.flaghuman_sostituto ='S' THEN I.forename_sostituto  ELSE NULL END as 'NomeRappresentante',  
	CASE WHEN I.flaghuman_sostituto ='S' THEN I.surname_sostituto   ELSE NULL END as 'CognomeRappresentante',   
-- <DATI GENERALI>
	CASE
		WHEN ((IK.flag&4)=0) THEN 'TD01'--fattura
		WHEN ((IK.flag&4)<>0) THEN 'TD04'-- nota di credito
	END as 'Tipodocumento',
	'EUR' as 'divisa',
	I.adate	as'data',
	--I.doc as 'numero',
	'dip' + replicate('0',5-len(convert(varchar(5),I.idinvkind ))) + convert(varchar(5),I.idinvkind )+ '-'+I.doc as 'numero',
	I.docdate as 'datadocumento',
	-- Sulla fattura, sull'intera fattura non sul dettaglio, � previsto o uno sconto o una maggiorazione. Per questo potremmo fare un altro check, che verifichi non vi siano sia sconti che maggiorazioni 
	-- nella stessa fattura, perch� non possiamo trasmettere nello stesso file un dettaglio scontato e un dettaglio maggiorato.Anche se il concetto di maggiorazione credo non venga usato proprio...
	--> Imponibile totale -  Imponibile totale scontato = importo sconto
	 ROUND((  select 
		  sum( CONVERT(decimal(19,8), (ID2.taxable_euro/ISNULL(ID2.npackage, ID2.number)-ID2.taxable))*ISNULL(ID2.npackage, ID2.number))		   
	  
		from invoicedetailview ID2		
		where ID2.ninv = I.ninv AND ID2.yinv = I.yinv AND ID2.idinvkind = I.idinvkind and ID2.taxable_euro <>0 and ISNULL(ID2.npackage, ID2.number)<>0
	   ),2)
		as 'sconto',
	case 
		when (select sum(discount) from invoicedetail id2 where id2.ninv = I.ninv AND id2.yinv = I.yinv AND id2.idinvkind = I.idinvkind)>0 then 'SC'
		when (select sum(discount) from invoicedetail id2 where id2.ninv = I.ninv AND id2.yinv = I.yinv AND id2.idinvkind = I.idinvkind)<0 then 'MG'
		else null
	end as 'tipoScontoMaggiorazione',
	I.total as 'ImportoTotaleDocumento',
	I.description as 'Causale',
--	<DatiFattureCollegate>	
	null as 'RiferimentoNumeroLinea',-- linea di dettaglio della fattura a cui si fa riferimento (se il riferimento � all'intera fattura, non viene valorizzato) 
									-- Non lo valorizziamo perch� noi nel dettaglio spefichiamo la fattura madre, e non anche la riga di dettaglio
	(select TOP 1 substring(M.doc,1,20) from invoice M 
			join invoicedetail id2
				on M.idinvkind = id2.idinvkind_main and M.yinv = id2.yinv_main and M.ninv = id2.ninv_main
		where id2.idinvkind = I.idinvkind and id2.yinv = I.yinv and id2.ninv = I.ninv) as 'IdDocumentoFatturaMadre',
	(select TOP 1 M.adate from invoice M 
			join invoicedetail id2
				on M.idinvkind = id2.idinvkind_main and M.yinv = id2.yinv_main and M.ninv = id2.ninv_main
		where id2.idinvkind = I.idinvkind and id2.yinv = I.yinv and id2.ninv = I.ninv) as 'DataFatturaMadre',
--	ivakind.rate as 'AliquotaIVA',
	I.idfepaymethodcondition as 'CondizioniPagamento',
	I.idfepaymethod as 'ModalitaPagamento',
	-- Data Scadenza Pagamento
/* Lasciamolo calcolare al form, perch� � pi� semplice calcolare le date
	case 
		-- Data contabile(data registrazione)  = Numero gg D.R.F.
		when I.idexpirationkind = 1 and I.paymentexpiring is not null then I.adate + paymentexpiring
		-- Data documento = Numero gg  D.F.
		when I.idexpirationkind = 2 then I.docdate
		-- Fine mese data documento = Numero gg F.M.D.F.
		when I.idexpirationkind = 3 then ultimo giorno(I.docdate)
		-- Fine mese data contabile = Numero gg F.M.D.R.F.
		when I.idexpirationkind = 4 then ultimo giorno(I.adate)
		--	Pagamento Immediato  = data registrazione
		when I.idexpirationkind = 5 then I.adate
	else null
	end as 'DataScadenzaPagamento'*/
	 I.idexpirationkind ,
	 I.paymentexpiring,
	 case	when isnull(I.flag_enable_split_payment,'N') = 'S' then  I.taxable
			else I.total 
	 end  as 'ImportoPagamento',
	 case --when (R.flagbankitaliaproceeds='S' AND I.idfepaymethod in ('MP05','MP15')) then (select iban_f24 from config where ayear = @yelectronicinvoice)
		when (R.flagbankitaliaproceeds='S' AND I.idfepaymethod in ('MP05','MP15')) then null
		  when (I.idtreasurer is not null  AND I.idfepaymethod in ('MP05','MP15')) then (select iban from treasurer where treasurer.idtreasurer = I.idtreasurer)
		  when  (I.idfepaymethod in ('MP05','MP15')) then (select iban from treasurer where flagdefault='S')
		  else null
	end as 'iban',
	I.idstampkind,
	case when (R.flagbankitaliaproceeds='S' AND I.idfepaymethod in ('MP05','MP15')) 
		then 'CODICE DI TESORERIA PER IL GIROCONTO: '+(select substring(iban_f24,len(iban_f24)-6,7 ) from config where ayear = @yelectronicinvoice)
		else null
	end as 'CodicePagamento',
	@rea_provinceoffice as rea_provinceoffice,
	@rea_number as rea_number,
	@rea_socialcapital as rea_socialcapital,
	@rea_partner as rea_partner,
	@rea_closingstatus as rea_closingstatus
from invoiceview I 
join invoicekind IK				ON IK.idinvkind = I.idinvkind
join registry R					on I.idreg = R.idreg
join residence RR				on RR.idresidence = R.residence
join registryclass RC			on RC.idregistryclass = R.idregistryclass
join electronicinvoiceview E	on I.nelectronicinvoice = E.nelectronicinvoice and I.yelectronicinvoice = E.yelectronicinvoice
JOIN #SedeCliente				ON #SedeCliente.idreg = I.idreg
LEFT OUTER JOIN #StabileOrganizzazione				ON #StabileOrganizzazione.idreg = I.idreg
where E.nelectronicinvoice = @nelectronicinvoice and E.yelectronicinvoice = @yelectronicinvoice
end

GO


SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO
 /*
 <DatiBeniServizi><DatiRiepilogo>Blocco sempre obbligatorio contenente i dati di riepilogo per ogni aliquota IVA o natura
	<AliquotaIVA>
	<Natura>
	<ImponibileImporto>	
	<Imposta>

<DatiPagamento>� un blocco facoltativo, contiene diverse info che non abbiamo.Valorizziamo il blocco con una sola occorrenza
<CondizioniPagamento> TP01: pagamento a rate, TP02: pagamento completo, TP03: anticipo >>> AGGIUNGERE >>>
<DettaglioPagamento>
	<ModalitaPagamento> valori codificati.Se l'anagrafica � 'Regolarizzazione riscossioni presso Banca d'Italia' ci metto MP15=giroconto su conti di contabilit� speciale, per default, altrimenti lascio vuoto rendendolo obbligatorio.
	<DataRiferimentoTerminiPagamento>	data emissione fattura 
	<GiorniTerminiPagamento>data riferimento termini pagamento - data scadenza pagamento
	<DataScadenzaPagamento>
*/


 