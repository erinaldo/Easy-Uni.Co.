SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[trigger_d_bookingdetail]') and OBJECTPROPERTY(id, N'IsTrigger') = 1)
drop trigger [trigger_d_bookingdetail]
GO

CREATE TRIGGER [trigger_d_bookingdetail] ON [bookingdetail] FOR DELETE
AS BEGIN

DECLARE @oldnumber decimal (19,2)
DECLARE @oldauthorized char(1)
DECLARE @oldidbooking int

DECLARE @oldidlist int
DECLARE @oldidstore int
DECLARE @idlcard int
DECLARE @oldprice decimal(19,2)

SELECT  @oldidbooking = idbooking, 
		@oldnumber = number , 
		@oldidlist = idlist, 
		@oldidstore = idstore,
		@oldprice = price,
		@oldauthorized = authorized  FROM deleted

SELECT @idlcard = idlcard 
		from booking
	where idbooking= @oldidbooking


DECLARE @valoredaSottarre decimal(19,2) 
DECLARE @todeallocate decimal(19,2)

IF( isnull(@oldauthorized, 'N') <> 'S' ) 
Begin
	SET @valoredaSottarre = 0
End
ELSE
Begin
	SET  @valoredaSottarre = @oldnumber
End
 
 SET @todeallocate = ISNULL( (SELECT allocated from booktotal where idbooking = @oldidbooking AND idlist = @oldidlist),0)

UPDATE stocktotal SET booked = booked - @valoredaSottarre WHERE idstore = @oldidstore AND idlist = @oldidlist

UPDATE booktotal SET number = number - @valoredaSottarre WHERE idbooking = @oldidbooking AND idlist = @oldidlist


IF (@todeallocate > 0)
BEGIN
	UPDATE booktotal SET allocated = 0 WHERE idbooking = @oldidbooking AND idlist = @oldidlist 
	EXEC trg_upd_booktotal_allocated @oldidstore, @oldidlist, @todeallocate
END 


DELETE FROM booktotal WHERE number = 0 AND allocated =  0
		AND idstore = @oldidstore AND idlist = @oldidlist AND idbooking = @oldidbooking

if @idlcard is not null
begin
	update lcardtotal set amount= isnull(amount,0)+ round(@oldprice*@valoredaSottarre,2) where idlcard=@idlcard
end


END


GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO




