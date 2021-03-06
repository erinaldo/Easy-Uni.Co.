SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[trg_upd_sorttotal]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [trg_upd_sorttotal]
GO

CREATE  PROCEDURE [trg_upd_sorttotal]
(
	@idsor varchar(36),
	@ayear smallint,
	@updatefield varchar(100),
	@amount decimal(19,2)
)
AS BEGIN
DECLARE @stringaSQL nvarchar(2000)

IF NOT EXISTS
	(SELECT * FROM sortedmovementtotal 
	WHERE idsor = @idsor
		AND ayear = @ayear)
BEGIN
	SELECT @stringaSQL = N'INSERT INTO sortedmovementtotal (idsor, ayear, ' + @updatefield + ')'
	+ 'VALUES (''' + @idsor + ''', '
	+ CONVERT(char(4), @ayear) + ', ' + STR(@amount, 20, 4) + ')'
END
	ELSE
BEGIN
	SELECT @stringaSQL = N'UPDATE sortedmovementtotal SET ' + @updatefield
	+ ' = ISNULL(' + @updatefield + ', 0) + ' + STR(@amount, 20, 4)
	+ 'WHERE idsor = '''+ @idsor
	+ ''' AND ayear = ' + CONVERT(char(4), @ayear)
END
EXEC sp_executesql @stringaSQL
END



GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

