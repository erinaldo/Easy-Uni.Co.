SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[trigger_d_inventorytree]') and OBJECTPROPERTY(id, N'IsTrigger') = 1)
drop trigger [dbo].[trigger_d_inventorytree]
GO



CREATE  TRIGGER [dbo].[trigger_d_inventorytree] ON [dbo].[inventorytree] FOR DELETE
AS BEGIN
IF @@ROWCOUNT > 0
BEGIN
	CREATE TABLE #inventorytree (idinv int)

	INSERT INTO #inventorytree (idinv)
	SELECT idinv FROM deleted

	DELETE FROM inventorytreelink
	WHERE idchild IN (SELECT idinv FROM #inventorytree)
END
END



GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

