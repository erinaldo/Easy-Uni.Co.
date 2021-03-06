if exists (select * from dbo.sysobjects where id = object_id(N'[exp_siope_incomesorted]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [exp_siope_incomesorted]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO
--setuser'amm'
--exp_siope_incomesorted 2017

CREATE procedure exp_siope_incomesorted (@ayear int) as
begin
	declare @DenominazioneDipartimento varchar(500)

	SET  @DenominazioneDipartimento  = ISNULL( (SELECT paramvalue from
			 generalreportparameter where idparam='DenominazioneDipartimento' 
				and  (start is null or year(start) <= @ayear) 
				and (stop is null or year(stop) >= @ayear)
				),'Manca Cfg. Parametri Tutte le stampe')
	DECLARE @codesorkind_siopeentrate varchar(20)
	SELECT  @codesorkind_siopeentrate  =  
	CASE  
		WHEN  (@ayear<= 2006) THEN  'SIOPE'
		WHEN  (@ayear BETWEEN 2007 AND 2017) THEN  '07E_SIOPE'
		ELSE   'SIOPE_E_18'
	END
	
    SELECT @DenominazioneDipartimento as 'Dipartimento', sorting as 'Classificazione entrate', sortcode as 'Siope entrate', sum(amount) as 'Importo'
			FROM incomesortedview WHERE (codesorkind=@codesorkind_siopeentrate) AND (ayear=@ayear) group by idsor, sortcode, sorting order by sortcode
	 
end


GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO
