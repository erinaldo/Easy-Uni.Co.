if exists (select * from dbo.sysobjects where id = object_id(N'[compute_history_nation]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [compute_history_nation]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO



CREATE                                       PROCEDURE [compute_history_nation]
	@idnation int,
	@flagusable char(1)
as begin
	create table #next (keyfield int, idnation int)
	insert into #next values(0, @idnation)
	declare @examinedCounter int
	set @examinedCounter = 0
	declare @insertedCounter int
	set @insertedCounter = 1
	while @examinedCounter < @insertedCounter begin
		select @idnation=idnation from #next where keyfield=@examinedCounter
	
		declare @newnation int
	
		select @newnation=newnation from geo_nation where idnation=@idnation
		if @newnation is not null and (select count(*) from #next where idnation=@newnation)=0  begin
			insert into #next values (@insertedCounter, @newnation)
			set @insertedCounter = @insertedCounter + 1
		end
	
		declare @cursore cursor
		set @cursore=cursor for select idnation from geo_nation where oldnation=@idnation
		open @cursore
		fetch next from @cursore into @newnation
		while @@fetch_status=0 begin
			if @newnation is not null and (select count(*) from #next where idnation=@newnation)=0  begin
				insert into #next values (@insertedCounter, @newnation)
				set @insertedCounter = @insertedCounter + 1
			end
			fetch next from @cursore into @newnation
		end
		close @cursore
		set @examinedCounter = @examinedCounter + 1
	end
	
	if (UPPER(@flagusable)='S') BEGIN
		select s.idnation, c.title, c.start, c.stop
		from #next s inner join geo_nation c on s.idnation=c.idnation
		INNER JOIN geo_nationusable g on s.idnation = g.idnation
		order by s.keyfield
	END
	ELSE BEGIN
		select s.idnation, c.title, c.start, c.stop
		from #next s inner join geo_nation c on s.idnation=c.idnation
		order by s.keyfield
	END
end



GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

