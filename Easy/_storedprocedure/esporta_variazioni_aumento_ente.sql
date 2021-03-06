if exists (select * from dbo.sysobjects where id = object_id(N'[esporta_variazioni_aumento_ente]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [esporta_variazioni_aumento_ente]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO




CREATE       PROCEDURE [esporta_variazioni_aumento_ente]
@year	int,
@codinventoryagency	int,
@date			smalldatetime,
@idinv			int
AS BEGIN
	declare @firstlevelidinv int
	select @firstlevelidinv = idparent
		from inventorytreelink
		where idchild = @idinv
		and nlevel = 1
		
--Considera le variazioni patrimoniale in aumento di tipo <> 'I'
	SELECT 	ROUND(ISNULL(assetvardetail.amount, 0),2) as 'Importo Variazioni Aumento',
		assetvar.yvar		as 'Eserc. Variazione',
		assetvar.nvar		as 'Num. Variazione',
		assetvardetail.idinv	as 'Class. inventariale' 
		FROM assetvardetail 
		JOIN assetvar
			ON assetvardetail.idassetvar = assetvar.idassetvar
		join inventorytreelink as linkcategoria
			on linkcategoria.idchild = assetvardetail.idinv and nlevel = 1
		WHERE assetvar.flag&1 <> 0
		AND assetvar.yvar = @year
		AND assetvar.adate <= @date
		AND assetvardetail.amount > 0
		AND linkcategoria.idparent = isnull(@firstlevelidinv, linkcategoria.idparent)
		AND assetvar.idinventoryagency = isnull(@codinventoryagency, assetvar.idinventoryagency)
END
SET QUOTED_IDENTIFIER ON 


GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO
