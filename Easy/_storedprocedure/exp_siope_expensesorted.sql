if exists (select * from dbo.sysobjects where id = object_id(N'[exp_siope_expensesorted]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [exp_siope_expensesorted]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO
--exp_siope_expensesorted 2017
CREATE procedure exp_siope_expensesorted (@ayear int) as
begin
	declare @DenominazioneDipartimento varchar(500)

	SET  @DenominazioneDipartimento  = ISNULL( (SELECT paramvalue from
			 generalreportparameter where idparam='DenominazioneDipartimento' 
				and  (start is null or year(start) <= @ayear) 
				and (stop is null or year(stop) >= @ayear)
				),'Manca Cfg. Parametri Tutte le stampe')
	
	
DECLARE @codesorkind_siopespese varchar(20)
SELECT  @codesorkind_siopespese  =  
CASE  
	WHEN  (@ayear<= 2006) THEN  'SIOPE'
	WHEN  (@ayear BETWEEN 2007 AND 2017) THEN  '07U_SIOPE'
	ELSE   'SIOPE_U_18'
END

	
	SELECT @DenominazioneDipartimento as 'Dipartimento', sorting as 'Classificazione spese', sortcode as 'Siope spese', sum(amount) as 'Importo'
	FROM expensesortedview WHERE (codesorkind=@codesorkind_siopespese) AND (ayear=@ayear) group by idsor, sortcode, sorting order by sortcode
end


GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

 