
SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[trg_upd_upbaccountextended]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [trg_upd_upbaccountextended]
GO


CREATE PROCEDURE [trg_upd_upbaccountextended]
(
	@idacc varchar(38),
	@idupb varchar(36),
	@currentprev decimal(19,2),
	@currentprev2 decimal(19,2),
	@currentprev3 decimal(19,2),
	@currentprev4 decimal(19,2),
	@currentprev5 decimal(19,2)	
)
AS BEGIN
IF (@idacc IS NOT NULL)
BEGIN
	DECLARE @nlevel tinyint
	SELECT @nlevel = nlevel FROM account WHERE idacc = @idacc

	declare @ayear smallint
	select @ayear = ayear from account where idacc = @idacc

	--DECLARE @minlevelusable tinyint
	--SELECT @minlevelusable = min(nlevel) from accountlevel where ayear = @ayear and (flagusable='S')
	
	WHILE (@nlevel >= 1)
	BEGIN
		IF NOT EXISTS (SELECT * FROM upbaccounttotal WHERE idacc = @idacc AND idupb = @idupb)
		BEGIN
			INSERT INTO upbaccounttotal
			(
				idacc,
				idupb,
				currentprev,
				currentprev2,
				currentprev3,
				currentprev4,
				currentprev5
			)
			VALUES
			(
				@idacc,
				@idupb,
				ISNULL(@currentprev,0),
				ISNULL(@currentprev2,0),
				ISNULL(@currentprev3,0),
				ISNULL(@currentprev4,0),
				ISNULL(@currentprev5,0)
			)
		END
		ELSE
		BEGIN
			UPDATE upbaccounttotal SET
			currentprev = ISNULL(currentprev,0) + ISNULL(@currentprev,0),
			currentprev2 = ISNULL(currentprev2,0) + ISNULL(@currentprev2,0),
			currentprev3 = ISNULL(currentprev3,0) + ISNULL(@currentprev3,0),
			currentprev4 = ISNULL(currentprev4,0) + ISNULL(@currentprev4,0),
			currentprev5 = ISNULL(currentprev5,0) + ISNULL(@currentprev5,0)
			WHERE idacc = @idacc
			AND idupb = @idupb
			--and ((select nlevel from account where idacc = @idacc) =< @minlevelusable)
		END
		SET @nlevel = @nlevel - 1
		SET @idacc = SUBSTRING(@idacc,1,len(@idacc)-4)		
	END
END
END



GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

 
 