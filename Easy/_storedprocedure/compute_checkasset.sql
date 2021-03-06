if exists (select * from dbo.sysobjects where id = object_id(N'[compute_checkasset]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [compute_checkasset]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO



CREATE         PROCEDURE compute_checkasset
(
	@idinventory int,
        @startnumber int,
	@number int,
	@is_ok char(1) output
)
AS BEGIN
DECLARE @counter int
SELECT @counter = @startnumber
SELECT @is_ok = 'S'
WHILE @counter < @startnumber + @number
BEGIN
	IF NOT EXISTS
		(SELECT * FROM assetview
		WHERE idinventory = @idinventory
			AND ninventory = @counter
			AND idassetunload IS NULL)
	BEGIN
		SELECT @is_ok = 'N'
		RETURN
	END
	SELECT @counter = @counter + 1
END
END


GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

