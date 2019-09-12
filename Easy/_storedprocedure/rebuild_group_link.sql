SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[rebuild_group_link]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [rebuild_group_link]
GO

CREATE PROCEDURE [rebuild_group_link]
(@ayear int = NULL)
AS BEGIN
	PRINT 'Ricostruzione di INCOMELINK...'
	EXEC rebuild_incomelink @ayear
	PRINT 'Ricostruzione di EXPENSELINK...'
	EXEC rebuild_expenselink @ayear
END



GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

