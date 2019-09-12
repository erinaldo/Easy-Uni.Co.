if exists (select * from dbo.sysobjects where id = object_id(N'[show_asset]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [show_asset]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO


CREATE PROCEDURE [show_asset]
(
	@date datetime,
	@idasset int
)
AS BEGIN

-- Valuta lo sconto
DECLARE @flagdiscount float   
IF(
	SELECT TOP 1 (inventorykind.flag & 1)
	FROM inventorykind 
	JOIN inventory 
		ON inventory.idinventorykind = inventorykind.idinventorykind
	JOIN assetacquire
		ON assetacquire.idinventory = inventory.idinventory
	JOIN asset 
		ON asset.nassetacquire = assetacquire.nassetacquire
	WHERE idasset = @idasset
) <> 0
BEGIN
	SET @flagdiscount = 1
END
ELSE 
BEGIN
	SET @flagdiscount = 0
END

IF (
	(SELECT assetload.yassetload
	FROM assetload
	JOIN assetacquire
		ON assetload.idassetload = assetacquire.idassetload
	JOIN asset 
		ON asset.nassetacquire = assetacquire.nassetacquire
	WHERE asset.idasset = @idasset AND asset.idpiece = 1)<2005)
BEGIN
	SET  @flagdiscount = 1 
END

CREATE TABLE #situation (value varchar(250), amount decimal(19,2), kind char(1))

DECLARE	@departmentname varchar(150)
SET  @departmentname = ISNULL( (SELECT paramvalue from
			 generalreportparameter where idparam='DenominazioneDipartimento' 
				and (start is null or start <= @date) 
				and (stop is null or stop >= @date)
				),'')

		
INSERT INTO #situation VALUES (@departmentname, NULL, 'H')
INSERT INTO #situation VALUES ('Situazione al ' + CONVERT(char(8), @date, 3), NULL, 'H')

DECLARE @idinventory int
DECLARE @ninventory int
DECLARE @tot_assetacquire decimal(19,2)
DECLARE @assetacquire_description varchar(150)
SELECT
	@idinventory = assetacquire.idinventory,
	@ninventory = asset.ninventory,
	@assetacquire_description = assetacquire.description	
FROM assetacquire
JOIN asset
	ON assetacquire.nassetacquire = asset.nassetacquire
WHERE asset.idasset = @idasset
	AND idpiece = 1
	--AND assetacquire.idassetload IS NOT NULL
SELECT
	@tot_assetacquire =
	CONVERT(decimal(19,2),
		ROUND(
			ISNULL(assetacquire.taxable,0)
			*(1-ISNULL(assetacquire.discount*@flagdiscount,0))
			+ ROUND(ISNULL(assetacquire.tax,0),2)/assetacquire.number
			- ROUND(ISNULL(assetacquire.abatable,0),2)/assetacquire.number
		,2)
	)
FROM assetacquire
JOIN asset
	ON assetacquire.nassetacquire = asset.nassetacquire
WHERE asset.idasset = @idasset
	AND assetacquire.adate <= @date
	AND idpiece = 1

DECLARE @descrinventory varchar(50)
SET @descrinventory = ISNULL((SELECT description FROM inventory WHERE idinventory = @idinventory), 'XXX')

INSERT INTO #situation VALUES (@descrinventory, NULL, 'H')
INSERT INTO #situation VALUES ('Numero ' + CONVERT(char(9), @ninventory), NULL, 'H')
INSERT INTO #situation VALUES (@assetacquire_description, null , 'H')
INSERT INTO #situation VALUES ('', NULL, 'N')
INSERT INTO #situation VALUES ('Carico Cespite', @tot_assetacquire, '')

DECLARE @tot_pieceacquire decimal(19,2)
SELECT
	@tot_pieceacquire =
	SUM(
		ROUND(
			ISNULL(assetacquire.taxable,0)
			*(1-ISNULL(assetacquire.discount*@flagdiscount,0))
			+ ROUND(ISNULL(assetacquire.tax,0),2)/assetacquire.number
			- ROUND(ISNULL(assetacquire.abatable,0),2)/assetacquire.number
		,2)
	)
FROM assetacquire
JOIN asset
	ON assetacquire.nassetacquire = asset.nassetacquire
WHERE asset.idasset = @idasset
	AND assetacquire.adate <= @date
	AND idpiece > 1
	AND assetacquire.idassetload IS NOT NULL

--PRINT @tot_pieceacquire

INSERT INTO #situation VALUES ('Carico Accessori', @tot_pieceacquire, '')
INSERT INTO #situation VALUES ('Totale carichi', ISNULL(@tot_assetacquire, 0) + ISNULL(@tot_pieceacquire, 0), 'S')  
INSERT  INTO #situation VALUES('',NULL,'N')

--------------------------------------------------------------------------------------------
----------- Rivalutazioni positive e negative di cespiti e accessori caricati --------------
----------- Da considerare se non ancora inclusi in un buono di scarico --------------------
----------- in questo caso considero la data (maria) ---------------------------------------
--------------------------------------------------------------------------------------------

DECLARE @amortized_asset decimal(19,2)
SELECT  @amortized_asset =
	SUM(ROUND(ISNULL(assetamortization.assetvalue,0) * 
	ISNULL(assetamortization.amortizationquota,0),2))
FROM assetamortization
JOIN asset
	ON  assetamortization.idasset = asset.idasset
	AND assetamortization.idpiece = asset.idpiece
JOIN assetacquire
	ON assetacquire.nassetacquire = asset.nassetacquire
JOIN inventoryamortization
	ON assetamortization.idinventoryamortization = inventoryamortization.idinventoryamortization
LEFT OUTER JOIN assetunload
	ON  assetamortization.idassetunload = assetunload.idassetunload
LEFT OUTER JOIN assetload
	ON  assetamortization.idassetload = assetload.idassetload
WHERE asset.idasset = @idasset AND asset.idpiece = 1
	AND (
 		     (assetamortization.amortizationquota >0 AND 
		     (
		      ((assetamortization.flag & 1 <> 1) AND assetamortization.adate <= @date) OR 
		      ((assetamortization.flag & 1 <> 0) AND assetload.ratificationdate <= @date))
		      )		     			

			OR
 		     (assetamortization.amortizationquota <0 AND 
		     (
		      ((assetamortization.flag & 1 <> 1) AND assetamortization.adate <= @date) OR 
		      ((assetamortization.flag & 1 <> 0) AND assetunload.adate <= @date))
		      )
		     )
		
	AND (inventoryamortization.flag & 2 <> 0)
	AND assetacquire.adate <= @date
	AND ((assetacquire.flag & 1 <> 1) OR assetacquire.idassetload IS NOT NULL)

DECLARE @amortized_piece decimal(19,2)
SELECT  @amortized_piece =
	SUM(ROUND(ISNULL(assetamortization.assetvalue,0) * 
	ISNULL(assetamortization.amortizationquota,0),2))
FROM assetamortization
JOIN asset
	ON  assetamortization.idasset=asset.idasset
	AND assetamortization.idpiece=asset.idpiece
JOIN assetacquire
	ON assetacquire.nassetacquire = asset.nassetacquire
JOIN inventoryamortization
	ON assetamortization.idinventoryamortization=inventoryamortization.idinventoryamortization
LEFT OUTER JOIN assetunload
	ON  assetamortization.idassetunload = assetunload.idassetunload
LEFT OUTER JOIN assetload
	ON  assetamortization.idassetload = assetload.idassetload
WHERE   asset.idasset = @idasset AND asset.idpiece > 1
	AND (

 		     (assetamortization.amortizationquota >0 AND 
		     (
		      ((assetamortization.flag & 1 <> 1) AND assetamortization.adate <= @date) OR 
		      ((assetamortization.flag & 1 <> 0) AND assetload.ratificationdate <= @date))
		      )		     

		OR
 	     (assetamortization.amortizationquota <0 AND 
	     (
		((assetamortization.flag & 1 <> 1) AND assetamortization.adate <= @date) OR 
		((assetamortization.flag & 1 <> 0) AND assetunload.adate <= @date))
 	     )
	    )
	AND (inventoryamortization.flag & 2 <> 0)
	AND assetacquire.adate <= @date
	AND ((assetacquire.flag & 1 <> 1) OR assetacquire.idassetload IS NOT NULL) 


--------------------------------------------------------------------------------------------
----------- Carichi accessori di cespiti scaricati -----------------------------------------
--------------------------------------------------------------------------------------------
 
DECLARE @tot_piece_loaded decimal(19,2)

SELECT
	@tot_piece_loaded =
	SUM(
		ROUND(
			ISNULL(caricoaccessorio.taxable,0)
			*(1-ISNULL(caricoaccessorio.discount*@flagdiscount,0))
			+ ROUND(ISNULL(caricoaccessorio.tax,0),2)/caricoaccessorio.number
			- ROUND(ISNULL(caricoaccessorio.abatable,0),2)/caricoaccessorio.number
		,2)
	)
FROM   assetacquire as caricoaccessorio
JOIN   asset as assetaccessorio
	ON caricoaccessorio.nassetacquire = assetaccessorio.nassetacquire
JOIN asset as assetcespite
	ON assetcespite.idasset = assetaccessorio.idasset
JOIN assetunload as assetunloadcespite
	ON assetunloadcespite.idassetunload = assetcespite.idassetunload
WHERE assetaccessorio.idasset = @idasset and assetaccessorio.idpiece > 1
	AND assetcespite.idpiece = 1
	AND (caricoaccessorio.idassetload IS NOT NULL)

--------------------------------------------------------------------------------------------
----------- Rivalutazioni ufficiali di accessori caricati di cespiti scaricati -------------
----  Da considerare se il cespite principale è incluso in un buono di scarico -------------
--------------------------------------------------------------------------------------------

DECLARE @tot_amort_piece_loaded decimal(19,2)

SELECT
	@tot_amort_piece_loaded =
	SUM(ROUND(ISNULL(assetamortization.assetvalue,0) * 
	ISNULL(assetamortization.amortizationquota,0),2))
FROM   assetamortization 
JOIN inventoryamortization
	ON assetamortization.idinventoryamortization = inventoryamortization.idinventoryamortization
JOIN   asset as assetaccessorio
	ON  assetamortization.idasset = assetaccessorio.idasset
	AND assetamortization.idpiece = assetaccessorio.idpiece
JOIN asset as assetcespite
	ON assetcespite.idasset = assetaccessorio.idasset
JOIN assetacquire as caricoaccessorio
	ON caricoaccessorio.nassetacquire = assetaccessorio.nassetacquire
JOIN assetunload as assetunloadcespite
	ON assetunloadcespite.idassetunload = assetcespite.idassetunload
WHERE assetaccessorio.idasset = @idasset and assetaccessorio.idpiece > 1
	AND assetcespite.idpiece=1
	AND (inventoryamortization.flag & 2 <> 0)
	AND (
		(
	     (ISNULL(assetamortization.amortizationquota,0)>0) AND 
             ((assetamortization.flag & 1 = 0) OR 
	      (assetamortization.idassetload IS NOT NULL))
	     )	    
			
		OR 
            
		(
	     (ISNULL(assetamortization.amortizationquota,0)<0) AND 
             ((assetamortization.flag & 1 <> 1) OR 
	      (assetamortization.idassetunload IS NOT NULL))
	     )
	    )
	AND caricoaccessorio.idassetload IS NOT NULL

print @tot_amort_piece_loaded

--------------------------------------------------------------------------------------------
-------------------------- Scarichi cespiti e accessori ------------------------------------
--------------------------------------------------------------------------------------------

DECLARE @assetunload decimal(19,2)	
SELECT  @assetunload =
	SUM(
		ROUND(
			ISNULL(assetacquire.taxable,0)
			*(1-ISNULL(assetacquire.discount*@flagdiscount,0))
			+ ROUND(ISNULL(assetacquire.tax,0),2)/assetacquire.number
			- ROUND(ISNULL(assetacquire.abatable,0),2)/assetacquire.number
		,2)
	)
FROM assetacquire
JOIN asset
	ON assetacquire.nassetacquire = asset.nassetacquire
JOIN assetunload
	ON assetunload.idassetunload = asset.idassetunload
WHERE asset.idasset = @idasset
	AND asset.idpiece=1
	AND assetunload.adate <= @date

DECLARE @pieceunload decimal(19,2)
SELECT  @pieceunload =
	SUM(
		ROUND(
			ISNULL(assetacquire.taxable,0)
			*(1-ISNULL(assetacquire.discount*@flagdiscount,0))
			+ ROUND(ISNULL(assetacquire.tax,0),2)/assetacquire.number
			- ROUND(ISNULL(assetacquire.abatable,0),2)/assetacquire.number
		,2)
	)
FROM assetacquire
JOIN asset
	ON assetacquire.nassetacquire = asset.nassetacquire
JOIN assetunload
	ON assetunload.idassetunload = asset.idassetunload
JOIN asset as cespite
	ON asset.idasset = cespite.idasset
LEFT OUTER JOIN assetunload as scaricocespite
	ON scaricocespite.idassetunload = cespite.idassetunload
WHERE asset.idasset = @idasset and cespite.idpiece = 1
	AND asset.idpiece>1 
	AND assetunload.adate <= @date
	AND assetunload.nassetunload <> ISNULL(scaricocespite.nassetunload,0)


--------------------------------------------------------------------------------------------
--------------------- Rivalutazioni positive e negative ufficiali --------------------------
---------------------- associate a scarichi Cespiti e Accessori  ---------------------------
--------------------------------------------------------------------------------------------

DECLARE @amortized_asset_unloaded decimal(19,2)
SELECT  @amortized_asset_unloaded =
	SUM(ROUND(ISNULL(assetamortization.assetvalue,0) * 
	ISNULL(assetamortization.amortizationquota,0),2))
FROM assetamortization
JOIN asset
	ON assetamortization.idasset=asset.idasset
	AND assetamortization.idpiece=asset.idpiece
JOIN inventoryamortization
	ON assetamortization.idinventoryamortization = inventoryamortization.idinventoryamortization
JOIN assetunload
	ON assetunload.idassetunload = asset.idassetunload
LEFT OUTER JOIN assetload
	ON  assetamortization.idassetload = assetload.idassetload
WHERE   asset.idasset = @idasset AND asset.idpiece = 1
	AND (
            (
	     (ISNULL(assetamortization.amortizationquota,0)>0) AND 
             ((assetamortization.flag & 1 <> 1) OR 
	      (assetload.ratificationdate IS NOT NULL))
	     )

		 OR 
            (
	     (ISNULL(assetamortization.amortizationquota,0)<0) AND 
             ((assetamortization.flag & 1 <> 1) OR 
	      (assetamortization.adate IS NOT NULL))
	     )
	    )
	AND (inventoryamortization.flag & 2 <> 0)
	AND assetunload.adate <= @date
	
	
DECLARE @amortized_piece_unloaded decimal(19,2)
SELECT  @amortized_piece_unloaded =
	SUM(ROUND(ISNULL(assetamortization.assetvalue,0) * 
	ISNULL(assetamortization.amortizationquota,0),2))
FROM assetamortization
JOIN asset 
	ON assetamortization.idasset = asset.idasset
	AND assetamortization.idpiece = asset.idpiece
JOIN inventoryamortization
	ON assetamortization.idinventoryamortization = inventoryamortization.idinventoryamortization
JOIN assetunload
	ON  assetunload.idassetunload = asset.idassetunload
JOIN asset as cespite
	ON asset.idasset = cespite.idasset
LEFT OUTER JOIN assetunload as scaricocespite
	ON scaricocespite.idassetunload = cespite.idassetunload
LEFT OUTER JOIN assetload A
	ON  assetamortization.idassetload = A.idassetload
WHERE asset.idasset = @idasset AND asset.idpiece > 1 and cespite.idpiece = 1
	AND (
             (
	     (ISNULL(assetamortization.amortizationquota,0) > 0) AND 
             ((assetamortization.flag & 1 <> 1) OR 
	      (A.ratificationdate IS NOT NULL))
	     )

		OR 

             (
	     (ISNULL(assetamortization.amortizationquota,0) < 0) AND 
             ((assetamortization.flag & 1 <> 1) OR 
	      (assetamortization.idassetunload IS NOT NULL))
	     )
	    )
	AND (inventoryamortization.flag & 2 <> 0)
	AND assetunload.adate <= @date
	AND assetunload.nassetunload <> ISNULL(scaricocespite.nassetunload,0)

-------------------------------------------------------------------------------------
---Scarichi Accessori di beni scaricati ---------------------------------------------
-------------------------------------------------------------------------------------
DECLARE @pieceunload_asset_unloaded decimal(19,2)
SELECT  @pieceunload_asset_unloaded =
	SUM(
		ROUND(
			ISNULL(assetacquire.taxable,0)
			*(1-ISNULL(assetacquire.discount*@flagdiscount,0))
			+ ROUND(ISNULL(assetacquire.tax,0),2)/assetacquire.number
			- ROUND(ISNULL(assetacquire.abatable,0),2)/assetacquire.number
		,2)
	)
FROM assetacquire
JOIN asset
	ON assetacquire.nassetacquire = asset.nassetacquire
JOIN asset as cespite
	ON  cespite.idasset = asset.idasset
	AND cespite.idpiece = 1
JOIN assetunload 
	ON  assetunload.idassetunload = cespite.idassetunload
WHERE asset.idasset = @idasset
	AND asset.idpiece > 1 
	AND (asset.idassetunload IS NOT NULL OR (asset.flag & 1 <> 1))
	AND assetacquire.idassetload IS NOT NULL
	
-------------------------------------------------------------------------------------
--RIVALUTAZIONI POSITIVE E NEGATIVE di Accessori SCARICATI di beni scaricati --------
-------------------------------------------------------------------------------------
	
DECLARE @amortization_pieceunload_asset_unloaded decimal(19,2)
SELECT  @amortization_pieceunload_asset_unloaded =
	SUM(ROUND(ISNULL(assetamortization.assetvalue,0) * 
	ISNULL(assetamortization.amortizationquota,0),2))
FROM assetamortization
JOIN asset 
	ON assetamortization.idasset=asset.idasset
	AND assetamortization.idpiece=asset.idpiece
JOIN assetacquire 
        ON assetacquire.nassetacquire = asset.nassetacquire
JOIN asset as cespite
	ON cespite.idasset=asset.idasset
	AND cespite.idpiece=1
JOIN inventoryamortization
	ON assetamortization.idinventoryamortization = inventoryamortization.idinventoryamortization
JOIN assetunload
	ON  assetunload.idassetunload = cespite.idassetunload
LEFT OUTER JOIN assetload A
	ON  assetamortization.idassetload = A.idassetload
WHERE asset.idasset = @idasset AND asset.idpiece>1
	AND (
             (
	     (ISNULL(assetamortization.amortizationquota,0)>0) AND 
             ((assetamortization.flag & 1 <> 1) OR 
	      (A.ratificationdate IS NOT NULL))
	     )

	OR 
             (
	     (ISNULL(assetamortization.amortizationquota,0)<0) AND 
             ((assetamortization.flag & 1 <> 1) OR 
	      (assetamortization.idassetunload IS NOT NULL))
	     )
	    )
	AND (inventoryamortization.flag & 2 <> 0)
	AND (asset.idassetunload IS NOT NULL OR (asset.flag & 1 <> 1))
	AND assetacquire.idassetload IS NOT NULL
	
DECLARE @tot_pieceunload decimal(19,2)
SELECT  @tot_pieceunload = ISNULL(@pieceunload,0) + ISNULL(@amortized_piece_unloaded,0)



DECLARE @tot_assetvariation decimal(19,2)

IF      (ISNULL(@assetunload,0)) >0 
BEGIN
SELECT @tot_assetvariation =
	ISNULL(@tot_piece_loaded,0) + 
	ISNULL(@amortized_asset,0)  +
	ISNULL(@tot_amort_piece_loaded,0) -
	ISNULL(@pieceunload,0)  -
	ISNULL(@amortized_piece_unloaded,0)
END
print 'inizio'
--print @assetunload
print ISNULL(@tot_piece_loaded,0) 
print ISNULL(@amortized_asset,0)  
print ISNULL(@tot_amort_piece_loaded,0)
print ISNULL(@pieceunload_asset_unloaded,0)
print ISNULL(@amortization_pieceunload_asset_unloaded,0)
print 'fine'
print   @assetunload
print   @tot_assetvariation
DECLARE @tot_assetunload decimal(19,2)

IF      (ISNULL(@assetunload,0)) >0 
BEGIN
	SELECT  @tot_assetunload = ISNULL(@tot_assetacquire,0) + ISNULL(@tot_assetvariation,0)
END	
ELSE    
BEGIN
	SELECT  @tot_assetunload = 0
END		   

INSERT  INTO #situation VALUES ('Scarico Cespite', @tot_assetunload,'')
INSERT  INTO #situation VALUES ('Scarico Accessori', @tot_pieceunload, '')
INSERT  INTO #situation VALUES ('Totale scarichi', @tot_pieceunload + @tot_assetunload , 'S')

declare @flagrival char(1)
set @flagrival='N'



INSERT  INTO #situation VALUES('',NULL,'H')
--INSERT INTO #situation VALUES('R I V A L U T A Z I O N I  E  S V A L U T A Z I O N I',NULL,'N')

DECLARE @idinventoryamortization varchar(20)
DECLARE @descr_inventoryamortization varchar(50)
DECLARE @tot_assetamortization decimal(19,2)
DECLARE @tot_pieceamortization decimal(19,2)
DECLARE @tot_assetamortization_unloaded decimal(19,2)
DECLARE @tot_pieceamortization_unloaded decimal(19,2)
DECLARE @tot_all_amortization decimal(19,2)
set @tot_all_amortization=0


DECLARE amortization_crs INSENSITIVE CURSOR FOR	
SELECT idinventoryamortization, description FROM inventoryamortization
				where (inventoryamortization.flag & 2 <> 0)
FOR READ ONLY
OPEN amortization_crs
FETCH NEXT FROM amortization_crs INTO @idinventoryamortization, @descr_inventoryamortization
WHILE (@@FETCH_STATUS = 0)
BEGIN
	---- Rivalutazioni e svalutazioni del cespite alla data
	SELECT
		@tot_assetamortization = SUM(ROUND(ISNULL(assetamortization.assetvalue,0) * 
					 ISNULL(assetamortization.amortizationquota,0),2))
	FROM assetamortization
	JOIN asset
		ON  assetamortization.idasset=asset.idasset
		AND assetamortization.idpiece=asset.idpiece
	JOIN assetacquire
		ON assetacquire.nassetacquire = asset.nassetacquire
	LEFT OUTER JOIN assetunload
		ON  assetamortization.idassetunload = assetunload.idassetunload
	LEFT OUTER JOIN assetload
		ON  assetamortization.idassetload = assetload.idassetload
	WHERE assetamortization.idasset = @idasset
		AND (
 		     (assetamortization.amortizationquota >0 AND 
		     (
		      ((assetamortization.flag & 1 <> 1) AND assetamortization.adate <= @date) OR 
		      ((assetamortization.flag & 1 <> 0) AND assetload.ratificationdate <= @date))
		      )

			OR
 		     (assetamortization.amortizationquota <0 AND 
		     (
		      ((assetamortization.flag & 1 <> 1) AND assetamortization.adate <= @date) OR 
		      ((assetamortization.flag & 1 <> 0) AND assetunload.adate <= @date))
		      )
		    )
		AND assetamortization.idpiece = 1   
		AND assetamortization.idinventoryamortization = @idinventoryamortization
		AND assetacquire.adate <= @date
		AND ((assetacquire.flag & 1 <> 1) OR assetacquire.idassetload IS NOT NULL) 


	
	---- Rivalutazioni e svalutazioni degli accessori alla data

	---- Questa SELECT è stata scritta x offrire maggiore chiarezza all'utente
	SELECT
		@tot_pieceamortization = SUM(ROUND(ISNULL(assetamortization.assetvalue,0) * 
					 ISNULL(assetamortization.amortizationquota,0),2))
	FROM assetamortization
	JOIN asset
		ON  assetamortization.idasset=asset.idasset
		AND assetamortization.idpiece=asset.idpiece
	JOIN assetacquire
		ON assetacquire.nassetacquire = asset.nassetacquire
	LEFT OUTER JOIN assetunload
		ON  assetamortization.idassetunload = assetunload.idassetunload
	LEFT OUTER JOIN assetload
		ON  assetamortization.idassetload = assetload.idassetload
	WHERE assetamortization.idasset = @idasset AND assetamortization.idpiece > 1
		AND (
			(assetamortization.amortizationquota >0 AND 
		     (
		      ((assetamortization.flag & 1 <> 1) AND assetamortization.adate <= @date) OR 
		      ((assetamortization.flag & 1 <> 0) AND assetload.ratificationdate <= @date))
		      )

		OR
 		     

			(assetamortization.amortizationquota <0 AND 
		     (
		      ((assetamortization.flag & 1 <> 1) AND assetamortization.adate <= @date) OR 
		      ((assetamortization.flag & 1 <> 0) AND assetunload.adate <= @date))
		      )
		     )
		AND assetamortization.idinventoryamortization = @idinventoryamortization
		AND assetacquire.adate <= @date
		AND ((assetacquire.flag & 1 <> 1) OR assetacquire.idassetload IS NOT NULL) 

	set @tot_assetamortization = ISNULL(@tot_assetamortization, 0)
	set @tot_pieceamortization= ISNULL(@tot_pieceamortization, 0)
	if (@tot_assetamortization<> 0) 
		INSERT INTO #situation VALUES (@descr_inventoryamortization + 'Cespite', @tot_assetamortization, '')
	if (@tot_pieceamortization <> 0)  
		INSERT INTO #situation VALUES (@descr_inventoryamortization + ' Accessori', @tot_pieceamortization, '')
	--if (@tot_pieceamortization<> 0 and @tot_assetamortization <> 0)  
	--		INSERT INTO #situation VALUES ('Totale ' + @descr_inventoryamortization, ISNULL(@tot_assetamortization, 0) + ISNULL(@tot_pieceamortization, 0),'') 

	if (@tot_pieceamortization<> 0 or @tot_assetamortization <> 0 )  
		set @flagrival='S'
	
	set @tot_all_amortization= @tot_all_amortization + @tot_assetamortization + @tot_pieceamortization
	/*
	SELECT  @tot_assetamortization_unloaded =
				SUM(ROUND(ISNULL(assetamortization.assetvalue,0) * 
				ISNULL(assetamortization.amortizationquota,0),2))
	FROM assetamortization
	JOIN asset
		ON assetamortization.idasset = asset.idasset
		AND assetamortization.idpiece = asset.idpiece
	JOIN assetunload
		ON assetunload.idassetunload = asset.idassetunload
	WHERE   asset.idasset = @idasset AND asset.idpiece = 1
		AND ((ISNULL(assetamortization.amortizationquota,0)>0) OR 
	            (
		     (ISNULL(assetamortization.amortizationquota,0)<0) AND 
	             ((assetamortization.flag & 1 <> 1) OR 
		      (assetamortization.idassetunload IS NOT NULL))
		     )
		    )
		AND assetamortization.idinventoryamortization = @idinventoryamortization
	
--------------------------------------------------------------------------------------------
----------- Rivalutazioni di accessori caricati di cespiti scaricati -----------------------
----  Da considerare se il cespite principale è incluso in un buono di scarico -------------
--------------------------------------------------------------------------------------------

	SELECT  @tot_pieceamortization_unloaded =
		SUM(ROUND(ISNULL(assetamortization.assetvalue,0) * 
		ISNULL(assetamortization.amortizationquota,0),2))
	FROM assetamortization
	JOIN asset
		ON assetamortization.idasset=asset.idasset
		AND assetamortization.idpiece=asset.idpiece
	JOIN asset as cespite
		ON cespite.idasset = asset.idasset
	JOIN assetunload
		ON assetunload.idassetunload = cespite.idassetunload
	WHERE   asset.idasset = @idasset AND asset.idpiece > 1 and cespite.idpiece = 1
		AND ((ISNULL(assetamortization.amortizationquota,0)>0) OR 
	            (
		     (ISNULL(assetamortization.amortizationquota,0)<0) AND 
	             ((assetamortization.flag & 1 <> 1) OR 
		      (assetamortization.idassetunload IS NOT NULL))
		     )
		    )
		AND assetamortization.idinventoryamortization = @idinventoryamortization
		AND (asset.idassetunload IS NOT NULL OR (asset.flag & 1 <> 1))
	
	DECLARE @tot_pieceamortization_unloaded_espliciti decimal(19,2)
	SELECT  @tot_pieceamortization_unloaded_espliciti =
		SUM(ROUND(ISNULL(assetamortization.assetvalue,0) * 
		ISNULL(assetamortization.amortizationquota,0),2))
	FROM assetamortization
	JOIN asset
		ON assetamortization.idasset=asset.idasset
		AND assetamortization.idpiece=asset.idpiece
	JOIN asset as cespite
		ON cespite.idasset = asset.idasset
	JOIN assetacquire
		ON asset.nassetacquire = assetacquire.nassetacquire
	JOIN assetunload
		ON assetunload.idassetunload = cespite.idassetunload
	WHERE   asset.idasset = @idasset AND asset.idpiece > 1 AND cespite.idpiece = 1
		AND ((ISNULL(assetamortization.amortizationquota,0)>0) OR 
	            (
		     (ISNULL(assetamortization.amortizationquota,0)<0) AND 
	             ((assetamortization.flag & 1 <> 1) OR 
		      (assetamortization.idassetunload IS NOT NULL))
		     )
		    )
		AND assetamortization.idinventoryamortization = @idinventoryamortization
		AND (asset.idassetunload IS NOT NULL OR (asset.flag & 1 <> 1))
		AND assetacquire.idassetload IS NOT NULL

	DECLARE @currvalue decimal(19,2)
	IF ISNULL(@assetunload,0)>0
	BEGIN
	SET @currvalue = 
		ISNULL(@tot_assetacquire, 0) 
		+ ISNULL(@tot_pieceacquire, 0)  
		+ ISNULL(@tot_assetamortization, 0)
		+ ISNULL(@tot_pieceamortization,0)  
		- ISNULL(@assetunload, 0) 
		- ISNULL(@pieceunload_asset_unloaded, 0) 
		- ISNULL(@tot_assetamortization_unloaded,0)  
		- ISNULL(@tot_pieceamortization_unloaded_espliciti,0)  
	END
	ELSE
	BEGIN
		SET @currvalue = 
		ISNULL(@tot_assetacquire, 0) 
		+ ISNULL(@tot_pieceacquire, 0)  
		+ ISNULL(@tot_assetamortization, 0)
		+ ISNULL(@tot_pieceamortization,0)  
		- ISNULL(@pieceunload, 0) 
		- ISNULL(@tot_pieceamortization_unloaded,0)  
	END

	INSERT INTO #situation VALUES ('Valore Corrente Cespite ( con ' + @descr_inventoryamortization + ' )', 
		@currvalue, 'S')
	*/
print ISNULL(@tot_pieceacquire,0)
FETCH NEXT FROM amortization_crs INTO @idinventoryamortization, @descr_inventoryamortization
END

-- Valore Storico del Bene
declare @historical decimal(19,2)
select @historical = historicalvalue from assetacquire AC 
			join asset A on A.nassetacquire=AC.nassetacquire
			where A.idasset=@idasset and A.idpiece=1
-- Ammortamenti Pregressi = Valore iniziale storico - Valore caricato
declare @previous_assetamortization decimal(19,2)
if( isnull(@historical,0)>0)
Begin
	SET @previous_assetamortization = @historical - isnull(@tot_assetacquire,0)
	if (@previous_assetamortization <> 0) 
	Begin
		INSERT INTO #situation VALUES ('Ammortamenti Pregressi Cespite', @previous_assetamortization, '')
		SET @flagrival = 'S'
		SET @tot_all_amortization = @tot_all_amortization + @previous_assetamortization
	End
End

DEALLOCATE amortization_crs
if (@flagrival='N')
	INSERT INTO #situation VALUES('Nessuna rivalutazione o svalutazione',NULL,'N')	
ELSE 
	INSERT INTO #situation VALUES ('Totale rivalutazioni e svalutazioni', @tot_all_amortization, 'S')  


INSERT INTO #situation VALUES('',NULL,'H')

DECLARE @currvalue1 decimal(19,2)
IF ISNULL(@assetunload,0)>0
	BEGIN
	SET @currvalue1 = 
		ISNULL(@tot_assetacquire, 0) 
		+ ISNULL(@tot_pieceacquire, 0)  
		+ ISNULL(@amortized_asset, 0)
		+ ISNULL(@amortized_piece,0)  
		- ISNULL(@assetunload, 0) 
		- ISNULL(@pieceunload_asset_unloaded, 0) 
		- ISNULL(@amortized_asset_unloaded,0)  
		- ISNULL(@amortization_pieceunload_asset_unloaded,0)  
	END
	ELSE
	BEGIN
		SET @currvalue1 = 
		ISNULL(@tot_assetacquire, 0) 
		+ ISNULL(@tot_pieceacquire, 0)  
		+ ISNULL(@amortized_asset, 0)
		+ ISNULL(@amortized_piece,0)  
		- ISNULL(@pieceunload, 0) 
		- ISNULL(@amortized_piece_unloaded,0)  
	END

print ISNULL(@tot_assetacquire, 0) 
print ISNULL(@tot_pieceacquire, 0)  
print ISNULL(@amortized_asset, 0)
print ISNULL(@amortized_piece,0)  
print ISNULL(@assetunload, 0) 
print ISNULL(@pieceunload_asset_unloaded, 0) 
print ISNULL(@amortized_asset_unloaded,0)  
print ISNULL(@amortization_pieceunload_asset_unloaded,0)  
INSERT INTO #situation VALUES ('Valore residuo cespite e accessori', 
	@currvalue1, 'S')	

SELECT value, amount, kind FROM #situation
END


GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO
