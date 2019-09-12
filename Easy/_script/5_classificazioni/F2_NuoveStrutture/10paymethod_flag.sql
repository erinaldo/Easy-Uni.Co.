-- Aggiornamento tabella PAYMETHOD e tabelle dipendenti
-- Le tabelle dipendenti sono:

-- Passo 0.bis: Rimozione dei Trigger NON CI SONO TRIGGER
IF NOT EXISTS(select * from [sysobjects] as T inner join syscolumns C on T.ID = C.ID where t.name = 'paymethod' and C.name = 'flag' AND (T.uid = USER_ID( ) OR T.uid = USER_ID('dbo')))
BEGIN
	ALTER TABLE [paymethod] ADD flag tinyint NULL
END
ELSE
BEGIN
	ALTER TABLE [paymethod] ALTER COLUMN flag tinyint NULL 
END
GO

-- Codifica - codekind (bit 0), flagusable (bit 1), flagrestart (bit 2)
-- codekind (N = 0; A = 1), flagusable (N = 0; S = 1), flagrestart (N = 0; S = 1)
UPDATE paymethod SET flag = 0
UPDATE paymethod SET flag = flag + 1 WHERE ISNULL(flagpaymentadvice,'N') = 'S'
GO


IF exists(select * from [sysobjects] as T inner join syscolumns C on T.ID = C.ID 
		where t.name = 'paymethod'
		and C.name ='flagpaymentadvice'
		AND (T.uid = USER_ID( ) OR T.uid = USER_ID('dbo'))
	)
BEGIN
	ALTER TABLE [paymethod] DROP COLUMN flagpaymentadvice
	DELETE FROM columntypes WHERE tablename = 'paymethod' AND field = 'flagpaymentadvice'
END
GO

ALTER TABLE [paymethod] ALTER COLUMN flag tinyint NOT NULL 
GO

IF exists(SELECT * FROM [columntypes] WHERE tablename = 'paymethod' AND field = 'flag')
UPDATE [columntypes] SET iskey = 'N',sqltype = 'tinyint',col_len = '1',col_precision = null,col_scale = null,systemtype = 'System.Byte',sqldeclaration = 'tinyint',allownull = 'N',defaultvalue = '',format = null,denynull = 'S',lastmodtimestamp = {ts '2007-10-24 17:16:31.967'},lastmoduser = '''NINO''',createuser = 'NINO',createtimestamp = {ts '2007-10-24 17:16:31.967'} WHERE tablename = 'paymethod' AND field = 'flag'
ELSE
INSERT INTO [columntypes] (tablename,field,iskey,sqltype,col_len,col_precision,col_scale,systemtype,sqldeclaration,allownull,defaultvalue,format,denynull,lastmodtimestamp,lastmoduser,createuser,createtimestamp) VALUES ('paymethod','flag','N','tinyint','1',null,null,'System.Byte','tinyint','N','',null,'S',{ts '2007-10-24 17:16:31.967'},'''NINO''','NINO',{ts '2007-10-24 17:16:31.967'})
GO
