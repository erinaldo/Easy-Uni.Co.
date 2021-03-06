SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[rebuild_expenselink]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [rebuild_expenselink]
GO

CREATE PROCEDURE rebuild_expenselink
AS BEGIN
	DELETE FROM expenselink

	--1 con 1
	INSERT INTO expenselink (idchild, nlevel, idparent) 	SELECT idexp, 1, idexp 	FROM expense where nphase=1

	declare @currlev int
	declare @maxlev int 
	select @maxlev= max(nphase) from expensephase
	set @currlev=2

	while (@currlev <= @maxlev) 
	BEGIN
		print @currlev
		
		-- @currlev con 1..@currlev-1
		insert into expenselink (idchild, nlevel, idparent)  
			SELECT E.idexp , EL.nlevel,  EL.idparent	FROM expense E
			join expenselink EL on EL.idchild=  E.parentidexp
			where E.nphase= @currlev
		
		-- @currlev con @currlev
		INSERT INTO expenselink (idchild, nlevel, idparent) 	
			SELECT idexp, @currlev, idexp 	FROM expense where nphase=@currlev

		set @currlev= @currlev+1
	END

	
END


GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO
