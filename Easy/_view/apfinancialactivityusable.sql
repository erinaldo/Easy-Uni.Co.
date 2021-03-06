-- CREAZIONE VISTA apfinancialactivityusable
IF EXISTS(select * from sysobjects where id = object_id(N'[apfinancialactivityusable]') and OBJECTPROPERTY(id, N'IsView') = 1)
DROP VIEW [apfinancialactivityusable]
GO


--select * from apfinancialactivityusable


CREATE     VIEW [apfinancialactivityusable] 
(
	idapfinancialactivity,
	apfinancialactivitycode,
	nlevel,
	leveldescr,
	paridapfinancialactivity,
	description,
	active,
	cu, 
	ct, 
	lu, 
	lt
)
AS SELECT
	apfinancialactivity.idapfinancialactivity,
	apfinancialactivity.apfinancialactivitycode,
	apfinancialactivity.nlevel,
	apfinancialactivitylevel.description,
	apfinancialactivity.paridapfinancialactivity,
	apfinancialactivity.description,
	apfinancialactivity.active,
	apfinancialactivity.cu, 
	apfinancialactivity.ct, 
	apfinancialactivity.lu,
	apfinancialactivity.lt 
FROM apfinancialactivity
JOIN apfinancialactivitylevel
	ON apfinancialactivitylevel.nlevel = apfinancialactivity.nlevel
where apfinancialactivity.active ='S'
	AND apfinancialactivity.idapfinancialactivity NOT IN
		(SELECT paridapfinancialactivity FROM apfinancialactivity
		WHERE paridapfinancialactivity IS NOT NULL)







