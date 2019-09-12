--setuser 'amministrazione' 
if exists (select * from dbo.sysobjects where id = object_id(N'[trasmele_expense_unicredit_ins]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [trasmele_expense_unicredit_ins]
GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE        PROCEDURE [trasmele_expense_unicredit_ins]
(
    @y int,
    @n int
)
AS BEGIN
/* Versione 1.0.0 del 05/09/2007 ultima modifica: SARA */
-- [trasmele_expense_unicredit_ins] 2013, 11
-- Inizio Sezione Dichiarativa
DECLARE @docversion varchar(5)
SET @docversion = '2.100'

DECLARE @len_npay_trans int
SET @len_npay_trans = 6

DECLARE @len_ndoc int
SET @len_ndoc = 7

DECLARE @len_committeeamount int
SET @len_committeeamount = 7

DECLARE @len_amount int
SET @len_amount = 15

DECLARE @len_desc_dept int
SET @len_desc_dept = 30

DECLARE @len_address_dept int
SET @len_address_dept = 30

DECLARE @len_location_dept int
SET @len_location_dept = 35

DECLARE @len_idpay int
SET @len_idpay = 7

DECLARE @len_idpro int
SET @len_idpro = 7

DECLARE @len_registry_title int
SET @len_registry_title = 140

DECLARE @len_address int
SET @len_address = 30

DECLARE @len_cap int
SET @len_cap = 5

DECLARE @len_location int
SET @len_location = 30

DECLARE @len_province int
SET @len_province = 2

DECLARE @len_cf int
SET @len_cf = 16

DECLARE @len_pi int
SET @len_pi = 11

DECLARE @len_pi_estera int
SET @len_pi_estera = 15

DECLARE @len_ABI int
SET @len_ABI = 5

DECLARE @len_CAB int
SET @len_CAB = 5

DECLARE @len_cc int
SET @len_cc = 12

DECLARE @len_cin int
SET @len_cin = 1

DECLARE @len_desc_paymethod int
SET @len_desc_paymethod = 30

DECLARE @len_desc_payment int
SET @len_desc_payment = 370

DECLARE @len_sortcode int
SET @len_sortcode = 10

DECLARE @len_desc_sort int
SET @len_desc_sort = 60

DECLARE @len_deputy int
SET @len_deputy = 140

DECLARE @len_bank_title int
SET @len_bank_title = 100

DECLARE @len_refexternaldoc int
SET @len_refexternaldoc = 1

DECLARE @len_idstamphandling int
SET @len_idstamphandling = 1

DECLARE @idtreasurer int
DECLARE @kpaymenttransmission int

DECLARE @lencodicecontabilitaspeciale int
SET @lencodicecontabilitaspeciale = 7  

DECLARE @len_codiceoperatore int
SET @len_codiceoperatore = 12

SELECT @idtreasurer = idtreasurer, @kpaymenttransmission = kpaymenttransmission FROM paymenttransmission
WHERE ypaymenttransmission = @y
    AND npaymenttransmission = @n

IF (@idtreasurer IS NULL)
BEGIN
    SELECT @idtreasurer = MAX(idtreasurer) FROM treasurer WHERE flagdefault = 'S'
END
IF (@idtreasurer IS NULL)
BEGIN
    SELECT @idtreasurer = MAX(idtreasurer) FROM treasurer
END

DECLARE @opkind char(2) -- Può assumere i valori I, A, S, N (vedere specifiche tracciato)
SET @opkind = 'I ' -- Attualmente può assumere solamente valore ' I'
-- Fine Sezione Dichiarativa

DECLARE @lenCC_vincolato int
SET @lenCC_vincolato = 7

DECLARE @lenbic_swift_code int
SET @lenbic_swift_code = 11

DECLARE @lenforeign_cc int
SET @lenforeign_cc = 18

DECLARE @leniban int
SET @leniban = 34

DECLARE @cc_vincolato varchar(7)

DECLARE @CodiceStruttura varchar(16)
DECLARE @len_CodiceStruttura int
SET @len_CodiceStruttura = 16

DECLARE @header varchar(150)


DECLARE @csa_flagtransmissionlinking char(1)
SELECT  @csa_flagtransmissionlinking = ISNULL(csa_flagtransmissionlinking,'S')  
FROM config WHERE ayear=@y

DECLARE @cod_department varchar(9) -- Codice dell'ente da esportare
DECLARE @ABI_code varchar(5)
SELECT @cod_department = ISNULL(agencycodefortransmission,''),
    @ABI_code = SUBSTRING(REPLICATE('0',@len_ABI),1,@len_ABI - DATALENGTH(ISNULL(idbank,'')))+ ISNULL(idbank,''),
    @cc_vincolato = SUBSTRING( REPLICATE(' ',7), 1, @lenCC_vincolato - DATALENGTH(SUBSTRING(ISNULL(trasmcode,''), DATALENGTH(ISNULL(trasmcode,''))-6,@lenCC_vincolato))) + substring(ISNULL(trasmcode,''), DATALENGTH(ISNULL(trasmcode,''))-6,@lenCC_vincolato),
    @CodiceStruttura =
        CASE
        WHEN DATALENGTH(ISNULL(billcode,'')) <= @len_CodiceStruttura
        THEN ISNULL(billcode,'') + SUBSTRING(SPACE(@len_CodiceStruttura),1,@len_CodiceStruttura - DATALENGTH(ISNULL(billcode,'')))
        ELSE SUBSTRING(billcode,1,@len_CodiceStruttura)
        END,
    @header =header
FROM treasurer WHERE idtreasurer = @idtreasurer


DECLARE @cf_dept varchar(16)
DECLARE @desc_dept varchar(30)
DECLARE @address_dept varchar(30)
DECLARE @location_dept varchar(35)
SELECT @cf_dept = ISNULL(cf,'') + SUBSTRING(SPACE(@len_cf),1,@len_cf - DATALENGTH(ISNULL(cf,''))) ,
@desc_dept =
CASE
    WHEN DATALENGTH(ISNULL(agencyname,'')) <= @len_desc_dept
    THEN ISNULL(agencyname,'') + SUBSTRING(SPACE(@len_desc_dept),1,@len_desc_dept - DATALENGTH(ISNULL(agencyname,'')))
    ELSE SUBSTRING(agencyname,1,@len_desc_dept)
END,
@address_dept =
CASE
    WHEN DATALENGTH(ISNULL(address1,'')) <= @len_address_dept
    THEN ISNULL(address1,'') + SUBSTRING(SPACE(@len_address_dept),1,@len_address_dept - DATALENGTH(ISNULL(address1,'')))
    ELSE SUBSTRING(address1,1,@len_address_dept)
END,
@location_dept =
CASE
    WHEN DATALENGTH(ISNULL(location,'')) <= @len_location_dept
    THEN ISNULL(location,'') + SUBSTRING(SPACE(@len_location_dept),1,@len_location_dept - DATALENGTH(ISNULL(location,'')))
    ELSE SUBSTRING(location,1,@len_location_dept)
END
FROM license

DECLARE @len_agencycode int
SET @len_agencycode = 7

CREATE TABLE #error (message varchar(400))

-- Inizio Sezione Controlli
-- CONTROLLO N. 0 -- Distinta di Trasmissione vuota
IF(
(SELECT COUNT(*) FROM payment
WHERE kpaymenttransmission = @kpaymenttransmission) = 0)
BEGIN
    INSERT INTO #error
    VALUES('La distinta di trasmissione ' + CONVERT(varchar(4),@y) + '/'
    + CONVERT(varchar(6),@n) + ' è vuota')
END
-- CONTROLLO N. 1. Presenza dei dati dell'ente
DECLARE @error char(1)
SET @error = 'N'
DECLARE @message varchar(400)
SET @message = 'Mancano i seguenti dati: '
IF (@cod_department IS NULL OR @cod_department = '')
BEGIN
    SET @message = @message + ' Il Codice Ente'
    SET @error = 'S'
END
IF (@ABI_code IS NULL OR @ABI_code = '')
BEGIN
    SET @message = @message + ' Il codice ABI'
    SET @error = 'S'
END
IF (@error = 'S')
BEGIN
    SET @message = @message + ' Andare nella maschera Opzioni - Tesoriere - Tesoriere ed inserire i dati'
    INSERT INTO #error VALUES(@message)
END
-- CONTROLLO N. 2. Lunghezza del codice ente
IF (DATALENGTH(@cod_department) > @len_agencycode)
BEGIN
    INSERT INTO #error
    VALUES ('Il codice Ente inserito è superiore alla lunghezza massima fissata a '
    + CONVERT(varchar(2),@len_agencycode))
END

-- CONTROLLO N. 3. Movimento di Spesa senza Modalità di Pagamento
INSERT INTO #error (message)
(SELECT 'Per il movimento n.' + CONVERT(varchar(6),nmov)
+ '/' + CONVERT(varchar(4),ymov) + ' non è stata scelta una modalità di pagamento'
FROM paymentcommunicated
WHERE ypaymenttransmission = @y
    AND npaymenttransmission = @n
    AND idpaymethod IS NULL
	AND ((paymentcommunicated.flag & 1) = 0)   -- non a copertura
	AND NOT EXISTS (SELECT * FROM expenseview WHERE expenseview.idexp =paymentcommunicated.idexp AND  netamount = 0)
	)

-- CONTROLLO N. 4. Movimento di spesa con refexternaldoc che eccede la lunghezza consentita
INSERT INTO #error (message)
(SELECT 'Nel movimento n.' + CONVERT(varchar(6),nmov)
+ '/' + CONVERT(varchar(4),ymov) + ' il riferimento al doc. esterno eccede la lunghezza di '
+ CONVERT(varchar(3),@len_refexternaldoc) + ' caratteri'
FROM paymentcommunicated
WHERE ypaymenttransmission = @y
    AND npaymenttransmission = @n
    AND DATALENGTH(ISNULL(RTRIM(refexternaldoc),''))> @len_refexternaldoc)

-- CONTROLLO N. 5. Movimento di Spesa con Modalità di Pagamento non configurata
INSERT INTO #error (message)
(SELECT 'Nel movimento n.' + CONVERT(varchar(6),paymentcommunicated.nmov)
+ '/' + CONVERT(varchar(4),paymentcommunicated.ymov) + ' la modalità di pagamento scelta non è configurata, Andare in Configurazione - Anagrafica - Modalità di Pagamento'
FROM paymentcommunicated
JOIN paymethod
    ON paymentcommunicated.idpaymethod = paymethod.idpaymethod
WHERE paymentcommunicated.ypaymenttransmission = @y
    AND paymentcommunicated.npaymenttransmission = @n
    AND (paymethod.methodbankcode IS NULL OR REPLACE(paymethod.methodbankcode,' ','') = '')
)
-- CONTROLLO N. 6. Codice IBAN o ABI o CAB devono essere valorizzati nel caso di modalità di pagamento 53 e 63
INSERT INTO #error (message)
(SELECT 'Al movimento n.' + CONVERT(varchar(6),paymentcommunicated.nmov)
+ '/' + CONVERT(varchar(4),paymentcommunicated.ymov) + ' nella modalità di pagamento scelta non è stato assegnato il codice ABI / CAB.'
FROM paymentcommunicated
    JOIN paymethod
    ON paymentcommunicated.idpaymethod = paymethod.idpaymethod
WHERE paymentcommunicated.ypaymenttransmission = @y
    AND paymentcommunicated.npaymenttransmission = @n
    AND paymethod.methodbankcode IN ('53','63')
    AND (
        (paymentcommunicated.idcab IS NULL OR REPLACE(paymentcommunicated.idcab,' ','') = '')
        OR (paymentcommunicated.idbank IS NULL OR REPLACE(paymentcommunicated.idbank,' ','') = '')
-- N.B. Giuseppe Rusciano scrive: Su richesta dell'Università di Bari, stiamo commentando l'obbligatorietà dell'IBAN,
-- negli ultimi giorni di maggio la rimettiamo e nel caso la vogliono togliere di nuovo ci facciamo mandare una mail
-- in quanto dal 3 giugno 2008 chi non mette l'IBAN è soggetto ad una sanzione di 1 euro
--        OR (paymentcommunicated.iban IS NULL OR REPLACE(paymentcommunicated.iban,' ','') = '')
    )
)

-- CONTROLLO N. 7. Il codice ABI, CAB e il CIN non devono eccedere la lunghezza massima nel caso di modalità di pagamento 53 e 63
INSERT INTO #error (message)
(SELECT 'Al movimento n.' + CONVERT(varchar(6),paymentcommunicated.nmov)
+ '/' + CONVERT(varchar(4),paymentcommunicated.ymov) + ' nella modalità di pagamento il codice ABI eccede la lunghezza di '
+ CONVERT(varchar(3),@len_ABI) + ' caratteri e/o il codice CAB eccede la lunghezza di '
+ CONVERT(varchar(3),@len_CAB) + ' caratteri e/o il CIN eccede la lunghezza di '
+ CONVERT(varchar(3),@len_cin) + ' caratteri'
FROM paymentcommunicated
JOIN paymethod
    ON paymentcommunicated.idpaymethod = paymethod.idpaymethod
WHERE paymentcommunicated.ypaymenttransmission = @y
    AND paymentcommunicated.npaymenttransmission = @n
    AND paymethod.methodbankcode IN ('53','63')
    AND (
    (DATALENGTH(paymentcommunicated.idcab) > @len_CAB)
    OR (DATALENGTH(paymentcommunicated.idbank) > @len_ABI)
    OR (DATALENGTH(paymentcommunicated.cin) > @len_cin)
        )
    )
  
-- CONTROLLO N. 6. Codice BIC/SWIFT  devono essere valorizzati nel caso di modalità di pagamento 69 (Bonifico SEPA)
INSERT INTO #error (message)
(SELECT 'Al movimento n.' + CONVERT(varchar(6),paymentcommunicated.nmov)
+ '/' + CONVERT(varchar(4),paymentcommunicated.ymov) + ' nella modalità di pagamento scelta non è stato assegnato il codice BIC/SWIFT.'
FROM paymentcommunicated
    JOIN paymethod
    ON paymentcommunicated.idpaymethod = paymethod.idpaymethod
WHERE paymentcommunicated.ypaymenttransmission = @y
    AND paymentcommunicated.npaymenttransmission = @n
    AND paymethod.methodbankcode IN ('69','73')
    AND (
        (paymentcommunicated.biccode IS NULL OR REPLACE(paymentcommunicated.biccode,' ','') = '')
         )
    )

-- CONTROLLO N. 6. Codice IBAN  devono essere valorizzati nel caso di modalità di pagamento 69 (Bonifico SEPA Italia o Bonifico SEPA estero)
INSERT INTO #error (message)
(SELECT 'Al movimento n.' + CONVERT(varchar(6),paymentcommunicated.nmov)
+ '/' + CONVERT(varchar(4),paymentcommunicated.ymov) + ' nella modalità di pagamento scelta non è stato assegnato il codice IBAN o il CONTO CORRENTE ESTERO.'
FROM paymentcommunicated
    JOIN paymethod
    ON paymentcommunicated.idpaymethod = paymethod.idpaymethod
WHERE paymentcommunicated.ypaymenttransmission = @y
    AND paymentcommunicated.npaymenttransmission = @n
    AND paymethod.methodbankcode IN ('69')
    AND (
        (paymentcommunicated.iban IS NULL OR REPLACE(paymentcommunicated.iban,' ','') = '')
         AND
        (paymentcommunicated.cc IS NULL OR REPLACE(paymentcommunicated.cc,' ','') = '')
        )
    )

-- CONTROLLO N. 6. Codice IBAN non deve essere italiano nel caso di modalità di pagamento 69 (Bonifico SEPA estero)
INSERT INTO #error (message)
(SELECT 'Al movimento n.' + CONVERT(varchar(6),paymentcommunicated.nmov)
+ '/' + CONVERT(varchar(4),paymentcommunicated.ymov) + ' nella modalità di pagamento scelta  (Bonifico SEPA) è stato assegnato un codice IBAN ITALIANO.'
FROM paymentcommunicated
    JOIN paymethod
    ON paymentcommunicated.idpaymethod = paymethod.idpaymethod
WHERE paymentcommunicated.ypaymenttransmission = @y
    AND paymentcommunicated.npaymenttransmission = @n
    AND paymethod.methodbankcode IN ('69')
    AND (
        (paymentcommunicated.iban IS NOT NULL AND SUBSTRING(UPPER(paymentcommunicated.iban), 1, 2) = 'IT')
        
        )
    )
  
-- CONTROLLO N. 8. Conto Corrente valorizzato e di lunghezza massima 12 caratteri nel caso di modalità di pagamento 52, 53 e 63
IF EXISTS
(SELECT * FROM paymentcommunicated
JOIN paymethod
    ON paymentcommunicated.idpaymethod = paymethod.idpaymethod
WHERE paymentcommunicated.ypaymenttransmission = @y
    AND paymentcommunicated.npaymenttransmission = @n
    AND paymethod.methodbankcode IN ('52','53','63')
AND (paymentcommunicated.cc IS NULL
    OR REPLACE(paymentcommunicated.cc,' ','') = ''
    OR DATALENGTH(ISNULL(
    REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(
    REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(paymentcommunicated.cc,',',''),'.',''),'_',''),'-',''),'*',''),'+',''),
    '/',''),':',''),';',''),' ','')
    ,'')) > @len_cc)
)
BEGIN
    INSERT INTO #error (message)
    (SELECT 'Al movimento n.' + CONVERT(varchar(6),paymentcommunicated.nmov)
    + '/' + CONVERT(varchar(4),paymentcommunicated.ymov)
    + ' nella modalità di pagamento non è stato il C/C o la lunghezza del C/C eccede i '
    + CONVERT(varchar(2),@len_cc) + ' caratteri'
    FROM paymentcommunicated
    JOIN paymethod
        ON paymentcommunicated.idpaymethod = paymethod.idpaymethod
    WHERE paymentcommunicated.ypaymenttransmission = @y
    AND paymentcommunicated.npaymenttransmission = @n
    AND paymethod.methodbankcode IN ('52','53','63')
    AND (paymentcommunicated.cc IS NULL
        OR REPLACE(paymentcommunicated.cc,' ','') = ''
        OR DATALENGTH(ISNULL(paymentcommunicated.cc,'')) > @len_cc)
    )
END

-- CONTROLLO N. 9. Presenza tipologia dei beneficiari
DECLARE @denomcred_err varchar(200)
INSERT INTO #error (message)
SELECT 'Il beneficiario ' + ISNULL(R.title,'XXX') + ' con codice ' + CONVERT(varchar(6),R.idreg) + ' non ha una tipologia associata. E'' necessario inserirla'
FROM expense E
JOIN expenselast EL
    ON E.idexp = EL.idexp
JOIN payment P
    ON P.kpay = EL.kpay
JOIN registry R
    ON R.idreg = E.idreg
WHERE R.idregistryclass IS NULL
    AND P.kpaymenttransmission = @kpaymenttransmission

-- CONTROLLO N. 10
INSERT INTO #error (message)
SELECT distinct 'Correggere il codice della modalità di pagamento ' + pm.description + '. La lunghezza deve essere 2. '
FROM expenselast el
JOIN payment p
    ON p.kpay = el.kpay
JOIN paymethod pm
    ON el.idpaymethod = pm.idpaymethod
WHERE p.kpaymenttransmission = @kpaymenttransmission
        AND len(pm.methodbankcode)<>2

INSERT INTO #error (message)
SELECT distinct 'Correggere il codice delle Commissioni Bancarie per la mod. di pagamento ' + pm.description + '. La lunghezza deve essere 1. '
FROM expenselast el
JOIN payment p
    ON p.kpay = el.kpay
JOIN paymethod pm
    ON el.idpaymethod = pm.idpaymethod
WHERE p.kpaymenttransmission = @kpaymenttransmission
        AND len(pm.committeecode)<>1


-- CONTROLLO N. 11. Uso di modlaità di pagamento NON ammesse dalla banca-  vedi 'MIF ABI-USI txt Multirecord - note V2200.pdf'
INSERT INTO #error (message)
(SELECT 'Nel movimento n.' + CONVERT(varchar(6),paymentcommunicated.nmov)
+ '/' + CONVERT(varchar(4),paymentcommunicated.ymov) + ' è stata usata una modalità di pagamento non prevista dalla banca.'
FROM paymentcommunicated
JOIN paymethod
    ON paymentcommunicated.idpaymethod = paymethod.idpaymethod
WHERE paymentcommunicated.ypaymenttransmission = @y
    AND paymentcommunicated.npaymenttransmission = @n
    AND paymethod.methodbankcode NOT IN ('51','52','53','55','57','61','63','64','65','67','68','69','71','72','73')
)

-- CONTROLLO N. 12. Modalità di Pagamento Esclusiva Cassiere
INSERT INTO #error (message)
(SELECT 'Nel movimento n.' + CONVERT(varchar(6),paymentcommunicated.nmov)
+ '/' + CONVERT(varchar(4),paymentcommunicated.ymov) + ' la modalità di pagamento scelta è Esclusiva Cassiere. Sostituirla con una più adeguata, al fine di attribuirne un significato più consono nella trasmissione telematica. '
FROM paymentcommunicated
JOIN paymethod
    ON paymentcommunicated.idpaymethod = paymethod.idpaymethod
WHERE paymentcommunicated.ypaymenttransmission = @y
    AND paymentcommunicated.npaymenttransmission = @n
    AND (paymethod.description like 'Esclusiva%Cassiere')
)

-- CONTROLLO N. 13. codice contabilita speciale errato o mancante
IF EXISTS
(SELECT * FROM paymentcommunicated
        join expenselast
            ON paymentcommunicated.idexp = expenselast.idexp
        join expense
              on expenselast.idexp = expense.idexp
        join registrypaymethod
                on registrypaymethod.idreg = expense.idreg
                and registrypaymethod.idpaymethod = expenselast.idpaymethod
                and registrypaymethod.idregistrypaymethod = expenselast.idregistrypaymethod
        JOIN paymethod
            ON expenselast.idpaymethod = paymethod.idpaymethod
WHERE paymentcommunicated.kpaymenttransmission = @kpaymenttransmission
    AND paymethod.methodbankcode = '61'
    AND (ISNULL(expenselast.extracode,registrypaymethod.extracode) IS NULL
        OR REPLACE(ISNULL(expenselast.extracode,registrypaymethod.extracode),' ','') = ''
        OR DATALENGTH(ISNULL(
        REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(
        REPLACE(REPLACE(REPLACE(REPLACE(ISNULL(expenselast.extracode,registrypaymethod.extracode),',',''),'.',''),'_',''),'-',''),'*',''),'+',''),
        '/',''),':',''),';','')
        ,'')) > @lencodicecontabilitaspeciale)
)
BEGIN
    INSERT INTO #error (message)
        (SELECT 'Al movimento n.' + CONVERT(varchar(6),paymentcommunicated.nmov)
        + '/' + CONVERT(varchar(4),paymentcommunicated.ymov)
        + ' nella modalità di pagamento non è stato inserito il Codice contabilità speciale o la sua lunghezza supera i '
        + CONVERT(varchar(7),@lencodicecontabilitaspeciale) + ' caratteri'
        FROM paymentcommunicated
        join expenselast
            ON paymentcommunicated.idexp = expenselast.idexp
        join expense
              on expenselast.idexp = expense.idexp
        join registrypaymethod
                on registrypaymethod.idreg = expense.idreg
                and registrypaymethod.idpaymethod = expenselast.idpaymethod
                and registrypaymethod.idregistrypaymethod = expenselast.idregistrypaymethod
        JOIN paymethod
            ON expenselast.idpaymethod = paymethod.idpaymethod
        WHERE paymentcommunicated.kpaymenttransmission = @kpaymenttransmission
            AND paymethod.methodbankcode = '61'
            AND (ISNULL(expenselast.extracode,registrypaymethod.extracode) IS NULL
                OR REPLACE(ISNULL(expenselast.extracode,registrypaymethod.extracode),' ','') = ''
                OR DATALENGTH(ISNULL(ISNULL(expenselast.extracode,registrypaymethod.extracode),'')) > @lencodicecontabilitaspeciale)
        )
END

-- CONTROLLO N. 15. Movimento di Spesa a Importo zero
INSERT INTO #error (message)
(SELECT 'Il movimento n.' + CONVERT(varchar(6),nmov) 
+ '/' + CONVERT(varchar(4),ymov) + ' ha importo pari a zero'
FROM paymentcommunicated
WHERE ypaymenttransmission = @y
	AND npaymenttransmission = @n
	AND ISNULL(curramount,0) = 0)
	

IF (SELECT COUNT(*) FROM #error) > 0
BEGIN
    SELECT * FROM #error
    RETURN
END
-- Attenzione! Altri controlli sono presenti nel testo della SP in quanto non era possibile calcolarli a priori
-- I controlli vengono riconosciuti in quanto il prefisso adoperato come linea di commento sarà CONTROLLO N. x.
-- Fine Sezione Controlli
SET @cod_department = @cod_department + SUBSTRING(SPACE(@len_agencycode),1,@len_agencycode - DATALENGTH(@cod_department))

-- Tabella di output
CREATE TABLE #trace
(
    y int,
    n int,
    ndoc int,
    nrow int,
    out_str varchar(2193) COLLATE SQL_Latin1_General_CP1_CI_AS
)

DECLARE @expenseregphase    tinyint
SELECT @expenseregphase = expenseregphase FROM  uniconfig

-- Tabella dei pagamenti
CREATE TABLE #payment
(
    ypaymenttransmission int,
    npaymenttransmission int,
    ydoc int,
    ndoc int,
    ndocformatted varchar(7),
    idexp int,
    curramount decimal(19,2),
    idreg int,
    expense_adate datetime,
    payment_adate datetime,
    transmissiondate datetime,
    idpay int,
    idpaymethodTRS varchar(10),
    desc_paymethod varchar(30),
    ABI varchar(5),
    CAB varchar(5),
    cc varchar(30), -- Viene impostato a 25 in quanto gli utenti possono adoperare un C/C che eccede tale lunghezza. Corretto a 30 perchè in expenselast vale 30.
    cin char(1),
    iban varchar(50),
    title_ben varchar(140),
    address_ben varchar(30),
    cap_ben varchar(5),
    location_ben varchar(30),
    province_ben varchar(2),
    pi_ben varchar(11),
    pi_ben_estera varchar(15),
    cf_ben varchar(16),
    stamp_charge char(1),
    free_stamp char(1),
    paymentdescr varchar(370),
    fulfilled char(1),
    uncharged char(1),
    iddeputy int,
    title_bank varchar(100),
    paymenthodistructions varchar(150),
    refexternaldoc char(1),
    nbill int,
    doc_docdate varchar(50),
    committeecode varchar(5),
    committeeamount decimal(19,2),
    extracode varchar(7),
    biccode varchar(20),
    foreign_cc varchar(30),
    flag_sepa char(1),
    flag_foreign_transfer char(1),
    cu varchar(20),
    codefin varchar(50),
    CR varchar(10),
    CUP varchar(15),
    cupcodefin varchar(15),
    cupcodeupb varchar(15),
    cupcodedetail varchar(15),
    cupcodeexpense varchar(15),
    CIG varchar(10),
    cigcodeexpense varchar(10),
    cigcodemandate varchar(10),
    txt varchar(200),-- E' il campo txt di payment che finirà, insieme ad altri, nel record DM delle note
    info_fatture varchar(750),
    bank_charges_exempt char(1),
    fincodefin    varchar(50), fintitle varchar(150),
    nlevel tinyint, finlevel varchar(50)
)

-- Tabella per il delegato
CREATE TABLE #deputy
(
    iddeputy int,
    title_deputy varchar(140),
    address_deputy varchar(30),
    cap_deputy varchar(5),
    location_deputy varchar(30),
    province_deputy varchar(2),
    cf_deputy varchar(16)
)

-- Tabella delle trattenute
CREATE TABLE #tax
(
    ypaymenttransmission int,
    npaymenttransmission int,
    ydoc int,
    ndoc int,
    ndocformatted varchar(7),
    idpay int,
    idexp int,
    idinc int,
    ymov_income int,
    nmov_income int,
    ypro int,
    npro int,
    nproformatted varchar(7),
    yproceedstransmission int,
    curramount decimal(19,2),
    idpro int,
    idreg int,
    autokind varchar(5)
)

-- Tabella delle trattenute a carico dell'ente
-- se la configurazione dei contributi prevede un automatismo di spesa e uno di entrata su partita di giro
-- per gli automatismi dei contributi trasmetto anche la reversale del corrispondente automatismo di entrata
CREATE TABLE #admintax
(
	ypaymenttransmission int,
	npaymenttransmission int,
	ydoc int,
	ndoc int,
	ndocformatted varchar(7),
	idpay int,
	idexp int,
	idinc int,
	ymov_income int,
	nmov_income int,
	ypro int,
	npro int,
	nproformatted varchar(7),
	yproceedstransmission int,
	curramount decimal(19,2),
	idpro int,
	idreg int,
	autokind varchar(5)
)

-- Tabella incassi da regolarizzare al netto delle spese accessorie
-- inserisco qui gli incassi a regolarizzazione collegati alle spese da trasmettere, di importo superiore alla spesa stessa
-- da suddividere in due tranches, la prima a regolarizzazione di importo pari al netto e scollegata dalla spesa
-- e la seconda tranche (collegata alla spesa da trasmettere, di importo pari al residuo)

CREATE TABLE #pendingincome
(
	ypaymenttransmission int,
	npaymenttransmission int,
	ydoc int,
	ndoc int,
	ndocformatted varchar(7),
	idpay int,
	idexp int,
	idinc int,
	ymov_income int,
	nmov_income int,
	ypro int,
	npro int,
	nproformatted varchar(7),
	yproceedstransmission int,
	curramount decimal(19,2),
	curramount_expense decimal(19,2),
	idpro int,
	idreg int,
	autokind varchar(5)
)

-- Tabella della classificazione SIOPE
CREATE TABLE #siope
(
    ypaymenttransmission int,
    npaymenttransmission int,
    ydoc int,
    ndoc int,
    ndocformatted varchar(7),
    idpay int,
    sortcode varchar(30),
    descr_sorting varchar(60),
    amount decimal(19,2),
    idexp int,
    cupcodefin varchar(15),
    cupcodeupb varchar(15),
    cupcodedetail varchar(15),
    cupcodeexpense varchar(15)
)

-- Tabella delle informazioni aggiuntive richieste dall'Ente
CREATE TABLE #note
(
    ypaymenttransmission int,
    npaymenttransmission int,
    ydoc int,
    ndoc int,
    ndocformatted varchar(7),
    idpay int,
    nome_campo varchar(30),
    testo varchar(200)
)



-- Inserimento dei movimenti di spesa presenti nella distinta di trasmissione
INSERT INTO #payment
(
    ypaymenttransmission, npaymenttransmission, ydoc, ndoc, idexp,curramount,
    idreg, expense_adate, payment_adate, transmissiondate, stamp_charge, free_stamp,
    idpaymethodTRS, desc_paymethod, ABI, CAB, cc, cin, iban,
    title_ben, cf_ben, pi_ben, pi_ben_estera, paymentdescr, doc_docdate, fulfilled, uncharged ,iddeputy, title_bank,
    paymenthodistructions, refexternaldoc, nbill, idpay,
    committeecode,committeeamount, extracode, biccode,foreign_cc,
    flag_sepa,flag_foreign_transfer,
    cu, codefin, CR,cupcodefin,cupcodeupb,cupcodeexpense, cigcodeexpense,
    txt,     fincodefin     , fintitle ,
    nlevel  , finlevel
)
SELECT
    t.ypaymenttransmission, t.npaymenttransmission, d.ypay, d.npay, s.idexp, i.curramount,
    s.idreg, s.adate, d.adate, t.transmissiondate,
    CASE
        WHEN DATALENGTH(ISNULL(tb.handlingbankcode,'')) <= @len_idstamphandling
        THEN ISNULL(tb.handlingbankcode,'') + SPACE(@len_idstamphandling - DATALENGTH(ISNULL(tb.handlingbankcode,'')))
        ELSE SUBSTRING(tb.handlingbankcode,1,@len_idstamphandling)
    END,
    CASE
        WHEN ISNULL(tb.handlingbankcode,' ') IN (' ','') THEN 'S'
        ELSE 'N'
    END,
  	CASE  
		when  m.methodbankcode is not null THEN  m.methodbankcode 
		else   '51' -- CASSA
	End,
    CASE
        WHEN DATALENGTH(ISNULL(m.description,'')) <= @len_desc_paymethod
        THEN ISNULL(m.description,'') + SUBSTRING(SPACE(@len_desc_paymethod),1,@len_desc_paymethod - DATALENGTH(ISNULL(m.description,'')))
        ELSE SUBSTRING(m.description,1, @len_desc_paymethod)
    END,
    CASE
        WHEN DATALENGTH(ISNULL(el.idbank,'')) <= @len_ABI
        THEN SUBSTRING(REPLICATE('0',@len_ABI),1,@len_ABI - DATALENGTH(ISNULL(el.idbank,''))) + ISNULL(el.idbank,'')
        ELSE SUBSTRING(el.idbank,1,@len_ABI)
    END,
    CASE
        WHEN DATALENGTH(ISNULL(el.idcab,'')) <= @len_CAB
        THEN SUBSTRING(REPLICATE('0',@len_CAB),1,@len_CAB - DATALENGTH(ISNULL(el.idcab,''))) + ISNULL(el.idcab,'')
        ELSE SUBSTRING(el.idcab,1,@len_CAB)
    END,
    ISNULL(el.cc,''),
    CASE
        WHEN DATALENGTH(ISNULL(el.cin,'')) <= @len_cin
        THEN ISNULL(el.cin,'') + SPACE(@len_cin - DATALENGTH(ISNULL(el.cin,'')))
        ELSE SUBSTRING(el.cin,1,@len_cin)
    END,
    CASE
        WHEN DATALENGTH(ISNULL(ISNULL(el.iban,mcd.iban),'')) <= @leniban
        THEN ISNULL(ISNULL(el.iban,mcd.iban),'') + SPACE(@leniban - DATALENGTH(ISNULL(ISNULL(el.iban,mcd.iban),'')))
        ELSE SUBSTRING(ISNULL(el.iban,mcd.iban),1,@leniban)
    END,
    ISNULL(c.title,'') + SUBSTRING(SPACE(@len_registry_title),1,@len_registry_title - DATALENGTH(ISNULL(c.title,''))),
    CASE
        WHEN ctc.flaghuman = 'S' AND cf IS NOT NULL
        THEN c.cf + SUBSTRING(SPACE(@len_cf),1,@len_cf - DATALENGTH(c.cf))
        WHEN ctc.flaghuman = 'S' AND c.cf IS NULL
        THEN REPLICATE('9',@len_cf)
        ELSE SPACE(@len_cf)
    END,
-- Partita Iva
    CASE
        WHEN ctc.flaghuman = 'N' AND isnull(c.p_iva,c.cf) IS NOT NULL AND ASCII(SUBSTRING(isnull(c.p_iva,c.cf),1,1)) NOT BETWEEN 48 AND 57
        THEN REPLICATE('9',@len_pi) ---> Se estera la valorizziamo con undici cifre uguali a 9.
        WHEN ctc.flaghuman = 'N' AND isnull(c.p_iva,c.cf) IS NOT NULL       AND DATALENGTH(isnull(c.p_iva,c.cf)) <= @len_pi
        THEN SUBSTRING(REPLICATE('0',@len_pi),1,@len_pi
            - ISNULL(DATALENGTH(SUBSTRING(ISNULL(isnull(c.p_iva,c.cf),''),1,@len_pi)),0))
            + SUBSTRING(isnull(isnull(c.p_iva,c.cf),''),1,@len_pi)
        WHEN ctc.flaghuman = 'N' AND isnull(c.p_iva,c.cf) IS NOT NULL      AND DATALENGTH(isnull(c.p_iva,c.cf)) > @len_pi
        THEN SUBSTRING(isnull(c.p_iva,c.cf), 1, @len_pi)
        ELSE REPLICATE('0',@len_pi)
    END,
-- Partita Iva estera
    CASE
        WHEN ctc.flaghuman = 'N' AND c.p_iva IS NOT NULL AND ASCII(SUBSTRING(c.p_iva,1,1)) NOT BETWEEN 48 AND 57
        -- Se è straniera la copiamo tale e quale. Quando verrrà inserita nel Record MP verrà interrogata nuovamente.      
        THEN SUBSTRING(c.p_iva,1,@len_pi_estera)
        ELSE NULL
    END,
-- paymentdescr:
/*    ISNULL(s.doc,'') + ISNULL(CONVERT(varchar(12),s.docdate),'') + ISNULL(s.description,'') +
    SUBSTRING(SPACE(@len_desc_payment),1,@len_desc_payment -
    DATALENGTH(ISNULL(s.doc,'') + ISNULL(CONVERT(varchar(12),s.docdate),'') + ISNULL(s.description,''))),
*/
    ISNULL(s.doc,'') + ISNULL(CONVERT(varchar(12),s.docdate),'') + ISNULL(s.description,'') ,
    ISNULL(s.doc,'') + ISNULL(CONVERT(varchar(12), s.docdate),''),
    CASE -- fullfilled
        when (( el.flag & 1)=1) then 'S'
        else 'N'
    End,
    CASE ---- uncharged
        WHEN (( el.flag & 8)<>0) then 'S'
        ELSE 'N'
    END,
    CASE
        WHEN m.allowdeputy = 'S' THEN el.iddeputy -- Codice Mod. Banca 01
        ELSE NULL
    END,
    ISNULL(bank.description,'')
    + SUBSTRING(SPACE(@len_bank_title),1,@len_bank_title - DATALENGTH(ISNULL(bank.description,''))),
    -- paymenthodistructions
    ISNULL(el.paymentdescr,''),  
    ISNULL(el.refexternaldoc,''),
    -- ISNULL(REPLICATE('0', 7-DATALENGTH(CONVERT(varchar(7),el.nbill))) + CONVERT(varchar(7),el.nbill),REPLICATE('0',7)),
    ISNULL(REPLICATE('0', 7-DATALENGTH(CONVERT(varchar(7),el.nbill))) + CONVERT(varchar(7),el.nbill),REPLICATE('0',7)),
    el.idpay,
    ISNULL(REPLACE(m.committeecode,' ',''),''),  
    ISNULL(m.committeeamount,0),
    CASE
    WHEN DATALENGTH(ISNULL(ISNULL(el.extracode,mcd.extracode),'')) <= @lencodicecontabilitaspeciale
    THEN SUBSTRING(REPLICATE('0',@lencodicecontabilitaspeciale),1,@lencodicecontabilitaspeciale - DATALENGTH(ISNULL(ISNULL(el.extracode,mcd.extracode),''))) + ISNULL(ISNULL(el.extracode,mcd.extracode),'')
    ELSE SUBSTRING(ISNULL(el.extracode,mcd.extracode),1,@lencodicecontabilitaspeciale)
    END    ,
    CASE
        WHEN DATALENGTH(ISNULL(ISNULL(el.biccode,mcd.biccode),'')) <= @lenbic_swift_code
        THEN ISNULL(ISNULL(el.biccode,mcd.biccode),'') + SPACE(@lenbic_swift_code - DATALENGTH(ISNULL(ISNULL(el.biccode,mcd.biccode),'')))
        ELSE SUBSTRING(ISNULL(el.biccode,mcd.biccode),1,@lenbic_swift_code)
    END,
    CASE
        WHEN DATALENGTH(ISNULL(ISNULL(el.cc,mcd.cc),'')) <= @lenforeign_cc
        THEN ISNULL(ISNULL(el.cc,mcd.cc),'') + SPACE(@lenforeign_cc - DATALENGTH(ISNULL(ISNULL(el.cc,mcd.cc),'')))
        ELSE SUBSTRING(ISNULL(el.cc,mcd.cc),1,@lenforeign_cc)
    END,
    CASE ---- flag_sepa
        WHEN (( el.paymethod_flag & 8192)<>0) then 'S'
        ELSE 'N'
    END,
    CASE ---- flag_foreign_transfer
        WHEN (( el.paymethod_flag & 16384)<>0) then 'S'
        ELSE 'N'
    END,
    CASE
        WHEN DATALENGTH(ISNULL(d.cu,'')) <= @len_codiceoperatore
        THEN ISNULL(d.cu,'') + SPACE(@len_codiceoperatore - DATALENGTH(ISNULL(d.cu, '')))
        ELSE SUBSTRING(d.cu, 1, @len_codiceoperatore)
    END,
    '0000000',
    CASE
        WHEN ((d.flag&1)<> 0) THEN 'Competenza'
        WHEN ((d.flag&2)<> 0) THEN '   Residuo'
        WHEN ((d.flag&4)<> 0) THEN REPLICATE(' ',10)
    END,
    finlast.cupcode,
    u.cupcode,
    RegPhase.cupcode,
    RegPhase.cigcode,
    ltrim(rtrim(substring(d.txt, 1, 200))),
    fin.codefin     , fin.title ,
    fin.nlevel  , finlevel.description
FROM expense s
JOIN expenselast el
    ON S.idexp = el.idexp
JOIN expensetotal i
    ON i.idexp = s.idexp
JOIN expenseyear y
    ON y.idexp = s.idexp
JOIN fin
    ON fin.idfin = y.idfin
JOIN finlevel
    ON fin.nlevel = finlevel.nlevel
    AND finlevel.ayear = y.ayear
JOIN payment d
    ON d.kpay = el.kpay
JOIN paymenttransmission t
    ON t.kpaymenttransmission = d.kpaymenttransmission
LEFT OUTER JOIN paymethod m
    ON el.idpaymethod = m.idpaymethod
JOIN expenselink as RegPhaseELK    -- Dobbiamo risalire alla fase del creditore per recuperare CUP e CIG
    ON RegPhaseELK.idchild = el.idexp
    AND RegPhaseELK.nlevel = @expenseregphase
JOIN expense RegPhase            -- fase del Creditore
    ON RegPhase.idexp = RegPhaseELK.idparent
LEFT OUTER JOIN registrypaymethod mcd
    ON mcd.idregistrypaymethod = el.idregistrypaymethod
    AND mcd.idreg = s.idreg
JOIN registry c
    ON c.idreg = s.idreg
JOIN registryclass ctc
    ON ctc.idregistryclass = c.idregistryclass
LEFT OUTER JOIN bank
    ON bank.idbank = el.idbank
LEFT OUTER JOIN stamphandling tb
    ON d.idstamphandling = tb.idstamphandling
LEFT OUTER JOIN fin f
    ON d.idfin = f.idfin
JOIN upb u
    ON u.idupb = y.idupb
JOIN fin f1
    ON f1.idfin = y.idfin
JOIN finlast
    ON finlast.idfin = f1.idfin
WHERE t.ypaymenttransmission = @y
    AND t.npaymenttransmission = @n
  
--SELECT * FROM #payment

declare @fasecontrattopassivo int
select @fasecontrattopassivo = expensephase from config where ayear=@y

DECLARE @max_count_idpay int
SET @max_count_idpay   = 500

INSERT INTO #error (message)
SELECT 'Il mandato di pagamento n° ' + CONVERT(varchar(6),p.ndoc) + '/' + CONVERT(varchar(4),p.ydoc)
+ ' contiene un numero di beneficiari superiore a '  + CONVERT(varchar(4),@max_count_idpay)
+ ' Si consiglia di controllare i pagamenti contenuti nel mandato.'
FROM #payment p
GROUP BY p.ydoc, p.ndoc
HAVING COUNT(p.idpay) > @max_count_idpay


IF (SELECT COUNT(*) FROM #error) > 0
BEGIN
    SELECT * FROM #error
    RETURN
END

-- Valorizza codice cup da eventuali -----
-- contabilizzazioni di dettagli ordine --
UPDATE #payment SET cupcodedetail =
       (SELECT MAX(cupcode )
          FROM mandatedetail
         WHERE (idexp_taxable IN (SELECT idparent
                                    FROM expenselink
                                   WHERE idchild = #payment.idexp and nlevel=@fasecontrattopassivo)
            OR idexp_iva IN (SELECT idparent
                               FROM expenselink
                              WHERE idchild = #payment.idexp and nlevel=@fasecontrattopassivo))
           AND cupcode IS NOT NULL)
where cupcodeexpense is null

-- Valorizza il codice CGI eventualmente presente del contratto passivo
UPDATE #payment SET cigcodemandate =
       (SELECT MAX(mandate.cigcode )
            FROM mandate
            JOIN mandatedetail
                ON    mandate.idmankind = mandatedetail.idmankind
                AND mandate.yman = mandatedetail.yman
                AND mandate.nman = mandatedetail.nman
         WHERE (mandatedetail.idexp_taxable IN (SELECT idparent
                                    FROM expenselink
                                   WHERE idchild = #payment.idexp and nlevel=@fasecontrattopassivo)
            OR mandatedetail.idexp_iva IN (SELECT idparent
                               FROM expenselink
                              WHERE idchild = #payment.idexp and nlevel=@fasecontrattopassivo))
         )
where cigcodeexpense is null

-- Valorizza il codice CIG eventualmente presente nella fattura
UPDATE #payment SET cigcodemandate = 
	   (SELECT MAX( invoicedetail.cigcode )
			FROM invoicedetail 
		WHERE (invoicedetail.idexp_taxable = #payment.idexp
				OR invoicedetail.idexp_iva = #payment.idexp)
		)
where cigcodeexpense is null and cigcodemandate is null		 


-- Valorizzo il carico commissioni e spese solo una volta per i bonifici. Se nel presente elenco
-- quel percipiente compare più di una volta, prendo il pagamento a importo massimo. In tutti gli altri casi
-- se si tratta di bonifico, specifico l'esenzione, per gli altri casi, non valorizzo nessun campo del flusso
-- in modo che si applichi la convenzione di tesoreria

-- BONIFICI
UPDATE #payment SET bank_charges_exempt  = 'N'
WHERE  ISNULL(#payment.curramount,0) =  (SELECT MAX(curramount) FROM #payment B
WHERE  B.idreg = #payment.idreg AND ISNULL(B.committeecode,'') = ISNULL(#payment.committeecode,'') -- a parità di modalità carico commissioni
AND  B.idpaymethodTRS = #payment.idpaymethodTRS )
AND    #payment.idexp = (SELECT top 1 idexp FROM #payment C
WHERE  C.idreg = #payment.idreg AND ISNULL(C.committeecode,'') = ISNULL(#payment.committeecode,'')
AND    C.idpaymethodTRS = #payment.idpaymethodTRS 
AND    C.curramount =  ISNULL(#payment.curramount,0) ORDER BY C.ndoc,C.idpay)
AND    #payment.idpaymethodTRS  = '53' -- solo per bonifici, specifica
-- l'applicazione di   SPESE e COMMISSIONI bancarie nei casi previsti

UPDATE #payment SET bank_charges_exempt  = 'S' WHERE bank_charges_exempt IS NULL --
AND    #payment.idpaymethodTRS  = '53' -- solo per bonifici, specifica l'esenzione da SPESE e COMMISSIONI bancarie,
-- indipendentemente dalla convenzione di Tesoreria

UPDATE #payment SET bank_charges_exempt  = 'C' WHERE bank_charges_exempt IS NULL --
AND    #payment.idpaymethodTRS  <> '53' -- per tutte le altre modalità di pagamento,
-- specifica l'applicazione della normale convenzione di Tesoreria

UPDATE #payment SET CIG = ISNULL(cigcodeexpense,ISNULL(cigcodemandate,''))  --Codice CIG
UPDATE #payment SET CUP = ISNULL(cupcodeexpense,ISNULL(cupcodedetail, ISNULL(cupcodeupb, ISNULL(cupcodefin,'')))) --Codice CUP


DECLARE @ydoc  INT 
DECLARE @ndoc  INT
DECLARE @idpay INT

DECLARE @info_fatture varchar(2000)
DECLARE rowcursor INSENSITIVE CURSOR FOR
SELECT  ydoc,ndoc, idpay
FROM    #payment
 
ORDER BY   ydoc,ndoc, idpay asc
FOR READ ONLY
OPEN rowcursor
FETCH NEXT FROM rowcursor
INTO @ydoc, @ndoc, @idpay
WHILE @@FETCH_STATUS = 0
BEGIN
    SET @info_fatture = ''
    SELECT     @info_fatture =
            @info_fatture + isnull (expenselastview.doc,'') + ' del ' + convert(varchar(20), expenselastview.docdate,105) + '; '
            FROM    expenselastview
            JOIN    expenseinvoice
            ON        expenselastview.idexp = expenseinvoice.idexp
            WHERE   expenselastview.ypay = @ydoc
            AND     expenselastview.npay = @ndoc
            AND     expenselastview.idpay = @idpay

            UPDATE  #payment SET info_fatture = SUBSTRING(@info_fatture,1,750)
            WHERE   #payment.ydoc  = @ydoc
            AND     #payment.ndoc  = @ndoc
            AND     #payment.idpay = @idpay

    FETCH NEXT FROM rowcursor
    INTO @ydoc, @ndoc,@idpay
END
DEALLOCATE rowcursor

--select info_fatture, * from #payment where  isnull(info_fatture, '') <> ''

-- Valorizza codice cup da eventuali -----
-- contabilizzazioni di dettagli ordine --
UPDATE #payment SET info_fatture =
       (SELECT MAX(cupcode )
          FROM mandatedetail
         WHERE (idexp_taxable IN (SELECT idparent
                                    FROM expenselink
                                   WHERE idchild = #payment.idexp and nlevel=@fasecontrattopassivo)
            OR idexp_iva IN (SELECT idparent
                               FROM expenselink
                              WHERE idchild = #payment.idexp and nlevel=@fasecontrattopassivo))
           AND cupcode IS NOT NULL)
where cupcodeexpense is null


INSERT INTO #error (message)
SELECT DISTINCT 'Il mandato di pagamento n° ' + CONVERT(varchar(6),p.ndoc) + '/' + CONVERT(varchar(4),p.ydoc)
+ ' contiene il pagamento '
+ CONVERT(varchar(6),e.nmov) + '/' + CONVERT(varchar(4),e.ymov)  + ' raggruppato con altri '
+ ' che tuttavia sono ora distinguibili per il CIG o il CUP. '
+ ' Si consiglia di controllare i codici CIG e CUP assegnati e di salvare nuovamente il mandato per correggere l''errore. '
FROM #payment p
JOIN #payment p2
    ON  p.ydoc = p2.ydoc
    AND p.ndoc = p2.ndoc
    AND p.idpay = p2.idpay
JOIN expenseview e on  p.idexp = e.idexp
WHERE  (isnull(p.CIG,'') <> isnull(p2.CIG,'') )
      OR
       (isnull(p.CUP,'') <> isnull(p2.CUP,'') )
 
-- Valorizza codice di bilancio --
DECLARE @len_codifica_bilancio int
SET @len_codifica_bilancio = 7

DECLARE @minoplevel tinyint

SELECT  @minoplevel = min(nlevel)
FROM     finlevel
WHERE     ayear = @y and flag&2 <> 0

DECLARE @lencod_lev int
SET  @lencod_lev = (SELECT  SUM (flag / 256)
                FROM finlevel
                WHERE ayear = @y AND     nlevel <= @minoplevel )

IF ( @lencod_lev <= 7 )
BEGIN
    UPDATE #payment SET codefin = SUBSTRING(REPLICATE('0',@len_codifica_bilancio),1,@len_codifica_bilancio - DATALENGTH(CONVERT(varchar(7),codefin))) + CONVERT(varchar(7),codefin)
END
ELSE
BEGIN
    UPDATE #payment SET codefin = REPLICATE('0',@len_codifica_bilancio)
END

-- Se il codice di bilancio non è un numerico compatibile lo pone a 0
UPDATE #payment SET codefin = REPLICATE('0',@len_codifica_bilancio) WHERE ( ISNUMERIC(ISNULL(codefin,'')) <> 1 )

----------------------------------------------------------------

-- Inizio Formattazione del C/C  
-- Unicredit ammette come C/C numeri e caratteri maiuscoli, il C/C deve essere allineato a destra, carattere di padding lo 0
UPDATE #payment
SET cc =
    UPPER(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(
    REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(cc,',',''),'.',''),'_',''),'-',''),'*',''),'+',''),
    '/',''),':',''),';',''),' ',''))

UPDATE #payment SET cc = REPLICATE('0',@len_cc - DATALENGTH(ISNULL(cc,''))) + ISNULL(cc,'')
-- Fine Formattazione del C/C

-- Calcolo del campo ndocformatted
UPDATE #payment
SET ndocformatted =
SUBSTRING(REPLICATE('0',@len_ndoc),1,@len_ndoc - DATALENGTH(CONVERT(varchar(7),ndoc))) + CONVERT(varchar(7),ndoc)

DECLARE @maxincomephase char(1)
SELECT @maxincomephase = MAX(nphase) FROM incomephase


-- CONTROLLO N. 13 Controllo che i movimenti di entrata associati ai movimenti di spesa che stiamo trasmettendo siano stati inseriti
-- in una distinta di trasmissione
INSERT INTO #error (message)
SELECT 'Il movimento di entrata ' + CONVERT(varchar(6),I.nmov) + '/' + CONVERT(varchar(4),I.ymov)
+ ' associato al movimento di spesa ' + CONVERT(varchar(6),E.nmov) + '/' + CONVERT(varchar(4),E.nmov)
+ ' non è stato inserito in una distinta di trasmissione'
FROM #payment P
JOIN income I
    ON I.idpayment = P.idexp  
JOIN expense E
    ON P.idexp = E.idexp
JOIN incomelast IL
    ON I.idinc = il.idinc
JOIN incometotal IT
    ON I.idinc = IT.idinc
LEFT OUTER JOIN proceeds S
    ON S.kpro = IL.kpro
LEFT OUTER JOIN proceedstransmission T
    ON S.kproceedstransmission = T.kproceedstransmission
WHERE I.nphase = @maxincomephase
    AND ((I.autokind = 6) /* <--Recupero*/    OR (I.autokind = 14) /*<--automatismo generico*/OR (I.autokind = 4 AND I.idreg = P.idreg)/*<--Ritenuta*/
		 OR (I.autokind in (20,21,30,31) AND I.idreg = P.idreg AND @csa_flagtransmissionlinking = 'S'))
    AND IT.ayear = @y
    AND T.yproceedstransmission IS NULL

----  Controllo sui pagamenti a netto zero
--INSERT INTO #error (message)
--SELECT 'Il mandato di pagamento n° ' + CONVERT(varchar(6),p.ndoc) + '/' + CONVERT(varchar(4),p.ydoc)
--+ ' contiene il pagamento per cassa interno n° ' + CONVERT(varchar(6),e.nmov) + '/' + CONVERT(varchar(4),e.ymov)
--+ ' che però non è collegato a incassi di pari importo. '
--+ ' Si consiglia di controllare i sub - movimenti del mandato e delle reversali collegate.'
--FROM #payment p
--join expenseview e on  p.idexp = e.idexp
--WHERE ISNULL(p.idpaymethodTRS,'') = '71' -- pagamento per cassa interno a netto zero
--AND EXISTS (SELECT * FROM
--      proceeds_bank
--      JOIN incomelast
--        ON  proceeds_bank.kpro =  incomelast.kpro
--        AND proceeds_bank.idpro = incomelast.idpro
--      JOIN income   ON income.idinc = incomelast.idinc
--      WHERE income.idpayment =  p.idexp
--      AND income.idreg =  p.idreg
--AND ISNULL(proceeds_bank.amount,0) <>
--(SELECT ISNULL( payment_bank.amount,0)
--FROM payment_bank
--      WHERE idpay = p.idpay
--      AND kpay =  e.kpay))

--IF (SELECT COUNT(*) FROM #error) > 0
--BEGIN
--    SELECT * FROM #error
--    RETURN
--END


-- Inserimento delle trattenute (vengono inseriti recuperi e ritenute, quest'ultime solo dipendenti)
INSERT INTO #tax
(
    ypaymenttransmission, npaymenttransmission, ydoc, ndoc, ndocformatted, idpay,
    idexp, idinc, ypro, npro, yproceedstransmission, curramount, idreg, autokind,
    ymov_income, nmov_income, idpro
)
SELECT
    p.ypaymenttransmission, p.npaymenttransmission, p.ydoc, p.ndoc, p.ndocformatted, p.idpay,
    p.idexp, e.idinc, di.ypro, di.npro, proceedstransmission.yproceedstransmission,
    ie.curramount, e.idreg, e.autokind, e.ymov, e.nmov, il.idpro
FROM #payment p
JOIN income e
    ON e.idpayment = p.idexp  
JOIN incomelast il
    ON e.idinc = il.idinc
JOIN incometotal ie
    ON e.idinc = ie.idinc
JOIN proceeds di
    ON di.kpro = il.kpro
JOIN proceedstransmission
    ON di.kproceedstransmission = proceedstransmission.kproceedstransmission
WHERE e.nphase = @maxincomephase
    AND ((e.autokind = 6) -- Recupero
    OR (e.autokind = 14) --automatismo generico
    OR (e.autokind = 4 AND e.idreg = p.idreg) -- Ritenuta
	OR (e.autokind in (20,21,30,31) AND e.idreg = p.idreg AND @csa_flagtransmissionlinking = 'S' )) -- AUTOMATISMI DA CSA
    AND ie.ayear = @y

-- L'incasso reale sarà suddiviso in due tranches, uno di importo parti al sospeso e non collegato alla spesa
-- l'altro sarà un incasso virtuale  collegato alla spesa (in modo da ottenere complessivamente saldo zero ) e con idpro
-- fittizio pari a 2 (obblighiamo a fare le reversali singole in tali casi)
INSERT INTO #pendingincome
(
	ypaymenttransmission, npaymenttransmission, ydoc, ndoc, idpay,
	idexp, idinc, ypro, npro, yproceedstransmission, curramount, curramount_expense, idreg, autokind,
	ymov_income, nmov_income, idpro, ndocformatted
)
SELECT
	p.ypaymenttransmission, p.npaymenttransmission, p.ydoc, p.ndoc, p.idpay,
	p.idexp, e.idinc, di.ypro, di.npro, proceedstransmission.yproceedstransmission,
	ie.curramount, p.curramount, e.idreg, e.autokind, e.ymov, e.nmov, il.idpro, p.ndocformatted
FROM #payment p
JOIN income e
	ON e.idpayment = p.idexp	
JOIN incomelast il
	ON e.idinc = il.idinc
JOIN incometotal ie
	ON e.idinc = ie.idinc
JOIN proceeds di
	ON di.kpro = il.kpro
JOIN proceedstransmission
	ON di.kproceedstransmission = proceedstransmission.kproceedstransmission
WHERE e.nphase = @maxincomephase 	
AND (e.autokind = 28 AND e.idreg = p.idreg) -- Incasso da regolarizzare con spesa accessoria e sospeso pari al netto
AND ie.ayear = @y
AND (il.flag&32 <> 0)
 

DECLARE @max_count_tax int
SET @max_count_tax = 30

--INSERT INTO #error (message)
--SELECT 'Il mandato di pagamento n° ' + CONVERT(varchar(6),t.ndoc) + '/' + CONVERT(varchar(4),t.ydoc)
--+ ' è collegato a un numero di ritenute superiore a ' + CONVERT(varchar(4),@max_count_tax)
--+ ' Si consiglia di controllare i pagamenti contenuti nel mandato e le reversali collegate.'
--FROM #tax t
--GROUP BY t.ydoc, t.ndoc
--HAVING COUNT(idpro) > @max_count_tax

IF (SELECT COUNT(*) FROM #error) > 0
BEGIN
    SELECT * FROM #error
    RETURN
END

-- se il pagamento principale, sottraendo le reversali delle ritenute associate ha un netto pari a zero,
-- la modalità di pagamento del mandato deve essere cambiata in pagamento interno 71

--UPDATE #payment SET idpaymethodTRS = '71' -- Pagamento per cassa interno
--WHERE  ISNULL(curramount,0) = ISNULL((SELECT SUM(curramount) FROM #tax WHERE #payment.idexp = #tax.idexp),0)

-- Valorizzazione del campo nproformatted
UPDATE #tax
SET nproformatted =
SUBSTRING(REPLICATE('0',@len_ndoc),1,@len_ndoc - DATALENGTH(CONVERT(varchar(7),npro))) +
CONVERT(varchar(7),npro)

-- Valorizzazione del campo nproformatted
UPDATE #pendingincome
SET nproformatted =
SUBSTRING(REPLICATE('0',@len_ndoc),1,@len_ndoc - DATALENGTH(CONVERT(varchar(7),npro))) +
CONVERT(varchar(7),npro)


-- Leggo configurazione dell'applicazione dei contributi 
DECLARE @admintaxkind int
SELECT  @admintaxkind = (automanagekind & 0xf) FROM config WHERE ayear = @y
 
-- Inserimento delle trattenute (vengono inseriti i contributi c/amministrazione)
INSERT INTO #admintax
(
	ypaymenttransmission, npaymenttransmission, ydoc, ndoc, ndocformatted, idpay,
	idexp, idinc, ypro, npro, yproceedstransmission, curramount, idreg, autokind,
	ymov_income, nmov_income, idpro
)
SELECT
	p.ypaymenttransmission, p.npaymenttransmission, p.ydoc, p.ndoc, p.ndocformatted, p.idpay,
	p.idexp, e.idinc, di.ypro, di.npro, proceedstransmission.yproceedstransmission,
	ie.curramount, e.idreg, e.autokind, e.ymov, e.nmov, il.idpro
FROM #payment p
JOIN expense s
	ON s.idexp = p.idexp
JOIN income e
	ON e.idpayment = s.idpayment	
JOIN incomelast il
	ON e.idinc = il.idinc
JOIN incometotal ie
	ON e.idinc = ie.idinc
JOIN proceeds di
	ON di.kpro = il.kpro
JOIN proceedstransmission
	ON di.kproceedstransmission = proceedstransmission.kproceedstransmission
WHERE e.nphase = @maxincomephase 
	AND e.autokind = 4 -- Contributo
	AND s.autokind = 4 
	AND s.autocode  = e.autocode
	AND p.idreg = e.idreg
	AND ie.ayear = @y
	AND @admintaxkind = 2 -- movimento di spesa sul capitolo di spesa o sul capitolo di liquidazione del contributo
	-- e movimento di entrata su partita di giro
	
-- Valorizzazione del campo nproformatted
UPDATE #admintax
SET nproformatted = 
SUBSTRING(REPLICATE('0',@len_ndoc),1,@len_ndoc - DATALENGTH(CONVERT(varchar(7),npro))) +
CONVERT(varchar(7),npro)


-- Riempimento della tabella del delegato
INSERT INTO #deputy (iddeputy, title_deputy, cf_deputy)
SELECT
    DISTINCT #payment.iddeputy,
    ISNULL(registry.title,'')
    + SUBSTRING(SPACE(@len_deputy),1,@len_deputy - DATALENGTH(ISNULL(registry.title,''))),
    ISNULL(registry.cf,SPACE(@len_cf))
FROM #payment
JOIN registry
    ON #payment.iddeputy = registry.idreg

-- Gestione Indirizzi Beneficiario / Delegato
DECLARE @codenostand varchar(20)
SET @codenostand = '07_SW_AVV'

DECLARE @codestand varchar(20)
SET @codestand = '07_SW_DEF'

DECLARE @STAND int
SELECT @STAND = idaddress FROM address WHERE codeaddress = @codestand

DECLARE @NOSTAND int
SELECT @NOSTAND = idaddress FROM address WHERE codeaddress = @codenostand

DECLARE @dateindi datetime
SET @dateindi = (SELECT transmissiondate FROM paymenttransmission WHERE ypaymenttransmission = @y AND npaymenttransmission = @n)

-- Tabella utilizzata per immagazzinare gli indirizzi dei creditori debitori che si trovano
-- nelle distinte di trasmissione da esportare
CREATE TABLE #address
(
    idaddresskind int,
    idreg int,
    address varchar(100),
    location varchar(116),
    cap varchar(15),
    province varchar(2),
    nation varchar(65)
)

INSERT INTO #address
(
    idaddresskind,
    idreg,
    address,
    location,
    cap,
    province,
    nation
)
SELECT
    idaddresskind,
    idreg,
    address,
    ISNULL(geo_city.title,'') + ' ' + ISNULL(registryaddress.location,'') ,
    registryaddress.cap,
    geo_country.province,
    CASE
        WHEN flagforeign = 'N' THEN 'ITALIA'
        ELSE geo_nation.title
    END
FROM registryaddress
LEFT OUTER JOIN geo_city
    ON geo_city.idcity = registryaddress.idcity
LEFT OUTER JOIN geo_country
    ON geo_city.idcountry = geo_country.idcountry
LEFT OUTER JOIN geo_nation
    ON geo_nation.idnation = registryaddress.idnation
WHERE
(registryaddress.active <>'N'
    AND registryaddress.start =
    (SELECT MAX(cdi.start)
    FROM registryaddress cdi
    WHERE cdi.idaddresskind = registryaddress.idaddresskind
        AND cdi.active <>'N'
        AND ((cdi.stop IS NULL) OR (cdi.stop >= @dateindi))
        AND cdi.idreg = registryaddress.idreg))
        AND
         (    (idreg IN (SELECT DISTINCT idreg FROM #payment))
            OR
            (idreg IN (SELECT DISTINCT iddeputy FROM #payment))
        )

DELETE #address
WHERE #address.idaddresskind <> @nostand
    AND EXISTS(
        SELECT * FROM #address r2
        WHERE #address.idreg = r2.idreg
            AND r2.idaddresskind = @nostand
    )

DELETE #address
WHERE #address.idaddresskind NOT IN (@nostand, @stand)
    AND EXISTS(
        SELECT * FROM #address r2
        WHERE #address.idreg = r2.idreg
            AND r2.idaddresskind = @stand
    )

DELETE #address
WHERE (
    SELECT COUNT(*) FROM #address r2
    WHERE #address.idreg = r2.idreg
)>1

-- CONTROLLO N. 10 Ogni beneficiario deve avere un indirizzo associato
IF EXISTS(
    (SELECT * FROM #payment WHERE idreg NOT IN
        (SELECT DISTINCT idreg FROM #address ind)))
BEGIN
    INSERT INTO #error (message)
    (SELECT 'Il beneficiario ' + #payment.title_ben +
    + ' non ha un indirizzo valido associato '
    FROM #payment
    WHERE idreg NOT IN
        (SELECT DISTINCT idreg FROM #address ind)
    )
END


-- CONTROLLO N. 11 Ogni delegato deve avere un indirizzo associato
IF EXISTS(
    (SELECT * FROM #deputy WHERE iddeputy NOT IN
        (SELECT DISTINCT idreg FROM #address ind)))
BEGIN
    INSERT INTO #error (message)
    (SELECT 'Il delegato ' + #deputy.title_deputy +
    + ' non ha un indirizzo valido associato '
    FROM #deputy
    WHERE iddeputy NOT IN
        (SELECT DISTINCT idreg FROM #address ind)
    )
END

IF (SELECT COUNT(*) FROM #error) > 0
BEGIN
    SELECT * FROM #error
    RETURN
END

-- Unificazione descrizioni di pagamento per movimenti di spesa che sono stati accorpati
-- L'unificazione della descrizione è necessaria in quanto nella group by finale viene inserita anche la descrizione
UPDATE #payment
SET paymentdescr = 'ACCORPAMENTO PAGAMENTI' -- + SPACE(348) La formattazione l'ho postata alla fine, perchè deve scrivere anche il CUP e CIG, ponendoli come prima info del campo 'casuale pagamento'
WHERE
    (SELECT COUNT(*)
    FROM #payment p2
    WHERE p2.ypaymenttransmission = #payment.ypaymenttransmission
        AND p2.npaymenttransmission = #payment.npaymenttransmission
        AND p2.ydoc = #payment.ydoc
        AND p2.ndoc = #payment.ndoc
        AND p2.idpay = #payment.idpay) > 1
    AND
        (SELECT COUNT(*)
        FROM #payment p2
        WHERE p2.ypaymenttransmission = #payment.ypaymenttransmission
            AND p2.npaymenttransmission = #payment.npaymenttransmission
            AND p2.ydoc = #payment.ydoc
            AND p2.ndoc = #payment.ndoc
            AND p2.idpay = #payment.idpay) <>
        (SELECT COUNT(*)
        FROM #payment p2
        WHERE p2.ypaymenttransmission = #payment.ypaymenttransmission
            AND p2.npaymenttransmission = #payment.npaymenttransmission
            AND p2.ydoc = #payment.ydoc
            AND p2.ndoc = #payment.ndoc
            AND p2.idpay = #payment.idpay
            AND p2.paymentdescr = #payment.paymentdescr)

-- Aggiornamento dei dati inerenti l'indirizzo del beneficiario  

UPDATE #payment
SET address_ben =
    (SELECT
    CASE
        WHEN DATALENGTH(ISNULL(address,'')) <= @len_address
        THEN ISNULL(address,'') + SUBSTRING(SPACE(@len_address),1,@len_address - DATALENGTH(ISNULL(address,'')))
        ELSE SUBSTRING(address,1,@len_address)
    END
    FROM #address
    WHERE #payment.idreg = #address.idreg),
cap_ben =
    (SELECT
    CASE
        WHEN DATALENGTH(ISNULL(cap,'')) <= @len_cap
        THEN SUBSTRING(REPLICATE('0',@len_cap),1,@len_cap - DATALENGTH(ISNULL(cap,'')))
        + ISNULL(cap,'')
        ELSE SUBSTRING(cap,1,@len_cap)
    END
    FROM #address
    WHERE #payment.idreg = #address.idreg),
location_ben =
    (SELECT
    CASE
        WHEN DATALENGTH(ISNULL(location,'')) <= @len_location
        THEN ISNULL(location,'') + SUBSTRING(SPACE(@len_location),1,@len_location - DATALENGTH(ISNULL(location,'')))
        ELSE SUBSTRING(location,1,@len_location)
    END
    FROM #address
    WHERE #payment.idreg = #address.idreg),
province_ben =
    (SELECT
    CASE
        WHEN DATALENGTH(ISNULL(province,'')) <= @len_province
        THEN ISNULL(province,'') + SUBSTRING(SPACE(@len_province),1,@len_province - DATALENGTH(ISNULL(province,'')))
        ELSE SUBSTRING(province,1,@len_province)
    END
    FROM #address
    WHERE #payment.idreg = #address.idreg)

-- Aggiornamento dati indirizzo delegato
UPDATE #deputy
SET address_deputy =
    (SELECT
    CASE
        WHEN DATALENGTH(ISNULL(address,'')) <= @len_address
        THEN ISNULL(address,'') + SUBSTRING(SPACE(@len_address),1,@len_address - DATALENGTH(ISNULL(address,'')))
        ELSE SUBSTRING(address,1,@len_address)
    END
    FROM #address
    WHERE #deputy.iddeputy = #address.idreg),
cap_deputy =
    (SELECT
    CASE
        WHEN DATALENGTH(ISNULL(cap,'')) <= @len_cap
        THEN SUBSTRING(REPLICATE('0',@len_cap),1,@len_cap - DATALENGTH(ISNULL(cap,'')))
        + ISNULL(cap,'')
        ELSE SUBSTRING(cap,1,@len_cap)
    END
    FROM #address
    WHERE #deputy.iddeputy = #address.idreg),
location_deputy =
    (SELECT
    CASE
        WHEN DATALENGTH(ISNULL(location,'')) <= @len_location
        THEN ISNULL(location,'') + SUBSTRING(SPACE(@len_location),1,@len_location - DATALENGTH(ISNULL(location,'')))
        ELSE SUBSTRING(location,1,@len_location)
    END
    FROM #address
    WHERE #deputy.iddeputy = #address.idreg),
province_deputy =
    (SELECT
    CASE
        WHEN DATALENGTH(ISNULL(province,'')) <= @len_province
        THEN ISNULL(province,'') + SUBSTRING(SPACE(@len_province),1,@len_province - DATALENGTH(ISNULL(province,'')))
        ELSE SUBSTRING(province,1,@len_province)
    END
    FROM #address
    WHERE #deputy.iddeputy = #address.idreg)

-- Riempimento della tabella con i dati della classificazione SIOPE
DECLARE @npos int
DECLARE @codeclassSIOPE varchar(20)

SELECT  @codeclassSIOPE  =  
CASE  
	WHEN  (@y<= 2006) THEN  'SIOPE'
	WHEN  (@y BETWEEN 2007 AND 2017) THEN  '07U_SIOPE'
	ELSE   'SIOPE_U_18'
END

SELECT  @npos  =  
CASE  
	WHEN  (@y<= 2006) THEN  2
	WHEN  (@y BETWEEN 2007 AND 2017) THEN  1
	ELSE   1
END

DECLARE @classSIOPE int
SELECT @classSIOPE = idsorkind FROM sortingkind WHERE codesorkind = @codeclassSIOPE
-- Inserimento delle classificazioni SIOPE dei movimenti di spesa
INSERT INTO #siope
(
    ypaymenttransmission, npaymenttransmission, ydoc, ndoc, ndocformatted,
    idpay, sortcode, descr_sorting, amount,idexp, cupcodefin, cupcodeupb, cupcodedetail, cupcodeexpense
)
SELECT
    #payment.ypaymenttransmission, #payment.npaymenttransmission,
    #payment.ydoc, #payment.ndoc, #payment.ndocformatted,
    #payment.idpay, SUBSTRING(sorting.sortcode,@npos,DATALENGTH(sorting.sortcode)),
    SUBSTRING(sorting.description,1,@len_desc_sort), SUM(expensesorted.amount),
    #payment.idexp,#payment.cupcodefin,#payment.cupcodeupb, #payment.cupcodedetail, #payment.cupcodeexpense
FROM #payment
JOIN expensesorted
    ON #payment.idexp = expensesorted.idexp
JOIN sorting
    ON sorting.idsor = expensesorted.idsor
WHERE sorting.idsorkind = @classSIOPE
GROUP BY #payment.ypaymenttransmission, #payment.npaymenttransmission, #payment.ydoc,
    #payment.ndoc, #payment.ndocformatted,
    #payment.idpay, SUBSTRING(sorting.sortcode,@npos,DATALENGTH(sorting.sortcode)),
    SUBSTRING(sorting.description,1,@len_desc_sort),#payment.idexp,
    #payment.cupcodeexpense, #payment.cupcodedetail,#payment.cupcodeupb, #payment.cupcodefin

-- CONTROLLO N. 12 Il numero di classificazioni non può superare il limite massimo per ogni beneficiario
DECLARE @max_sort_number int
SET @max_sort_number = 30
INSERT INTO #error (message)
(SELECT 'Il mandato n. ' + CONVERT(varchar(6),ndoc) + '/' + CONVERT(varchar(4),ydoc)
+ ' contiene più di ' + CONVERT(varchar(2),@max_sort_number) + ' classificazioni SIOPE'
FROM #siope WHERE
    (SELECT COUNT(distinct s2.sortcode) FROM #siope s2
    WHERE s2.ypaymenttransmission = #siope.ypaymenttransmission
        AND s2.npaymenttransmission = #siope.npaymenttransmission
        AND s2.ydoc = #siope.ydoc
        AND s2.ndoc = #siope.ndoc
        AND s2.idpay = #siope.idpay)
> @max_sort_number)

IF (SELECT COUNT(*) FROM #error) > 0
BEGIN
    SELECT * FROM #error
    RETURN
END

-- Inserimento delle note per il record DM
--INSERT INTO #note (ypaymenttransmission, npaymenttransmission, ydoc, ndoc, ndocformatted, idpay, nome_campo, testo)
--SELECT  DISTINCT
--ypaymenttransmission,
--npaymenttransmission,
--ydoc,
--ndoc,
--ndocformatted,
--1,  -- lo valorizzo solo per il primo sub
--[dbo].getstringformatted_r('Note', 30),
--[dbo].getstringformatted_r(txt, 200)
--FROM #payment
--WHERE ltrim(rtrim(#payment.txt)) <> ''
--GROUP BY ypaymenttransmission, npaymenttransmission, ndoc, idpay,
--         ydoc, ndocformatted, txt

if (@cod_department = '9004000') -- SECONDA UNIVERSITà NAPOLI
BEGIN
	INSERT INTO #note (ypaymenttransmission, npaymenttransmission, ydoc, ndoc, ndocformatted, idpay, nome_campo, testo)
	SELECT
	ypaymenttransmission,
	npaymenttransmission,
	ydoc,
	ndoc,
	ndocformatted,
	idpay,
	[dbo].getstringformatted_r('Bilancio', 30),
	[dbo].getstringformatted_r(finlevel + ': ' + fincodefin + ' - ' + fintitle , 200)
	FROM #payment
	GROUP BY ypaymenttransmission, npaymenttransmission, ndoc, idpay,
			 ydoc, ndocformatted, finlevel, fincodefin, fintitle
END

-- Tabella delle informazioni aggiuntive richieste dall'Ente
 if (@cod_department = '9057001') --  'UNIVERSITA' CATANIA'
	BEGIN
	INSERT INTO #note (ypaymenttransmission, npaymenttransmission, ydoc, ndoc, ndocformatted, idpay, nome_campo, testo)
		SELECT
		ypaymenttransmission,
		npaymenttransmission,
		ydoc,
		ndoc,
		ndocformatted,
		1,
		[dbo].getstringformatted_r('Dipartimento/Struttura:', 30),
		[dbo].getstringformatted_r(@header, 200)
		FROM #payment
		GROUP BY ypaymenttransmission, npaymenttransmission, ndoc,
				 ydoc, ndocformatted
	
	END


         

-- Tabella delle bollette multiple
CREATE TABLE #expensebill
(
    ypaymenttransmission int,
    npaymenttransmission int,
    idexp int,
    ydoc int,
    ndoc int,
    idpay int,
    ybill int,
    nbill int,
    amount decimal(19,2)
)
-- Riempimento della tabella delle bollette

--  Bollette singole
INSERT INTO  #expensebill
(    ypaymenttransmission, npaymenttransmission, idexp,
    ydoc, ndoc, idpay, ybill,nbill, amount)
SELECT
    #payment.ypaymenttransmission, #payment.npaymenttransmission, #payment.idexp,
    #payment.ydoc, #payment.ndoc,
    #payment.idpay, #payment.ydoc, expenselast.nbill,   
    #payment.curramount            
FROM  #payment JOIN expenselast ON #payment.idexp = expenselast.idexp
WHERE   expenselast.nbill IS NOT NULL
 
  
 -- Bollette multiple
INSERT INTO  #expensebill
(    ypaymenttransmission, npaymenttransmission, idexp,
    ydoc, ndoc, idpay, ybill,nbill, amount)
SELECT
    #payment.ypaymenttransmission, #payment.npaymenttransmission,  #payment.idexp,  #payment.ydoc, #payment.ndoc,
    #payment.idpay, expensebill.ybill, expensebill.nbill, expensebill.amount
FROM #payment
JOIN expensebill ON #payment.idexp = expensebill.idexp


--IF (@cod_department = '9000777') -- TOR VERGATA
--	BEGIN
--	INSERT INTO #error (message)
--	SELECT DISTINCT 
--	'I pagamenti  a copertura contenuti nella distinta ' + CONVERT(varchar(6),@n) + '/' + CONVERT(varchar(4),@y) + 
--	' non coprono interamente il sospeso di uscita n° ' + CONVERT(varchar(6),b.nbill) + '/' + CONVERT(varchar(4),b.ybill) 
--	+ ' di importo corrente  ' + CONVERT(varchar(20), ISNULL(b.total,0 ) - ISNULL(b.reduction,0)) + '.'
--	+ ' Si consiglia di controllare i pagamenti associati al sospeso.'
--	FROM billview b
--	JOIN #payment p ON  b.billkind = 'D' AND b.ybill = @y  and p.nbill = b.nbill
--	WHERE 
--	(ISNULL(b.total,0) - ISNULL(b.reduction,0)  
--	-
--	ISNULL((SELECT SUM(amount) FROM #expensebill I where I.ybill = b.ybill AND I.nbill = b.nbill),0)
--	) > 0
	
--	IF (SELECT COUNT(*) FROM #error) > 0
--	BEGIN
--		SELECT * FROM #error
--		RETURN
--	END
--END

-- Inserimento di tutte le testate di flusso che corrispondono alle distinte di trasmissione
-- RECORD TF
INSERT INTO #trace (y, n, ndoc, nrow, out_str)
SELECT
    ypaymenttransmission, npaymenttransmission, 0, 0,
    'TF' + @ABI_code + SUBSTRING('000000',1,@len_npay_trans - DATALENGTH(CONVERT(varchar(6),npaymenttransmission))) +
    CONVERT(varchar(6),npaymenttransmission) +
    CONVERT(varchar(19),CONVERT(smalldatetime, GETDATE(), 126),126) +
    CONVERT(varchar(4),@y) + @cod_department + @docversion
FROM paymenttransmission
WHERE ypaymenttransmission = @y
    AND npaymenttransmission = @n

-- RECORD MT
INSERT INTO #trace (y, n, ndoc, nrow, out_str)
SELECT
    ypaymenttransmission, npaymenttransmission, ndoc, 1,
    -- Tipo Record
    'MT' +
    -- Codice Ente
    @cod_department +
    -- Esercizio
    CONVERT(varchar(4), ydoc) +
    -- Numero Documento (default a zero)
    '0000000' +
    -- Codice Funzione
    @opkind +
    -- Numero Mandato
    ndocformatted +
    -- Data Mandato
    CONVERT(varchar(4),YEAR(payment_adate)) + '-' +
    SUBSTRING('00',1,2 - DATALENGTH(CONVERT(varchar(2),MONTH(payment_adate)))) +
    CONVERT(varchar(2),MONTH(payment_adate)) + '-' +
    SUBSTRING('00',1,2 - DATALENGTH(CONVERT(varchar(2),DAY(payment_adate)))) +
    CONVERT(varchar(2),DAY(payment_adate)) +
    -- Importo Mandato
    SUBSTRING(REPLICATE('0',@len_amount),1,1 + @len_amount -
    DATALENGTH(CONVERT(varchar(15),SUM(curramount)))) +
    SUBSTRING(CONVERT(varchar(15),SUM(curramount)),1,
    DATALENGTH(CONVERT(varchar(15),SUM(curramount)))-3) +
    SUBSTRING(CONVERT(varchar(15),SUM(curramount)),
    DATALENGTH(CONVERT(varchar(15),SUM(curramount)))-1,2) +
    -- Flag Finanza Locale
    SPACE(1) +
    -- Gruppo Banca Italia Testata
    'O' + 'F' +
    -- conto_tesoreria : Numero del conto Libero o Vincolato intrattenuto presso il Tesoriere
    @cc_vincolato +
    -- Codifica Bilancio (Capitolo)
    codefin +
    --   numero Articolo)  + Voce Economica
    REPLICATE('0',7) +
    -- Descrizione Codifica
    SPACE(30) +
    -- Gestione
    CR +
    -- da Anno Residuo a Disponibilità Cassa (7 campi)
    REPLICATE('0',94) +
    -- Filler EX Testata Classificazione (3 campi)
    SPACE(32) +
    -- da Estremi Provvedimento a Ufficio Responsabile (6 campi)
    SPACE(286) +
    -- Codice ABI
    @ABI_code +
    -- Codice Fiscale Ente
    @cf_dept +
    -- Descrizione Ente
    @desc_dept +
    -- Indirizzo Ente
    @address_dept +
    -- Località Ente
    @location_dept +
    -- Codice Ente
    @cod_department +
    -- Esercizio Emissione Mandato
    CONVERT(varchar(4),ydoc) +
    -- Codice Struttura
    @CodiceStruttura +
    --Progressivo Mandato Struttura
    SPACE(6) +
    -- Gestione SIOPE
    SPACE(219)
FROM #payment
GROUP BY ypaymenttransmission, npaymenttransmission, ydoc, ndoc, ndocformatted, payment_adate, codefin, CR


--Esamino il MIF ABI-USI txt Multirecord - tracciato mandati - V2300
--RECORD MP (progressivo beneficiario)
--campo facoltativo InfSerMan_Fatture AN LUNGHEZZA 750 F
--Elencazione fatture (numero, data, oggetto,
--importo , altro…) max 25*30 POSIZIONI DA 1423 2172


DECLARE @nota_pivaestera varchar(50)
SET @nota_pivaestera = 'P. Iva Estera'

-- RECORD MP
INSERT INTO #trace (y, n, ndoc, nrow, out_str)
SELECT
    ypaymenttransmission, npaymenttransmission, ndoc, 5 * idpay - 3,
    -- Tipo Record
    'MP' +
    -- Codice Ente
    @cod_department +
    -- Esercizio Emissione Mandato
    CONVERT(varchar(4),ydoc) +
    -- Numero Mandato
    ndocformatted +
    -- Progressivo Beneficiario
    SUBSTRING(REPLICATE('0',@len_idpay),1,@len_idpay - DATALENGTH(CONVERT(varchar(7),idpay))) +
    CONVERT(varchar(7),idpay) +
    -- Impignorabile
    ' ' +
    -- Destinazione
    REPLICATE('0',7) +
    -- Num C/C presso Banca d'Italia
    CASE
        WHEN idpaymethodTRS ='61' THEN extracode
        ELSE REPLICATE('0',7)
    end +
    -- Tipo Contabilità Ente ricevente
    SPACE(1) +
    -- Gestione Provvisoria
    SPACE(1) +
    -- Frazionabile
    SPACE(1) +
    -- Anagrafica Beneficiario
    title_ben +
    -- Indirizzo Beneficiario
    address_ben +
    -- C.A.P. Beneficiario
    cap_ben +
    -- Località Beneficiario
    location_ben +
    -- Provincia Beneficiario
    province_ben +
    -- Partita IVA (Se la Partita IVA è estera valorizzare il campo con 11 nove e contestualmente valorizzare
    -- il campo informazioni tesoriere - decisione presa dopo colloquio telefonico con Gagliardi)
    /*
        CASE
        WHEN  ASCII(SUBSTRING(pi_ben,1,1)) NOT BETWEEN 48 AND 57
        THEN REPLICATE('9',@len_pi)
        ELSE pi_ben
    END +
    */
    pi_ben + -->  SE Italiana sarà già stata valorizzata bene nella SELECT iniziale, SE Estera sarà stata valorizzata con 11 nove. Quindi la leggiamo e basta.
    -- Codice Fiscale
    cf_ben +
    -- Invio Avviso (per ora valorizzo a ' ' CHIEDERE a Francesco)
    SPACE(1) +
    -- Codice Fiscale Avviso
    SPACE(16) +
    -- Codice ABI Beneficiario
    CASE
        WHEN idpaymethodTRS IN ('53','63') THEN ABI
        ELSE REPLICATE('0',@len_ABI)
    END +
    -- Codice CAB Beneficiario
    CASE
        WHEN idpaymethodTRS IN ('53','63') THEN CAB
        ELSE REPLICATE('0',@len_CAB)
    END +
    -- Conto Corrente Beneficiario
    CASE
        WHEN idpaymethodTRS = '53' THEN cc
        ELSE SPACE(@len_cc)
    END +
    -- CIN per IBAN
    CASE
        WHEN idpaymethodTRS = '53' THEN
        CASE
            WHEN DATALENGTH(iban) >= 4 AND
                SUBSTRING(iban, 1, 2) = 'IT' THEN SUBSTRING(UPPER(iban), 3, 2)
            ELSE REPLICATE('0',2)
        END
        ELSE REPLICATE('0',2)
    END +
    -- CIN
    CASE
        WHEN idpaymethodTRS IN ('53','63') THEN UPPER(cin)
        ELSE SPACE(1)
    END +
    -- Codice Paese
    CASE
        WHEN idpaymethodTRS = '53' THEN
        CASE
            WHEN DATALENGTH(iban) >= 4 AND
                SUBSTRING(iban, 1, 2) = 'IT' THEN SUBSTRING(UPPER(iban), 1, 2)
            ELSE SPACE(2)
        END
        ELSE SPACE(2)
    END +
    -- Denominazione Banca Destinataria
    title_bank + ------ vedere se possiamo censire le banche estere
    -- Conto Corrente Postale
    CASE
        WHEN idpaymethodTRS = '52' THEN cc
        ELSE REPLICATE('0',@len_cc)
    END +
    -- Codice Ente Beneficiario (IMPOSTATO a '0000000' perché viene applicato sempre la mod. BONIFICO)
    REPLICATE('0',7) +
    ------------------------------------------------------------------------------------------
    --------------------------- INIZIO  BONIFICO SEPA O BONIFICO ESTERO ----------------------
    ------------------------------------------------------------------------------------------
    -- conto_corrente_estero 446- 460 (lunghezza 18)
    -- codice_swift 461- 471 (lunghezza 11)
    -- coordinate_iban 472 - 505
    -- flag_pagamento_condizionato 506
    CASE
        WHEN (idpaymethodTRS = '69' AND flag_foreign_transfer = 'S') THEN foreign_cc
        ELSE SPACE(@lenforeign_cc)
    END +
    CASE
        WHEN idpaymethodTRS = '69' THEN upper(biccode)
        ELSE SPACE(@lenbic_swift_code)
    END +
    CASE
        WHEN (idpaymethodTRS = '69' AND flag_sepa = 'S')  THEN iban
        ELSE SPACE(@leniban)
    END +
    SPACE(1) +  --FLAG_PAGAMENTO_CONDIZIONATO
    ------------------------------------------------------------------------------------------
    --------------------------- FINE  BONIFICO SEPA O BONIFICO ESTERO ------------------------
    ------------------------------------------------------------------------------------------
    -- Esenzione Bollo
    free_stamp +
    -- Carico Bollo (impostato sempre a carico del BENEFICIARIO - Chiedere a Francesco)
    stamp_charge +
    -- Causale per esenzione bollo (decidere cosa scrivere)
    CASE
        WHEN free_stamp = 'S' THEN 'Esente bollo' + SPACE(18)
        ELSE SPACE(30)
    END +
    -- Importo Bollo
    REPLICATE('0',7) +
    -- Carico Spese
    CASE
        WHEN (uncharged = 'N' AND bank_charges_exempt in ('N','C')) THEN SPACE(1) --- gestione spese come da convenzione di Tesoreria
        ELSE 'E' --- esenzione spese BANCARIE
    END +
    -- Importo Spese
    REPLICATE('0',7) +
    -- Carico Commissioni
    CASE
        WHEN (committeecode = 'E' OR bank_charges_exempt = 'S' ) THEN 'E' -- esplicito l'esenzione dalle commissioni bancarie
        WHEN (committeecode in ('B','C') AND bank_charges_exempt = 'N') THEN committeecode -- specifico il carico commissioni prescelto
        ELSE SPACE(1) -- non specifico niente, gestione commissioni come da convenzione di Tesoreria
    END +
    -- Importo Commissioni
    CASE
        WHEN committeecode = 'E' THEN     SUBSTRING(REPLICATE('0',@len_committeeamount),1,1 + @len_committeeamount -
                        DATALENGTH(CONVERT(varchar(7),committeeamount))) +
                        SUBSTRING(CONVERT(varchar(7),committeeamount),1,
                        DATALENGTH(CONVERT(varchar(7),committeeamount))-3) +
                        SUBSTRING(CONVERT(varchar(7),committeeamount),
                        DATALENGTH(CONVERT(varchar(7),committeeamount))-1,2)
        WHEN  (committeecode in ('B','C') AND bank_charges_exempt = 'N')  THEN     SUBSTRING(REPLICATE('0',@len_committeeamount),1,1 + @len_committeeamount -
                        DATALENGTH(CONVERT(varchar(7),committeeamount))) +
                        SUBSTRING(CONVERT(varchar(7),committeeamount),1,
                        DATALENGTH(CONVERT(varchar(7),committeeamount))-3) +
                        SUBSTRING(CONVERT(varchar(7),committeeamount),
                        DATALENGTH(CONVERT(varchar(7),committeeamount))-1,2)
        ELSE REPLICATE('0',7)
    END +
    -- Tipo Pagamento
    desc_paymethod +
    -- Codice Modalità Pagamento
    idpaymethodTRS +
    -- Importo Dettagli
    SUBSTRING(REPLICATE('0',@len_amount),1,1 + @len_amount -
    DATALENGTH(CONVERT(varchar(15),SUM(curramount)))) +
    SUBSTRING(CONVERT(varchar(15),SUM(curramount)),1,
    DATALENGTH(CONVERT(varchar(15),SUM(curramount)))-3) +
    SUBSTRING(CONVERT(varchar(15),SUM(curramount)),
    DATALENGTH(CONVERT(varchar(15),SUM(curramount)))-1,2) +
    -- Causale Pagamento
    ------------------------------------------------------------------------------------------------------------------------------------------------
    CASE
    -- CUP CIG  e DESCRIZIONE
            WHEN ((        DATALENGTH(isnull(CUP,'')) >0
                    AND DATALENGTH(isnull(CIG,'')) >0
                    AND ( 11 + DATALENGTH(ISNULL(CUP,''))+ DATALENGTH(ISNULL(CIG,''))+ DATALENGTH(ISNULL(paymentdescr,''))) <= @len_desc_payment ) )
            THEN 'CUP:' + isnull(CUP,'') +';CIG:'+isnull(CIG,'') + '; '+ ISNULL(paymentdescr, '')
                    + SUBSTRING(
                                SPACE(@len_desc_payment),
                                1,
                                @len_desc_payment - 11 - DATALENGTH(ISNULL(CUP,'') + ISNULL(CIG,'') + ISNULL(paymentdescr,''))
                                )
    -- CIG  e DESCRIZIONE
            WHEN ( (    DATALENGTH(isnull(CIG,'')) >0
                    AND (6+DATALENGTH(ISNULL(CIG,''))+ DATALENGTH(ISNULL(paymentdescr,''))) <= @len_desc_payment ) )
            THEN 'CIG:'+isnull(CIG,'') + '; '+ISNULL(paymentdescr, '')
                    + SUBSTRING(
                                SPACE(@len_desc_payment),
                                1,
                                @len_desc_payment - 6 - DATALENGTH(ISNULL(CIG,'') + ISNULL(paymentdescr,''))
                                )
    -- CUP  e DESCRIZIONE
            WHEN ( (DATALENGTH(isnull(CUP,'')) >0
                    AND (6 + DATALENGTH(ISNULL(CUP,''))+ DATALENGTH(ISNULL(paymentdescr,''))) <= @len_desc_payment ))
            THEN 'CUP:'+isnull(CUP,'') + '; '+ISNULL(paymentdescr, '')
                    + SUBSTRING(
                                SPACE(@len_desc_payment),
                                1,
                                @len_desc_payment - 6 - DATALENGTH(ISNULL(CUP,'') + ISNULL(paymentdescr,''))
                                )
    -- DESCRIZIONE
            ELSE ISNULL(paymentdescr, '')
                    + SUBSTRING(SPACE(@len_desc_payment),1,    @len_desc_payment - DATALENGTH(ISNULL(paymentdescr,'')))
    END +
    ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

    -- Data Esecuzione Pagamento
    -- Su richiesta di Unicredit valorizzo a BLANK
    SPACE(10) +          
    -- Data Scadenza Pagamento (Chiedere a Francesco se bisogna usare questa data o la data di scadenza del pagamento)
    -- Su richiesta di Unicredit valorizzo a BLANK
    SPACE(10) +
    -- Valuta Antergata (Chiedere a Francesco)
    SPACE(1) +
    -- Divisa Estera
    SPACE(3) +
    -- Flag Assegno Circolare
    CASE
        WHEN idpaymethodTRS = '55' THEN 'S'
        ELSE SPACE(1)
    END +
    -- Flag Vaglia Postale (non gestiamo questa informazione)
    SPACE(1) +
    -- Lingua
    'I' +
    -- Riferimento Documento Esterno (Decidere quando valorizzare ad 8)
    CASE
        WHEN refexternaldoc <> '' THEN RTRIM(refexternaldoc)
        ELSE SPACE(1)
    END +
    -- Informazioni Tesoriere
    paymenthodistructions +
    CASE
-- Non dobbiamo pià interrogare il primo carattere, perchè abbiamo introdotto il campo pi_ben_estera che contiente la p.iva estera oppure vale null.
        --WHEN ASCII(SUBSTRING(pi_ben,1,1)) NOT BETWEEN 48 AND 57
        WHEN pi_ben_estera is not null
        THEN @nota_pivaestera + pi_ben_estera +
            SPACE(150 - DATALENGTH(paymenthodistructions) - DATALENGTH(@nota_pivaestera) - DATALENGTH(pi_ben_estera))
        ELSE SPACE(150 - DATALENGTH(paymenthodistructions))
    END +
    -- da Tipo Utenza a Codice Generico (3 campi)
    SPACE(41) +
    -- Flag Copertura
    fulfilled +
    -- Gruppo Funzionario Delegato (5 campi)
    SPACE(16) + REPLICATE('0',15) + SPACE(15) +
    -- Gruppo Sostituzione Mandato (3 campi)
    SPACE(14) + REPLICATE('0',4) +
    -- Gruppo Info Servizio Mandato Testata (7 campi)
    SPACE(160)+
    CASE
        WHEN ISNULL(info_fatture,'') = '' THEN SPACE(750)
        ELSE SPACE(750 - DATALENGTH(SUBSTRING (ISNULL(info_fatture,''),1,750)) ) + SUBSTRING (ISNULL(info_fatture,''),1,750)
    END +
    SPACE(9)+ -- ProgrSpesa e TipoSpesa
    cu -- 12
FROM #payment
GROUP BY
    ypaymenttransmission, npaymenttransmission, ydoc, ndoc, ndocformatted, idpay,
    title_ben, address_ben, cap_ben, location_ben, province_ben,
    pi_ben, pi_ben_estera, cf_ben, ABI, CAB, cc, cin, title_bank, iban,
    free_stamp, desc_paymethod, idpaymethodTRS, paymentdescr, CUP, CIG, transmissiondate, fulfilled,uncharged,
    paymenthodistructions, refexternaldoc, stamp_charge,committeecode,committeeamount, extracode,
    foreign_cc,biccode, flag_sepa, flag_foreign_transfer, ISNULL(info_fatture,''), cu,bank_charges_exempt


-- RECORD CL
INSERT INTO #trace (y, n, ndoc, nrow, out_str)
SELECT
    ypaymenttransmission, npaymenttransmission, ndoc, 5 * idpay - 2,
    'CL' + @cod_department + CONVERT(varchar(4),ydoc) + ndocformatted +
    SUBSTRING(REPLICATE('0',@len_idpay),1,@len_idpay - DATALENGTH(CONVERT(varchar(7),idpay))) +
    CONVERT(varchar(7),idpay) +
    sortcode + SUBSTRING(SPACE(@len_sortcode),1,@len_sortcode - DATALENGTH(sortcode)) +
    descr_sorting + SUBSTRING(SPACE(@len_desc_sort),1,@len_desc_sort - DATALENGTH(descr_sorting)) +
    SPACE(15) + --Codice CUP
    -- da Descrizione CUP a Descrizione CPV (4 campi)
    SPACE(134) +
    SUBSTRING(REPLICATE('0',@len_amount),1,1 + @len_amount -
    DATALENGTH(CONVERT(varchar(15),SUM(#siope.amount)))) +
    SUBSTRING(CONVERT(varchar(15),SUM(#siope.amount)),1,
    DATALENGTH(CONVERT(varchar(15),SUM(#siope.amount)))-3) +
    SUBSTRING(CONVERT(varchar(15),SUM(#siope.amount)),
    DATALENGTH(CONVERT(varchar(15),SUM(#siope.amount)))-1,2)
FROM #siope
GROUP BY ypaymenttransmission, npaymenttransmission, ndoc, idpay, sortcode,
         descr_sorting, ydoc, ndocformatted

-- RECORD EB (Estremi Bilancio) Non bisogna dare informazioni

-- RECORD DE
INSERT INTO #trace (y, n, ndoc, nrow, out_str)
SELECT DISTINCT
    #payment.ypaymenttransmission, #payment.npaymenttransmission, #payment.ndoc, 5 * idpay - 1,
    'DE' + @cod_department + CONVERT(varchar(4),ydoc) + ndocformatted +
    SUBSTRING(REPLICATE('0',@len_idpay),1,@len_idpay - DATALENGTH(CONVERT(varchar(7),idpay))) +
    CONVERT(varchar(7),idpay) +
    #deputy.title_deputy +
    #deputy.address_deputy +
    #deputy.cap_deputy +
    #deputy.location_deputy +
    #deputy.province_deputy +
    #deputy.cf_deputy
FROM #payment
JOIN #deputy
    ON #payment.iddeputy = #deputy.iddeputy

-- RECORD RT (a) PER RITENUTE A CARICO DEL BENEFICIARIO
INSERT INTO #trace (y, n, ndoc, nrow, out_str)
SELECT
    #tax.ypaymenttransmission, #tax.npaymenttransmission, #tax.ndoc, 5 * #tax.idpay,
    'RT' + @cod_department + CONVERT(varchar(4),#tax.ydoc) + #tax.ndocformatted +
    SUBSTRING(REPLICATE('0',@len_idpay),1,@len_idpay - DATALENGTH(CONVERT(varchar(7),#tax.idpay))) +
    CONVERT(varchar(7),#tax.idpay) +
    -- Tipo Ritenuta
    'R' +
    -- Importo Ritenuta
    SUBSTRING(REPLICATE('0',@len_amount),1,1 + @len_amount -
    DATALENGTH(CONVERT(varchar(15),SUM(#tax.curramount)))) +
    SUBSTRING(CONVERT(varchar(15),SUM(#tax.curramount)),1,
    DATALENGTH(CONVERT(varchar(15),SUM(#tax.curramount)))-3) +
    SUBSTRING(CONVERT(varchar(15),SUM(#tax.curramount)),
    DATALENGTH(CONVERT(varchar(15),SUM(#tax.curramount)))-1,2) +
    -- Numero Reversale
    #tax.nproformatted +
    -- Progressivo Reversale
    SUBSTRING(REPLICATE('0',@len_idpro),1,@len_idpro - DATALENGTH(CONVERT(varchar(7),#tax.idpro))) +
    CONVERT(varchar(7),#tax.idpro)
FROM #tax
GROUP BY #tax.ypaymenttransmission, #tax.npaymenttransmission, #tax.ydoc, #tax.ndoc, #tax.ndocformatted,
#tax.idpay, #tax.npro, #tax.nproformatted, #tax.idpro



----------------------------------------------------	
--------------------- RECORD RT (b)-----------------
----------------------------------------------------	
-- RECORD CHE DEVE ESSERE GESTITO PER QUEI 
-- PAGAMENTI RELATIVI ALL'APPLICAZIONE DEI CONTRIBUTI (ES. IRAP)
-- CON CORRISPONDENTE MOVIMENTO DI ENTRATA SU PARTITA DI GIRO

INSERT INTO #trace (y, n, ndoc, nrow, out_str)
SELECT
	#admintax.ypaymenttransmission, #admintax.npaymenttransmission, #admintax.ndoc, 5 * #admintax.idpay,
	'RT' + @cod_department + CONVERT(varchar(4),#admintax.ydoc) + #admintax.ndocformatted +
	SUBSTRING(REPLICATE('0',@len_idpay),1,@len_idpay - DATALENGTH(CONVERT(varchar(7),#admintax.idpay))) + 
	CONVERT(varchar(7),#admintax.idpay) +
	-- Tipo Ritenuta
	'R' +
	-- Importo Ritenuta
	SUBSTRING(REPLICATE('0',@len_amount),1,1 + @len_amount - 
	DATALENGTH(CONVERT(varchar(15),SUM(#admintax.curramount)))) +
	SUBSTRING(CONVERT(varchar(15),SUM(#admintax.curramount)),1,
	DATALENGTH(CONVERT(varchar(15),SUM(#admintax.curramount)))-3) +
	SUBSTRING(CONVERT(varchar(15),SUM(#admintax.curramount)),
	DATALENGTH(CONVERT(varchar(15),SUM(#admintax.curramount)))-1,2) +
	-- Numero Reversale
	#admintax.nproformatted +
	-- Progressivo Reversale
	SUBSTRING(REPLICATE('0',@len_idpro),1,@len_idpro - DATALENGTH(CONVERT(varchar(7),#admintax.idpro))) + 
	CONVERT(varchar(7),#admintax.idpro)
FROM #admintax
GROUP BY #admintax.ypaymenttransmission, #admintax.npaymenttransmission, #admintax.ydoc, #admintax.ndoc, #admintax.ndocformatted,
#admintax.idpay, #admintax.npro, #admintax.nproformatted, #admintax.idpro
 
----------------------------------------------------	
--------------------- RECORD RT (c)-----------------
----------------------------------------------------	
-- RECORD CHE DEVE ESSERE GESTITO PER QUEI 
-- PAGAMENTI ACCESSORI RELATIVI A INCASSI DA REGOLARIZZARE CON SOSPESO PARI ALLA DIFFERENZA TRA INCASSO REALE E SPESA
-- INSERISCO NEL RECORD RITENUTE IL CORRISPONDENTE MOVIMENTO DI ENTRATA VIRTUALE DI IMPORTO PARI ALLA SPESA
-- E IDPRO FITTIZIO PARI A 2 (SE L'ORIGINALE E' 1)

INSERT INTO #trace (y, n, ndoc, nrow, out_str)
SELECT
	#pendingincome.ypaymenttransmission, #pendingincome.npaymenttransmission, #pendingincome.ndoc, 5 * #pendingincome.idpay,
	'RT' + @cod_department + CONVERT(varchar(4),#pendingincome.ydoc) + #pendingincome.ndocformatted +
	SUBSTRING(REPLICATE('0',@len_idpay),1,@len_idpay - DATALENGTH(CONVERT(varchar(7),#pendingincome.idpay))) + 
	CONVERT(varchar(7),#pendingincome.idpay) +
	-- Tipo Ritenuta
	'R' +
	-- Importo Ritenuta
	SUBSTRING(REPLICATE('0',@len_amount),1,1 + @len_amount - 
	DATALENGTH(CONVERT(varchar(15),SUM(#pendingincome.curramount_expense)))) +
	SUBSTRING(CONVERT(varchar(15),SUM(#pendingincome.curramount_expense)),1,
	DATALENGTH(CONVERT(varchar(15),SUM(#pendingincome.curramount_expense)))-3) +
	SUBSTRING(CONVERT(varchar(15),SUM(#pendingincome.curramount_expense)),
	DATALENGTH(CONVERT(varchar(15),SUM(#pendingincome.curramount_expense)))-1,2) +
	-- Numero Reversale
	#pendingincome.nproformatted +
	-- Progressivo Reversale
	SUBSTRING(REPLICATE('0',@len_idpro),1,@len_idpro - DATALENGTH(CONVERT(varchar(7),#pendingincome.idpro + 1))) + 
	CONVERT(varchar(7),#pendingincome.idpro + 1)
FROM #pendingincome
GROUP BY #pendingincome.ypaymenttransmission, #pendingincome.npaymenttransmission, 
	#pendingincome.ydoc, #pendingincome.ndoc, #pendingincome.ndocformatted,
	#pendingincome.idpay, #pendingincome.npro, #pendingincome.nproformatted, #pendingincome.idpro

-- RECORD SO (Sospesi)
INSERT INTO #trace (y, n, ndoc, nrow, out_str)
SELECT
    #payment.ypaymenttransmission, #payment.npaymenttransmission, #payment.ndoc, 5 * #payment.idpay + 1,
    'SO' --Fisso "SO"
    + @cod_department --Codice identificativo dell'Ente
    + CONVERT(varchar(4),#payment.ydoc) --Esercizio di emissione del mandato
    + #payment.ndocformatted --Numero del mandato; se numerico allineato a destra e preceduto da zeri
--"numero progressivo delle disposizioni contenute nel mandato; se numerico allineato a destra e preceduto da zeri.
--In caso di mandato monobeneficiario il progressivo deve essere impostato sempre ad 1."
    + SUBSTRING(REPLICATE('0',@len_idpay),1,@len_idpay - DATALENGTH(CONVERT(varchar(7),#payment.idpay))) + CONVERT(varchar(7),#payment.idpay)
    + REPLICATE('0',7 - LEN(CONVERT(varchar(7),#expensebill.nbill))) + CONVERT(varchar(7),#expensebill.nbill) --numero del provvisorio emesso per il pagamento anticipato
    + SUBSTRING(REPLICATE('0',@len_amount),1,1 + @len_amount - DATALENGTH(CONVERT(varchar(15),SUM(#expensebill.amount))))
    + SUBSTRING(CONVERT(varchar(15),SUM(#expensebill.amount)),1, DATALENGTH(CONVERT(varchar(15),SUM(#expensebill.amount)))-3)
    + SUBSTRING(CONVERT(varchar(15),SUM(#expensebill.amount)), DATALENGTH(CONVERT(varchar(15),SUM(#expensebill.amount)))-1,2) --importo del provvisorio emesso per il pagamento anticipato
FROM #payment JOIN #expensebill ON #payment.idexp = #expensebill.idexp
GROUP BY #payment.ypaymenttransmission, #payment.npaymenttransmission, #payment.ydoc, #payment.ndoc,
#payment.ndocformatted, #payment.idpay, #expensebill.nbill

if (@cod_department = '9004000') -- SECONDA UNIVERSITà NAPOLI
	BEGIN
	INSERT INTO #trace (y, n, ndoc, nrow, out_str)
	SELECT
		ypaymenttransmission, npaymenttransmission, ndoc,  5 * idpay + 2,
		'DM' + @cod_department + CONVERT(varchar(4),ydoc) + ndocformatted +
		SUBSTRING(REPLICATE('0',@len_idpay),1,@len_idpay - DATALENGTH(CONVERT(varchar(7),idpay))) + CONVERT(varchar(7),idpay) +
		nome_campo +  -- nome campo da 28 57
		testo           -- valore campo da 58 257
	FROM #note
	ORDER BY ndoc,idpay
END

if (@cod_department = '9057001') --  'UNIVERSITA' CATANIA'
BEGIN
	INSERT INTO #trace (y, n, ndoc, nrow, out_str)
	SELECT
		ypaymenttransmission, npaymenttransmission, ndoc,  5 * idpay + 2,
		'DM' + @cod_department + CONVERT(varchar(4),ydoc) + ndocformatted +
		SUBSTRING(REPLICATE('0',@len_idpay),1,@len_idpay - DATALENGTH(CONVERT(varchar(7),idpay))) + CONVERT(varchar(7),idpay) +
		nome_campo +  -- nome campo da 28 57
		testo           -- valore campo da 58 257
	FROM #note
	ORDER BY ndoc,idpay
END
	
-- RECORD CF
INSERT INTO #trace (y, n, ndoc, nrow, out_str)
SELECT
    ypaymenttransmission, npaymenttransmission, 99999999, 2147483647,
    'CF' + @ABI_code + SUBSTRING('000000',1,@len_npay_trans - DATALENGTH(CONVERT(varchar(6),npaymenttransmission))) +
    CONVERT(varchar(6),npaymenttransmission) +
    CONVERT(varchar(19),CONVERT(smalldatetime, GETDATE(), 126),126) +
    CONVERT(varchar(4),@y) + @cod_department +
    -- Numero Record
    SUBSTRING('0000000',1,@len_ndoc -
    DATALENGTH(CONVERT(varchar(7),
        (SELECT COUNT(*)
        FROM #trace
        WHERE out_str LIKE 'MP%'
            AND ypaymenttransmission = paymenttransmission.ypaymenttransmission
            AND npaymenttransmission = paymenttransmission.npaymenttransmission))
    )) +
    CONVERT(varchar(7),
        (SELECT COUNT(*)
        FROM #trace
        WHERE out_str LIKE 'MP%'
            AND ypaymenttransmission = paymenttransmission.ypaymenttransmission
            AND npaymenttransmission = paymenttransmission.npaymenttransmission)) +
    -- Importo Lordo
    SUBSTRING(REPLICATE('0',@len_amount),1,1 + @len_amount -
    DATALENGTH(CONVERT(varchar(15),
        (SELECT SUM(curramount) FROM #payment

        WHERE ypaymenttransmission = paymenttransmission.ypaymenttransmission
            AND npaymenttransmission = paymenttransmission.npaymenttransmission))
    )) +
    SUBSTRING(
    CONVERT(varchar(15),
        (SELECT SUM(curramount) FROM #payment
        WHERE ypaymenttransmission = paymenttransmission.ypaymenttransmission
            AND npaymenttransmission = paymenttransmission.npaymenttransmission)),1,
    DATALENGTH(
    CONVERT(varchar(15),
        (SELECT SUM(curramount) FROM #payment
        WHERE ypaymenttransmission = paymenttransmission.ypaymenttransmission
            AND npaymenttransmission = paymenttransmission.npaymenttransmission))
    ) - 3
    ) +
    SUBSTRING(
    CONVERT(varchar(15),
        (SELECT SUM(curramount) FROM #payment
        WHERE ypaymenttransmission = paymenttransmission.ypaymenttransmission
            AND npaymenttransmission = paymenttransmission.npaymenttransmission)),
    DATALENGTH(
    CONVERT(varchar(15),
        (SELECT SUM(curramount) FROM #payment
        WHERE ypaymenttransmission = paymenttransmission.ypaymenttransmission
            AND npaymenttransmission = paymenttransmission.npaymenttransmission))
    ) -1,2
    )
FROM paymenttransmission
WHERE ypaymenttransmission = @y
    AND npaymenttransmission = @n

-- Rimozione dei caratteri non consentiti
UPDATE #trace SET out_str =
REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(
REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(
REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(
REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(
REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(
REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(
REPLACE(REPLACE(REPLACE(
out_str,
'Ç','c'),'ç','c'),'€','e'),'|',' '),'\',' '),'£',' '),'§',' '),'@',' '),'[',' '),'#',' '),'!',' '),'Ù','u'),
'Ö','o'),'Ü','u'),'Ñ','n'),'Ð','d'),'Ê','e'),'Ë','e'),'Î','i'),'Ï','i'),'Ô','o'),'Õ','o'),'Û','u'),'Ý','y'),
']',' '),'`',' '),'{',' '),'}',' '),'~',' '),'ü','u'),'â','a'),'ä','a'),'å','a'),'ê','e'),'ë','e'),'ï','i'),
'î','i'),'Ä','a'),'Å','a'),'ô','o'),'ö','o'),'û','u'),'ÿ','y'),'ñ','n'),'Â','a'),'¥','y'),'ã','a'),'Ã','a'),
'õ','o'),'ý','y'),'é','e'),'à','a'),'è','e'),'ì','i'),'ò','o'),'ù','u'),'á','a'),'í','i'),'ó','o'),'É','e'),
'Á','a'),'À','a'),'È','e'),'Í','i'),'Ì','i'),'Ó','o'),'Ò','o'),'Ú','u'),
CHAR(9),' '),CHAR(10),' '),CHAR(13),' ')

SELECT out_str FROM #trace ORDER BY y, n, ndoc, nrow
END





GO

SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO


 