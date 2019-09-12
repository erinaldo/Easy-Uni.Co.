SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[trg_upd_underwriting]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [trg_upd_underwriting]
GO


CREATE  PROCEDURE [trg_upd_underwriting]
(
	@movkind char(1),
	@idmov int,
	@nphase tinyint,
	@idunderwriting int
)
AS BEGIN
DECLARE @currentphase tinyint
DECLARE @maxphase tinyint

IF @movkind = 'I'
BEGIN
	-- IF usato altrimenti nel caso non ci sono righe il cursore può andare in errore
	IF (SELECT COUNT(*) FROM income WHERE parentidinc = @idmov) = 0 RETURN
	DECLARE @idinc int
	DECLARE @crs_inc CURSOR
	
	SET @crs_inc = CURSOR FOR
	SELECT idinc FROM income WHERE parentidinc = @idmov
	FOR READ ONLY

	OPEN @crs_inc
	
	FETCH NEXT FROM @crs_inc INTO @idinc
	WHILE (@@FETCH_STATUS = 0)
	BEGIN
		UPDATE income SET idunderwriting = @idunderwriting, 
		lu = '''TRIGGER''', lt = GETDATE()
		WHERE idinc = @idinc

		FETCH NEXT FROM @crs_inc INTO @idinc
	END
	CLOSE @crs_inc
	DEALLOCATE @crs_inc
END
ELSE
BEGIN
	--La parte spesa la scriveremo in seguito
	print'expese'
END
END




GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

