SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[trg_upd_fin]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [trg_upd_fin]
GO

CREATE PROCEDURE [trg_upd_fin]
(
	@movementkind char(1),
	@idmovement int,
	@ayear int,
	@nphase tinyint,
	@idfin int
)
AS BEGIN
	CREATE TABLE #tempmov (idmov int)

	IF @movementkind = 'I'
	BEGIN
		INSERT INTO #tempmov SELECT idchild FROM incomelink WHERE idparent = @idmovement AND nlevel > @nphase
	
		UPDATE incomeyear SET idfin = @idfin 
		FROM #tempmov WHERE incomeyear.idinc = #tempmov.idmov
	END
	ELSE
	BEGIN
		INSERT INTO #tempmov SELECT idchild FROM expenselink WHERE idparent = @idmovement AND nlevel > @nphase
	
		UPDATE expenseyear SET idfin = @idfin 
		FROM #tempmov WHERE expenseyear.idexp = #tempmov.idmov
	END

	DROP TABLE #tempmov
END

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

