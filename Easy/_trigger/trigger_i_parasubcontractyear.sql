SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[trigger_i_parasubcontractyear]') and OBJECTPROPERTY(id, N'IsTrigger') = 1)
drop trigger [trigger_i_parasubcontractyear]
GO


CREATE   TRIGGER [trigger_i_parasubcontractyear] ON [parasubcontractyear] FOR INSERT
AS BEGIN
	CREATE TABLE #paras
	(
		idcon varchar(8),
		ayear int,
		iddbdepartment varchar(50),
		idreg int
	)

	INSERT INTO #paras (idcon, ayear, iddbdepartment, idreg)
	SELECT I.idcon, I.ayear, USER, P.idreg
	FROM inserted I
	JOIN parasubcontract P
		ON I.idcon = P.idcon
	JOIN service S
		ON S.idser = P.idser
	WHERE ISNULL(S.certificatekind, '') = 'U'

	IF (SELECT COUNT(*) FROM #paras) = 0
	BEGIN
		DROP TABLE #paras
		RETURN
	END

	INSERT INTO parasubcontractlist
	(
		ayear,
		idcon,
		iddbdepartment,
		idreg,
		balanced,
		linked
	)
	SELECT ayear, idcon, iddbdepartment, idreg, 'N', 'N'
	FROM #paras
	WHERE NOT EXISTS
		(SELECT * FROM parasubcontractlist L
		WHERE L.ayear = #paras.ayear
			AND L.idcon = #paras.idcon
			AND L.iddbdepartment = #paras.iddbdepartment)

	DROP TABLE #paras
END


GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

