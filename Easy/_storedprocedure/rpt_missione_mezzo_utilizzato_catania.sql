if exists (select * from dbo.sysobjects where id = object_id(N'[rpt_missione_mezzo_utilizzato_catania]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [rpt_missione_mezzo_utilizzato_catania]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO 

--setuser 'amministrazione'
--[rpt_missione_mezzo_utilizzato_catania] 2019, 1

/*
flagmove & 1 = 0		=> nessuno
se flagmove & 1 <> 0	=> aereo o nave
*/

CREATE  PROCEDURE [rpt_missione_mezzo_utilizzato_catania]
	@yitineration smallint, 
	@nitineration int
AS BEGIN

select fi.*, r.title as registry , 
CASE i.flagmove
when 0 then 'NESSUNA'
when 2 then 'AEREA'
when 4 then 'MARITTIMA'
when 6 then 'MARITTIMA e AEREA'
else 'NESSUNA'
END via
from itinerationflights fi
join itineration i on fi.iditineration = i.iditineration
join registry r on r.idreg = i.idreg 
where i.yitineration = @yitineration
and i.nitineration = @nitineration

END

