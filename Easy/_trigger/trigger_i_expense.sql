SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[trigger_i_expense]') and OBJECTPROPERTY(id, N'IsTrigger') = 1)
drop trigger [trigger_i_expense]
GO


CREATE   TRIGGER [trigger_i_expense] ON [expense] FOR INSERT
AS BEGIN
IF (@@ROWCOUNT = 0) RETURN
DECLARE @nrowinserted int
SET @nrowinserted = ISNULL((SELECT COUNT(*) FROM inserted),0)

IF (@nrowinserted > 1)
BEGIN
	CREATE TABLE #expense (idexp int, nphase tinyint)
	
	INSERT INTO #expense (idexp, nphase)
	SELECT idexp, nphase FROM inserted
	
	INSERT INTO expenselink (idchild, nlevel, idparent)
	SELECT idexp, nphase, idexp
	FROM #expense
	
	WHILE(@@ROWCOUNT > 0)
	BEGIN
		INSERT INTO expenselink (idchild, nlevel, idparent)
		SELECT IL.idchild, (nlevel - 1), I.parentidexp
		FROM expenselink IL
		JOIN expense I
		ON IL.idparent = I.idexp
		WHERE IL.nlevel > 1
		AND NOT EXISTS(SELECT * FROM expenselink IL2 WHERE IL2.idchild = IL.idchild AND IL2.nlevel = (IL.nlevel - 1))
		AND EXISTS(SELECT * FROM #expense WHERE #expense.idexp = IL.idchild)
	END
END
ELSE
BEGIN
	DECLARE @idexp int
	DECLARE @nphase tinyint
	DECLARE @parentidexp int
	SELECT @idexp = idexp, @nphase = nphase, @parentidexp = parentidexp FROM inserted

	INSERT INTO expenselink (idchild, nlevel, idparent)
	VALUES(@idexp, @nphase, @idexp)

	while (@nphase>1)
	begin
	  set @nphase=@nphase-1
		INSERT INTO expenselink (idchild, nlevel, idparent)
		VALUES(@idexp,@nphase, @parentidexp)
		if (@nphase>1) select @parentidexp=parentidexp from expense where idexp = @parentidexp	
	
	end
	
END
END



GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

