SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[trigger_u_finlevel]') and OBJECTPROPERTY(id, N'IsTrigger') = 1)
drop trigger [trigger_u_finlevel]
GO

CREATE TRIGGER [trigger_u_finlevel] ON [finlevel] FOR UPDATE
AS BEGIN

DECLARE	@lu varchar(64)
SELECT	@lu = lu FROM inserted
if (user<>'amministrazione' OR @lu = 'trigger_finlevel_upd') return;

CREATE TABLE #finlevel
(
	ayear smallint,
	nlevel tinyint,
	flag smallint,
	ct datetime, cu varchar(64), lt datetime, lu varchar(64),
	description varchar(50))

INSERT INTO #finlevel
(
	ayear, nlevel, 
	flag, 
	lt, lu,
	description
)
SELECT
	I.ayear, I.nlevel, 
	I.flag,
	I.lt, 'trigger_finlevel_upd',
	I.description
FROM inserted I
WHERE I.nlevel <= (select unifiedfinlevel from commonconfig where ayear =I.ayear)
AND  I.lu <> 'trigger_finlevel_upd'

IF (SELECT COUNT(*) FROM #finlevel) = 0 RETURN
-- Parte di propagazione delle modifiche a tutti i dipartimenti

        DECLARE @currdep varchar(50)
        SET @currdep = user
        
        DECLARE @iddbdepartment varchar(50)
        
        DECLARE @cursore cursor
        SET @cursore = CURSOR FOR
        SELECT  iddbdepartment FROM dbdepartment WHERE iddbdepartment <> @currdep
        OPEN @cursore
        FETCH NEXT FROM @cursore INTO @iddbdepartment
        WHILE (@@FETCH_STATUS = 0)
        BEGIN
        	DECLARE @sql nvarchar(4000)
        
        	SET @sql = N'UPDATE [' + @iddbdepartment + '].finlevel' +
        	' SET [' + @iddbdepartment + '].finlevel.flag = f.flag, ' +
        	' [' + @iddbdepartment + '].finlevel.description = f.description, ' +
        	' [' + @iddbdepartment + '].finlevel.lt = f.lt, ' +
        	' [' + @iddbdepartment + '].finlevel.lu = ''trigger_finlevel_upd'' ' +
        	' FROM #finlevel f ' +
        	' WHERE [' + @iddbdepartment + '].finlevel.ayear = f.ayear 
        	AND [' + @iddbdepartment + '].finlevel.nlevel = f.nlevel
        	AND ([' + @iddbdepartment + '].finlevel.lt <> f.lt OR [' +
        	@iddbdepartment + '].finlevel.lu <> f.lu)'
        
        	IF EXISTS
        		(SELECT * FROM sysobjects WHERE ID = OBJECT_ID(@iddbdepartment+'.finlevel') 
        			AND OBJECTPROPERTY(id, N'IsUserTable') = 1
        			AND (uid = USER_ID(@iddbdepartment)))
        	BEGIN
        		EXEC SP_EXECUTESQL @sql
        	END
        	FETCH NEXT FROM @cursore INTO @iddbdepartment
        END
        CLOSE @cursore
        DEALLOCATE @cursore

DROP TABLE #finlevel
END

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

