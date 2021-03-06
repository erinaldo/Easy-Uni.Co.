if exists (select * from dbo.sysobjects where id = object_id(N'[read_tax_sdi_acquisto]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [read_tax_sdi_acquisto]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
  --setuser 'amm'
  --setuser 'amministrazione'
CREATE    procedure [read_tax_sdi_acquisto] (
	@idinvkind	int,
	@yinv	smallint,
	@ninv	int,
	@idivakind int,
	@res decimal(19,6) out
) as
BEGIN
	DECLARE @idsdi_acquisto int
	select @idsdi_acquisto = idsdi_acquisto  from invoice where idinvkind= @idinvkind and yinv = @yinv and ninv = @ninv
	DECLARE @myrate decimal(19,6)
	SELECT @myrate = rate from ivakind where idivakind = @idivakind
	SET @myrate = @myrate *100
	declare @f int
	
	SET @res =0
	declare @xx float
	declare @x XML
	select @x = cast (S.xml as XML)   from sdi_acquisto S 		 where S.idsdi_acquisto= @idsdi_acquisto

	set @f = @x.value('count(//DatiBeniServizi/DatiRiepilogo/AliquotaIVA[text()=  sql:variable("@myrate") ]/../Imposta)[1]','int')	 	

	IF (@f > 0) 
	BEGIN
		SET @xx =  isnull(@x.value('sum(//DatiBeniServizi/DatiRiepilogo/AliquotaIVA[text()= sql:variable("@myrate") ]/../Imposta)[1]','float') ,0)		
		set @res= convert(decimal(19,6),@xx)
    END
	 

END

GO


