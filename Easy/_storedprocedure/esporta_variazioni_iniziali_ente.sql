if exists (select * from dbo.sysobjects where id = object_id(N'[esporta_variazioni_iniziali_ente]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [esporta_variazioni_iniziali_ente]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO






CREATE       PROCEDURE [esporta_variazioni_iniziali_ente]
@year			int,
@codinventoryagency	int,
@date			smalldatetime,
@idinv			int
AS BEGIN
	declare @firstlevelidinv int
	select @firstlevelidinv = idparent
		from inventorytreelink
		where idchild = @idinv
		and nlevel = 1

SELECT   ROUND(ISNULL(assetvardetail.amount, 0),2) as 'Importo Variazioni Iniziali',
		assetvar.yvar		as 'Eserc. Variazione',
		assetvar.nvar		as 'Num. Variazione',
		inventorytree.codeinv	as 'Class. inventariale'
		FROM assetvardetail
		join inventorytree
			on inventorytree.idinv = assetvardetail.idinv
		JOIN assetvar
			ON assetvardetail.idassetvar = assetvar.idassetvar
		join inventorytreelink as linkcategoria
			on linkcategoria.idchild = assetvardetail.idinv and linkcategoria.nlevel = 1
		WHERE assetvar.flag&1 = 0
		AND assetvar.yvar = @year
		AND assetvar.adate <= @date
		AND linkcategoria.idparent = isnull(@firstlevelidinv, linkcategoria.idparent)
		AND assetvar.idinventoryagency = isnull(@codinventoryagency, assetvar.idinventoryagency)
END
SET QUOTED_IDENTIFIER ON 



GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO
