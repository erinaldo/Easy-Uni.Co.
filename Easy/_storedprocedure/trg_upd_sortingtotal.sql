SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[trg_upd_sortingtotal]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [trg_upd_sortingtotal]
GO

CREATE PROCEDURE [trg_upd_sortingtotal]
(
	@idsor int,
	@idacc varchar(38),
	@updatefield varchar(255),
	@amount decimal(19,2)
)
AS BEGIN
DECLARE @sql varchar(2000)
IF @idacc IS NOT NULL
BEGIN
	WHILE((LEN(@idacc) - 2) >=4)
	BEGIN
		IF NOT EXISTS
			(SELECT * FROM sortingtotal
			WHERE idsor = @idsor
			AND idacc = @idacc)
		BEGIN
			SET @sql = 'INSERT INTO sortingtotal (idsor, idacc, ' + @updatefield + ')
			 VALUES (''' + CONVERT(varchar(10), @idsor) + ''',''' + @idacc + ''',' + STR(@amount, 20, 4) + ')'
		END
		ELSE
		BEGIN
			SET @sql = 'UPDATE sortingtotal SET ' + @updatefield + ' = ISNULL(' + @updatefield + ', 0) + ' + STR(@amount, 20, 4) +
			' WHERE idsor = ''' + CONVERT(varchar(10), @idsor) + ''' AND idacc = ''' + @idacc + ''''
		END
		EXEC (@sql)
		-- Se modifico i campi delle variazioni di bilancio
		-- DEVO PROPAGARE LE MODIFICHE FINO AL PRIMO LIVELLO!
		-- Diversamente la modifica viene effettuata SOLO sul livello di pertinenza!
		IF (@updatefield = 'previsionvariation')
		BEGIN
			SET @idacc = SUBSTRING(@idacc,1,LEN(@idacc)-4)
		END
		ELSE
		BEGIN
			SET @idacc=''
		END
	END
END
END



GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

