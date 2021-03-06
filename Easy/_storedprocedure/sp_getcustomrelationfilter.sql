if exists (select * from dbo.sysobjects where id = object_id(N'[sp_getcustomrelationfilter]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [sp_getcustomrelationfilter]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO



CREATE                                      PROCEDURE [sp_getcustomrelationfilter]  @fromtable varchar(50), @totable varchar(50), @edittype varchar(50), @operation char(1)  AS
BEGIN
	CREATE TABLE #tabfiltro
			(
			filtro            varchar(200) NULL
			)
		
	
		IF ((@fromtable='fin')  and  (@totable='creditvardetail')  and  (@edittype='default')  and  (@operation='I'))
			INSERT INTO #tabfiltro VALUES ('(finpart=''S'')')	
			
		IF ((@fromtable='fin')  and  (@totable='creditvardetail')  and  (@edittype='default')  and  (@operation='S'))
			INSERT INTO #tabfiltro VALUES ('(finpart=''S'')')	
		
		IF ((@fromtable='mandate')  and  (@totable='expense')  and  (@edittype='default') and  (@operation='I'))
			INSERT INTO #tabfiltro 
			VALUES ('(nphase=''<%sys[mandatephase]%>'')')	
		SELECT * FROM #tabfiltro 
			ORDER BY filtro
END



GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

