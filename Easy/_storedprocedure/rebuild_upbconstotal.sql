SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[rebuild_upbconstotal]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [rebuild_upbconstotal]
GO

CREATE     PROCEDURE [rebuild_upbconstotal]
(
	@ayear int = null
)
AS BEGIN

--setuser 'amm'

IF (@ayear IS NULL) 
BEGIN
	DELETE FROM upbconstotal

	insert into upbconstotal (idfin,idupb,totprev,totprev_inserted)
	select UT.idfin,u.idupb, 
				isnull(sum(currentprev),0)+isnull(sum(previsionvariation),0),
				isnull(sum(currentprev),0)+isnull(sum(previsionvariation_inserted),0)
	from upbtotal ut
		join upb u on ut.idupb like u.idupb+'%' 
	group by UT.idfin,u.idupb
END
ELSE -- @ayear specificato
BEGIN 
	DELETE FROM upbconstotal 
		WHERE EXISTS(SELECT fin.idfin FROM fin WHERE fin.idfin = upbconstotal.idfin
					 AND fin.ayear = @ayear)

	insert into upbconstotal (idfin,idupb,totprev,totprev_inserted)
	select UT.idfin,u.idupb, 
				isnull(sum(currentprev),0)+isnull(sum(previsionvariation),0),
				isnull(sum(currentprev),0)+isnull(sum(previsionvariation_inserted),0)
	from upbtotal ut
		join upb u on ut.idupb like u.idupb+'%' 
		join fin f on ut.idfin = f.idfin and f.ayear =@ayear
	group by UT.idfin,u.idupb
END
	
END





GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

