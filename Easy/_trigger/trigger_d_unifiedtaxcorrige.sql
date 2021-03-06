SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[trigger_d_unifiedtaxcorrige]') and OBJECTPROPERTY(id, N'IsTrigger') = 1)
drop trigger [trigger_d_unifiedtaxcorrige]
GO

CREATE TRIGGER [trigger_d_unifiedtaxcorrige] ON unifiedtaxcorrige 
FOR DELETE 
AS
BEGIN
	DECLARE @idexp int
	DECLARE @idexpensetaxcorrige int
        DECLARE @iddbdepartment varchar(50)
	
	SELECT         
                @idexp = idexp,
                @idexpensetaxcorrige = idexpensetaxcorrige,      
                @iddbdepartment = iddbdepartment
	FROM deleted

	DECLARE @sql nvarchar(600)
	SET @sql = N' UPDATE [' + @iddbdepartment + '].expensetaxcorrige ' +
                ' SET idunifiedtaxcorrige = NULL ' + 
                ' WHERE idexp = '+ convert(varchar(8),@idexp) + 
                ' AND idexpensetaxcorrige = '+ convert(varchar(8),@idexpensetaxcorrige) 

	EXEC SP_EXECUTESQL @sql

END


GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

