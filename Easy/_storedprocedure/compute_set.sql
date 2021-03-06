
if exists (select * from dbo.sysobjects where id = object_id(N'[compute_set]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [compute_set]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO


CREATE  PROCEDURE compute_set
(
	@ayear int,
	@iduser varchar(50),
	@idflowchart varchar(34),
	@varname varchar(30)
)
AS BEGIN

CREATE TABLE #outtable
(
	yn char(1),
	mustquote char(1)
)

IF (@idflowchart IS NULL)
BEGIN
	INSERT INTO #outtable VALUES('S','S')
	SELECT yn,mustquote FROM #outtable
	RETURN
END

DECLARE @nrowfound int
SET @nrowfound =
	(SELECT COUNT(*)
	FROM flowchartrestrictedfunction FF
	JOIN restrictedfunction RF
		ON RF.idrestrictedfunction = FF.idrestrictedfunction
	WHERE FF.idflowchart = @idflowchart
		AND RF.variablename = @varname)

IF (@nrowfound > 0)
BEGIN
	INSERT INTO #outtable VALUES('S','S')
	SELECT yn,mustquote FROM #outtable
END
ELSE
BEGIN
	INSERT INTO #outtable VALUES('N','S')
	SELECT yn,mustquote FROM #outtable
END
END
GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO
