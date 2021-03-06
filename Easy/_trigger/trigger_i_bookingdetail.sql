
SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[trigger_i_bookingdetail]') and OBJECTPROPERTY(id, N'IsTrigger') = 1)
drop trigger [trigger_i_bookingdetail]
GO


CREATE TRIGGER [trigger_i_bookingdetail] ON [bookingdetail] FOR INSERT
AS BEGIN


DECLARE @newnumber decimal (19,2)
DECLARE @newidbooking int
DECLARE @newidlist int
DECLARE @newidstore int
DECLARE @authorized char(1)
DECLARE @idlcard int
DECLARE @newprice decimal(19,2)


SELECT  @newidbooking = idbooking, 
		@newnumber = number , 
		@newprice = price,
		@newidlist = idlist, @newidstore = idstore,
		@authorized = authorized  
FROM inserted

SELECT @idlcard = idlcard 
		from booking
	where idbooking= @newidbooking

-- Se il dettaglio non ha autorizzazione per il totalizzatore la q.tà prenotata vale 0.
IF ( isnull(@authorized, 'N')<>'S' ) 
Begin
	SET @newnumber = 0
End
DECLARE @unallocated decimal(19,2)

IF exists( select * from stocktotal where idstore = @newidstore AND idlist = @newidlist)
Begin
	select  @unallocated= number-booked  from stocktotal WHERE idstore = @newidstore AND idlist = @newidlist
	if @unallocated<0 set @unallocated=0
	UPDATE stocktotal SET booked = booked + @newnumber WHERE idstore = @newidstore AND idlist = @newidlist
    
End
Else
Begin
	INSERT INTO stocktotal
		(idstore, idlist, number, ordered, booked)
	VALUES (@newidstore, @newidlist, 0, 0, @newnumber)
    set @unallocated = 0

End

declare @toallocate decimal(19,2)
if (@newnumber>@unallocated)
   set @toallocate=@unallocated
else
   set @toallocate=@newnumber

if exists (select * from booktotal where idbooking = @newidbooking and idlist = @newidlist and idstore = @newidstore )
Begin
	UPDATE booktotal SET 
						number = isnull(number,0) + @newnumber, 
						allocated = isnull(allocated,0) + @toallocate
	where idbooking = @newidbooking and idlist = @newidlist and idstore = @newidstore 
End
Else
Begin
	INSERT INTO booktotal 
			(idbooking, idlist, idstore,number,allocated)
	VALUES (@newidbooking, @newidlist, @newidstore, @newnumber, @toallocate )
End

if @idlcard is not null
begin
	update lcardtotal set amount= isnull(amount,0)- round(@newprice*@newnumber,2) where idlcard=@idlcard
end

END

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO




