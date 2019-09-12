SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[rebuild_group_budget]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [rebuild_group_budget]
GO

CREATE  PROCEDURE [rebuild_group_budget]
(@ayear int = NULL)
AS BEGIN

	PRINT 'Ricostruzione di EPEXPTOTAL...'
	EXEC rebuild_epexptotal @ayear
	
	PRINT 'Ricostruzione di EPACCTOTAL...'
	EXEC rebuild_epacctotal @ayear
END


GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

 