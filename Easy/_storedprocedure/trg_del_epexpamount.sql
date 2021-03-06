SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[trg_del_epexpamount]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [trg_del_epexpamount]
GO


CREATE  PROCEDURE [trg_del_epexpamount]
(
	@ayear int,
	@idmov int,
	@paridmov int,
	@amount decimal(19,2),
	@amount2 decimal(19,2),
	@amount3 decimal(19,2),
	@amount4 decimal(19,2),
	@amount5 decimal(19,2)

)
AS BEGIN
	IF (@paridmov IS NOT NULL)
	BEGIN
		UPDATE epexptotal SET
		available = ISNULL(available,0) - isnull(@amount,0),
		available2 = ISNULL(available2,0) - isnull(@amount2,0),
		available3 = ISNULL(available3,0) - isnull(@amount3,0),
		available4 = ISNULL(available4,0) - isnull(@amount4,0),
		available5 = ISNULL(available5,0) - isnull(@amount5,0)

		WHERE idepexp = @paridmov
		AND ayear = @ayear
	END

	DELETE FROM epexptotal
	WHERE idepexp = @idmov
	AND ayear = @ayear


END



GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

