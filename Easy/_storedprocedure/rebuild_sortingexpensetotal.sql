SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[rebuild_sortingexpensetotal]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [rebuild_sortingexpensetotal]
GO

/*
CREATE PROCEDURE [rebuild_sortingexpensetotal]
(
	@ayear int = null
)
AS BEGIN

	if (@ayear is null) 
	BEGIN
		DELETE FROM sortingexpensetotal

		INSERT INTO sortingexpensetotal
		(
			idsorkind,
			idsor,
			idacc,
			total
		)
		SELECT epexpsorting.idsorkind, epexpsorting.idsor, epexpsorting.idacc, 
		ISNULL(SUM(epexpsorting.amount),0)
		FROM epexpsorting
		LEFT OUTER JOIN account A
		ON epexpsorting.idacc LIKE A.idacc + '%'
		GROUP BY epexpsorting.idsorkind, epexpsorting.idsor, epexpsorting.idacc



	END
	ELSE
	BEGIN
		DELETE FROM sortingexpensetotal WHERE idacc LIKE
				substring(convert(varchar,@ayear,4),3,2)+'%'
		INSERT INTO sortingexpensetotal 
		(
			idsorkind,
			idsor,
			idacc,
			total
		)
		SELECT epexpsorting.idsorkind, epexpsorting.idsor, epexpsorting.idacc, 
		ISNULL(SUM(epexpsorting.amount),0)
		FROM epexpsorting
		LEFT OUTER JOIN account A
		ON epexpsorting.idacc LIKE A.idacc + '%'
		WHERE A.ayear = @ayear
		AND epexpsorting.idacc LIKE A.idacc + '%'
		GROUP BY epexpsorting.idsorkind, epexpsorting.idsor, epexpsorting.idacc
	END	

END


GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

*/