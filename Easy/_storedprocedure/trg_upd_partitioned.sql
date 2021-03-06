SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[trg_upd_partitioned]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [trg_upd_partitioned]
GO

CREATE PROCEDURE [trg_upd_partitioned]
(
	@ayear int,
	@idinc int,
	@newamount decimal(19,2),
	@oldamount decimal(19,2)
)
AS BEGIN
UPDATE incometotal
SET partitioned = ISNULL(partitioned, 0) + @oldamount + @newamount
WHERE idinc = @idinc
AND ayear = @ayear
END



GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

