SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[trigger_i_finlookup]') and OBJECTPROPERTY(id, N'IsTrigger') = 1)
drop trigger [trigger_i_finlookup]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO


CREATE TRIGGER [trigger_i_finlookup] ON [finlookup] FOR INSERT
AS BEGIN
IF (@@ROWCOUNT = 0) RETURN
DECLARE	@cu varchar(64)
SELECT	@cu = cu FROM inserted

if (user<>'amministrazione' OR @cu='trigger_fin_copy')  return

CREATE TABLE #finlookup
(
	oldidfin int,
	newidfin int,
	ct datetime, cu varchar(64), lt datetime, lu varchar(64)
)

INSERT INTO #finlookup
SELECT oldidfin, newidfin, inserted.ct, 'trigger_fin_copy', inserted.lt, inserted.lu
FROM inserted
JOIN fin fo
	ON fo.idfin = inserted.oldidfin
JOIN fin fn
	ON fn.idfin = inserted.newidfin
WHERE fo.nlevel <= (SELECT unifiedfinlevel FROM commonconfig WHERE ayear =  fo.ayear)
AND fn.nlevel <= (SELECT unifiedfinlevel FROM commonconfig WHERE ayear =  fn.ayear)
and inserted.cu <> 'trigger_fin_copy'

DECLARE @currdep varchar(50)
SET @currdep = user

DECLARE @iddbdepartment varchar(50)

--IF (user='amministrazione' )
--Begin

        DECLARE @cursore cursor
        SET @cursore = CURSOR FOR
        SELECT  iddbdepartment FROM dbdepartment WHERE iddbdepartment <> @currdep
        OPEN @cursore
        FETCH NEXT FROM @cursore INTO @iddbdepartment
        WHILE (@@FETCH_STATUS = 0)
        BEGIN
        	DECLARE @sql nvarchar(2000)
        
        	SET @sql = N'INSERT INTO [' + @iddbdepartment + '].finlookup' +
        	' (oldidfin, newidfin, ct, cu, lt, lu)' +
        	' SELECT FF1.idfin, FF2.idfin, #finlookup.ct, ''trigger_fin_copy'', #finlookup.lt, #finlookup.lu ' +
        	' FROM #finlookup '+
        	'  JOIN fin F1 on F1.idfin=#finlookup.oldidfin '+
        	'  JOIN [' + @iddbdepartment + '].fin FF1 on F1.ayear=FF1.ayear and F1.codefin=FF1.codefin and F1.flag&1=FF1.flag&1 ' +
        	'  JOIN fin F2 on F2.idfin=#finlookup.newidfin '+
        	'  JOIN [' + @iddbdepartment + '].fin FF2 on F2.ayear=FF2.ayear and F2.codefin=FF2.codefin and F2.flag&1=FF2.flag&1 ' +
        	' WHERE NOT EXISTS(SELECT * FROM [' + @iddbdepartment + '].finlookup fd '+
        				'  JOIN [' + @iddbdepartment + '].fin g1 on g1.idfin=fd.oldidfin '+
        				'  JOIN fin gg1 on g1.ayear=gg1.ayear and g1.codefin=gg1.codefin and g1.flag&1=gg1.flag&1 ' +
        				'  JOIN [' + @iddbdepartment + '].fin g2 on F2.idfin=fd.newidfin '+
        				'  JOIN fin gg2 on g2.ayear=gg2.ayear and g2.codefin=gg2.codefin and g2.flag&1=gg2.flag&1 ' +
        			' WHERE gg1.idfin = #finlookup.oldidfin AND gg2.idfin = #finlookup.newidfin)'
        
        	
        	--PRINT @sql
        	EXEC SP_EXECUTESQL @sql
        
        	FETCH NEXT FROM @cursore INTO @iddbdepartment
        END
        CLOSE @cursore
        DEALLOCATE @cursore
--End

DROP TABLE #finlookup
END



GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO


