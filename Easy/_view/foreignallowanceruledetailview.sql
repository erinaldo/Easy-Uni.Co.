-- CREAZIONE VISTA foreignallowanceruledetailview
IF EXISTS(select * from sysobjects where id = object_id(N'[dbo].[foreignallowanceruledetailview]') and OBJECTPROPERTY(id, N'IsView') = 1)
DROP VIEW [dbo].[foreignallowanceruledetailview]
GO



CREATE  VIEW DBO.foreignallowanceruledetailview
(
	idforeignallowancerule,
	iddetail,
	idforeigncountry,
	codeforeigncountry,
	foreigncountry,
	start,
	minforeigngroupnumber,
	maxforeigngroupnumber,
	amount,
	advancepercentage,
	ct, cu, lt, lu
)
AS SELECT 
	DET.idforeignallowancerule,
	DET.iddetail,
	F.idforeigncountry,
	FC.codeforeigncountry,
	FC.description,
	F.start,
	DET.minforeigngroupnumber,
	DET.maxforeigngroupnumber,
	DET.amount,
	DET.advancepercentage,
	DET.ct, DET.cu, DET.lt, DET.lu
FROM foreignallowanceruledetail DET
JOIN foreignallowancerule F
	ON F.idforeignallowancerule = DET.idforeignallowancerule
JOIN foreigncountry FC
	ON FC.idforeigncountry = F.idforeigncountry



GO

-- VERIFICA DI foreignallowanceruledetailview IN COLUMNTYPES --
DELETE FROM columntypes WHERE tablename = 'foreignallowanceruledetailview'
IF exists(SELECT * FROM columntypes WHERE tablename = 'foreignallowanceruledetailview' AND field = 'advancepercentage')
UPDATE columntypes set createuser = 'SARA',lastmoduser = '''SARA''',col_scale = '6',sqltype = 'decimal',defaultvalue = '',allownull = 'N',systemtype = 'System.Decimal',sqldeclaration = 'decimal(19,6)',iskey = 'N',tablename = 'foreignallowanceruledetailview',denynull = 'S',format = '',col_len = '9',field = 'advancepercentage',col_precision = '19' where tablename = 'foreignallowanceruledetailview' AND field = 'advancepercentage'
ELSE
INSERT INTO columntypes (createuser,lastmoduser,col_scale,sqltype,defaultvalue,allownull,systemtype,sqldeclaration,iskey,tablename,denynull,format,col_len,field,col_precision) VALUES('SARA','''SARA''','6','decimal','','N','System.Decimal','decimal(19,6)','N','foreignallowanceruledetailview','S','','9','advancepercentage','19')
GO

IF exists(SELECT * FROM columntypes WHERE tablename = 'foreignallowanceruledetailview' AND field = 'amount')
UPDATE columntypes set createuser = 'SARA',lastmoduser = '''SARA''',col_scale = '2',sqltype = 'decimal',defaultvalue = '',allownull = 'N',systemtype = 'System.Decimal',sqldeclaration = 'decimal(19,2)',iskey = 'N',tablename = 'foreignallowanceruledetailview',denynull = 'S',format = '',col_len = '9',field = 'amount',col_precision = '19' where tablename = 'foreignallowanceruledetailview' AND field = 'amount'
ELSE
INSERT INTO columntypes (createuser,lastmoduser,col_scale,sqltype,defaultvalue,allownull,systemtype,sqldeclaration,iskey,tablename,denynull,format,col_len,field,col_precision) VALUES('SARA','''SARA''','2','decimal','','N','System.Decimal','decimal(19,2)','N','foreignallowanceruledetailview','S','','9','amount','19')
GO

