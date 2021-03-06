SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[rpt_buono_carico_sub1_rc]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [rpt_buono_carico_sub1_rc]
GO

CREATE    PROCEDURE [rpt_buono_carico_sub1_rc]
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
	fin.codefin,
	fin.title,
	expense.ymov,
	payment.npay,
	payment.printdate
FROM assetloadexpense
JOIN assetload
	ON assetload.idassetload = assetloadexpense.idassetload
JOIN expense 
	ON assetloadexpense.idexp = expense.idexp
JOIN expenselast
	ON expense.idexp = expenselast.idexp
JOIN expenseyear 
	ON expense.idexp = expenseyear.idexp
JOIN fin
	ON fin.idfin= expenseyear.idfin
JOIN payment
	ON expenselast.kpay = payment.kpay
WHERE assetload.idassetloadkind = @idassetloadkind
	AND assetload.yassetload = @ayear
	AND assetload.nassetload = @nassetload
	AND expenseyear.ayear = @ayear
ORDER BY expense.ymov, payment.printdate, payment.npay
END




GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO
