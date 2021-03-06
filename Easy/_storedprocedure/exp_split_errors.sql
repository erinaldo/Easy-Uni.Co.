if exists (select * from dbo.sysobjects where id = object_id(N'[exp_invoice_split_errors]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [exp_invoice_split_errors]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

CREATE  PROCEDURE [exp_invoice_split_errors]
AS BEGIN
 

select 
 Ik.description as 'Tipo', 
 I.yinv as 'Eserc.', 
 I.ninv as 'N.', 
 I.doc as 'Doc.', 
 I.docdate as 'Data doc.', 
 I.adate as 'Data registrazione',
 I.expiring as 'Data scadenza',
 case I.flagdeferred when 'S' then 'Differita' else 'Immediata' end  as 'Tipo iva',
 i.registry as 'Fornitore',
 case I.flag_enable_split_payment when 'S' then 'Split' else 'no' end as 'Split', 
 case I.flag_auto_split_payment when 'S' then 'automatico' else 'manuale' end as 'Inserimento',
 case when ((select count(*) from invoicedeferred ID where  ID.idinvkind=I.idinvkind and ID.yinv=I.yinv and ID.ninv=I.ninv)
					>0) then 'SI' else 'NO' end as 'in liquidazione iva',
 case when ((select count(*) from invoicedetail IDET where  IDET.idinvkind=I.idinvkind and IDET.yinv=I.yinv and IDET.ninv=I.ninv
					and (IDET.idexp_taxable  is not null or IDET.idexp_iva is not null))
					>0) then 'SI'else 'NO' end as 'Pagata',
 convert(decimal(19,2),I.taxable) as 'imponibile totale',
 isnull((select sum(IDET1.taxable_euro) from invoicedetailview IDET1 
					where  IDET1.idinvkind=I.idinvkind and IDET1.yinv=I.yinv and IDET1.ninv=I.ninv and IDET1.idexp_taxable is not null),0) 
					as 'imponibile pagato al fornitore',
  convert(decimal(19,2),I.tax) as 'iva totale',
  isnull((select sum(IDET2.iva_euro) from invoicedetailview IDET2 
					where  IDET2.idinvkind=I.idinvkind and IDET2.yinv=I.yinv and IDET2.ninv=I.ninv and IDET2.idexp_taxable is not null),0) 
					as 'iva pagata al fornitore'


 from invoiceview I
	join invoicekind ik on ik.idinvkind = I.idinvkind
	join invoicekindregisterkind ikk on ik.idinvkind = ikk.idinvkind -- order by  ik.idinvkind, ikk.idivaregisterkind
	join ivaregisterkind rk on rk.idivaregisterkind = ikk.idivaregisterkind
where I.yinv = 2015 and YEAR(I.docdate) = 2015
and ik.flag&1 = 0 
and  rk.registerclass = 'A'
and isnull(i.tax,0)>0
and I.flag_enable_split_payment = 'N'
and I.flagintracom = 'N'
and I.ycon is null --   

order by i.adate desc


		
END

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

 