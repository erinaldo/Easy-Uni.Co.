-- CREAZIONE VISTA locationunusable
IF EXISTS(select * from sysobjects where id = object_id(N'[locationunusable]') and OBJECTPROPERTY(id, N'IsView') = 1)
DROP VIEW [locationunusable]
GO




CREATE VIEW locationunusable
(
	idlocation,
	locationcode,
	nlevel,
	leveldescr,
	paridlocation,
	description,
	idman,
	manager,
	cu, 
	ct, 
	lu, 
	lt
)
AS SELECT
	location.idlocation,
	location.locationcode,
	location.nlevel,
	locationlevel.description,
	location.paridlocation,
	location.description,
	location.idman,
	manager.title,
	location.cu, 
	location.ct, 
	location.lu,
	location.lt 
FROM location
JOIN locationlevel
	ON locationlevel.nlevel = location.nlevel
LEFT OUTER JOIN manager
	ON manager.idman = location.idman
WHERE locationlevel.flag & 2 <> 2
	OR location.idlocation IN
		(SELECT paridlocation FROM location
		WHERE paridlocation IS NOT NULL)






GO

-- VERIFICA DI locationunusable IN COLUMNTYPES --
DELETE FROM columntypes WHERE tablename = 'locationunusable'
IF exists(SELECT * FROM columntypes WHERE tablename = 'locationunusable' AND field = 'ct')
UPDATE columntypes set createuser = 'NINO',lastmoduser = '''SARA''',col_scale = '',sqltype = 'datetime',defaultvalue = '',allownull = 'N',systemtype = 'System.DateTime',sqldeclaration = 'datetime',iskey = 'N',tablename = 'locationunusable',denynull = 'S',format = '',col_len = '8',field = 'ct',col_precision = '' where tablename = 'locationunusable' AND field = 'ct'
ELSE
INSERT INTO columntypes (createuser,lastmoduser,col_scale,sqltype,defaultvalue,allownull,systemtype,sqldeclaration,iskey,tablename,denynull,format,col_len,field,col_precision) VALUES('NINO','''SARA''','','datetime','','N','System.DateTime','datetime','N','locationunusable','S','','8','ct','')
GO

IF exists(SELECT * FROM columntypes WHERE tablename = 'locationunusable' AND field = 'cu')
UPDATE columntypes set createuser = 'NINO',lastmoduser = '''SARA''',col_scale = '',sqltype = 'varchar',defaultvalue = '',allownull = 'N',systemtype = 'System.String',sqldeclaration = 'varchar(64)',iskey = 'N',tablename = 'locationunusable',denynull = 'S',format = '',col_len = '64',field = 'cu',col_precision = '' where tablename = 'locationunusable' AND field = 'cu'
ELSE
INSERT INTO columntypes (createuser,lastmoduser,col_scale,sqltype,defaultvalue,allownull,systemtype,sqldeclaration,iskey,tablename,denynull,format,col_len,field,col_precision) VALUES('NINO','''SARA''','','varchar','','N','System.String','varchar(64)','N','locationunusable','S','','64','cu','')
GO

IF exists(SELECT * FROM columntypes WHERE tablename = 'locationunusable' AND field = 'description')
UPDATE columntypes set createuser = 'NINO',lastmoduser = '''SARA''',col_scale = '',sqltype = 'varchar',defaultvalue = '',allownull = 'N',systemtype = 'System.String',sqldeclaration = 'varchar(150)',iskey = 'N',tablename = 'locationunusable',denynull = 'S',format = '',col_len = '150',field = 'description',col_precision = '' where tablename = 'locationunusable' AND field = 'description'
ELSE
INSERT INTO columntypes (createuser,lastmoduser,col_scale,sqltype,defaultvalue,allownull,systemtype,sqldeclaration,iskey,tablename,denynull,format,col_len,field,col_precision) VALUES('NINO','''SARA''','','varchar','','N','System.String','varchar(150)','N','locationunusable','S','','150','description','')
GO

IF exists(SELECT * FROM columntypes WHERE tablename = 'locationunusable' AND field = 'idlocation')
UPDATE columntypes set createuser = 'NINO',lastmoduser = '''SARA''',col_scale = '',sqltype = 'int',defaultvalue = '',allownull = 'N',systemtype = 'System.Int32',sqldeclaration = 'int',iskey = 'N',tablename = 'locationunusable',denynull = 'S',format = '',col_len = '4',field = 'idlocation',col_precision = '' where tablename = 'locationunusable' AND field = 'idlocation'
ELSE
INSERT INTO columntypes (createuser,lastmoduser,col_scale,sqltype,defaultvalue,allownull,systemtype,sqldeclaration,iskey,tablename,denynull,format,col_len,field,col_precision) VALUES('NINO','''SARA''','','int','','N','System.Int32','int','N','locationunusable','S','','4','idlocation','')
GO

IF exists(SELECT * FROM columntypes WHERE tablename = 'locationunusable' AND field = 'idman')
UPDATE columntypes set createuser = 'NINO',lastmoduser = '''SARA''',col_scale = '',sqltype = 'int',defaultvalue = '',allownull = 'S',systemtype = 'System.Int32',sqldeclaration = 'int',iskey = 'N',tablename = 'locationunusable',denynull = 'N',format = '',col_len = '4',field = 'idman',col_precision = '' where tablename = 'locationunusable' AND field = 'idman'
ELSE
INSERT INTO columntypes (createuser,lastmoduser,col_scale,sqltype,defaultvalue,allownull,systemtype,sqldeclaration,iskey,tablename,denynull,format,col_len,field,col_precision) VALUES('NINO','''SARA''','','int','','S','System.Int32','int','N','locationunusable','N','','4','idman','')
GO

IF exists(SELECT * FROM columntypes WHERE tablename = 'locationunusable' AND field = 'leveldescr')
UPDATE columntypes set createuser = 'NINO',lastmoduser = '''SARA''',col_scale = '',sqltype = 'varchar',defaultvalue = '',allownull = 'N',systemtype = 'System.String',sqldeclaration = 'varchar(50)',iskey = 'N',tablename = 'locationunusable',denynull = 'S',format = '',col_len = '50',field = 'leveldescr',col_precision = '' where tablename = 'locationunusable' AND field = 'leveldescr'
ELSE
INSERT INTO columntypes (createuser,lastmoduser,col_scale,sqltype,defaultvalue,allownull,systemtype,sqldeclaration,iskey,tablename,denynull,format,col_len,field,col_precision) VALUES('NINO','''SARA''','','varchar','','N','System.String','varchar(50)','N','locationunusable','S','','50','leveldescr','')
GO

IF exists(SELECT * FROM columntypes WHERE tablename = 'locationunusable' AND field = 'locationcode')
UPDATE columntypes set createuser = 'NINO',lastmoduser = '''SARA''',col_scale = '',sqltype = 'varchar',defaultvalue = '',allownull = 'N',systemtype = 'System.String',sqldeclaration = 'varchar(50)',iskey = 'N',tablename = 'locationunusable',denynull = 'S',format = '',col_len = '50',field = 'locationcode',col_precision = '' where tablename = 'locationunusable' AND field = 'locationcode'
ELSE
INSERT INTO columntypes (createuser,lastmoduser,col_scale,sqltype,defaultvalue,allownull,systemtype,sqldeclaration,iskey,tablename,denynull,format,col_len,field,col_precision) VALUES('NINO','''SARA''','','varchar','','N','System.String','varchar(50)','N','locationunusable','S','','50','locationcode','')
GO

IF exists(SELECT * FROM columntypes WHERE tablename = 'locationunusable' AND field = 'lt')
UPDATE columntypes set createuser = 'NINO',lastmoduser = '''SARA''',col_scale = '',sqltype = 'datetime',defaultvalue = '',allownull = 'N',systemtype = 'System.DateTime',sqldeclaration = 'datetime',iskey = 'N',tablename = 'locationunusable',denynull = 'S',format = '',col_len = '8',field = 'lt',col_precision = '' where tablename = 'locationunusable' AND field = 'lt'
ELSE
INSERT INTO columntypes (createuser,lastmoduser,col_scale,sqltype,defaultvalue,allownull,systemtype,sqldeclaration,iskey,tablename,denynull,format,col_len,field,col_precision) VALUES('NINO','''SARA''','','datetime','','N','System.DateTime','datetime','N','locationunusable','S','','8','lt','')
GO

