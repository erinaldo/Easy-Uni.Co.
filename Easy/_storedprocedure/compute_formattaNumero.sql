if exists (select * from dbo.sysobjects where id = object_id(N'[compute_formattaNumero]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [compute_formattaNumero]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO


CREATE                                         procedure [compute_formattaNumero](
	@parametro double precision, 
	@precisione int,
	@0arrotonda1tronca int,
	@lunghezza int, 
	@decimali int, 
	@stringa varchar(150) output
) as begin
	declare @numero double precision
	set @numero = round(@parametro, @precisione, @0arrotonda1tronca)
	if (@precisione > 0) set @lunghezza = @lunghezza + 1
	set @stringa = str(@numero, @lunghezza, @decimali)
	set @stringa = replace(@stringa, ' ', '0')
	set @stringa = replace(@stringa, '.', '')
end



GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

