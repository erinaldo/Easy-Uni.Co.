
if exists (select * from dbo.sysobjects where id = object_id(N'[copyrow_ivapay]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [copyrow_ivapay]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

CREATE PROCEDURE [copyrow_ivapay]
(
	@idivakind int
)
AS 
BEGIN

 declare @query nvarchar(3000)
 declare @iddbdepartment varchar(50)
 declare  @idivakindstr varchar(10)
 declare @codeivakindstr varchar(100)
 declare @codeivakind varchar(100)
 set @idivakindstr= convert(varchar,@idivakind)
 SELECT  @codeivakind = codeivakind from ivakind where idivakind=@idivakind
 set @codeivakindstr= ''''+ replace(@codeivakind,'''','''''')+''''
 
 declare @amm varchar(100)
 set @amm=user
-- set @amm='amm'
 --print user

 declare @crsdepartment cursor
 set 	@crsdepartment = cursor for select  iddbdepartment from dbdepartment where iddbdepartment<>@amm order by iddbdepartment
 open 	@crsdepartment
 fetch next from @crsdepartment into @iddbdepartment
 while @@fetch_status=0 
 begin
  set @query= 'if not exists(select * from ['+@iddbdepartment+'].ivakind IK where '+
		' IK.codeivakind= '+@codeivakindstr+' ) '+
     ' insert into ['+@iddbdepartment+'].ivakind (ct,cu,description,lt,lu,rate,unabatabilitypercentage,active,idivataxablekind,idivakind,codeivakind,flag,annotations) '+
     ' SELECT ct,cu,description,lt,lu,rate,unabatabilitypercentage,active,idivataxablekind,'+
	'isnull((select max(idivakind) from ['+@iddbdepartment+'].ivakind),0)+1,'+
     'codeivakind,flag,annotations from ['+@amm+'].ivakind where idivakind='+@idivakindstr+
     ' ELSE UPDATE  ['+@iddbdepartment+'].ivakind SET ct=IK1.ct, cu=IK1.cu,description=IK1.description,lt=IK1.lt,lu=IK1.lu,'+
	'rate= IK1.rate,unabatabilitypercentage=IK1.unabatabilitypercentage,active=IK1.active, idivataxablekind=IK1.idivataxablekind,'+
        'codeivakind=IK1.codeivakind, flag=IK1.flag, annotations = IK1.annotations FROM ['+@iddbdepartment+'].ivakind inner join '+
		'['+@amm+'].ivakind IK1 ON IK1.codeivakind=['+@iddbdepartment+'].ivakind.codeivakind  WHERE  IK1.idivakind='+@idivakindstr

 print @query

 EXEC sp_executesql @query
 


 fetch next from @crsdepartment into @iddbdepartment
 end

END


GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO


