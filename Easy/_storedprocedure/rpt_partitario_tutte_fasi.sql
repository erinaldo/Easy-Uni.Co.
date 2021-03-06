if exists (select * from dbo.sysobjects where id = object_id(N'[rpt_partitario_tutte_fasi]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [rpt_partitario_tutte_fasi]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO







CREATE                               PROCEDURE rpt_partitario_tutte_fasi
	@ayear smallint,
	@kind char(1),
	@idupb	varchar(36),
	@finpart char(1),
	@nlevel tinyint,
	@start smalldatetime,
	@stop smalldatetime,
	@showupb char (1),
	@showchildupb char(1),
	@suppressifblank char(1),
	@flagnofficial	char(1),
	@idfin int,
	@idsor01 int,
	@idsor02 int,
	@idsor03 int,
	@idsor04 int,
	@idsor05 int
AS
	BEGIN
/* Versione 1.0.1 del 11/09/2007 ultima modifica: SARA */
		IF @finpart = 'E'
			EXEC rpt_partitario_entrata_tutte_fasi 
				@ayear,
				@kind,
				@idupb,
				@nlevel,
				@start,
				@stop,
				@showupb,
				@showchildupb,
				@suppressifblank,
				@flagnofficial,
				@idfin,
				@idsor01,
				@idsor02,
				@idsor03,
				@idsor04,
				@idsor05
		ELSE
			EXEC rpt_partitario_spesa_tutte_fasi 
				@ayear,
				@kind,
				@idupb,
				@nlevel,
				@start,
				@stop,
				@showupb,
				@showchildupb,
				@suppressifblank,
				@flagnofficial,
				@idfin,
				@idsor01,
				@idsor02,
				@idsor03,
				@idsor04,
				@idsor05
  END







GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