IF exists(SELECT * FROM columntypes WHERE tablename = 'foreignallowanceruledetailview' AND field = 'codeforeigncountry')
UPDATE columntypes set createuser = 'SARA',lastmoduser = '''SARA''',col_scale = '',sqltype = 'varchar',defaultvalue = '',allownull = 'N',systemtype = 'System.String',sqldeclaration = 'varchar(20)',iskey = 'N',tablename = 'foreignallowanceruledetailview',denynull = 'S',format = '',col_len = '20',field = 'codeforeigncountry',col_precision = '' where tablename = 'foreignallowanceruledetailview' AND field = 'codeforeigncountry'
ELSE
INSERT INTO columntypes (createuser,lastmoduser,col_scale,sqltype,defaultvalue,allownull,systemtype,sqldeclaration,iskey,tablename,denynull,format,col_len,field,col_precision) VALUES('SARA','''SARA''','','varchar','','N','System.String','varchar(20)','N','foreignallowanceruledetailview','S','','20','codeforeigncountry','')
GO

IF exists(SELECT * FROM columntypes WHERE tablename = 'foreignallowanceruledetailview' AND field = 'ct')
UPDATE columntypes set createuser = 'SARA',lastmoduser = '''SARA''',col_scale = '',sqltype = 'datetime',defaultvalue = '',allownull = 'N',systemtype = 'System.DateTime',sqldeclaration = 'datetime',iskey = 'N',tablename = 'foreignallowanceruledetailview',denynull = 'S',format = '',col_len = '8',field = 'ct',col_precision = '' where tablename = 'foreignallowanceruledetailview' AND field = 'ct'
ELSE
INSERT INTO columntypes (createuser,lastmoduser,col_scale,sqltype,defaultvalue,allownull,systemtype,sqldeclaration,iskey,tablename,denynull,format,col_len,field,col_precision) VALUES('SARA','''SARA''','','datetime','','N','System.DateTime','datetime','N','foreignallowanceruledetailview','S','','8','ct','')
GO

IF exists(SELECT * FROM columntypes WHERE tablename = 'foreignallowanceruledetailview' AND field = 'cu')
UPDATE columntypes set createuser = 'SARA',lastmoduser = '''SARA''',col_scale = '',sqltype = 'varchar',defaultvalue = '',allownull = 'N',systemtype = 'System.String',sqldeclaration = 'varchar(64)',iskey = 'N',tablename = 'foreignallowanceruledetailview',denynull = 'S',format = '',col_len = '64',field = 'cu',col_precision = '' where tablename = 'foreignallowanceruledetailview' AND field = 'cu'
ELSE
INSERT INTO columntypes (createuser,lastmoduser,col_scale,sqltype,defaultvalue,allownull,systemtype,sqldeclaration,iskey,tablename,denynull,format,col_len,field,col_precision) VALUES('SARA','''SARA''','','varchar','','N','System.String','varchar(64)','N','foreignallowanceruledetailview','S','','64','cu','')
GO

IF exists(SELECT * FROM columntypes WHERE tablename = 'foreignallowanceruledetailview' AND field = 'foreigncountry')
UPDATE columntypes set createuser = 'SARA',lastmoduser = '''SARA''',col_scale = '',sqltype = 'varchar',defaultvalue = '',allownull = 'N',systemtype = 'System.String',sqldeclaration = 'varchar(50)',iskey = 'N',tablename = 'foreignallowanceruledetailview',denynull = 'S',format = '',col_len = '50',field = 'foreigncountry',col_precision = '' where tablename = 'foreignallowanceruledetailview' AND field = 'foreigncountry'
ELSE
INSERT INTO columntypes (createuser,lastmoduser,col_scale,sqltype,defaultvalue,allownull,systemtype,sqldeclaration,iskey,tablename,denynull,format,col_len,field,col_precision) VALUES('SARA','''SARA''','','varchar','','N','System.String','varchar(50)','N','foreignallowanceruledetailview','S','','50','foreigncountry','')
GO

IF exists(SELECT * FROM columntypes WHERE tablename = 'foreignallowanceruledetailview' AND field = 'iddetail')
UPDATE columntypes set createuser = 'SARA',lastmoduser = '''SARA''',col_scale = '',sqltype = 'int',defaultvalue = '',allownull = 'N',systemtype = 'System.Int32',sqldeclaration = 'int',iskey = 'N',tablename = 'foreignallowanceruledetailview',denynull = 'S',format = '',col_len = '4',field = 'iddetail',col_precision = '' where tablename = 'foreignallowanceruledetailview' AND field = 'iddetail'
ELSE
INSERT INTO columntypes (createuser,lastmoduser,col_scale,sqltype,defaultvalue,allownull,systemtype,sqldeclaration,iskey,tablename,denynull,format,col_len,field,col_precision) VALUES('SARA','''SARA''','','int','','N','System.Int32','int','N','foreignallowanceruledetailview','S','','4','iddetail','')
GO

IF exists(SELECT * FROM columntypes WHERE tablename = 'foreignallowanceruledetailview' AND field = 'idforeignallowancerule')
UPDATE columntypes set createuser = 'SARA',lastmoduser = '''SARA''',col_scale = '',sqltype = 'int',defaultvalue = '',allownull = 'N',systemtype = 'System.Int32',sqldeclaration = 'int',iskey = 'N',tablename = 'foreignallowanceruledetailview',denynull = 'S',format = '',col_len = '4',field = 'idforeignallowancerule',col_precision = '' where tablename = 'foreignallowanceruledetailview' AND field = 'idforeignallowancerule'
ELSE
INSERT INTO columntypes (createuser,lastmoduser,col_scale,sqltype,defaultvalue,allownull,systemtype,sqldeclaration,iskey,tablename,denynull,format,col_len,field,col_precision) VALUES('SARA','''SARA''','','int','','N','System.Int32','int','N','foreignallowanceruledetailview','S','','4','idforeignallowancerule','')
GO

IF exists(SELECT * FROM columntypes WHERE tablename = 'foreignallowanceruledetailview' AND field = 'idforeigncountry')
UPDATE columntypes set createuser = 'SARA',lastmoduser = '''SARA''',col_scale = '',sqltype = 'int',defaultvalue = '',allownull = 'N',systemtype = 'System.Int32',sqldeclaration = 'int',iskey = 'N',tablename = 'foreignallowanceruledetailview',denynull = 'S',format = '',col_len = '4',field = 'idforeigncountry',col_precision = '' where tablename = 'foreignallowanceruledetailview' AND field = 'idforeigncountry'
ELSE
INSERT INTO columntypes (createuser,lastmoduser,col_scale,sqltype,defaultvalue,allownull,systemtype,sqldeclaration,iskey,tablename,denynull,format,col_len,field,col_precision) VALUES('SARA','''SARA''','','int','','N','System.Int32','int','N','foreignallowanceruledetailview','S','','4','idforeigncountry','')
GO

IF exists(SELECT * FROM columntypes WHERE tablename = 'foreignallowanceruledetailview' AND field = 'lt')
UPDATE columntypes set createuser = 'SARA',lastmoduser = '''SARA''',col_scale = '',sqltype = 'datetime',defaultvalue = '',allownull = 'N',systemtype = 'System.DateTime',sqldeclaration = 'datetime',iskey = 'N',tablename = 'foreignallowanceruledetailview',denynull = 'S',format = '',col_len = '8',field = 'lt',col_precision = '' where tablename = 'foreignallowanceruledetailview' AND field = 'lt'
ELSE
INSERT INTO columntypes (createuser,lastmoduser,col_scale,sqltype,defaultvalue,allownull,systemtype,sqldeclaration,iskey,tablename,denynull,format,col_len,field,col_precision) VALUES('SARA','''SARA''','','datetime','','N','System.DateTime','datetime','N','foreignallowanceruledetailview','S','','8','lt','')
GO

IF exists(SELECT * FROM columntypes WHERE tablename = 'foreignallowanceruledetailview' AND field = 'lu')
UPDATE columntypes set createuser = 'SARA',lastmoduser = '''SARA''',col_scale = '',sqltype = 'varchar',defaultvalue = '',allownull = 'N',systemtype = 'System.String',sqldeclaration = 'varchar(64)',iskey = 'N',tablename = 'foreignallowanceruledetailview',denynull = 'S',format = '',col_len = '64',field = 'lu',col_precision = '' where tablename = 'foreignallowanceruledetailview' AND field = 'lu'
ELSE
INSERT INTO columntypes (createuser,lastmoduser,col_scale,sqltype,defaultvalue,allownull,systemtype,sqldeclaration,iskey,tablename,denynull,format,col_len,field,col_precision) VALUES('SARA','''SARA''','','varchar','','N','System.String','varchar(64)','N','foreignallowanceruledetailview','S','','64','lu','')
GO

IF exists(SELECT * FROM columntypes WHERE tablename = 'foreignallowanceruledetailview' AND field = 'maxforeigngroupnumber')
UPDATE columntypes set createuser = 'SARA',lastmoduser = '''SARA''',col_scale = '',sqltype = 'smallint',defaultvalue = '',allownull = 'N',systemtype = 'System.Int16',sqldeclaration = 'smallint',iskey = 'N',tablename = 'foreignallowanceruledetailview',denynull = 'S',format = '',col_len = '2',field = 'maxforeigngroupnumber',col_precision = '' where tablename = 'foreignallowanceruledetailview' AND field = 'maxforeigngroupnumber'
ELSE
INSERT INTO columntypes (createuser,lastmoduser,col_scale,sqltype,defaultvalue,allownull,systemtype,sqldeclaration,iskey,tablename,denynull,format,col_len,field,col_precision) VALUES('SARA','''SARA''','','smallint','','N','System.Int16','smallint','N','foreignallowanceruledetailview','S','','2','maxforeigngroupnumber','')
GO

IF exists(SELECT * FROM columntypes WHERE tablename = 'foreignallowanceruledetailview' AND field = 'minforeigngroupnumber')
UPDATE columntypes set createuser = 'SARA',lastmoduser = '''SARA''',col_scale = '',sqltype = 'smallint',defaultvalue = '',allownull = 'N',systemtype = 'System.Int16',sqldeclaration = 'smallint',iskey = 'N',tablename = 'foreignallowanceruledetailview',denynull = 'S',format = '',col_len = '2',field = 'minforeigngroupnumber',col_precision = '' where tablename = 'foreignallowanceruledetailview' AND field = 'minforeigngroupnumber'
ELSE
INSERT INTO columntypes (createuser,lastmoduser,col_scale,sqltype,defaultvalue,allownull,systemtype,sqldeclaration,iskey,tablename,denynull,format,col_len,field,col_precision) VALUES('SARA','''SARA''','','smallint','','N','System.Int16','smallint','N','foreignallowanceruledetailview','S','','2','minforeigngroupnumber','')
GO

IF exists(SELECT * FROM columntypes WHERE tablename = 'foreignallowanceruledetailview' AND field = 'start')
UPDATE columntypes set createuser = 'SARA',lastmoduser = '''SARA''',col_scale = '',sqltype = 'datetime',defaultvalue = '',allownull = 'N',systemtype = 'System.DateTime',sqldeclaration = 'datetime',iskey = 'N',tablename = 'foreignallowanceruledetailview',denynull = 'S',format = '',col_len = '8',field = 'start',col_precision = '' where tablename = 'foreignallowanceruledetailview' AND field = 'start'
ELSE
INSERT INTO columntypes (createuser,lastmoduser,col_scale,sqltype,defaultvalue,allownull,systemtype,sqldeclaration,iskey,tablename,denynull,format,col_len,field,col_precision) VALUES('SARA','''SARA''','','datetime','','N','System.DateTime','datetime','N','foreignallowanceruledetailview','S','','8','start','')
GO

-- VERIFICA DI foreignallowanceruledetailview IN CUSTOMOBJECT --
IF EXISTS(select * from customobject where objectname = 'foreignallowanceruledetailview')
UPDATE customobject set isreal = 'N' where objectname = 'foreignallowanceruledetailview'
ELSE
INSERT INTO customobject (objectname, isreal) values('foreignallowanceruledetailview', 'N')
GO
-- FINE GENERAZIONE SCRIPT --

