SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO


if exists (select * from dbo.sysobjects where id = object_id(N'[compute_list_unusable_registry]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [compute_list_unusable_registry]
GO

CREATE PROCEDURE compute_list_unusable_registry (
	@solononattive  char(1)
)
AS BEGIN
CREATE TABLE #reg
(
	idreg int,
	usable char(1)
)

INSERT INTO #reg (idreg, usable)
SELECT idreg, 'N'
FROM registry WHERE isnull(active,'S')='N' OR @solononattive='N'

CREATE TABLE #app (n int)

DECLARE @tname varchar(256)
DECLARE @field varchar(30)
DECLARE @isdbo char(1)
DECLARE @iddbdepartment varchar(50)
DECLARE @sql nvarchar(4000)

DECLARE #crs INSENSITIVE CURSOR FOR
SELECT o.name, c.name,
CASE
	WHEN o.uid = USER_ID('dbo')
	THEN 'S'
	ELSE 'N'
END
FROM sysobjects o
JOIN syscolumns c
	ON o.id = c.id
WHERE o.xtype = 'U'
	AND
	(
		(
			c.name IN ('idreg', 'iddeputy', 'idsorreg', 'registrymanager', 'idregauto', 'paymentagency', 'refundagency','regionalagency')
			AND o.name NOT IN ('registry', 'registryaddress', 'registryreference', 'registrypaymethod', 'registrylegalstatus',
			'registrytaxablestatus', 'registrycf', 'registrypiva', 'registryrole','taxpaymentpartsetup')
		)
		OR (o.name = 'registrypaymethod' AND c.name = 'iddeputy')
		OR (o.name='registry' and c.name='toredirect')
		OR (o.name='taxregionsetup' and c.name='regionalagency')
		OR (o.name='serviceregistry' and c.name='idconferring')
	)
	AND (o.uid = USER_ID() OR o.uid = USER_ID('dbo'))
ORDER by 
CASE
	WHEN o.name IN ('expense', 'income') THEN 0
	ELSE 1
END

FOR READ ONLY
OPEN #crs

FETCH NEXT FROM #crs INTO @tname, @field, @isdbo

WHILE(@@FETCH_STATUS = 0)
BEGIN

	IF (@isdbo = 'S')
	BEGIN
		SET @sql = N'UPDATE #reg SET #reg.usable = ''S''
		FROM [dbo].' + @tname + ' T
		WHERE T.' + @field + ' = #reg.idreg
		AND #reg.usable = ''N'''

		EXEC sp_executesql @sql

		IF (SELECT COUNT(*) FROM #reg WHERE usable = 'N') = 0 BREAK
	END
	ELSE
	BEGIN
		DECLARE #dip INSENSITIVE CURSOR FOR
		SELECT iddbdepartment FROM dbdepartment
	
		FOR READ ONLY
		
		OPEN #dip
	
		FETCH NEXT FROM #dip INTO @iddbdepartment
	
		WHILE(@@FETCH_STATUS = 0)
		BEGIN
			SET @sql = N'UPDATE #reg SET #reg.usable = ''S''
			FROM [' + @iddbdepartment + '].' + @tname + ' T
			WHERE T.' + @field + ' = #reg.idreg
			AND #reg.usable = ''N'''

			EXEC sp_executesql @sql
	
			FETCH NEXT FROM #dip INTO @iddbdepartment
	
			IF (SELECT COUNT(*) FROM #reg WHERE usable = 'N') = 0 BREAK
		END
	
		CLOSE #dip
		DEALLOCATE #dip
	END

	IF (SELECT COUNT(*) FROM #reg WHERE usable = 'N') = 0 BREAK
	FETCH NEXT FROM #crs INTO @tname, @field, @isdbo
END
CLOSE #crs
DEALLOCATE #crs

SELECT
	#reg.idreg,
	V.title, 
	V.surname,
	V.forename,
	V.cf,
	V.p_iva,
	V.registryclass,
	V.active,
	V.lt, V.lu	
FROM #reg
JOIN registrymainview V
	ON V.idreg = #reg.idreg
WHERE #reg.usable = 'N'
END


GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

