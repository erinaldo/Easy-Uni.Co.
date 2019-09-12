if exists (select * from dbo.sysobjects where id = object_id(N'[rpt_unified_certfiscale_inps_gestsep]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [rpt_unified_certfiscale_inps_gestsep]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO


CREATE    PROCEDURE [rpt_unified_certfiscale_inps_gestsep]
	@ayear int,
	@idreg int,
    @unified char(1) -- consolidamento dei dati
AS BEGIN	

IF (@unified <> 'S')
BEGIN
        EXEC rpt_certfiscale_inps_gestsep @ayear, @idreg 
        RETURN
END
 
CREATE TABLE #unified (
        departmentname  varchar(150),
	idreg int,
	registry varchar(100),
	causale varchar(250),
	birthdate smalldatetime,
	b_place varchar(120),
	b_province varchar(2),
	b_nation varchar(65),
	cf varchar(16),
	cfestero varchar(40),
	taxable decimal(19,2),
	adminretension decimal(19,2),
	employretension decimal(19,2),
	officename varchar(50),
	sendaddress varchar(100),
	sendlocation varchar(120),
	sendcap varchar(20),
	sendprovince varchar(2),
	sendnation varchar(65),
	workperiod varchar(200)
)


DECLARE @iddbdepartment varchar(50)
DECLARE @crsdepartment cursor

SET @crsdepartment = cursor FOR SELECT iddbdepartment FROM dbdepartment
					 where (start is null or start <= @ayear ) AND ( stop is null or stop >= @ayear)
OPEN @crsdepartment

FETCH NEXT FROM @crsdepartment INTO @iddbdepartment
WHILE @@fetch_status=0 begin
	DECLARE @dip_nomesp varchar(300)
	SET @dip_nomesp = @iddbdepartment + '.rpt_certfiscale_inps_gestsep'
PRINT @iddbdepartment
	INSERT INTO #unified (
                departmentname,
        	idreg,
        	registry,
        	causale,
        	birthdate,
        	b_place,
        	b_province,
        	b_nation,
        	cf,
        	cfestero,
        	taxable,
        	adminretension,
        	employretension,
        	officename,
        	sendaddress,
        	sendlocation,
        	sendcap,
        	sendprovince,
        	sendnation,
        	workperiod
	)
		EXEC @dip_nomesp @ayear, @idreg
	FETCH NEXT FROM @crsdepartment INTO @iddbdepartment
END


SELECT  
        departmentname,
	idreg,
	registry,
	causale,
	birthdate,
	b_place,
	b_province,
	b_nation,
	cf,
	cfestero,
	ISNULL(SUM(taxable),0) AS taxable,
	ISNULL(SUM(adminretension),0) AS adminretension,
	ISNULL(SUM(employretension),0) AS employretension,
	officename,
	sendaddress 	as 'spedaddress',
	sendlocation 	as 'spedlocation',
	sendcap		as 'spedcap',
	sendprovince 	as 'spedprovince',
	sendnation 	as 'spednation',
	workperiod
FROM #unified
--GROUP BY inserita pechè la sp interna per ogni percipiente calcola il SUM, quindi in out fornisce solo una riga con i totali.
GROUP BY idreg,registry,cf,cfestero,departmentname,
	causale,
	birthdate,b_place,b_province,b_nation,
	officename,sendaddress,
	sendlocation,sendcap,sendprovince,sendnation,workperiod
ORDER BY registry ASC
	
END


GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO
