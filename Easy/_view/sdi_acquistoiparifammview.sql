GO
-- CREAZIONE VISTA sdi_acquistoiparifammview
IF EXISTS(select * from sysobjects where id = object_id(N'[sdi_acquistoiparifammview]') and OBJECTPROPERTY(id, N'IsView') = 1)
DROP VIEW [sdi_acquistoiparifammview]
GO


-- clear_table_info 'sdi_acquistoiparifammview'

CREATE VIEW sdi_acquistoiparifammview 
(
	idsdi_acquisto,
	filename,
	zipfilename,
	adate,
	protocoldate,
	identificativo_sdi,
	ec_sent,
	flag_unseen,
	idsdi_status,
	sdi_status,
	position,
	ec_number,
	exist_mt,
	exist_ec,
	exist_se,
	exist_dt,
	title,
	description,
	ninvoice,
	riferimento_amministrazione,
	codice_ipa,
	total,
	discount_amount,
	idinvkind, yinv, ninv,
	arrivalprotocolnum,
	rejectreason,
	existsinvoice,
	idsor01,
	idsor02,
	idsor03,
	idsor04,
	idsor05,
	lu, 
	lt,
	utente_accettata,
	data_accettata,
	utente_rifiutata,
	data_rifiutata,
	tipodocumento,
	notcreacontabilita
)
AS SELECT
	sdi_acquisto.idsdi_acquisto,
	sdi_acquisto.filename,
	sdi_acquisto.zipfilename,
	sdi_acquisto.adate,
	sdi_acquisto.protocoldate,
	sdi_acquisto.identificativo_sdi,
	sdi_acquisto.ec_sent,
	sdi_acquisto.flag_unseen,
	sdi_acquisto.idsdi_status,
	sdi_status.description,
	sdi_acquisto.position,
	sdi_acquisto.ec_number,
	case when flag_unseen&1<>0 then 'S' else'N' end,
	case when flag_unseen&2<>0 then 'S' else'N' end,
	case when flag_unseen&4<>0 then 'S' else'N' end,
	case when flag_unseen&8<>0 then 'S' else'N' end,
	sdi_acquisto.title,
	sdi_acquisto.description,
	sdi_acquisto.ninvoice,
	sdi_acquisto.riferimento_amministrazione,
	sdi_acquisto.codice_ipa,
	sdi_acquisto.total,
	sdi_acquisto.discount_amount,
	invoice.idinvkind, invoice.yinv, invoice.ninv,	
	sdi_acquisto.arrivalprotocolnum,
	sdi_acquisto.rejectreason,
	case when invoice.idinvkind is not null then 'S' else 'N' end,
	sdi_rifamm.idsor01,
	sdi_rifamm.idsor02,
	sdi_rifamm.idsor03,
	sdi_rifamm.idsor04,
	sdi_rifamm.idsor05,
	sdi_acquisto.lu, 
	sdi_acquisto.lt,
	sdi_acquisto.utente_accettata,
	sdi_acquisto.data_accettata,
	sdi_acquisto.utente_rifiutata,
	sdi_acquisto.data_rifiutata,
	sdi_acquisto.tipodocumento,
	sdi_acquisto.notcreacontabilita
FROM sdi_acquisto
JOIN sdi_rifamm
	on sdi_acquisto.riferimento_amministrazione = sdi_rifamm.idsdi_rifamm
LEFT OUTER JOIN sdi_status
	ON sdi_acquisto.idsdi_status = sdi_status.idsdi_status
LEFT OUTER JOIN invoice
	on sdi_acquisto.idsdi_acquisto = invoice.idsdi_acquisto

GO



