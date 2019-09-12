if exists (select * from dbo.sysobjects where id = object_id(N'[exp_document_multiple_entry]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [exp_document_multiple_entry]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO
 
CREATE PROCEDURE [exp_document_multiple_entry]
(
	@ayear int,
	@idsor01 int = null,
	@idsor02 int = null,
	@idsor03 int = null,
	@idsor04 int = null,
	@idsor05 int = null
)
AS 
BEGIN
-- setuser'amm'
-- exec [exp_document_multiple_entry] 2018
 
 select E.nentry as 'n.',
		E.adate as 'data',
		E.description as 'descrizione',
		ED.detaildescription as 'descrizione dett.',
		E.doc as 'documento',
		E.docdate as 'data documento',
		ED.amount as 'importo',
		ED.codeacc as 'codice conto',
		ED.account as 'conto',
		ED.codeupb as 'codice upb',
		ED.upb,
		ED.idrelated as 'idrelated dettaglio'


		

	 from entry E 
	 join entrydetailview ED on E.yentry=ED.yentry and E.nentry=ED.nentry
	where	ED.idrelated is not null 	
			AND (@idsor01 IS NULL OR E.idsor01 = @idsor01)
			AND (@idsor02 IS NULL OR E.idsor02 = @idsor02)
			AND (@idsor03 IS NULL OR E.idsor03 = @idsor03)
			AND (@idsor04 IS NULL OR E.idsor04 = @idsor04)
			AND (@idsor05 IS NULL OR E.idsor05 = @idsor05)
			and (select count(*) from entrydetail ED2 where ED2.idrelated = ED.idrelated) >1 
			and E.yentry=@ayear
END 

 

GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