IF exists(SELECT * FROM columntypes WHERE tablename = 'locationunusable' AND field = 'lu')
UPDATE columntypes set createuser = 'NINO',lastmoduser = '''SARA''',col_scale = '',sqltype = 'varchar',defaultvalue = '',allownull = 'N',systemtype = 'System.String',sqldeclaration = 'varchar(64)',iskey = 'N',tablename = 'locationunusable',denynull = 'S',format = '',col_len = '64',field = 'lu',col_precision = '' where tablename = 'locationunusable' AND field = 'lu'
ELSE
INSERT INTO columntypes (createuser,lastmoduser,col_scale,sqltype,defaultvalue,allownull,systemtype,sqldeclaration,iskey,tablename,denynull,format,col_len,field,col_precision) VALUES('NINO','''SARA''','','varchar','','N','System.String','varchar(64)','N','locationunusable','S','','64','lu','')
GO

IF exists(SELECT * FROM columntypes WHERE tablename = 'locationunusable' AND field = 'manager')
UPDATE columntypes set createuser = 'NINO',lastmoduser = '''SARA''',col_scale = '',sqltype = 'varchar',defaultvalue = '',allownull = 'S',systemtype = 'System.String',sqldeclaration = 'varchar(150)',iskey = 'N',tablename = 'locationunusable',denynull = 'N',format = '',col_len = '150',field = 'manager',col_precision = '' where tablename = 'locationunusable' AND field = 'manager'
ELSE
INSERT INTO columntypes (createuser,lastmoduser,col_scale,sqltype,defaultvalue,allownull,systemtype,sqldeclaration,iskey,tablename,denynull,format,col_len,field,col_precision) VALUES('NINO','''SARA''','','varchar','','S','System.String','varchar(150)','N','locationunusable','N','','150','manager','')
GO

IF exists(SELECT * FROM columntypes WHERE tablename = 'locationunusable' AND field = 'nlevel')
UPDATE columntypes set createuser = 'NINO',lastmoduser = '''SARA''',col_scale = '',sqltype = 'tinyint',defaultvalue = '',allownull = 'N',systemtype = 'System.Byte',sqldeclaration = 'tinyint',iskey = 'N',tablename = 'locationunusable',denynull = 'S',format = '',col_len = '1',field = 'nlevel',col_precision = '' where tablename = 'locationunusable' AND field = 'nlevel'
ELSE
INSERT INTO columntypes (createuser,lastmoduser,col_scale,sqltype,defaultvalue,allownull,systemtype,sqldeclaration,iskey,tablename,denynull,format,col_len,field,col_precision) VALUES('NINO','''SARA''','','tinyint','','N','System.Byte','tinyint','N','locationunusable','S','','1','nlevel','')
GO

IF exists(SELECT * FROM columntypes WHERE tablename = 'locationunusable' AND field = 'paridlocation')
UPDATE columntypes set createuser = 'NINO',lastmoduser = '''SARA''',col_scale = '',sqltype = 'int',defaultvalue = '',allownull = 'S',systemtype = 'System.Int32',sqldeclaration = 'int',iskey = 'N',tablename = 'locationunusable',denynull = 'N',format = '',col_len = '4',field = 'paridlocation',col_precision = '' where tablename = 'locationunusable' AND field = 'paridlocation'
ELSE
INSERT INTO columntypes (createuser,lastmoduser,col_scale,sqltype,defaultvalue,allownull,systemtype,sqldeclaration,iskey,tablename,denynull,format,col_len,field,col_precision) VALUES('NINO','''SARA''','','int','','S','System.Int32','int','N','locationunusable','N','','4','paridlocation','')
GO

-- VERIFICA DI locationunusable IN CUSTOMOBJECT --
IF EXISTS(select * from customobject where objectname = 'locationunusable')
UPDATE customobject set isreal = 'N' where objectname = 'locationunusable'
ELSE
INSERT INTO customobject (objectname, isreal) values('locationunusable', 'N')
GO
-- FINE GENERAZIONE SCRIPT --

