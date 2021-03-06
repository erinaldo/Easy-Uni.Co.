SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[trg_upd_upbmovtotal]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [trg_upd_upbmovtotal]
GO

CREATE    PROCEDURE [trg_upd_upbmovtotal]
(
	@movkind char(1),
	@idfin int,
	@idupb varchar(36),
	@flagarrear char(1),
	@nphase tinyint,
	@amount decimal(19,2)
)
AS BEGIN
DECLARE @nlevel tinyint
SELECT @nlevel = nlevel FROM fin WHERE idfin = @idfin

IF (@movkind = 'I')
BEGIN
	IF (@flagarrear = 'C')
	BEGIN
		WHILE (@nlevel > 0)
		BEGIN
			if exists(SELECT idfin	FROM upbincometotal	WHERE idfin = @idfin AND idupb = @idupb		AND nphase = @nphase)
				UPDATE upbincometotal SET		totalcompetency = ISNULL(totalcompetency, 0) + @amount
					WHERE idfin = @idfin 	AND idupb = @idupb	AND nphase = @nphase
			ELSE
				INSERT INTO upbincometotal (idfin, idupb, nphase, totalcompetency)
					VALUES (@idfin, @idupb, @nphase, @amount)
			SET @nlevel = @nlevel - 1
			if (@nlevel>0) SELECT @idfin = idparent FROM finlink WHERE idchild = @idfin AND nlevel = @nlevel
		END
	END
	ELSE
	BEGIN
		WHILE (@nlevel >0)
		BEGIN
			if exists(SELECT idfin	FROM upbincometotal	WHERE idfin = @idfin AND idupb = @idupb	AND nphase = @nphase)
				UPDATE upbincometotal SET		totalarrears = ISNULL(totalarrears, 0) + @amount
					WHERE idfin = @idfin 	AND idupb = @idupb	AND nphase = @nphase
			ELSE
				INSERT INTO upbincometotal (idfin, idupb, nphase, totalarrears)
					VALUES (@idfin, @idupb, @nphase, @amount)
			SET @nlevel = @nlevel - 1
			if (@nlevel>0) SELECT @idfin = idparent FROM finlink WHERE idchild = @idfin AND nlevel = @nlevel
		END
	END

END
ELSE
BEGIN

	IF (@flagarrear = 'C')
	BEGIN
		WHILE (@nlevel >0)
		BEGIN
			if exists(SELECT idfin FROM upbexpensetotal WHERE idfin = @idfin AND idupb = @idupb AND nphase = @nphase)
				UPDATE upbexpensetotal SET		totalcompetency = ISNULL(totalcompetency, 0) + @amount
					WHERE idfin = @idfin 	AND idupb = @idupb	AND nphase = @nphase
			ELSE
				INSERT INTO upbexpensetotal (idfin, idupb, nphase, totalcompetency)
					VALUES (@idfin, @idupb, @nphase, @amount)
			SET @nlevel = @nlevel - 1
			if (@nlevel>0) SELECT @idfin = idparent FROM finlink WHERE idchild = @idfin AND nlevel = @nlevel
		END
	END
	ELSE
	BEGIN
		WHILE (@nlevel >0)
		BEGIN
			if exists(SELECT idfin FROM upbexpensetotal WHERE idfin = @idfin AND idupb = @idupb AND nphase = @nphase)
				UPDATE upbexpensetotal SET	totalarrears = ISNULL(totalarrears, 0) + @amount
					WHERE idfin = @idfin AND idupb = @idupb	AND nphase = @nphase
			ELSE
				INSERT INTO upbexpensetotal (idfin, idupb, nphase, totalarrears)
					VALUES (@idfin, @idupb, @nphase, @amount)

			SET @nlevel = @nlevel - 1
			if (@nlevel>0) SELECT @idfin = idparent FROM finlink WHERE idchild = @idfin AND nlevel = @nlevel

		END
	END

END

END




GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

