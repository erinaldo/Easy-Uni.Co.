SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[rebuild_group_upbaccount]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [rebuild_group_upbaccount]
GO


CREATE   PROCEDURE [rebuild_group_upbaccount]
(@ayear int = NULL,@idupb varchar(36)='%')
AS BEGIN
	PRINT 'Ricostruzione di UPBEPEXPTOTAL...'
	EXEC rebuild_upbepexptotal @ayear , @idupb
	
	PRINT 'Ricostruzione di UPBEPACCTOTAL...'
	EXEC rebuild_upbepacctotal @ayear , @idupb
	
	PRINT 'Ricostruzione di UPBACCOUNTTOTAL...'
	EXEC rebuild_upbaccounttotal @ayear, @idupb

	PRINT 'ricostruzione di ACCOUNTYEAR'
	exec rebuild_accountyear @ayear, @idupb

	
END
 


GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

