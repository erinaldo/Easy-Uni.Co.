if exists (select * from dbo.sysobjects where id = object_id(N'[entry_shrink]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [entry_shrink]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

CREATE PROCEDURE [entry_shrink]
(
	@esercizio int
)
AS BEGIN

CREATE TABLE #lookup (
	nentry_old int,
	nentry_new int
)
INSERT INTO #lookup
SELECT nentry, ROW_NUMBER() OVER (ORDER BY adate asc, ct asc, lt asc)
FROM [entry]
WHERE yentry = @esercizio;

UPDATE	[entry]
SET 	nentry = nentry_new
FROM	#lookup
WHERE 	nentry = nentry_old AND yentry = @esercizio;

DISABLE TRIGGER [trigger_u_entrydetail] ON [entrydetail];

UPDATE	[entrydetail]
SET 	nentry = nentry_new
FROM	#lookup
WHERE 	nentry = nentry_old AND yentry = @esercizio;

ENABLE TRIGGER [trigger_u_entrydetail] ON [entrydetail];

UPDATE	[entrydetailaccrual]
SET 	nentry = nentry_new
FROM	#lookup
WHERE 	nentry = nentry_old AND yentry = @esercizio;

UPDATE	[entrydetailaccrual]
SET 	nentrylinked = nentry_new
FROM	#lookup
WHERE	nentrylinked = nentry_old AND yentrylinked = @esercizio;

DROP TABLE #lookup;

END
GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

