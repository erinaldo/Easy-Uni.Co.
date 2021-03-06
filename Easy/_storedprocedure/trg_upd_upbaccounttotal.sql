SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[trg_upd_upbaccounttotal]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [trg_upd_upbaccounttotal]
GO


CREATE  PROCEDURE [trg_upd_upbaccounttotal]
(
	@idacc  varchar(38),
	@idupb varchar(36),
	@updatefield varchar(255),
	@amount decimal(19,2)
)
AS BEGIN
	DECLARE @cmd1 varchar(600)
	DECLARE @cmd2 varchar(600)
	DECLARE @cmd3 varchar(600)
	
		DECLARE @nlevel tinyint
		SELECT @nlevel = convert(int,nlevel) FROM account WHERE idacc = @idacc

		WHILE(@nlevel > 0)
		BEGIN
			IF NOT EXISTS (SELECT * FROM upbaccounttotal WHERE idacc = @idacc AND idupb = @idupb)
			BEGIN
				SELECT @cmd1 = 'INSERT INTO upbaccounttotal'
				SELECT @cmd2 = '(idacc, idupb, ' + @updatefield + ')'
				SELECT @cmd3 = 'VALUES (''' +@idacc + ''', ''' + @idupb + ''',' + STR(@amount, 20, 4) + ')'
			END
			ELSE
			BEGIN
				SELECT @cmd1 = 'UPDATE upbaccounttotal SET '
				SELECT @cmd2 = @updatefield + ' = ISNULL(' + @updatefield + ', 0) + ' + STR(@amount, 20, 4)
				SELECT @cmd3 = ' WHERE idacc = ''' + @idacc +''''
				SELECT @cmd3 = @cmd3 + ' AND idupb = ''' + @idupb + ''''
			END


			EXEC (@cmd1 + @cmd2 + @cmd3)

			-- Se modifico i campi delle variazioni di budget
			-- DEVO PROPAGARE LE MODIFICHE FINO AL TITOLO!
			-- Diversamente la modifica viene effettuata SOLO sul livello di pertinenza!
			IF (@updatefield like 'previsionvariation%' )
			BEGIN
				SET @nlevel = @nlevel - 1
				SELECT @idacc = substring(@idacc,1,len(@idacc)-4)
			END
			ELSE
			BEGIN
				SET @nlevel = 0
			END
		END
	
END


GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

