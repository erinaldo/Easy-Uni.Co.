/*
    Easy
    Copyright (C) 2019 UniversitÓ degli Studi di Catania (www.unict.it)

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.
*/

using System;
using System.Data;
using System.Collections.Generic;
using System.Runtime.Serialization;
using metadatalibrary;
#pragma warning disable 1591
// ReSharper disable InconsistentNaming
// ReSharper disable UnusedMember.Global
namespace meta_wageaddition {
public class wageadditionRow: MetaRow  {
	public wageadditionRow(DataRowBuilder rb) : base(rb) {} 

	#region Field Definition
	///<summary>
	///N. contratto
	///</summary>
	public Int32? ncon{ 
		get {if (this["ncon"]==DBNull.Value)return null; return  (Int32?)this["ncon"];}
		set {if (value==null) this["ncon"]= DBNull.Value; else this["ncon"]= value;}
	}
	public object nconValue { 
		get{ return this["ncon"];}
		set {if (value==null|| value==DBNull.Value) this["ncon"]= DBNull.Value; else this["ncon"]= value;}
	}
	public Int32? nconOriginal { 
		get {if (this["ncon",DataRowVersion.Original]==DBNull.Value)return null; return  (Int32?)this["ncon",DataRowVersion.Original];}
	}
	///<summary>
	///Anno contratto
	///</summary>
	public Int32? ycon{ 
		get {if (this["ycon"]==DBNull.Value)return null; return  (Int32?)this["ycon"];}
		set {if (value==null) this["ycon"]= DBNull.Value; else this["ycon"]= value;}
	}
	public object yconValue { 
		get{ return this["ycon"];}
		set {if (value==null|| value==DBNull.Value) this["ycon"]= DBNull.Value; else this["ycon"]= value;}
	}
	public Int32? yconOriginal { 
		get {if (this["ycon",DataRowVersion.Original]==DBNull.Value)return null; return  (Int32?)this["ycon",DataRowVersion.Original];}
	}
	///<summary>
	///data contabile
	///</summary>
	public DateTime? adate{ 
		get {if (this["adate"]==DBNull.Value)return null; return  (DateTime?)this["adate"];}
		set {if (value==null) this["adate"]= DBNull.Value; else this["adate"]= value;}
	}
	public object adateValue { 
		get{ return this["adate"];}
		set {if (value==null|| value==DBNull.Value) this["adate"]= DBNull.Value; else this["adate"]= value;}
	}
	public DateTime? adateOriginal { 
		get {if (this["adate",DataRowVersion.Original]==DBNull.Value)return null; return  (DateTime?)this["adate",DataRowVersion.Original];}
	}
	///<summary>
	///N
	///</summary>
	public String completed{ 
		get {if (this["completed"]==DBNull.Value)return null; return  (String)this["completed"];}
		set {if (value==null) this["completed"]= DBNull.Value; else this["completed"]= value;}
	}
	public object completedValue { 
		get{ return this["completed"];}
		set {if (value==null|| value==DBNull.Value) this["completed"]= DBNull.Value; else this["completed"]= value;}
	}
	public String completedOriginal { 
		get {if (this["completed",DataRowVersion.Original]==DBNull.Value)return null; return  (String)this["completed",DataRowVersion.Original];}
	}
	///<summary>
	///data creazione
	///</summary>
	public DateTime? ct{ 
		get {if (this["ct"]==DBNull.Value)return null; return  (DateTime?)this["ct"];}
		set {if (value==null) this["ct"]= DBNull.Value; else this["ct"]= value;}
	}
	public object ctValue { 
		get{ return this["ct"];}
		set {if (value==null|| value==DBNull.Value) this["ct"]= DBNull.Value; else this["ct"]= value;}
	}
	public DateTime? ctOriginal { 
		get {if (this["ct",DataRowVersion.Original]==DBNull.Value)return null; return  (DateTime?)this["ct",DataRowVersion.Original];}
	}
	///<summary>
	///nome utente creazione
	///</summary>
	public String cu{ 
		get {if (this["cu"]==DBNull.Value)return null; return  (String)this["cu"];}
		set {if (value==null) this["cu"]= DBNull.Value; else this["cu"]= value;}
	}
	public object cuValue { 
		get{ return this["cu"];}
		set {if (value==null|| value==DBNull.Value) this["cu"]= DBNull.Value; else this["cu"]= value;}
	}
	public String cuOriginal { 
		get {if (this["cu",DataRowVersion.Original]==DBNull.Value)return null; return  (String)this["cu",DataRowVersion.Original];}
	}
	///<summary>
	///Descrizione
	///</summary>
	public String description{ 
		get {if (this["description"]==DBNull.Value)return null; return  (String)this["description"];}
		set {if (value==null) this["description"]= DBNull.Value; else this["description"]= value;}
	}
	public object descriptionValue { 
		get{ return this["description"];}
		set {if (value==null|| value==DBNull.Value) this["description"]= DBNull.Value; else this["description"]= value;}
	}
	public String descriptionOriginal { 
		get {if (this["description",DataRowVersion.Original]==DBNull.Value)return null; return  (String)this["description",DataRowVersion.Original];}
	}
	///<summary>
	///Importo lordo
	///</summary>
	public Decimal? feegross{ 
		get {if (this["feegross"]==DBNull.Value)return null; return  (Decimal?)this["feegross"];}
		set {if (value==null) this["feegross"]= DBNull.Value; else this["feegross"]= value;}
	}
	public object feegrossValue { 
		get{ return this["feegross"];}
		set {if (value==null|| value==DBNull.Value) this["feegross"]= DBNull.Value; else this["feegross"]= value;}
	}
	public Decimal? feegrossOriginal { 
		get {if (this["feegross",DataRowVersion.Original]==DBNull.Value)return null; return  (Decimal?)this["feegross",DataRowVersion.Original];}
	}
	///<summary>
	///id causale (tabella acccmotive)
	///</summary>
	public String idaccmotive{ 
		get {if (this["idaccmotive"]==DBNull.Value)return null; return  (String)this["idaccmotive"];}
		set {if (value==null) this["idaccmotive"]= DBNull.Value; else this["idaccmotive"]= value;}
	}
	public object idaccmotiveValue { 
		get{ return this["idaccmotive"];}
		set {if (value==null|| value==DBNull.Value) this["idaccmotive"]= DBNull.Value; else this["idaccmotive"]= value;}
	}
	public String idaccmotiveOriginal { 
		get {if (this["idaccmotive",DataRowVersion.Original]==DBNull.Value)return null; return  (String)this["idaccmotive",DataRowVersion.Original];}
	}
	///<summary>
	///id anagrafica (tabella registry)
	///</summary>
	public Int32? idreg{ 
		get {if (this["idreg"]==DBNull.Value)return null; return  (Int32?)this["idreg"];}
		set {if (value==null) this["idreg"]= DBNull.Value; else this["idreg"]= value;}
	}
	public object idregValue { 
		get{ return this["idreg"];}
		set {if (value==null|| value==DBNull.Value) this["idreg"]= DBNull.Value; else this["idreg"]= value;}
	}
	public Int32? idregOriginal { 
		get {if (this["idreg",DataRowVersion.Original]==DBNull.Value)return null; return  (Int32?)this["idreg",DataRowVersion.Original];}
	}
	///<summary>
	///id voce upb (tabella upb)
	///</summary>
	public String idupb{ 
		get {if (this["idupb"]==DBNull.Value)return null; return  (String)this["idupb"];}
		set {if (value==null) this["idupb"]= DBNull.Value; else this["idupb"]= value;}
	}
	public object idupbValue { 
		get{ return this["idupb"];}
		set {if (value==null|| value==DBNull.Value) this["idupb"]= DBNull.Value; else this["idupb"]= value;}
	}
	public String idupbOriginal { 
		get {if (this["idupb",DataRowVersion.Original]==DBNull.Value)return null; return  (String)this["idupb",DataRowVersion.Original];}
	}
	///<summary>
	///data ultima modifica
	///</summary>
	public DateTime? lt{ 
		get {if (this["lt"]==DBNull.Value)return null; return  (DateTime?)this["lt"];}
		set {if (value==null) this["lt"]= DBNull.Value; else this["lt"]= value;}
	}
	public object ltValue { 
		get{ return this["lt"];}
		set {if (value==null|| value==DBNull.Value) this["lt"]= DBNull.Value; else this["lt"]= value;}
	}
	public DateTime? ltOriginal { 
		get {if (this["lt",DataRowVersion.Original]==DBNull.Value)return null; return  (DateTime?)this["lt",DataRowVersion.Original];}
	}
	///<summary>
	///nome ultimo utente modifica
	///</summary>
	public String lu{ 
		get {if (this["lu"]==DBNull.Value)return null; return  (String)this["lu"];}
		set {if (value==null) this["lu"]= DBNull.Value; else this["lu"]= value;}
	}
	public object luValue { 
		get{ return this["lu"];}
		set {if (value==null|| value==DBNull.Value) this["lu"]= DBNull.Value; else this["lu"]= value;}
	}
	public String luOriginal { 
		get {if (this["lu",DataRowVersion.Original]==DBNull.Value)return null; return  (String)this["lu",DataRowVersion.Original];}
	}
	///<summary>
	///Durata (Giorni)
	///</summary>
	public Int32? ndays{ 
		get {if (this["ndays"]==DBNull.Value)return null; return  (Int32?)this["ndays"];}
		set {if (value==null) this["ndays"]= DBNull.Value; else this["ndays"]= value;}
	}
	public object ndaysValue { 
		get{ return this["ndays"];}
		set {if (value==null|| value==DBNull.Value) this["ndays"]= DBNull.Value; else this["ndays"]= value;}
	}
	public Int32? ndaysOriginal { 
		get {if (this["ndays",DataRowVersion.Original]==DBNull.Value)return null; return  (Int32?)this["ndays",DataRowVersion.Original];}
	}
	///<summary>
	///allegati
	///</summary>
	public Byte[] rtf{ 
		get {if (this["rtf"]==DBNull.Value)return null; return  (Byte[])this["rtf"];}
		set {if (value==null) this["rtf"]= DBNull.Value; else this["rtf"]= value;}
	}
	public object rtfValue { 
		get{ return this["rtf"];}
		set {if (value==null|| value==DBNull.Value) this["rtf"]= DBNull.Value; else this["rtf"]= value;}
	}
	public Byte[] rtfOriginal { 
		get {if (this["rtf",DataRowVersion.Original]==DBNull.Value)return null; return  (Byte[])this["rtf",DataRowVersion.Original];}
	}
	///<summary>
	///data inizio
	///</summary>
	public DateTime? start{ 
		get {if (this["start"]==DBNull.Value)return null; return  (DateTime?)this["start"];}
		set {if (value==null) this["start"]= DBNull.Value; else this["start"]= value;}
	}
	public object startValue { 
		get{ return this["start"];}
		set {if (value==null|| value==DBNull.Value) this["start"]= DBNull.Value; else this["start"]= value;}
	}
	public DateTime? startOriginal { 
		get {if (this["start",DataRowVersion.Original]==DBNull.Value)return null; return  (DateTime?)this["start",DataRowVersion.Original];}
	}
	///<summary>
	///data fine
	///</summary>
	public DateTime? stop{ 
		get {if (this["stop"]==DBNull.Value)return null; return  (DateTime?)this["stop"];}
		set {if (value==null) this["stop"]= DBNull.Value; else this["stop"]= value;}
	}
	public object stopValue { 
		get{ return this["stop"];}
		set {if (value==null|| value==DBNull.Value) this["stop"]= DBNull.Value; else this["stop"]= value;}
	}
	public DateTime? stopOriginal { 
		get {if (this["stop",DataRowVersion.Original]==DBNull.Value)return null; return  (DateTime?)this["stop",DataRowVersion.Original];}
	}
	///<summary>
	///note testuali
	///</summary>
	public String txt{ 
		get {if (this["txt"]==DBNull.Value)return null; return  (String)this["txt"];}
		set {if (value==null) this["txt"]= DBNull.Value; else this["txt"]= value;}
	}
	public object txtValue { 
		get{ return this["txt"];}
		set {if (value==null|| value==DBNull.Value) this["txt"]= DBNull.Value; else this["txt"]= value;}
	}
	public String txtOriginal { 
		get {if (this["txt",DataRowVersion.Original]==DBNull.Value)return null; return  (String)this["txt",DataRowVersion.Original];}
	}
	///<summary>
	///chiave prestazione (tabella service)
	///</summary>
	public Int32? idser{ 
		get {if (this["idser"]==DBNull.Value)return null; return  (Int32?)this["idser"];}
		set {if (value==null) this["idser"]= DBNull.Value; else this["idser"]= value;}
	}
	public object idserValue { 
		get{ return this["idser"];}
		set {if (value==null|| value==DBNull.Value) this["idser"]= DBNull.Value; else this["idser"]= value;}
	}
	public Int32? idserOriginal { 
		get {if (this["idser",DataRowVersion.Original]==DBNull.Value)return null; return  (Int32?)this["idser",DataRowVersion.Original];}
	}
	///<summary>
	///id voce analitica 1(tabella sorting)
	///</summary>
	public Int32? idsor1{ 
		get {if (this["idsor1"]==DBNull.Value)return null; return  (Int32?)this["idsor1"];}
		set {if (value==null) this["idsor1"]= DBNull.Value; else this["idsor1"]= value;}
	}
	public object idsor1Value { 
		get{ return this["idsor1"];}
		set {if (value==null|| value==DBNull.Value) this["idsor1"]= DBNull.Value; else this["idsor1"]= value;}
	}
	public Int32? idsor1Original { 
		get {if (this["idsor1",DataRowVersion.Original]==DBNull.Value)return null; return  (Int32?)this["idsor1",DataRowVersion.Original];}
	}
	///<summary>
	///id voce analitica 2(tabella sorting)
	///</summary>
	public Int32? idsor2{ 
		get {if (this["idsor2"]==DBNull.Value)return null; return  (Int32?)this["idsor2"];}
		set {if (value==null) this["idsor2"]= DBNull.Value; else this["idsor2"]= value;}
	}
	public object idsor2Value { 
		get{ return this["idsor2"];}
		set {if (value==null|| value==DBNull.Value) this["idsor2"]= DBNull.Value; else this["idsor2"]= value;}
	}
	public Int32? idsor2Original { 
		get {if (this["idsor2",DataRowVersion.Original]==DBNull.Value)return null; return  (Int32?)this["idsor2",DataRowVersion.Original];}
	}
	///<summary>
	///id voce analitica 3(tabella sorting)
	///</summary>
	public Int32? idsor3{ 
		get {if (this["idsor3"]==DBNull.Value)return null; return  (Int32?)this["idsor3"];}
		set {if (value==null) this["idsor3"]= DBNull.Value; else this["idsor3"]= value;}
	}
	public object idsor3Value { 
		get{ return this["idsor3"];}
		set {if (value==null|| value==DBNull.Value) this["idsor3"]= DBNull.Value; else this["idsor3"]= value;}
	}
	public Int32? idsor3Original { 
		get {if (this["idsor3",DataRowVersion.Original]==DBNull.Value)return null; return  (Int32?)this["idsor3",DataRowVersion.Original];}
	}
	///<summary>
	///Id della causale di debito (tabella accmotive) 
	///</summary>
	public String idaccmotivedebit{ 
		get {if (this["idaccmotivedebit"]==DBNull.Value)return null; return  (String)this["idaccmotivedebit"];}
		set {if (value==null) this["idaccmotivedebit"]= DBNull.Value; else this["idaccmotivedebit"]= value;}
	}
	public object idaccmotivedebitValue { 
		get{ return this["idaccmotivedebit"];}
		set {if (value==null|| value==DBNull.Value) this["idaccmotivedebit"]= DBNull.Value; else this["idaccmotivedebit"]= value;}
	}
	public String idaccmotivedebitOriginal { 
		get {if (this["idaccmotivedebit",DataRowVersion.Original]==DBNull.Value)return null; return  (String)this["idaccmotivedebit",DataRowVersion.Original];}
	}
	///<summary>
	///Id causale di debito - correzione (tabella accmotive)
	///</summary>
	public String idaccmotivedebit_crg{ 
		get {if (this["idaccmotivedebit_crg"]==DBNull.Value)return null; return  (String)this["idaccmotivedebit_crg"];}
		set {if (value==null) this["idaccmotivedebit_crg"]= DBNull.Value; else this["idaccmotivedebit_crg"]= value;}
	}
	public object idaccmotivedebit_crgValue { 
		get{ return this["idaccmotivedebit_crg"];}
		set {if (value==null|| value==DBNull.Value) this["idaccmotivedebit_crg"]= DBNull.Value; else this["idaccmotivedebit_crg"]= value;}
	}
	public String idaccmotivedebit_crgOriginal { 
		get {if (this["idaccmotivedebit_crg",DataRowVersion.Original]==DBNull.Value)return null; return  (String)this["idaccmotivedebit_crg",DataRowVersion.Original];}
	}
	///<summary>
	///Data correzione causale di debito
	///</summary>
	public DateTime? idaccmotivedebit_datacrg{ 
		get {if (this["idaccmotivedebit_datacrg"]==DBNull.Value)return null; return  (DateTime?)this["idaccmotivedebit_datacrg"];}
		set {if (value==null) this["idaccmotivedebit_datacrg"]= DBNull.Value; else this["idaccmotivedebit_datacrg"]= value;}
	}
	public object idaccmotivedebit_datacrgValue { 
		get{ return this["idaccmotivedebit_datacrg"];}
		set {if (value==null|| value==DBNull.Value) this["idaccmotivedebit_datacrg"]= DBNull.Value; else this["idaccmotivedebit_datacrg"]= value;}
	}
	public DateTime? idaccmotivedebit_datacrgOriginal { 
		get {if (this["idaccmotivedebit_datacrg",DataRowVersion.Original]==DBNull.Value)return null; return  (DateTime?)this["idaccmotivedebit_datacrg",DataRowVersion.Original];}
	}
	///<summary>
	///id progressivo pos. giuridica
	///</summary>
	public Int32? idregistrylegalstatus{ 
		get {if (this["idregistrylegalstatus"]==DBNull.Value)return null; return  (Int32?)this["idregistrylegalstatus"];}
		set {if (value==null) this["idregistrylegalstatus"]= DBNull.Value; else this["idregistrylegalstatus"]= value;}
	}
	public object idregistrylegalstatusValue { 
		get{ return this["idregistrylegalstatus"];}
		set {if (value==null|| value==DBNull.Value) this["idregistrylegalstatus"]= DBNull.Value; else this["idregistrylegalstatus"]= value;}
	}
	public Int32? idregistrylegalstatusOriginal { 
		get {if (this["idregistrylegalstatus",DataRowVersion.Original]==DBNull.Value)return null; return  (Int32?)this["idregistrylegalstatus",DataRowVersion.Original];}
	}
	///<summary>
	///Doc. autorizzazione
	///</summary>
	public String authdoc{ 
		get {if (this["authdoc"]==DBNull.Value)return null; return  (String)this["authdoc"];}
		set {if (value==null) this["authdoc"]= DBNull.Value; else this["authdoc"]= value;}
	}
	public object authdocValue { 
		get{ return this["authdoc"];}
		set {if (value==null|| value==DBNull.Value) this["authdoc"]= DBNull.Value; else this["authdoc"]= value;}
	}
	public String authdocOriginal { 
		get {if (this["authdoc",DataRowVersion.Original]==DBNull.Value)return null; return  (String)this["authdoc",DataRowVersion.Original];}
	}
	///<summary>
	///Data autorizzazione
	///</summary>
	public DateTime? authdocdate{ 
		get {if (this["authdocdate"]==DBNull.Value)return null; return  (DateTime?)this["authdocdate"];}
		set {if (value==null) this["authdocdate"]= DBNull.Value; else this["authdocdate"]= value;}
	}
	public object authdocdateValue { 
		get{ return this["authdocdate"];}
		set {if (value==null|| value==DBNull.Value) this["authdocdate"]= DBNull.Value; else this["authdocdate"]= value;}
	}
	public DateTime? authdocdateOriginal { 
		get {if (this["authdocdate",DataRowVersion.Original]==DBNull.Value)return null; return  (DateTime?)this["authdocdate",DataRowVersion.Original];}
	}
	///<summary>
	///Autorizzaz. richiesta
	///</summary>
	public String authneeded{ 
		get {if (this["authneeded"]==DBNull.Value)return null; return  (String)this["authneeded"];}
		set {if (value==null) this["authneeded"]= DBNull.Value; else this["authneeded"]= value;}
	}
	public object authneededValue { 
		get{ return this["authneeded"];}
		set {if (value==null|| value==DBNull.Value) this["authneeded"]= DBNull.Value; else this["authneeded"]= value;}
	}
	public String authneededOriginal { 
		get {if (this["authneeded",DataRowVersion.Original]==DBNull.Value)return null; return  (String)this["authneeded",DataRowVersion.Original];}
	}
	///<summary>
	///Motivo di rifiuto autorizzazione
	///</summary>
	public String noauthreason{ 
		get {if (this["noauthreason"]==DBNull.Value)return null; return  (String)this["noauthreason"];}
		set {if (value==null) this["noauthreason"]= DBNull.Value; else this["noauthreason"]= value;}
	}
	public object noauthreasonValue { 
		get{ return this["noauthreason"];}
		set {if (value==null|| value==DBNull.Value) this["noauthreason"]= DBNull.Value; else this["noauthreason"]= value;}
	}
	public String noauthreasonOriginal { 
		get {if (this["noauthreason",DataRowVersion.Original]==DBNull.Value)return null; return  (String)this["noauthreason",DataRowVersion.Original];}
	}
	///<summary>
	///codice debitore pignorato
	///</summary>
	public Int32? idreg_distrained{ 
		get {if (this["idreg_distrained"]==DBNull.Value)return null; return  (Int32?)this["idreg_distrained"];}
		set {if (value==null) this["idreg_distrained"]= DBNull.Value; else this["idreg_distrained"]= value;}
	}
	public object idreg_distrainedValue { 
		get{ return this["idreg_distrained"];}
		set {if (value==null|| value==DBNull.Value) this["idreg_distrained"]= DBNull.Value; else this["idreg_distrained"]= value;}
	}
	public Int32? idreg_distrainedOriginal { 
		get {if (this["idreg_distrained",DataRowVersion.Original]==DBNull.Value)return null; return  (Int32?)this["idreg_distrained",DataRowVersion.Original];}
	}
	///<summary>
	///id voce class.sicurezza 1(tabella sorting)
	///</summary>
	public Int32? idsor01{ 
		get {if (this["idsor01"]==DBNull.Value)return null; return  (Int32?)this["idsor01"];}
		set {if (value==null) this["idsor01"]= DBNull.Value; else this["idsor01"]= value;}
	}
	public object idsor01Value { 
		get{ return this["idsor01"];}
		set {if (value==null|| value==DBNull.Value) this["idsor01"]= DBNull.Value; else this["idsor01"]= value;}
	}
	public Int32? idsor01Original { 
		get {if (this["idsor01",DataRowVersion.Original]==DBNull.Value)return null; return  (Int32?)this["idsor01",DataRowVersion.Original];}
	}
	///<summary>
	///id voce class.sicurezza 2(tabella sorting)
	///</summary>
	public Int32? idsor02{ 
		get {if (this["idsor02"]==DBNull.Value)return null; return  (Int32?)this["idsor02"];}
		set {if (value==null) this["idsor02"]= DBNull.Value; else this["idsor02"]= value;}
	}
	public object idsor02Value { 
		get{ return this["idsor02"];}
		set {if (value==null|| value==DBNull.Value) this["idsor02"]= DBNull.Value; else this["idsor02"]= value;}
	}
	public Int32? idsor02Original { 
		get {if (this["idsor02",DataRowVersion.Original]==DBNull.Value)return null; return  (Int32?)this["idsor02",DataRowVersion.Original];}
	}
	///<summary>
	///id voce class.sicurezza 3(tabella sorting)
	///</summary>
	public Int32? idsor03{ 
		get {if (this["idsor03"]==DBNull.Value)return null; return  (Int32?)this["idsor03"];}
		set {if (value==null) this["idsor03"]= DBNull.Value; else this["idsor03"]= value;}
	}
	public object idsor03Value { 
		get{ return this["idsor03"];}
		set {if (value==null|| value==DBNull.Value) this["idsor03"]= DBNull.Value; else this["idsor03"]= value;}
	}
	public Int32? idsor03Original { 
		get {if (this["idsor03",DataRowVersion.Original]==DBNull.Value)return null; return  (Int32?)this["idsor03",DataRowVersion.Original];}
	}
	///<summary>
	///id voce class.sicurezza 4(tabella sorting)
	///</summary>
	public Int32? idsor04{ 
		get {if (this["idsor04"]==DBNull.Value)return null; return  (Int32?)this["idsor04"];}
		set {if (value==null) this["idsor04"]= DBNull.Value; else this["idsor04"]= value;}
	}
	public object idsor04Value { 
		get{ return this["idsor04"];}
		set {if (value==null|| value==DBNull.Value) this["idsor04"]= DBNull.Value; else this["idsor04"]= value;}
	}
	public Int32? idsor04Original { 
		get {if (this["idsor04",DataRowVersion.Original]==DBNull.Value)return null; return  (Int32?)this["idsor04",DataRowVersion.Original];}
	}
	///<summary>
	///id voce class.sicurezza 5(tabella sorting)
	///</summary>
	public Int32? idsor05{ 
		get {if (this["idsor05"]==DBNull.Value)return null; return  (Int32?)this["idsor05"];}
		set {if (value==null) this["idsor05"]= DBNull.Value; else this["idsor05"]= value;}
	}
	public object idsor05Value { 
		get{ return this["idsor05"];}
		set {if (value==null|| value==DBNull.Value) this["idsor05"]= DBNull.Value; else this["idsor05"]= value;}
	}
	public Int32? idsor05Original { 
		get {if (this["idsor05",DataRowVersion.Original]==DBNull.Value)return null; return  (Int32?)this["idsor05",DataRowVersion.Original];}
	}
	///<summary>
	///Posizione Dalia
	///</summary>
	public Int32? iddaliaposition{ 
		get {if (this["iddaliaposition"]==DBNull.Value)return null; return  (Int32?)this["iddaliaposition"];}
		set {if (value==null) this["iddaliaposition"]= DBNull.Value; else this["iddaliaposition"]= value;}
	}
	public object iddaliapositionValue { 
		get{ return this["iddaliaposition"];}
		set {if (value==null|| value==DBNull.Value) this["iddaliaposition"]= DBNull.Value; else this["iddaliaposition"]= value;}
	}
	public Int32? iddaliapositionOriginal { 
		get {if (this["iddaliaposition",DataRowVersion.Original]==DBNull.Value)return null; return  (Int32?)this["iddaliaposition",DataRowVersion.Original];}
	}
	///<summary>
	///id della class. siope (idsor di sorting) per il costo
	///</summary>
	public Int32? idsor_siope{ 
		get {if (this["idsor_siope"]==DBNull.Value)return null; return  (Int32?)this["idsor_siope"];}
		set {if (value==null) this["idsor_siope"]= DBNull.Value; else this["idsor_siope"]= value;}
	}
	public object idsor_siopeValue { 
		get{ return this["idsor_siope"];}
		set {if (value==null|| value==DBNull.Value) this["idsor_siope"]= DBNull.Value; else this["idsor_siope"]= value;}
	}
	public Int32? idsor_siopeOriginal { 
		get {if (this["idsor_siope",DataRowVersion.Original]==DBNull.Value)return null; return  (Int32?)this["idsor_siope",DataRowVersion.Original];}
	}
	public Int32? iddaliarecruitmentmotive{ 
		get {if (this["iddaliarecruitmentmotive"]==DBNull.Value)return null; return  (Int32?)this["iddaliarecruitmentmotive"];}
		set {if (value==null) this["iddaliarecruitmentmotive"]= DBNull.Value; else this["iddaliarecruitmentmotive"]= value;}
	}
	public object iddaliarecruitmentmotiveValue { 
		get{ return this["iddaliarecruitmentmotive"];}
		set {if (value==null|| value==DBNull.Value) this["iddaliarecruitmentmotive"]= DBNull.Value; else this["iddaliarecruitmentmotive"]= value;}
	}
	public Int32? iddaliarecruitmentmotiveOriginal { 
		get {if (this["iddaliarecruitmentmotive",DataRowVersion.Original]==DBNull.Value)return null; return  (Int32?)this["iddaliarecruitmentmotive",DataRowVersion.Original];}
	}
	#endregion

}
///<summary>
///Altri Compensi
///</summary>
public class wageadditionTable : MetaTableBase<wageadditionRow> {
	public wageadditionTable() : base("wageaddition"){
		baseColumns = new Dictionary<string, DataColumn>(){
			{"ncon",createColumn("ncon",typeof(int),false,false)},
			{"ycon",createColumn("ycon",typeof(int),false,false)},
			{"adate",createColumn("adate",typeof(DateTime),false,false)},
			{"completed",createColumn("completed",typeof(string),true,false)},
			{"ct",createColumn("ct",typeof(DateTime),false,false)},
			{"cu",createColumn("cu",typeof(string),false,false)},
			{"description",createColumn("description",typeof(string),false,false)},
			{"feegross",createColumn("feegross",typeof(decimal),false,false)},
			{"idaccmotive",createColumn("idaccmotive",typeof(string),true,false)},
			{"idreg",createColumn("idreg",typeof(int),false,false)},
			{"idupb",createColumn("idupb",typeof(string),true,false)},
			{"lt",createColumn("lt",typeof(DateTime),false,false)},
			{"lu",createColumn("lu",typeof(string),false,false)},
			{"ndays",createColumn("ndays",typeof(int),false,false)},
			{"rtf",createColumn("rtf",typeof(Byte[]),true,false)},
			{"start",createColumn("start",typeof(DateTime),false,false)},
			{"stop",createColumn("stop",typeof(DateTime),false,false)},
			{"txt",createColumn("txt",typeof(string),true,false)},
			{"idser",createColumn("idser",typeof(int),false,false)},
			{"idsor1",createColumn("idsor1",typeof(int),true,false)},
			{"idsor2",createColumn("idsor2",typeof(int),true,false)},
			{"idsor3",createColumn("idsor3",typeof(int),true,false)},
			{"idaccmotivedebit",createColumn("idaccmotivedebit",typeof(string),true,false)},
			{"idaccmotivedebit_crg",createColumn("idaccmotivedebit_crg",typeof(string),true,false)},
			{"idaccmotivedebit_datacrg",createColumn("idaccmotivedebit_datacrg",typeof(DateTime),true,false)},
			{"idregistrylegalstatus",createColumn("idregistrylegalstatus",typeof(int),true,false)},
			{"authdoc",createColumn("authdoc",typeof(string),true,false)},
			{"authdocdate",createColumn("authdocdate",typeof(DateTime),true,false)},
			{"authneeded",createColumn("authneeded",typeof(string),true,false)},
			{"noauthreason",createColumn("noauthreason",typeof(string),true,false)},
			{"idreg_distrained",createColumn("idreg_distrained",typeof(int),true,false)},
			{"idsor01",createColumn("idsor01",typeof(int),true,false)},
			{"idsor02",createColumn("idsor02",typeof(int),true,false)},
			{"idsor03",createColumn("idsor03",typeof(int),true,false)},
			{"idsor04",createColumn("idsor04",typeof(int),true,false)},
			{"idsor05",createColumn("idsor05",typeof(int),true,false)},
			{"iddaliaposition",createColumn("iddaliaposition",typeof(int),true,false)},
			{"idsor_siope",createColumn("idsor_siope",typeof(int),true,false)},
			{"iddaliarecruitmentmotive",createColumn("iddaliarecruitmentmotive",typeof(int),true,false)},
		};
	}
}
}
