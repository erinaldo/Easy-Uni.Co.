
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO
if exists (select * from dbo.sysobjects where id = object_id(N'[rebuild_treasurercashtotal]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [rebuild_treasurercashtotal]
GO


CREATE     PROCEDURE [rebuild_treasurercashtotal]
(
	@ayear int = NULL
)
AS BEGIN

IF (@ayear IS NOT NULL)
BEGIN

	DELETE FROM treasurercashtotal WHERE ayear = @ayear 
	DECLARE @startamount DECIMAL(19,2)
	
	DECLARE @idtreasurer  int
	DECLARE treasurerc INSENSITIVE CURSOR FOR
	SELECT  idtreasurer FROM treasurer
	FOR READ ONLY
	OPEN treasurerc
	
	FETCH NEXT FROM treasurerc INTO @idtreasurer
	WHILE (@@FETCH_STATUS = 0)
	BEGIN
	
	SET @startamount = 0
	SELECT  @startamount = amount FROM treasurerstart WHERE ayear = @ayear AND idtreasurer = @idtreasurer
	
	INSERT INTO treasurercashtotal (ayear, idtreasurer, currentfloatfund) VALUES (@ayear,@idtreasurer,ISNULL(@startamount,0))
	
	UPDATE treasurercashtotal
			SET currentfloatfund =
			currentfloatfund +
			ISNULL(
				(SELECT SUM(i.curramount)
				FROM incometotal i 
				JOIN incomelast IL
					ON IL.idinc = i.idinc
				JOIN proceeds p
					ON p.kpro=IL.kpro
				WHERE i.ayear = @ayear
				AND p.idtreasurer = @idtreasurer)
			,0)
			WHERE ayear = @ayear
			AND idtreasurer = @idtreasurer

	UPDATE treasurercashtotal
			SET currentfloatfund =
				currentfloatfund +
				ISNULL(
					(SELECT SUM(amount)
					FROM moneytransfer 
					WHERE ytransfer = @ayear
					AND idtreasurerdest = @idtreasurer)
				,0)
			WHERE ayear = @ayear
			AND idtreasurer = @idtreasurer
			
		UPDATE treasurercashtotal SET currentfloatfund = currentfloatfund -
			ISNULL(
				(SELECT SUM(i.curramount)
				FROM expenselast EL
				JOIN expensetotal i
					ON EL.idexp = i.idexp
				JOIN payment p
					ON p.kpay=EL.kpay
				WHERE i.ayear = @ayear
				AND p.idtreasurer = @idtreasurer)
			,0)
		WHERE ayear = @ayear
		AND idtreasurer = @idtreasurer
		
		UPDATE treasurercashtotal
			SET currentfloatfund =
				currentfloatfund -
				ISNULL(
					(SELECT SUM(amount)
					FROM moneytransfer 
					WHERE ytransfer = @ayear
					AND idtreasurersource = @idtreasurer)
				,0)
			WHERE ayear = @ayear
			AND idtreasurer = @idtreasurer
			
		FETCH NEXT FROM treasurerc INTO @idtreasurer
	END
	DEALLOCATE treasurerc
END	
ELSE -- @ayear non specificato
BEGIN
	DELETE FROM treasurercashtotal
	
	DECLARE @ycursor int
	DECLARE fc INSENSITIVE CURSOR FOR
	SELECT ayear FROM accountingyear
	FOR READ ONLY
	OPEN fc

	FETCH NEXT FROM fc INTO @ycursor
	WHILE (@@FETCH_STATUS = 0)
	BEGIN
		DECLARE treasurerc INSENSITIVE CURSOR FOR
		SELECT  idtreasurer FROM treasurer
		FOR READ ONLY
		OPEN treasurerc
		
		FETCH NEXT FROM treasurerc INTO @idtreasurer
		WHILE (@@FETCH_STATUS = 0)
		BEGIN
		SET @startamount = 0
		SELECT  @startamount = amount FROM treasurerstart WHERE ayear = @ycursor AND idtreasurer = @idtreasurer

		INSERT INTO treasurercashtotal (ayear, idtreasurer, currentfloatfund ) VALUES(@ycursor,@idtreasurer,ISNULL(@startamount,0))
	
			UPDATE treasurercashtotal
			SET currentfloatfund =
				currentfloatfund +
				ISNULL(
					(SELECT SUM(i.curramount)
					FROM incometotal i 
					JOIN incomelast IL
						ON IL.idinc = i.idinc
					JOIN proceeds p
						ON p.kpro=IL.kpro
					WHERE i.ayear = @ycursor
					AND p.idtreasurer = @idtreasurer)
				,0)
			WHERE ayear = @ycursor
			AND idtreasurer = @idtreasurer

			UPDATE treasurercashtotal
			SET currentfloatfund =
				currentfloatfund +
				ISNULL(
					(SELECT SUM(amount)
					FROM moneytransfer 
					WHERE ytransfer = @ycursor
					AND idtreasurerdest = @idtreasurer)
				,0)
			WHERE ayear = @ycursor
			AND idtreasurer = @idtreasurer

	
			UPDATE treasurercashtotal SET currentfloatfund = currentfloatfund -
			ISNULL(
				(SELECT SUM(i.curramount)
				FROM expenselast EL
				JOIN expensetotal i
					ON EL.idexp = i.idexp
				JOIN payment p
					ON p.kpay=EL.kpay
				WHERE i.ayear = @ycursor
				AND p.idtreasurer = @idtreasurer)
			,0)
			WHERE ayear = @ycursor
			AND idtreasurer = @idtreasurer
			
			UPDATE treasurercashtotal
			SET currentfloatfund =
				currentfloatfund -
				ISNULL(
					(SELECT SUM(amount)
					FROM moneytransfer 
					WHERE ytransfer = @ycursor
					AND idtreasurersource = @idtreasurer)
				,0)
			WHERE ayear = @ycursor
			AND idtreasurer = @idtreasurer
			
	FETCH NEXT FROM treasurerc INTO @idtreasurer
	END
	DEALLOCATE treasurerc
	FETCH NEXT FROM fc INTO @ycursor
	END
	DEALLOCATE fc
	END
END




GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

