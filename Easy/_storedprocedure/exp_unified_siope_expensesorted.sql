if exists (select * from dbo.sysobjects where id = object_id(N'[exp_unified_siope_expensesorted]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [exp_unified_siope_expensesorted]

GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE        procedure [exp_unified_siope_expensesorted]
	(@ayear int,
	@flagresearchagency char(1),
    @unified char(1)) as
begin

-- [exp_unified_siope_expensesorted] 2011,'S','S'
IF (@unified <> 'S')
BEGIN
	EXEC exp_siope_expensesorted @ayear
	RETURN
END

CREATE TABLE #unified (
	DenominazioneDipartimento varchar(150), 
	sorting varchar(200), 
	sortcode varchar(50), 
	amount decimal(19,2)
)



DECLARE @iddbdepartment varchar(50)
DECLARE @crsdepartment cursor

DECLARE @dip_nomesp varchar(300)
DECLARE @department varchar(150)


DECLARE @query nvarchar(300)
CREATE TABLE #flag(flag char(1))


SET @crsdepartment = cursor FOR SELECT iddbdepartment FROM dbdepartment
							where (start is null or start <= @ayear ) AND ( stop is null or stop >= @ayear)
OPEN @crsdepartment

FETCH NEXT FROM @crsdepartment INTO @iddbdepartment
WHILE @@fetch_status=0 begin

	SET @dip_nomesp = @iddbdepartment + '.exp_siope_expensesorted'
        SET  @query = ' SELECT flagresearchagency FROM '+ @iddbdepartment + '.uniconfig'
        -- Come prima: deve consolidare solo gli enti di ricerca o non di ricerca
        DELETE FROM #flag
        INSERT INTO #flag EXEC ( @query )
		IF (@flagresearchagency = 'A' AND @iddbdepartment='amministrazione') OR 
			(@flagresearchagency <> 'A' AND @iddbdepartment<>'amministrazione' AND (SELECT flag FROM #flag)=@flagresearchagency)
        Begin

			INSERT INTO #unified (
        		DenominazioneDipartimento, 
				sorting, 
				sortcode, 
				amount
			)

		EXEC @dip_nomesp @ayear
        End
print @iddbdepartment

	FETCH NEXT FROM @crsdepartment INTO @iddbdepartment
END

IF (@ayear<=2006)
BEGIN 
	SELECT 
			sorting as 'Classificazione spese', 
			sortcode as 'Siope', 
			SUM(amount) as 'Importo'
			FROM #unified 
			Group by sorting,sortcode
END ELSE BEGIN
	SELECT 
			sorting as 'Classificazione spese', 
			sortcode as 'Siope Spese', 
			SUM(amount) as 'Importo'
			FROM #unified 
			Group by sorting,sortcode
	END
END
GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO
