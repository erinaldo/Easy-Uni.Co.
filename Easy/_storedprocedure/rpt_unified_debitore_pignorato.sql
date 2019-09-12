if exists (select * from dbo.sysobjects where id = object_id(N'[rpt_unified_debitore_pignorato]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [rpt_unified_debitore_pignorato]
GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

CREATE     PROCEDURE [rpt_unified_debitore_pignorato]
(
	@ayear smallint, 
	@idreg int, 
	@start datetime,
	@stop datetime,
	@certificatekind char(1),
    @unified char(1) -- consolidamento dei dati 
)
AS BEGIN

IF (@unified <> 'S')
BEGIN
        EXEC rpt_debitore_pignorato @ayear, @idreg, @start, @stop, @certificatekind
        RETURN
END 

CREATE TABLE #unified (
        departmentname  varchar(150),
	idexp int,
	idreg int ,
	registry varchar(100),
	idreg_distrained int ,
	registry_distrained varchar(100),
	b_city varchar(120),
   	birthdate smalldatetime,
	b_province varchar(2),
	b_nation varchar(65),
	cf varchar(16),
	p_iva varchar(15),
	taxdescription varchar(50),
	expensedescription varchar(150),	
	service varchar(50),
	idser int,
	module varchar(15),
	npay int,
	taxablenet decimal(19,2),
	grossamount decimal(19,2), --Importo Lordo del Pagamento
	transmissiondate datetime, 
	employtax decimal(19,2),
	admintax decimal(19,2),
	taxablegross decimal(19,2), -- Imponibile Lordo
	sent_address varchar(100),
	sent_location varchar(120),
	sent_cap varchar(20),
	sent_province varchar(2),
	foreigncf varchar(40),
	flaghuman_distrained char(1),
	flaghuman char(1)
)


DECLARE @iddbdepartment varchar(50)

--DECLARE @crsdepartment cursor
--SET @crsdepartment = cursor FOR SELECT iddbdepartment FROM dbdepartment
DECLARE crsdepartment  cursor LOCAL STATIC FOR 
SELECT iddbdepartment FROM dbdepartment 
WHERE (start is null or start <= @ayear ) AND ( stop is null or stop >= @ayear)
FOR READ ONLY

OPEN crsdepartment

FETCH NEXT FROM crsdepartment INTO @iddbdepartment
WHILE @@fetch_status=0 begin
	DECLARE @dip_nomesp varchar(300)
        SET @dip_nomesp = '['+@iddbdepartment+']'+ '.rpt_debitore_pignorato'
PRINT @iddbdepartment
		INSERT INTO #unified (
                    departmentname,
                	idexp,
                	idreg_distrained,
                	idreg,
                	registry,
                	registry_distrained,
                	b_city,
                   	birthdate,
                	b_province,
                	b_nation,
                	cf,p_iva,
                	taxdescription,
                	expensedescription,	
                	service,
                	idser,
                	module,
                	npay,
                	taxablenet,
                	grossamount,--Importo Lordo del Pagamento
                	transmissiondate,
                	employtax,
                	admintax,
                	--taxablegross, -- Imponibile Lordo
                	sent_address,
                	sent_location,
                	sent_cap,
                	sent_province,
					foreigncf,
					flaghuman_distrained,
					flaghuman
		)
		EXEC @dip_nomesp @ayear, @idreg, @start, @stop, @certificatekind

	FETCH NEXT FROM crsdepartment INTO @iddbdepartment
end

DEALLOCATE crsdepartment

SELECT
    departmentname,
	idexp,
	idreg_distrained,
    idreg,
    registry,
    registry_distrained,
	b_city,
   	birthdate,
	b_province,
	b_nation,
	cf,p_iva,
	taxdescription,
	expensedescription,	
	service,
	idser,
	module,
	npay,
	taxablenet,
	grossamount,--Importo Lordo del Pagamento
	transmissiondate,
	employtax,
	admintax,
--	taxablegross, -- Imponibile Lordo
	sent_address,
	sent_location,
	sent_cap,
	sent_province,
	foreigncf,
	flaghuman_distrained,
	flaghuman
FROM #unified

DROP TABLE #unified
END

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO



