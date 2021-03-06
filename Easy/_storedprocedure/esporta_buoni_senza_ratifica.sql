if exists (select * from dbo.sysobjects where id = object_id(N'[esporta_buoni_senza_ratifica]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [esporta_buoni_senza_ratifica]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO
 
CREATE   PROCEDURE [esporta_buoni_senza_ratifica]
-- exec [esporta_buoni_senza_ratifica]
AS BEGIN
SELECT
	assetloadview.codeassetloadkind as 'Cod. Tipo Buono Carico',
	assetloadview.assetloadkind 'Tipo Buono carico',
	assetloadview.yassetload 'Eserc.Buono',
	assetloadview.nassetload 'Num.Buono',
	assetloadview.adate 'Data Contabile',
	assetloadview.totalassetacquire as 'Totale carichi',
	assetloadview.assetamortizationamount as 'Totale rivalutazioni',
	assetloadview.totalassetload as 'Totale Buono'

FROM 	assetloadview 
WHERE 	assetloadview.ratificationdate is null
ORDER BY assetloadview.codeassetloadkind,
	 assetloadview.yassetload desc,
	 assetloadview.nassetload  			
			
END





GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

