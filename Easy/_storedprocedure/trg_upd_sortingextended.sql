SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[trg_upd_sortingextended]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [trg_upd_sortingextended]
GO

CREATE PROCEDURE [trg_upd_sortingextended]
(
	@idsor int,
	@idacc varchar(38),
	@previousprev decimal(19,2),
	@currentprev decimal(19,2)
)
AS BEGIN
IF (@idacc IS NOT NULL)
BEGIN
	WHILE (LEN(@idacc)>=6)
	BEGIN
		IF NOT EXISTS (SELECT * FROM sortingtotal
		WHERE idsor = @idsor
		AND idacc = @idacc)
		BEGIN
			INSERT INTO sortingtotal
			(
				idsor,
				idacc,
				previousprev,
				currentprev
			)
			VALUES
			(
				@idsor,
				@idacc,
				ISNULL(@previousprev,0),
				ISNULL(@currentprev,0)
			)
		END
		ELSE
		BEGIN
			UPDATE sortingtotal SET
			previousprev = ISNULL(previousprev,0) + ISNULL(@previousprev,0),
			currentprev = ISNULL(currentprev,0) + ISNULL(@currentprev,0)
			WHERE idsor = @idsor
			AND idacc = @idacc
		END
		SET @idacc = SUBSTRING(@idacc,1,LEN(@idacc)-4)
	END
END
END



GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

