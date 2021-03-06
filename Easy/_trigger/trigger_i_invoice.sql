SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[trigger_i_invoice]') and OBJECTPROPERTY(id, N'IsTrigger') = 1)
drop trigger [trigger_i_invoice]
GO

CREATE  TRIGGER [trigger_i_invoice] ON [invoice] 
FOR INSERT
AS
begin
	declare @unifiedninv int
	declare @numregistri int
	select @numregistri = count(*) from unifiedivaregisterkind

	IF (@numregistri = 0) RETURN

	if @numregistri = 1
	begin
		insert into unifiedivaregister 
			(yinv, idivaregisterkind, unifiedninv, iddbdepartment, idinvkind, ninv)
			select yinv, 'P', 
			(select 1+isnull(max(unifiedninv),0) from unifiedivaregister),
			system_user, idinvkind, ninv 
			from inserted
	end else begin
		declare @flagbuysell char(1)
		select @flagbuysell=case when (flag & 1) = 0 then 'A' else 'V' end from invoicekind where idinvkind=invoicekind.idinvkind
		insert into unifiedivaregister 
			(yinv, idivaregisterkind, unifiedninv, iddbdepartment, idinvkind, ninv)
			select yinv, @flagbuysell,
			(select 1+isnull(max(unifiedninv),0) from unifiedivaregister where idivaregisterkind=@flagbuysell),
			system_user, idinvkind, ninv 
			from inserted
	end
end




GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

