/****** Object:  StoredProcedure [amm].[count_contract]    Script Date: 05/12/2014 11.53.10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[count_contract]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [count_contract]
GO


--input @kind= C occasionale  o P professionale
CREATE    PROCEDURE [count_contract](
	@ayear 		smallint,
	@kind 		char(1),
	@idreg		int,
	@res int out
) as 
begin

create table #mytable (nrows int)
declare @iddbdepartment varchar(50)
declare @currstmt nvarchar(1000)

declare @num int

declare @cursore cursor
set @cursore = cursor for select  iddbdepartment from dbdepartment
open @cursore
fetch next from @cursore into @iddbdepartment

while @@fetch_status=0 begin
--	print @iddbdepartment
	if (@kind='C')
		SET @currstmt= 'SELECT  COUNT(*) FROM ['+ @iddbdepartment + '].casualcontract' +
					' where ycon = '+convert(varchar(20),@ayear)+' and idreg= '+convert(varchar(20),@idreg)
	else
		SET @currstmt= 'SELECT  COUNT(*) FROM ['+ @iddbdepartment + '].profservice' +
					' where ycon = '+convert(varchar(20),@ayear)+' and idreg= '+convert(varchar(20),@idreg)

	insert into #mytable exec sp_executesql @currstmt
	if (select max(nrows) from #mytable)>0 break
	delete from #mytable 
	fetch next from @cursore into @iddbdepartment	
end

SET @res= ISNULL((SELECT max(nrows) from #mytable), 0)
drop table #mytable
--print @res
end
