if exists (select * from dbo.sysobjects where id = object_id(N'[compute_taxpay_unified]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [compute_taxpay_unified]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO


--setuser 'amm'
-- [compute_taxpay_unified] 2011,3,'31-12-2014'
CREATE   PROCEDURE  [compute_taxpay_unified]
(
	@ayear int,
	@taxcode int,
	@stop smalldatetime
)
AS BEGIN
/* Versione 1.0.2 del 18/11/2008 ultima modifica: SARA */
CREATE TABLE #automov_unified
(
    departmentname varchar(500),
	department varchar(150),
	ymov int, 
    nmov int,
	movkind varchar(128), 
    amount decimal(19,2),
	idreg int, 
	registry varchar(100),
	idfin int, 
    competencydate datetime, 
	codefin varchar(50), 
	idupb varchar(36),
	codeupb varchar(50),
	idman int,
	manager varchar(150),
	idexp int , 
        payee_title varchar(100), 
	location varchar(200),
	idcity int,
	city varchar(35),
	idfiscaltaxregion varchar(5),
	fiscaltaxregion varchar(50),
	sourcekind char(1),
	fiscaltaxcode varchar(20),
	taxcode int,
    tax varchar(50),
    taxref varchar(20),
	ayear int,
	refmonth int,
	idtreasurer int,
	idser int,
	codeser varchar(20),
	service varchar(50)
)
--exec compute_taxpay_unified 2008,18,{ts '2008-11-18 00:00:00'}
DECLARE @iddbdepartment varchar(50)
DECLARE @crsdepartment cursor

SET @crsdepartment = cursor FOR SELECT iddbdepartment FROM dbdepartment
OPEN @crsdepartment

FETCH NEXT FROM @crsdepartment INTO @iddbdepartment
WHILE @@fetch_status=0 begin
	DECLARE @dip_nomesp varchar(300)
	SET @dip_nomesp = @iddbdepartment + '.compute_taxpay'

		INSERT INTO #automov_unified (
                departmentname,
				department,
        	ymov, 
                nmov,
        	movkind, 
                amount,
        	idreg, 
        	registry,
        	idfin, 
                competencydate, 
        	codefin, 
        	idupb,
        	codeupb,
        	idman,
        	manager,
        	idexp, 
                payee_title, 
        	location,
        	idcity,
        	city,
        	idfiscaltaxregion,
        	fiscaltaxregion,
        	sourcekind,
        	fiscaltaxcode,
        	taxcode,
                tax,
                taxref,
        	ayear,
        	refmonth,
			idtreasurer,
			idser,codeser,service
    		)
                EXEC @dip_nomesp @ayear,@taxcode,@stop 
	FETCH NEXT FROM @crsdepartment INTO @iddbdepartment
END


SELECT
        departmentname,
		department,
	ymov, 
        nmov,
	movkind, 
        amount,
	idreg, 
	registry,
	idfin, 
        competencydate, 
	codefin, 
	idupb,
	codeupb,
	idman,
	manager,
	idexp, 
        payee_title, 
	location,
	idcity,
	city,
	idfiscaltaxregion,
	fiscaltaxregion,
	sourcekind,
	fiscaltaxcode,
	taxcode,
        tax,
        taxref,
	ayear,
	refmonth,
	idtreasurer,
	idser,codeser,service
FROM #automov_unified

END
GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO


 