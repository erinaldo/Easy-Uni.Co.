SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[tr_x_auditcheck]') and OBJECTPROPERTY(id, N'IsTrigger') = 1)
drop trigger [tr_x_auditcheck]
GO

CREATE    TRIGGER [tr_x_auditcheck] ON auditcheck
FOR INSERT,UPDATE, DELETE 
AS 
BEGIN
	DECLARE @dbtable	VARCHAR(50)
	DECLARE @dboperation	CHAR(1)

	CREATE TABLE #a_check
	(
		tablename varchar(150),
		opkind char(1)
	)
	declare @dd datetime 
	set @dd= GETDATE()
	if (select count(*) from inserted)>0 
		insert into #a_check(tablename,opkind) select distinct tablename,opkind from  inserted

	if (select count(*) from deleted)>0 
		insert into #a_check(tablename,opkind) select distinct tablename,opkind from  deleted
	
	if (select count(*) from #a_check)>0 
	BEGIN
		INSERT INTO sptocompile(tablename, opkind, lt) 
			SELECT DISTINCT tablename,opkind,@dd from #a_check WHERE
				NOT EXISTS (SELECT * FROM sptocompile WHERE tablename = #a_check.tablename 
										AND opkind = #a_check.opkind)
	END
	
	DROP TABLE #a_check

END


GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

