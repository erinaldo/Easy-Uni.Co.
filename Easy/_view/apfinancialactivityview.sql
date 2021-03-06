-- CREAZIONE VISTA apfinancialactivityview
IF EXISTS(select * from sysobjects where id = object_id(N'[apfinancialactivityview]') and OBJECTPROPERTY(id, N'IsView') = 1)
DROP VIEW [apfinancialactivityview]
GO





CREATE     VIEW [apfinancialactivityview] 
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








