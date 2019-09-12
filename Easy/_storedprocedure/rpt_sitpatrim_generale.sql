if exists (select * from dbo.sysobjects where id = object_id(N'[rpt_sitpatrim_generale]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [rpt_sitpatrim_generale]
GO


SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO
 
CREATE    PROCEDURE [rpt_sitpatrim_generale]
	@year int,
	@codinventoryagency int =null,
	@date datetime=null,	
	@showmotive char(1)='N',
	@idinventory int

AS BEGIN
-- setuser 'amm'
-- exec [rpt_sitpatrim_generale] 2016, null, '2016-31-12', 'S',  null
-- exec [rpt_sitpatrim_generale] 2016, null, '2016-31-12', 'N',  null
DECLARE @firstday datetime
SET @firstday = CONVERT(datetime, '01-01-' + CONVERT(char(4),@year), 105)
if (@date is null) SET @date = CONVERT(datetime, '31-12-' + CONVERT(char(4),@year), 105)



CREATE TABLE #assetloadmotive
(
idmot  int,
codemot varchar(20),
description  varchar(50)
)
INSERT INTO #assetloadmotive
(idmot, codemot, description)
SELECT idmot, codemot, description
FROM assetloadmotive
UNION
SELECT
null, null,null


CREATE TABLE #patrimonio
(
	idinventoryagency int,
	idinv int,
	description varchar(150),
	initial_amount decimal(19,2), --somma valore iniziale  di tutti i cespiti e accessori sino all'anno precedente e non scaricati sino all'anno scorso
	final_amount decimal(19,2), 
	idmot int,
	var_aum decimal(19,2),   -- carichi di quest'anno
	var_dim decimal(19,2),	 -- scarichi di quest'anno

	-- Rivalutazioni Positive e Negative ufficiali  (di BENI E DI ACCESSORI) sino all'anno scorso, di cespiti non ancora scaricati nell'anno attuale
	-- COLONNA 5  "Ammortamenti pregressi di cespiti in carico nel "
	ammortization_pre_in_carico decimal(19,2),  


	-- Rivalutazioni Positive e Negative ufficiali  (di BENI E DI ACCESSORI) sino all'anno scorso purch� RISULTINO SCARICATI IN QUEST'ANNO
	-- COLONNA 6 "Ammortamenti pregressi di cespiti scaricati nel " 
	ammortization_pre_scaricati decimal(19,2),
	

	-- Rivalutazioni Positive e Negative ufficiali  (di BENI E DI ACCESSORI) di QUESTO ANNO, di cespiti non ancora scaricati nell'anno attuale
	-- COLONNA 8
	ammortization_post decimal(19,2)

			
	
)

	
-------------------------------------------------------------------------------------
-------------------------- Situazione patrim. iniziale-------------------------------
-------------------------------------------------------------------------------------


---------------------------------------------------------------------------------------------------------------------------
---------------- COLONNA 1 Carichi cespite E accessori  DI ANNI PRECEDENTI ANCORA IN CARICO l'anno prec. -----------------
----- "Consistenza iniziale storica"  
---------------------------------------------------------------------------------------------------------------------------
INSERT INTO #patrimonio(idinventoryagency,idinv,idmot,initial_amount)
SELECT 	inventory.idinventoryagency,	inventorytreelink.idparent,	assetacquire.idmot,	SUM(AC.start)
FROM assetacquire 
JOIN asset					ON assetacquire.nassetacquire = asset.nassetacquire
JOIN assetview_current AC	on AC.idasset=asset.idasset and AC.idpiece=asset.idpiece	
JOIN assetload				ON assetload.idassetload = assetacquire.idassetload
JOIN inventory				ON assetacquire.idinventory = inventory.idinventory
JOIN inventorykind			ON inventory.idinventorykind= inventorykind.idinventorykind
JOIN inventorytreelink		ON inventorytreelink.idchild = assetacquire.idinv
LEFT OUTER JOIN assetunload AU	ON  asset.idassetunload = AU.idassetunload

WHERE 
	inventorytreelink.nlevel = 1
	AND assetload.ratificationdate < @firstday 
	AND (inventory.idinventoryagency = @codinventoryagency OR @codinventoryagency IS NULL)	
	AND ( (inventorykind.flag&2)=0) --inventario visibile
	AND (assetacquire.idinventory = @idinventory OR @idinventory IS NULL) 
	AND (AU.adate is null or AU.adate >= @firstday )  ---cespite ancora in carico l'anno scorso

GROUP BY inventory.idinventoryagency, inventorytreelink.idparent, assetacquire.idmot
	


INSERT INTO #patrimonio(idinventoryagency,idinv,idmot,initial_amount)
SELECT 	inventory.idinventoryagency,	inventorytreelink.idparent,	assetacquire.idmot,	-SUM(AC.start)
FROM assetacquire 
JOIN asset					ON assetacquire.nassetacquire = asset.nassetacquire
join assetacquire B			on B.nassetacquire = asset.nassetacquire
JOIN assetview_current AC	on AC.idasset=asset.idasset and AC.idpiece=asset.idpiece	
LEFT OUTER JOIN assetload	ON assetload.idassetload = assetacquire.idassetload
JOIN inventory				ON assetacquire.idinventory = inventory.idinventory
JOIN inventorykind			ON inventory.idinventorykind= inventorykind.idinventorykind
JOIN inventorytreelink		ON inventorytreelink.idchild = assetacquire.idinv
JOIN assetunload AU	ON  asset.idassetunload = AU.idassetunload
WHERE 
	inventorytreelink.nlevel = 1 and AC.idpiece>1 
	AND assetload.idassetload is null	
	AND (inventory.idinventoryagency = @codinventoryagency OR @codinventoryagency IS NULL)	
	AND ( (inventorykind.flag&2)=0)   --inventario visibile
	AND (assetacquire.idinventory = @idinventory OR @idinventory IS NULL) 
	AND AU.adate < @firstday ---accessorio scaricato prima di quest'anno
	and  ((B.flag & 1 <> 1) AND (B.flag & 2 <> 0)) 

GROUP BY inventory.idinventoryagency, inventorytreelink.idparent, assetacquire.idmot

	
-------------------------------------------------------------------------------------
--------- COLONNA 2  Carichi cespite E accessori di quest'anno  ---------------------
-------------------------------------------------------------------------------------
INSERT INTO #patrimonio(idinventoryagency,idinv,idmot,var_aum)
SELECT 	inventory.idinventoryagency,	inventorytreelink.idparent,	assetacquire.idmot,	SUM(AC.start)
FROM assetacquire 
JOIN asset					ON assetacquire.nassetacquire = asset.nassetacquire
JOIN assetview_current AC	on AC.idasset=asset.idasset and AC.idpiece=asset.idpiece	
JOIN assetload				ON assetload.idassetload = assetacquire.idassetload
JOIN inventory				ON assetacquire.idinventory = inventory.idinventory
JOIN inventorykind			ON inventory.idinventorykind= inventorykind.idinventorykind
JOIN inventorytreelink		ON inventorytreelink.idchild = assetacquire.idinv
WHERE 
	inventorytreelink.nlevel = 1
	AND assetload.ratificationdate BETWEEN @firstday AND @date
	AND (inventory.idinventoryagency = @codinventoryagency OR @codinventoryagency IS NULL)	
	AND ( (inventorykind.flag&2)=0)
	AND (assetacquire.idinventory = @idinventory OR @idinventory IS NULL) 
GROUP BY inventory.idinventoryagency, inventorytreelink.idparent, assetacquire.idmot
	


------------------------------------------------------------------------------------
------- COLONNA 3  Scarichi Cespite E accessori  DI QUESTO ANNO --------------------
------------------------------------------------------------------------------------


INSERT INTO #patrimonio(idinventoryagency,idinv,idmot,var_dim)
SELECT
	inventory.idinventoryagency,inventorytreelink.idparent, 	assetacquire.idmot,	SUM(AC.start)
FROM assetacquire
JOIN asset								ON assetacquire.nassetacquire = asset.nassetacquire
JOIN assetview_current AC				on AC.idasset=asset.idasset and AC.idpiece=asset.idpiece	
JOIN assetunload						ON assetunload.idassetunload = asset.idassetunload
JOIN inventory							ON assetacquire.idinventory = inventory.idinventory
JOIN inventorykind						ON inventory.idinventorykind= inventorykind.idinventorykind   
JOIN inventorytreelink					ON inventorytreelink.idchild = assetacquire.idinv
WHERE  inventorytreelink.nlevel = 1
	AND assetunload.adate BETWEEN @firstday AND @date
	AND (inventory.idinventoryagency = @codinventoryagency OR @codinventoryagency IS NULL )	
	AND ( (inventorykind.flag&2)=0)
	AND (assetacquire.idinventory = @idinventory OR @idinventory IS NULL) 
GROUP BY inventory.idinventoryagency, inventorytreelink.idparent,assetacquire.idmot





---------------------------------------------------------------------------------------------------------------------------
---------------- COLONNA 4 Carichi cespite E accessori  ANCORA IN CARICO -------------------------------
-------  "Consistenza finale storica" 
---------------------------------------------------------------------------------------------------------------------------
INSERT INTO #patrimonio(idinventoryagency,idinv,idmot,final_amount)
SELECT 	inventory.idinventoryagency,	inventorytreelink.idparent,	assetacquire.idmot,	SUM(AC.start)
FROM assetacquire 
JOIN asset					ON assetacquire.nassetacquire = asset.nassetacquire
JOIN assetview_current AC	on AC.idasset=asset.idasset and AC.idpiece=asset.idpiece	
JOIN assetload				ON assetload.idassetload = assetacquire.idassetload
JOIN inventory				ON assetacquire.idinventory = inventory.idinventory
JOIN inventorykind			ON inventory.idinventorykind= inventorykind.idinventorykind
JOIN inventorytreelink		ON inventorytreelink.idchild = assetacquire.idinv
LEFT OUTER JOIN assetunload AU	ON  asset.idassetunload = AU.idassetunload

WHERE 
	inventorytreelink.nlevel = 1
	AND assetload.ratificationdate <= @date 
	AND (inventory.idinventoryagency = @codinventoryagency OR @codinventoryagency IS NULL)	
	AND ( (inventorykind.flag&2)=0) --inventario visibile
	AND (assetacquire.idinventory = @idinventory OR @idinventory IS NULL) 
	AND (AU.adate is null or AU.adate >@date)  ---cespite non ancora scaricato quest'anno

GROUP BY inventory.idinventoryagency, inventorytreelink.idparent, assetacquire.idmot


INSERT INTO #patrimonio(idinventoryagency,idinv,idmot,final_amount)
SELECT 	inventory.idinventoryagency,	inventorytreelink.idparent,	assetacquire.idmot,	-SUM(AC.start)
FROM assetacquire 
JOIN asset					ON assetacquire.nassetacquire = asset.nassetacquire
join assetacquire B			on B.nassetacquire = asset.nassetacquire
JOIN assetview_current AC	on AC.idasset=asset.idasset and AC.idpiece=asset.idpiece	
LEFT OUTER JOIN assetload	ON assetload.idassetload = assetacquire.idassetload
JOIN inventory				ON assetacquire.idinventory = inventory.idinventory
JOIN inventorykind			ON inventory.idinventorykind= inventorykind.idinventorykind
JOIN inventorytreelink		ON inventorytreelink.idchild = assetacquire.idinv
JOIN assetunload AU	ON  asset.idassetunload = AU.idassetunload
WHERE 
	inventorytreelink.nlevel = 1 and AC.idpiece>1 
	AND assetload.idassetload is null
	AND (inventory.idinventoryagency = @codinventoryagency OR @codinventoryagency IS NULL)	
	AND ( (inventorykind.flag&2)=0)   --inventario visibile
	AND (assetacquire.idinventory = @idinventory OR @idinventory IS NULL) 
	--AND AU.adate BETWEEN @firstday AND @date ---accessorio scaricato quest'anno
	AND AU.adate <= @date ---accessorio scaricato prima di quest'anno
	and  ((B.flag & 1 <> 1) AND (B.flag & 2 <> 0)) 

GROUP BY inventory.idinventoryagency, inventorytreelink.idparent, assetacquire.idmot





-------------------------------------------------------------------------------------
------ COLONNA 5 "Ammortamenti pregressi di cespiti in carico nel "
------ Ammortamenti PREGRESSI di cespiti ancora in carico nell'anno corrente
-------------------------------------------------------------------------------------

---Ammortamenti 
INSERT INTO #patrimonio(idinventoryagency,idinv,idmot,ammortization_pre_in_carico)
SELECT 	inventory.idinventoryagency,inventorytreelink.idparent, assetacquire.idmot,
	-SUM(ROUND(ISNULL(assetamortization.assetvalue,0) * ISNULL(assetamortization.amortizationquota,0),2))
FROM assetacquire
JOIN asset					ON assetacquire.nassetacquire = asset.nassetacquire
JOIN assetamortization		ON assetamortization.idasset = asset.idasset and assetamortization.idpiece = asset.idpiece
LEFT OUTER JOIN assetunload	ON  assetamortization.idassetunload = assetunload.idassetunload
LEFT OUTER JOIN assetunload AU	ON  asset.idassetunload = AU.idassetunload
JOIN inventory					ON inventory.idinventory = assetacquire.idinventory
JOIN inventorykind				ON inventory.idinventorykind= inventorykind.idinventorykind
JOIN inventoryamortization		ON inventoryamortization.idinventoryamortization = assetamortization.idinventoryamortization
JOIN inventorytreelink			ON inventorytreelink.idchild = assetacquire.idinv
WHERE  
	inventorytreelink.nlevel = 1
	AND (inventoryamortization.flag & 2 <> 0)
	AND assetamortization.amortizationquota < 0  AND
	(
		(
		 ((assetamortization.flag & 1 = 0)	  AND assetamortization.adate < @firstday ) 
		  OR 
		  ((assetamortization.flag & 1 <> 0)  AND assetunload.adate < @firstday)
		)
	)
	AND (inventory.idinventoryagency = @codinventoryagency OR @codinventoryagency IS NULL )
	AND (AU.adate is null or AU.adate >@date)  ---cespite non ancora scaricato quest'anno
	AND ( (inventorykind.flag&2)=0)
	AND (assetacquire.idinventory = @idinventory OR @idinventory IS NULL) 
	--AND (inventoryamortization.flag &8) <> 0 -- Considera solo i tipo ammortamento : Ammortamento
GROUP BY inventory.idinventoryagency, inventorytreelink.idparent, assetacquire.idmot


--Rivalutazioni
INSERT INTO #patrimonio(idinventoryagency,idinv,idmot,ammortization_pre_in_carico)
SELECT 	inventory.idinventoryagency,	inventorytreelink.idparent,	assetacquire.idmot,
	-SUM(ROUND(ISNULL(assetamortization.assetvalue,0) * ISNULL(assetamortization.amortizationquota,0),2))
FROM assetacquire
JOIN asset					ON assetacquire.nassetacquire = asset.nassetacquire
JOIN assetamortization		ON assetamortization.idasset = asset.idasset and assetamortization.idpiece = asset.idpiece
LEFT OUTER JOIN assetload		ON  assetamortization.idassetload = assetload.idassetload
LEFT OUTER JOIN assetunload AU	ON  asset.idassetunload = AU.idassetunload
JOIN inventory					ON inventory.idinventory = assetacquire.idinventory
JOIN inventorykind				ON inventory.idinventorykind= inventorykind.idinventorykind
JOIN inventoryamortization		ON inventoryamortization.idinventoryamortization = assetamortization.idinventoryamortization
JOIN inventorytreelink			ON inventorytreelink.idchild = assetacquire.idinv
WHERE  
	inventorytreelink.nlevel = 1
	AND (inventoryamortization.flag & 2 <> 0)
	AND assetamortization.amortizationquota > 0  AND
	(
		(
		 ((assetamortization.flag & 1 = 0)  AND assetamortization.adate < @firstday) 
		  OR 
		  ((assetamortization.flag & 1 <> 0)AND assetload.ratificationdate < @firstday)
		)
	)
	AND (inventory.idinventoryagency = @codinventoryagency OR @codinventoryagency IS NULL )
	AND (AU.adate is null or AU.adate >@date)  ---cespite non ancora scaricato quest'anno
	AND ( (inventorykind.flag&2)=0)
	AND (assetacquire.idinventory = @idinventory OR @idinventory IS NULL) 
	--AND (inventoryamortization.flag &8) <> 0 -- Considera solo i tipo ammortamento : Ammortamento
GROUP BY inventory.idinventoryagency, inventorytreelink.idparent, assetacquire.idmot
	 
	

-------------------------------------------------------------------------------------
------ COLONNA 6
------ Ammortamenti pregressi di cespiti scaricati nell'anno corrente
-------------------------------------------------------------------------------------

---Ammortamenti 
INSERT INTO #patrimonio(idinventoryagency,idinv,idmot,ammortization_pre_scaricati)
SELECT 	inventory.idinventoryagency,inventorytreelink.idparent, assetacquire.idmot,
	-SUM(ROUND(ISNULL(assetamortization.assetvalue,0) * ISNULL(assetamortization.amortizationquota,0),2))
FROM assetacquire
JOIN asset					ON assetacquire.nassetacquire = asset.nassetacquire
JOIN assetamortization		ON assetamortization.idasset = asset.idasset and assetamortization.idpiece = asset.idpiece
LEFT OUTER JOIN assetunload	ON  assetamortization.idassetunload = assetunload.idassetunload
LEFT OUTER JOIN assetunload AU	ON  asset.idassetunload = AU.idassetunload
JOIN inventory					ON inventory.idinventory = assetacquire.idinventory
JOIN inventorykind				ON inventory.idinventorykind= inventorykind.idinventorykind
JOIN inventoryamortization		ON inventoryamortization.idinventoryamortization = assetamortization.idinventoryamortization
JOIN inventorytreelink			ON inventorytreelink.idchild = assetacquire.idinv
WHERE  
	inventorytreelink.nlevel = 1
	AND (inventoryamortization.flag & 2 <> 0)
	AND assetamortization.amortizationquota < 0  AND
	(
		(
		 ((assetamortization.flag & 1 = 0)	  AND assetamortization.adate < @firstday) 
		  OR 
		  ((assetamortization.flag & 1 <> 0)  AND assetunload.adate < @firstday)
		)
	)
	AND (inventory.idinventoryagency = @codinventoryagency OR @codinventoryagency IS NULL )
	AND (AU.adate BETWEEN @firstday AND @date)  ---cespite scaricato quest'anno
	AND ( (inventorykind.flag&2)=0)
	AND (assetacquire.idinventory = @idinventory OR @idinventory IS NULL) 
	--AND (inventoryamortization.flag &8) <> 0 -- Considera solo i tipo ammortamento : Ammortamento
GROUP BY inventory.idinventoryagency, inventorytreelink.idparent, assetacquire.idmot


--Rivalutazioni
INSERT INTO #patrimonio(idinventoryagency,idinv,idmot,ammortization_pre_scaricati)
SELECT 	inventory.idinventoryagency,	inventorytreelink.idparent,	assetacquire.idmot,
	-SUM(ROUND(ISNULL(assetamortization.assetvalue,0) * ISNULL(assetamortization.amortizationquota,0),2))
FROM assetacquire
JOIN asset					ON assetacquire.nassetacquire = asset.nassetacquire
JOIN assetamortization		ON assetamortization.idasset = asset.idasset and assetamortization.idpiece = asset.idpiece
LEFT OUTER JOIN assetload		ON  assetamortization.idassetload = assetload.idassetload
LEFT OUTER JOIN assetunload AU	ON  asset.idassetunload = AU.idassetunload
JOIN inventory					ON inventory.idinventory = assetacquire.idinventory
JOIN inventorykind				ON inventory.idinventorykind= inventorykind.idinventorykind
JOIN inventoryamortization		ON inventoryamortization.idinventoryamortization = assetamortization.idinventoryamortization
JOIN inventorytreelink			ON inventorytreelink.idchild = assetacquire.idinv
WHERE  
	inventorytreelink.nlevel = 1
	AND (inventoryamortization.flag & 2 <> 0)
	AND assetamortization.amortizationquota > 0  AND
	(
		(
		 ((assetamortization.flag & 1 = 0)  AND assetamortization.adate < @firstday) 
		  OR 
		  ((assetamortization.flag & 1 <> 0)AND assetload.ratificationdate < @firstday)
		)
	)
	AND (inventory.idinventoryagency = @codinventoryagency OR @codinventoryagency IS NULL )
	AND (AU.adate BETWEEN @firstday AND @date)  ---cespite scaricato quest'anno
	AND ( (inventorykind.flag&2)=0)
	AND (assetacquire.idinventory = @idinventory OR @idinventory IS NULL) 
	--AND (inventoryamortization.flag &8) <> 0 -- Considera solo i tipo ammortamento : Ammortamento
GROUP BY inventory.idinventoryagency, inventorytreelink.idparent, assetacquire.idmot



-------------------------------------------------------------------------------------
------ COLONNA 8  Ammortamenti di cespiti non ancora scaricati nell'anno attuale
------ Ammortamenti di quest'anno
-------------------------------------------------------------------------------------

---Ammortamenti 
INSERT INTO #patrimonio(idinventoryagency,idinv,idmot,ammortization_post)
SELECT 	inventory.idinventoryagency,inventorytreelink.idparent, assetacquire.idmot,
	-SUM(ROUND(ISNULL(assetamortization.assetvalue,0) * ISNULL(assetamortization.amortizationquota,0),2))
FROM assetacquire
JOIN asset					ON assetacquire.nassetacquire = asset.nassetacquire
JOIN assetamortization		ON assetamortization.idasset = asset.idasset and assetamortization.idpiece = asset.idpiece
LEFT OUTER JOIN assetunload	ON  assetamortization.idassetunload = assetunload.idassetunload
LEFT OUTER JOIN assetunload AU	ON  asset.idassetunload = AU.idassetunload
JOIN inventory					ON inventory.idinventory = assetacquire.idinventory
JOIN inventorykind				ON inventory.idinventorykind= inventorykind.idinventorykind
JOIN inventoryamortization		ON inventoryamortization.idinventoryamortization = assetamortization.idinventoryamortization
JOIN inventorytreelink			ON inventorytreelink.idchild = assetacquire.idinv
WHERE  
	inventorytreelink.nlevel = 1
	AND (inventoryamortization.flag & 2 <> 0)
	AND assetamortization.amortizationquota < 0  AND
	(
		(
		 ((assetamortization.flag & 1 = 0)	  AND assetamortization.adate BETWEEN @firstday AND @date)  --ammortamenti di quest'anno
		  OR 
		  ((assetamortization.flag & 1 <> 0)  AND assetunload.adate BETWEEN @firstday AND @date)
		)
	)
	AND (inventory.idinventoryagency = @codinventoryagency OR @codinventoryagency IS NULL )
	AND (AU.adate is null OR AU.adate > @date)  ---cespite non ancora scaricato
	AND ( (inventorykind.flag&2)=0)
	AND (assetacquire.idinventory = @idinventory OR @idinventory IS NULL) 
	--AND (inventoryamortization.flag &8) <> 0 -- Considera solo i tipo ammortamento : Ammortamento
GROUP BY inventory.idinventoryagency, inventorytreelink.idparent, assetacquire.idmot


--Rivalutazioni
INSERT INTO #patrimonio(idinventoryagency,idinv,idmot,ammortization_post)
SELECT 	inventory.idinventoryagency,	inventorytreelink.idparent,	assetacquire.idmot,
	-SUM(ROUND(ISNULL(assetamortization.assetvalue,0) * ISNULL(assetamortization.amortizationquota,0),2))
FROM assetacquire
JOIN asset					ON assetacquire.nassetacquire = asset.nassetacquire
JOIN assetamortization		ON assetamortization.idasset = asset.idasset and assetamortization.idpiece = asset.idpiece
LEFT OUTER JOIN assetload		ON  assetamortization.idassetload = assetload.idassetload
LEFT OUTER JOIN assetunload AU	ON  asset.idassetunload = AU.idassetunload
JOIN inventory					ON inventory.idinventory = assetacquire.idinventory
JOIN inventorykind				ON inventory.idinventorykind= inventorykind.idinventorykind
JOIN inventoryamortization		ON inventoryamortization.idinventoryamortization = assetamortization.idinventoryamortization
JOIN inventorytreelink			ON inventorytreelink.idchild = assetacquire.idinv
WHERE  
	inventorytreelink.nlevel = 1
	AND (inventoryamortization.flag & 2 <> 0)
	AND assetamortization.amortizationquota > 0  AND
	(
		(
		 ((assetamortization.flag & 1 = 0)  AND assetamortization.adate BETWEEN @firstday AND @date)   --rivalutazioni di quest'anno
		  OR 
		  ((assetamortization.flag & 1 <> 0)AND assetload.ratificationdate BETWEEN @firstday AND @date)
		)
	)
	AND (inventory.idinventoryagency = @codinventoryagency OR @codinventoryagency IS NULL )
	AND (AU.adate is null OR AU.adate > @date)  ---cespite non ancora scaricato
	AND ( (inventorykind.flag&2)=0)
	AND (assetacquire.idinventory = @idinventory OR @idinventory IS NULL) 
	--AND (inventoryamortization.flag &8) <> 0 -- Considera solo i tipo ammortamento : Ammortamento
GROUP BY inventory.idinventoryagency, inventorytreelink.idparent, assetacquire.idmot






DECLARE @MostraAvanzoCassa char(1)
SELECT  @MostraAvanzoCassa = isnull(paramvalue,'N')
FROM    reportadditionalparam
WHERE   paramname = 'MostraAvanzoCassa' and reportname='rpt_sitpatrim_generale'

IF (Upper(@MostraAvanzoCassa)='S')
Begin
	DECLARE @startfloatfund decimal(19,2)
	DECLARE @aumfloatfund decimal(19,2)
	DECLARE @dimfloatfund decimal(19,2)

	SELECT 
		@startfloatfund = ISNULL(startfloatfund, 0.0),
	        @aumfloatfund = ISNULL(competencyproceeds, 0.0) + ISNULL(residualproceeds, 0.0),
	        @dimfloatfund = ISNULL(competencypayments, 0.0) + ISNULL(residualpayments, 0.0)
	FROM surplus
	WHERE ayear = @year
	
	INSERT INTO #patrimonio (idsor, idmot, description, initial_amount, var_aum, var_dim)
	VALUES('9999','9999','Avanzo di cassa', @startfloatfund, @aumfloatfund, @dimfloatfund)
End


declare @inventory varchar(50)
select @inventory = description from inventory where idinventory = @idinventory

IF (@showmotive= 'S') 
BEGIN
	SELECT 
		ENTE.codeinventoryagency AS 'codinventoryagency',
		ENTE.description as 'descinventoryagency',
		#patrimonio.idinv as idsor,
		CLASS.codeinv as 'codesor',
		CLASS.nlevel,
		#patrimonio.idmot,
		MOTIVE.description as 'motive',
		CLASS.description,
		initial_amount as 'initial_amount',
		var_aum ,
		var_dim ,
		ammortization_pre_in_carico,
		ammortization_pre_scaricati,
		final_amount,
		ammortization_post ,
		@date as 'stop',
		@inventory as 'inventory'
	FROM #patrimonio
	LEFT OUTER JOIN inventorytree CLASS 		ON CLASS.idinv = #patrimonio.idinv
	LEFT OUTER JOIN inventoryagency	ENTE		ON ENTE.idinventoryagency = #patrimonio.idinventoryagency
	LEFT OUTER JOIN #assetloadmotive MOTIVE		ON MOTIVE.idmot = ISNULL(#patrimonio.idmot,0)
	ORDER BY ENTE.codeinventoryagency,#patrimonio.idmot, CLASS.codeinv
END
ELSE
BEGIN
	SELECT 
		ENTE.codeinventoryagency AS 'codinventoryagency',
		ENTE.description as 'descinventoryagency',
		#patrimonio.idinv as idsor,
		CLASS.codeinv as 'codesor',
		CLASS.nlevel,
		null as 'idmot',
		null as 'motive',
		CLASS.description,
		ISNULL(SUM(initial_amount),0) as 'initial_amount',
		ISNULL(SUM(var_aum),0) as 'var_aum',
		ISNULL(SUM(var_dim),0) as 'var_dim',
		ISNULL(SUM(ammortization_pre_in_carico),0) as 'ammortization_pre_in_carico',
		ISNULL(SUM(ammortization_pre_scaricati),0) as 'ammortization_pre_scaricati',
		ISNULL(SUM(final_amount),0) as 'final_amount',		  
		ISNULL(SUM(ammortization_post),0) as 'ammortization_post',
		--ISNULL(SUM(initial_amount),0)+ISNULL(SUM(var_aum),0)-ISNULL(SUM(var_dim),0)-ISNULL(SUM(amortization_pre),0)-ISNULL(SUM(amortization_post),0) as 'total',
		@date as 'stop',
		@inventory as 'inventory'
	FROM #patrimonio
	LEFT OUTER JOIN inventorytree CLASS  	ON CLASS.idinv = #patrimonio.idinv
	LEFT OUTER JOIN inventoryagency	ENTE   	ON ENTE.idinventoryagency = #patrimonio.idinventoryagency
	GROUP BY ENTE.codeinventoryagency, ENTE.description,#patrimonio.idinv, CLASS.codeinv, CLASS.nlevel,CLASS.description
	ORDER BY  ENTE.codeinventoryagency, CLASS.codeinv
END
END


GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO


