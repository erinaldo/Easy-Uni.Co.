SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[trg_upd_upbextended]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [trg_upd_upbextended]
GO

CREATE PROCEDURE [trg_upd_upbextended]
(
	@idfin int,
	@idupb varchar(36),
	@previousprev decimal(19,2),
	@currentprev decimal(19,2),
	@previoussecondaryprev decimal(19,2),
	@currentsecondaryprev decimal(19,2),
	@previousarrears decimal(19,2),
	@currentarrears decimal(19,2)
)
AS BEGIN
IF (@idfin IS NOT NULL)
BEGIN
	DECLARE @nlevel tinyint
	SELECT @nlevel = nlevel FROM fin WHERE idfin = @idfin

	WHILE (@nlevel >= 1)
	BEGIN
		IF NOT EXISTS (SELECT * FROM upbtotal WHERE idfin = @idfin AND idupb = @idupb)
		BEGIN
			INSERT INTO upbtotal
			(
				idfin,
				idupb,
				previousprev,
				currentprev,
				previoussecondaryprev,
				currentsecondaryprev,
				previousarrears,
				currentarrears
			)
			VALUES
			(
				@idfin,
				@idupb,
				ISNULL(@previousprev,0),
				ISNULL(@currentprev,0),
				ISNULL(@previoussecondaryprev,0),
				ISNULL(@currentsecondaryprev,0),
				ISNULL(@previousarrears,0),
				ISNULL(@currentarrears,0)
			)
		END
		ELSE
		BEGIN
			UPDATE upbtotal SET
			previousprev = ISNULL(previousprev,0) + ISNULL(@previousprev,0),
			currentprev = ISNULL(currentprev,0) + ISNULL(@currentprev,0),
			previoussecondaryprev = ISNULL(previoussecondaryprev,0) + ISNULL(@previoussecondaryprev,0),
			currentsecondaryprev = ISNULL(currentsecondaryprev,0) + ISNULL(@currentsecondaryprev,0),
			previousarrears = ISNULL(previousarrears,0) + ISNULL(@previousarrears,0),
			currentarrears = ISNULL(currentarrears,0) + ISNULL(@currentarrears,0)
			WHERE idfin = @idfin
			AND idupb = @idupb
		END
		SET @nlevel = @nlevel - 1
		SELECT @idfin = idparent FROM finlink WHERE idchild = @idfin AND nlevel = @nlevel
	END
END
END





GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

