SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[rpt_buono_carico_sub1]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [rpt_buono_carico_sub1]
GO

CREATE      PROCEDURE [rpt_buono_carico_sub1]
@ayear int,
@idassetloadkind int,
@nassetload int	
AS
BEGIN
SELECT
	assetload.idassetloadkind,
	assetload.yassetload,
	assetload.nassetload,
	assetloadexpense.idexp,
	expense.ymov,
	payment.npay,
	payment.printdate
FROM assetloadexpense
JOIN assetload
	ON assetload.idassetload = assetloadexpense.idassetload
JOIN expense 
	ON assetloadexpense.idexp = expense.idexp
JOIN expenselast
	on expenselast.idexp = expense.idexp
JOIN payment
	ON expenselast.kpay = payment.kpay
WHERE assetload.idassetloadkind = @idassetloadkind
	AND assetload.yassetload = @ayear
	AND assetload.nassetload = @nassetload	
ORDER BY expense.ymov, payment.printdate, payment.npay
END

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO
