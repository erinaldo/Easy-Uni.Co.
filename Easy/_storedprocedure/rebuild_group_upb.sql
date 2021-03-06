SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[rebuild_group_upb]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [rebuild_group_upb]
GO


CREATE   PROCEDURE [rebuild_group_upb]
(@ayear int = NULL)
AS BEGIN
	PRINT 'Ricostruzione di FINLINK...'
	EXEC rebuild_finlink @ayear
	PRINT 'Ricostruzione di UPBINCOMETOTAL...'
	EXEC rebuild_upbincometotal @ayear
	PRINT 'Ricostruzione di UPBEXPENSETOTAL...'
	EXEC rebuild_upbexpensetotal @ayear
	PRINT 'Ricostruzione di UPBTOTAL...'
	EXEC rebuild_upbtotal @ayear
	PRINT 'Ricostruzione di UPBCONSTOTAL...'
	EXEC rebuild_upbconstotal @ayear


	PRINT 'Ricostruzione di UPBUNDERWRITINGTOTAL...'
	EXEC rebuild_upbunderwritingtotal @ayear
	PRINT 'Ricostruzione di UNDERWRITINGEXPENSETOTAL...'
	EXEC rebuild_underwritingexpensetotal @ayear
	PRINT 'Ricostruzione di UNDERWRITINGINCOMETOTAL...'
	EXEC rebuild_underwritingincometotal @ayear
	PRINT 'Ricostruzione di FINYEAR...'
	EXEC rebuild_finyear @ayear
END


GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

