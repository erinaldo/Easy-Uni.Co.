if exists (select * from dbo.sysobjects where id = object_id(N'[compute_idnation]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [compute_idnation]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO




CREATE                                                  procedure [compute_idnation] (
	@denominazione varchar(150), 
	@data smalldatetime,
	@flagstorico CHAR(1),
	@idnazione int output
) as 
begin
	set @idnazione = null
	IF @denominazione IS NULL RETURN
	declare @count INT
	if @data is null SET @data=GETDATE()
	select @count=count(*) from geo_nation WHERE title = @denominazione 
		AND @data between ISNULL(start, {d '1900-01-01'}) AND ISNULL(stop, {d '2079-06-06'})
	if @count=1 BEGIN
		select @idnazione=idnation from geo_nation WHERE title = @denominazione 
			AND @data between ISNULL(start, {d '1900-01-01'}) AND ISNULL(stop, {d '2079-06-06'})
		return
	END
end



GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

