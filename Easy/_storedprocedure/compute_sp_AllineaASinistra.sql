if exists (select * from dbo.sysobjects where id = object_id(N'[compute_sp_AllineaASinistra]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [compute_sp_AllineaASinistra]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO



CREATE                                           procedure compute_sp_AllineaASinistra (
	@lunghezza int,
	@stringa varchar(8000) output
)AS BEGIN
	if (@stringa is null) set @stringa = space(@lunghezza)
	declare @lenstr int
	set @lenStr=len(@stringa)
	if (@lenStr>@lunghezza) set @stringa = substring(@stringa,1,@lunghezza)
	set @stringa = @stringa+space(@lunghezza-@lenStr)
END




GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

