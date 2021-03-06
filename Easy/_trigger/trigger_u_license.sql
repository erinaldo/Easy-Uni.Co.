SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[trigger_u_license]') and OBJECTPROPERTY(id, N'IsTrigger') = 1)
drop trigger [dbo].[trigger_u_license]
GO

CREATE TRIGGER [trigger_u_license] ON license 
FOR UPDATE 
AS BEGIN
	IF UPDATE(cap) 
	OR UPDATE(idreg)
	OR UPDATE(agencycode)
	OR UPDATE(cf)
	OR UPDATE(departmentname)
	OR UPDATE(agencyname)
	OR UPDATE(p_iva)
	OR UPDATE(address1)
	OR UPDATE(address2)
	OR UPDATE(country)
	OR UPDATE(location)
	BEGIN
		UPDATE license SET sent = 'N'
	END
END


GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

