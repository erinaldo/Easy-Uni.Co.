 

 --------------------------------
 --- unita organizzativa --------
 --------------------------------

/****** Object:  Index [PK_UNITA_ORGANIZZATIVA_1]    Script Date: 15/11/2013 14.23.18 ******/
ALTER TABLE [dbo].[UNITA_ORGANIZZATIVA] ADD  CONSTRAINT [PK_UNITA_ORGANIZZATIVA_1] PRIMARY KEY CLUSTERED 
(
	[CHIAVE_COMPLETA] ASC,
	[VERSIONE] ASC,
	[ESERCIZIO] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
GO

 
/****** Object:  Index [ix1_unita_organizzativa]    Script Date: 15/11/2013 14.23.59 ******/
CREATE NONCLUSTERED INDEX [ix1_unita_organizzativa] ON [dbo].[UNITA_ORGANIZZATIVA]
(
	[CHIAVE_COMPLETA_PADRE] ASC,
	[ESERCIZIO] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
GO
 



 --------------------------------
 --- relazione_dcont_dcont --------
 --------------------------------
 
/****** Object:  Index [PK_RELAZIONE_DCONT_DCONT]    Script Date: 15/11/2013 14.30.59 ******/
ALTER TABLE [dbo].[RELAZIONE_DCONT_DCONT] ADD  CONSTRAINT [PK_RELAZIONE_DCONT_DCONT] PRIMARY KEY CLUSTERED 
(
	[CHIAVE_COMPLETA_DOC_PADRE] ASC,
	[CHIAVE_COMPLETA_DOC_FIGLIO] ASC,
	[BILANCIO] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
GO
 


 --------------------------------
 --- bilancio-cassiere --------
 --------------------------------
 

/****** Object:  Index [PK_BILANCIO_CASSIERE]    Script Date: 15/11/2013 14.32.21 ******/
ALTER TABLE [dbo].[BILANCIO_CASSIERE] ADD  CONSTRAINT [PK_BILANCIO_CASSIERE] PRIMARY KEY CLUSTERED 
(
	[CODICE_BILANCIO] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
GO



 --------------------------------
 ---conto_f --------
 --------------------------------
 
 

/****** Object:  Index [PK_CONTO_F]    Script Date: 15/11/2013 14.33.49 ******/
ALTER TABLE [dbo].[CONTO_F] ADD  CONSTRAINT [PK_CONTO_F] PRIMARY KEY CLUSTERED 
(
	[ESERCIZIO] ASC,
	[CHIAVE_COMPLETA] ASC,
	[CHIAVE_PIANO] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
GO
 


 --------------------------------
 ---ordine  --------
 --------------------------------
 
/****** Object:  Index [PK_ORDINE]    Script Date: 15/11/2013 14.42.30 ******/
ALTER TABLE [dbo].[ORDINE] ADD  CONSTRAINT [PK_ORDINE] PRIMARY KEY CLUSTERED 
(
	[ESERCIZIO] ASC,
	[BILANCIO] ASC,
	[NUMERO_ORDINE] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
GO





 --------------------------------
 ---preventivo  --------
 -------------------------------
 

/****** Object:  Index [PK_PREVENTIVO]    Script Date: 15/11/2013 14.44.09 ******/
ALTER TABLE [dbo].[PREVENTIVO] ADD  CONSTRAINT [PK_PREVENTIVO] PRIMARY KEY CLUSTERED 
(
	[CHIAVE_PIANO] ASC,
	[BILANCIO] ASC,
	[CHIAVE_COMPLETA] ASC,
	[CHIAVE_VERSIONE] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
GO

 
 --------------------------------
 ---preventivo_rip_var  --------
 -------------------------------
 

/****** Object:  Index [PK_PREVENTIVO_RIP_VAR]    Script Date: 15/11/2013 14.45.24 ******/
ALTER TABLE [dbo].[PREVENTIVO_RIP_VAR] ADD  CONSTRAINT [PK_PREVENTIVO_RIP_VAR] PRIMARY KEY CLUSTERED 
(
	[CHIAVE_PIANO] ASC,
	[BILANCIO] ASC,
	[UNITA_ORGANIZZATIVA] ASC,
	[CHIAVE_COMPLETA] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
GO



 --------------------------------
 ---preventivo_ripartizione  --------
 -------------------------------
 

/****** Object:  Index [PK_PREVENTIVO_RIPARTIZIONE]    Script Date: 15/11/2013 14.46.16 ******/
ALTER TABLE [dbo].[PREVENTIVO_RIPARTIZIONE] ADD  CONSTRAINT [PK_PREVENTIVO_RIPARTIZIONE] PRIMARY KEY CLUSTERED 
(
	[CHIAVE_PIANO] ASC,
	[BILANCIO] ASC,
	[CHIAVE_COMPLETA] ASC,
	[UNITA_ORGANIZZATIVA] ASC,
	[CHIAVE_VERSIONE] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
GO

 
/****** Object:  Index [xi1_prevrip]    Script Date: 15/11/2013 14.46.42 ******/
CREATE NONCLUSTERED INDEX [xi1_prevrip] ON [dbo].[PREVENTIVO_RIPARTIZIONE]
(
	[CHIAVE_PIANO] ASC,
	[BILANCIO] ASC,
	[CHIAVE_COMPLETA] ASC,
	[UNITA_ORGANIZZATIVA] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
GO




GO

/****** Object:  Index [xi1_documento_generico]    Script Date: 17/12/2013 15.46.29 ******/
CREATE NONCLUSTERED INDEX [xi1_documento_generico] ON [dbo].[curr_documento_contabile]
(
	[CHIAVE_COMPLETA_DOCUMENTO] ASC,
	[ESERCIZIO] ASC,
	[NUMERO_VERSIONE] ASC,
	[BILANCIO] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
GO


/****** Object:  Index [xpk_fattura]    Script Date: 22/01/2014 12.55.34 ******/
CREATE CLUSTERED INDEX [xpk_fattura] ON [dbo].[FATTURA]
(
	[BILANCIO] ASC,
	[ESERCIZIO] ASC,
	[NUMERO_FATTURA] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO



/****** Object:  Index [xpk_fattura_att]    Script Date: 22/01/2014 12.55.52 ******/
CREATE CLUSTERED INDEX [xpk_fattura_att] ON [dbo].[FATTURA_ATT]
(
	[BILANCIO] ASC,
	[ESERCIZIO] ASC,
	[NUMERO_FATTURA] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO


/****** Object:  Index [xpk_FATTURA_ATT_DETTAGLIO]    Script Date: 22/01/2014 12.56.07 ******/
CREATE UNIQUE CLUSTERED INDEX [xpk_FATTURA_ATT_DETTAGLIO] ON [dbo].[FATTURA_ATT_DETTAGLIO]
(
	[BILANCIO] ASC,
	[ESERCIZIO] ASC,
	[NUMERO_FATTURA] ASC,
	[NUMERO_DETTAGLIO] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
USE [TEST]
GO


/****** Object:  Index [xpk_FATTURA_ATT_DETTAGLIO_S]    Script Date: 22/01/2014 12.56.19 ******/
CREATE CLUSTERED INDEX [xpk_FATTURA_ATT_DETTAGLIO_S] ON [dbo].[FATTURA_ATT_DETTAGLIO_S]
(
	[BILANCIO] ASC,
	[ESERCIZIO] ASC,
	[NUMERO_FATTURA] ASC,
	[NUMERO_DETTAGLIO] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO

