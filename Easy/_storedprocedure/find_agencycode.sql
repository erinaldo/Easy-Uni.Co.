if exists (select * from dbo.sysobjects where id = object_id(N'[find_agencycode]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [find_agencycode]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO



CREATE              PROCEDURE [find_agencycode]
(@idgeo INT,
@idente INT, 
@idcodice INT,
@tipo CHAR(1))
AS
BEGIN
	--comune
	IF @tipo IS NULL OR UPPER(@tipo) = 'C'
	BEGIN
		SELECT value FROM geo_city_agency 
		WHERE idcity=@idgeo AND idagency=@idente and idcode=@idcodice
		ORDER BY value ASC
		RETURN
	END
	--provincia
	IF UPPER(@tipo) = 'P'
	BEGIN
		SELECT value FROM geo_country_agency 
		WHERE idcountry=@idgeo AND idagency=@idente and idcode=@idcodice
		ORDER BY value ASC
		RETURN
	END
	--regione
	IF UPPER(@tipo) = 'R'
	BEGIN
		SELECT value FROM geo_region_agency 
		WHERE idregion = @idgeo AND idagency=@idente and idcode=@idcodice
		ORDER BY value ASC
		RETURN
	END
	--nazione
	IF UPPER(@tipo) = 'N'
	BEGIN
		SELECT value FROM geo_nation_agency 
		WHERE idnation = @idgeo AND idagency=@idente and idcode=@idcodice
		ORDER BY value ASC
		RETURN
	END
END


GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

