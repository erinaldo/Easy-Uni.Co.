if exists (select * from dbo.sysobjects where id = object_id(N'[rpt_asset_label]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [rpt_asset_label]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE    PROCEDURE [rpt_asset_label]
(
	@idinventory int,
	@ayear int,
	@idinventoryagency int,
	@start int,
	@stop int
)
AS 
BEGIN

CREATE TABLE #output (agencycode varchar(20), codeinventoryagency varchar(20), nassetload int, yassetload int, 
					  ninventory int, tipoinventario varchar(20), description varchar(150), barcode varchar(100))

DECLARE @agencycode varchar(20) 
DECLARE @codeinventoryagency varchar(20) 
DECLARE @nassetload int
DECLARE @yassetload int
DECLARE @ninventory int
DECLARE @tipoinventario varchar(20)
DECLARE @description varchar(150)
DECLARE @barcode varchar(100)

DECLARE @inventario varchar(100)

DECLARE #con_crs INSENSITIVE CURSOR FOR
SELECT ISNULL(ia.agencycode,'') as agencycode, 
	ia.codeinventoryagency, 
	al.nassetload, 
	al.yassetload, 
	a.ninventory, 
	CASE 
		WHEN (I.CODEINVENTORY like '%ord%') OR (I.CODEINVENTORY like '%MAIN%') THEN 'O'
		WHEN (I.CODEINVENTORY like '%lib%') OR (I.CODEINVENTORY like '%BOOK%') THEN 'L'
	END as 'tipoinventario',
	aq.description 
	FROM asset a
		JOIN assetacquire aq
			ON a.nassetacquire = aq.nassetacquire
		JOIN assetload al
			ON aq.idassetload = al.idassetload
		JOIN inventory i
			ON aq.idinventory = i.idinventory
		JOIN inventoryagency ia 
			ON i.idinventoryagency = ia.idinventoryagency
	WHERE aq.idinventory= @idinventory
	AND a.ninventory between @start and @stop
	AND ia.idinventoryagency= @idinventoryagency
	AND al.yassetload = @ayear
FOR READ ONLY

OPEN #con_crs

FETCH NEXT FROM #con_crs INTO @agencycode, @codeinventoryagency, @nassetload, @yassetload, @ninventory, @tipoinventario, @description 

WHILE(@@FETCH_STATUS = 0)
BEGIN
	
	SET @inventario = convert(varchar(100),@ninventory)
	execute calc_barcode @inventario, @barcode OUTPUT

	INSERT INTO #output (agencycode, codeinventoryagency, nassetload, yassetload, ninventory, tipoinventario, description, barcode )
	values(@agencycode, @codeinventoryagency, @nassetload, @yassetload, @ninventory, @tipoinventario, @description, @barcode)

	
	FETCH NEXT FROM #con_crs INTO @agencycode, @codeinventoryagency, @nassetload, @yassetload, @ninventory, @tipoinventario, @description 
END
CLOSE #con_crs
DEALLOCATE #con_crs

SELECT agencycode, codeinventoryagency, nassetload, yassetload, ninventory, tipoinventario, description, barcode FROM #output
ORDER BY ninventory

END 

GO



