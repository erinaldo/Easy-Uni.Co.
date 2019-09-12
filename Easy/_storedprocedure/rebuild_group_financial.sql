SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[rebuild_group_financial]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [rebuild_group_financial]
GO

CREATE PROCEDURE [rebuild_group_financial]
(@ayear int = NULL)
AS BEGIN
	PRINT 'Ricostruzione di INCOMETOTAL...'
	EXEC rebuild_incometotal @ayear
	PRINT 'Ricostruzione di EXPENSETOTAL...'
	EXEC rebuild_expensetotal @ayear
END


GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

