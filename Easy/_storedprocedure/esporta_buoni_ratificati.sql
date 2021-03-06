if exists (select * from dbo.sysobjects where id = object_id(N'[esporta_buoni_ratificati]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [esporta_buoni_ratificati]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO
 

--sp_help assetloadview


CREATE   PROCEDURE [esporta_buoni_ratificati]
	 @start smalldatetime,
	 @stop  smalldatetime
AS BEGIN
-- exec [esporta_buoni_ratificati] {ts '2016-01-01 00:00:00'},{ts '2016-12-31 00:00:00'}
SELECT
	assetloadview.codeassetloadkind as 'Cod. Tipo Buono Carico',
	assetloadview.assetloadkind 'Tipo Buono Carico',
	assetloadview.yassetload 'Eserc.Buono',
	assetloadview.yassetload 'Eserc.Buono',
	assetloadview.yassetload 'Eserc.Buono',
	assetloadview.adate as 'Data Contabile',
	assetloadview.ratificationdate as 'Data Ratifica',
	assetloadview.totalassetacquire as 'Totale carichi',
	assetloadview.assetamortizationamount as 'Totale rivalutazioni',
	assetloadview.totalassetload as 'Totale Buono'
FROM assetloadview 
WHERE	assetloadview.ratificationdate between @start and @stop
ORDER BY assetloadview.assetloadkind,
	 assetloadview.yassetload desc,
	 assetloadview.nassetload  
END






GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO
