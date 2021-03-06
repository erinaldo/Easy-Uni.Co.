SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[rebuild_all]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [rebuild_all]
GO

CREATE  PROCEDURE [rebuild_all]
(@ayear int = null, @r varchar(10)=null)
AS BEGIN
PRINT 'Ricostruzione Totali Tabelle LINK dei movimenti ...'
if (@r='H')
	EXEC rebuild_group_link @ayear
else 
	WAITFOR DELAY '00:00:30'

PRINT 'Ricostruzione Totali Movimenti Finanziari...'
if (@r='H')
EXEC rebuild_group_financial @ayear
else 
	WAITFOR DELAY '00:00:30'

PRINT 'Ricostruzione degli UPB...'
if (@r='H')
EXEC rebuild_group_upb @ayear
else 
	WAITFOR DELAY '00:00:30'

PRINT 'Ricostruzione del Fondo di Cassa Corrente...'
if (@r='H')
EXEC rebuild_currentfloatfund @ayear 
else 
	WAITFOR DELAY '00:01'

PRINT 'Ricostruzione dei Totali delle Classificazioni...'
if (@r='H')
EXEC rebuild_sortedmovementtotal @ayear 
else 
	WAITFOR DELAY '00:01'

PRINT 'Ricostruzione dei Totali del Budget'
if (@r='H')
EXEC rebuild_group_budget @ayear
else 
	WAITFOR DELAY '00:01'

PRINT 'Ricostruzione LINK patrimoniali ...'
if (@r='H')
EXEC rebuild_group_cespiti @ayear
else 
	WAITFOR DELAY '00:01'

PRINT 'Ricostruzione LINK classificazioni ...'
if (@r='H')
EXEC rebuild_sortinglink
else 
	WAITFOR DELAY '00:01'

PRINT 'Ricostruzione totali ep...'
if (@r='H')
EXEC rebuild_group_upbaccount @ayear
else 
	WAITFOR DELAY '00:01'


END


GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

