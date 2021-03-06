if exists (select * from dbo.sysobjects where id = object_id(N'[esporta_buoni_ratifiche_incoerenti]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [esporta_buoni_ratifiche_incoerenti]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO


 

CREATE   PROCEDURE  [esporta_buoni_ratifiche_incoerenti]
	@start smalldatetime,
	@stop  smalldatetime
AS BEGIN
-- exec [esporta_buoni_ratifiche_incoerenti] {ts '2016-01-01 00:00:00'},{ts '2016-12-31 00:00:00'}
	SELECT
		assetloadview.codeassetloadkind as 'Cod. Tipo Buono Carico',
		assetloadview.assetloadkind 'Tipo Buono Carico',
		assetloadview.yassetload 'Eserc.Buono',
		assetloadview.nassetload 'Num.Buono',
		assetloadview.adate as 'Data Contabile',
		assetloadview.ratificationdate as 'Data Ratifica',
		assetloadview.totalassetacquire as 'Totale carichi',
		assetloadview.assetamortizationamount as 'Totale rivalutazioni',
		assetloadview.totalassetload as 'Totale Buono'
	FROM assetloadview 
	WHERE	assetloadview.ratificationdate < assetloadview.adate
		AND assetloadview.ratificationdate between @start and @stop		
	 ORDER BY assetloadview.codeassetloadkind,
	 assetloadview.yassetload desc,
	 assetloadview.nassetload  	
END



GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

