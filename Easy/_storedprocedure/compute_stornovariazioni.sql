
if exists (select * from dbo.sysobjects where id = object_id(N'[compute_stornovariazioni]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [compute_stornovariazioni]
GO

 
SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO
-- exec compute_stornovariazioni 2015, 10
CREATE   PROCEDURE [compute_stornovariazioni]
	@yvar int,
	@nvar int
AS
BEGIN
	
	IF not exists(select * from finvar where nvar= @nvar and yvar = @yvar)
	begin
		select 'Non esiste la variazione di bilancio indicata : n.'+convert(varchar(20),@nvar) + ' esercizio '+ convert(varchar(20),@yvar)+'.'as Avviso
		return
	End
	
	
	 declare @new_nvar int
	 select @new_nvar = max(nvar) from finvar where yvar=@yvar
	 set @new_nvar = @new_nvar +1

	 insert into finvar(
			yvar,
			nvar,
			idfinvarstatus,
			flagprevision,flagsecondaryprev,flagcredit,flagproceeds,
			description,
			variationkind,
			adate, 
			idman,
			ct,cu,lt,lu,moneytransfer,official,idsor01,idsor02,idsor03,idsor04,idsor05,varflag)
	  select @yvar,
			@new_nvar,
			1, -- bozza
			flagprevision,flagsecondaryprev,flagcredit,flagproceeds,
			'Storno variazione n.' +convert(varchar(20),@nvar) + ' esercizio '+ convert(varchar(20),@yvar),
			3,-- assestamento
			CONVERT(smalldatetime, 
				CONVERT(varchar,Datepart(year,GetDate()))  + '-' +
				CONVERT(varchar,Datepart(day,GetDate()) )+ '-' +
				CONVERT(varchar,Datepart(month,GetDate()))),
			idman,
			GETDATE(),'compute_stornovariazioni',GETDATE(),'compute_stornovariazioni',
			moneytransfer,'N',idsor01,idsor02,idsor03,idsor04,idsor05,varflag
		from finvar
		where nvar= @nvar and yvar = @yvar

		insert into finvardetail(
			yvar,nvar, rownum,
			idfin,idupb,idunderwriting,amount,
			ct, cu, lt, lu, 
			createexpense )
		select 
			@yvar, @new_nvar, rownum,
			idfin,idupb,idunderwriting,
			-amount,
			GETDATE(),'compute_stornovariazioni',GETDATE(),'compute_stornovariazioni',
			createexpense 
		from finvardetail
		where  nvar= @nvar and yvar = @yvar

		select 'E'' stata creata la variazione di bilancio n.'+convert(varchar(20),@new_nvar) + ' esercizio '+ convert(varchar(20),@yvar)+'.'as Avviso

END



GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

