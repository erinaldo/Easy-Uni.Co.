SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[trg_upd_upbaccount]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [trg_upd_upbaccount]
GO


CREATE  PROCEDURE [trg_upd_upbaccount]
(
	@idmov int,
	@ayear int,
	@nphase tinyint,
	@idacc varchar(38),
	@idupb varchar(36)
)
AS BEGIN
DECLARE @currentphase tinyint
DECLARE @maxphase tinyint
-- Viene implementato un cursore che cambia le coppie idupb/idfin solo x i figli diretti

	-- IF usato altrimenti nel caso non ci sono righe il cursore può andare in errore
	-- N.B. Quando viene adoperato un cursore in una SP che può essere chiamata in modo ciclico
	-- bisogna adoperare la dichiarazione del cursore come se fosse una var. locale e non con
	-- INSENSITIVE CURSOR FOR

	IF (SELECT COUNT(*) FROM epexp WHERE paridepexp = @idmov) = 0 RETURN

	DECLARE @idepexp int
	DECLARE @crs_exp CURSOR

	SET @crs_exp = CURSOR FOR
	SELECT idepexp FROM epexp WHERE paridepexp = @idmov
	FOR READ ONLY

	OPEN @crs_exp
	
	FETCH NEXT FROM @crs_exp INTO @idepexp
	WHILE (@@FETCH_STATUS = 0)
	BEGIN
		UPDATE epexpyear SET idacc = @idacc, idupb = @idupb --, lu = '''TRIGGER''', lt = GETDATE()
		WHERE idepexp = @idepexp
			AND ayear = @ayear

		FETCH NEXT FROM @crs_exp INTO @idepexp
	END
	CLOSE @crs_exp
	DEALLOCATE @crs_exp


END




GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

