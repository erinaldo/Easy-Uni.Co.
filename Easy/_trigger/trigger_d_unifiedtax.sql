SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[trigger_d_unifiedtax]') and OBJECTPROPERTY(id, N'IsTrigger') = 1)
drop trigger [trigger_d_unifiedtax]
GO

CREATE TRIGGER [trigger_d_unifiedtax] ON unifiedtax 
FOR DELETE 
AS
BEGIN
	DECLARE @idexp int
	DECLARE @taxcode int
	DECLARE @nbracket int

        DECLARE @iddbdepartment varchar(50)
	
	SELECT         
                @idexp = idexp,
                @taxcode = taxcode,
                @nbracket = nbracket,        
                @iddbdepartment = iddbdepartment
	FROM deleted

	DECLARE @sql nvarchar(600)
	SET @sql = N' UPDATE [' + @iddbdepartment + '].expensetax ' +
                ' SET idunifiedtax = NULL ' + 
                ' WHERE idexp = '+ convert(varchar(8),@idexp) + 
                ' AND taxcode = '+ convert(varchar(8),@taxcode) + 
                ' AND nbracket = '+ convert(varchar(8),@nbracket)  

	EXEC SP_EXECUTESQL @sql

END


GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

