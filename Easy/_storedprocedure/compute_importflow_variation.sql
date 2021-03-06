

if exists (select * from dbo.sysobjects where id = object_id(N'[compute_importflow_variation]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [compute_importflow_variation]
GO


SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

CREATE   PROCEDURE [compute_importflow_variation]
	@ayear int
AS
BEGIN
 --  compute_importflow_variation 2013

    with sumimp (idfin, idupb, amount)
    as (select idfin, idupb, sum(importo)
        from import_flowview
        where esercizio = @ayear and anno_accimp is null and variazione = 'S' and id_inc is null and id_liq is null
        group by idfin              , idupb)
    select sumimp.idfin, sumimp.idupb, F.codefin, F.title  as fin, UU.codeupb , UU.title as upb,
         -- (sumimp.amount- isnull(U.expenseprevavailable,0)- isnull(U.incomeprevavailable,0)) as amount,
         sumimp.amount, 
		 case
               when ((F.flag & 1) = 0) then 'E'
               when ((F.flag & 1) <> 0) then 'S'
           end      as finpart
    from sumimp
        left outer join upbfinyearview U on U.idfin = sumimp.idfin and sumimp.idupb = U.idupb
        join fin F on F.idfin = sumimp.idfin
		join upb UU on UU.idupb = sumimp.idupb;

--where (sumimp.amount > (isnull(U.expenseprevavailable,0)+isnull(U.incomeprevavailable,0)))


END

