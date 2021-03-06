SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[trigger_u_fin]') and OBJECTPROPERTY(id, N'IsTrigger') = 1)
drop trigger [trigger_u_fin]
GO

CREATE    TRIGGER [trigger_u_fin] ON [fin] FOR UPDATE
AS BEGIN
DECLARE @ayear smallint
SELECT @ayear = ayear FROM deleted


DECLARE	@lu varchar(64)
SELECT	@lu = lu FROM inserted
if (user<>'amministrazione' OR @lu = 'trigger_fin_upd') return;

CREATE TABLE #newfin
(
	idfin int,
	ayear smallint,
	codefin varchar(50),
	flag tinyint,
	lt datetime, lu varchar(64),
	nlevel char(1),
	paridfin int,
	printingorder varchar(50),
	rtf image, txt text,
	title varchar(150)
)


INSERT INTO #newfin
(
	idfin,
	ayear,
	codefin,
	flag,
	lt, lu,
	nlevel,
	paridfin,
	printingorder,
	title
)
SELECT
	idfin,
	ayear,
	codefin,
	flag,
	lt, 'trigger_fin_upd',
	nlevel,
	paridfin,
	printingorder,
	title
FROM inserted
WHERE nlevel <= (SELECT unifiedfinlevel FROM commonconfig WHERE ayear = inserted.ayear)
AND inserted.lu <> 'trigger_fin_upd'

CREATE TABLE #oldfin
(
	idfin int,
	ayear smallint,
	codefin varchar(50),
	flag tinyint,
)


INSERT INTO #oldfin
(
	idfin,
	ayear,
	codefin,
	flag
)
SELECT
	idfin,
	ayear,
	codefin,
	flag
FROM deleted
WHERE nlevel <= (SELECT unifiedfinlevel FROM commonconfig WHERE ayear = deleted.ayear)


IF (SELECT COUNT(*) FROM #newfin) = 0 RETURN

        
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
        
        	SET @sql = N'UPDATE [' + @iddbdepartment + '].fin' +
        	' SET [' + @iddbdepartment + '].fin.codefin = f.codefin, ' +
        	' [' + @iddbdepartment + '].fin.printingorder = f.printingorder, ' +
        	' [' + @iddbdepartment + '].fin.title = f.title, ' +
        	' [' + @iddbdepartment + '].fin.flag = f.flag, ' +
        	' [' + @iddbdepartment + '].fin.lt = f.lt, ' +
        	' [' + @iddbdepartment + '].fin.lu = ''trigger_fin_upd'' ' +
        	' FROM #newfin f ' +
        	' join #oldfin fo on f.idfin=fo.idfin '+
        	' WHERE [' + @iddbdepartment + '].fin.codefin = fo.codefin ' +
        	' and [' + @iddbdepartment + '].fin.ayear = fo.ayear ' +
        	' and ([' + @iddbdepartment + '].fin.flag & 1) = (fo.flag & 1) ' +
        	' AND ([' + @iddbdepartment + '].fin.lt <> f.lt OR [' +
        	@iddbdepartment + '].fin.lu <> f.lu)'
        
        	
        	EXEC SP_EXECUTESQL @sql
        	
        	FETCH NEXT FROM @cursore INTO @iddbdepartment
        END
        CLOSE @cursore
        DEALLOCATE @cursore
End
        
DROP TABLE #oldfin
DROP TABLE #newfin


GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

