if exists (select * from dbo.sysobjects where id = object_id(N'[compute_filtered_sortingkind_income]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [compute_filtered_sortingkind_income]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO


CREATE           PROCEDURE [compute_filtered_sortingkind_income] 
@ayear int,
@idinc int,
@idreg int,
@idupb varchar(36),
@nphase char(1),
@idfin int,
@idman int,
@incomeamount decimal(23,2),
@idsorkind int,
@idsor int,
@idsubclass smallint,
@sortingamount decimal(23,2),
@description varchar(150),
@flagnodate char(1),
@tobecontinued char(1),
@start datetime,
@stop datetime,
@valuen1 decimal(23,2),
@valuen2 decimal(23,2),
@valuen3 decimal(23,2),
@valuen4 decimal(23,2),
@valuen5 decimal(23,2),
@values1 varchar(20),
@values2 varchar(20),
@values3 varchar(20),
@values4 varchar(20),
@values5 varchar(20),
@valuev1 decimal(23,6),
@valuev2 decimal(23,6),
@valuev3 decimal(23,6),
@valuev4 decimal(23,6),
@valuev5 decimal(23,6)
AS



GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

