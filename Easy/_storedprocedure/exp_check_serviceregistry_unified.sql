if exists (select * from dbo.sysobjects where id = object_id(N'[exp_check_serviceregistry_unified]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [exp_check_serviceregistry_unified]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO


CREATE PROCEDURE exp_check_serviceregistry_unified (
	@ayear int,
	@unified char(1)
	)
AS 
BEGIN

IF (@unified <> 'S')
BEGIN
        EXEC exp_check_serviceregistry_single @ayear
        RETURN
END 

CREATE TABLE #AllCompensi(
		departmentname varchar(200),
		nservreg	int,
		yservreg	int,
		title		varchar(150),
		kind		varchar(50),
		ncon		int,
		ycon		int
		)
	declare @iddbdepartment varchar(50)
	declare @crsdepartment cursor
	set 	@crsdepartment = cursor for select  iddbdepartment from dbdepartment
	open 	@crsdepartment
	fetch next from @crsdepartment into @iddbdepartment
	while @@fetch_status=0 begin
		declare @dip_nomesp varchar(300)
											  
		set @dip_nomesp = @iddbdepartment + '.exp_check_serviceregistry_single'

		INSERT INTO #AllCompensi(
			departmentname,
			title,
			nservreg,
			yservreg,
			kind,
			ncon,
			ycon
			)
		exec @dip_nomesp  @ayear
		fetch next from @crsdepartment into @iddbdepartment
	
	END

SELECT 
	departmentname as 'Dipartimento',
	title as 'Anagrafica',
	yservreg as 'Eserc.Incarico',
	nservreg as 'Nun.Incarico',
	kind as 'Compenso',
	ycon as 'Eserc.Compenso',
	ncon as 'Nun.Compenso'
FROM #AllCompensi 
ORDER BY departmentname, title, yservreg, nservreg


END


GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO




