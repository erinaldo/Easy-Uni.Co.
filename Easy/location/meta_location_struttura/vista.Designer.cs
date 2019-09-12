/*
    Easy
    Copyright (C) 2019 Universit� degli Studi di Catania (www.unict.it)

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
namespace meta_location_struttura {
public class location_strutturaRow: MetaRow  {
	public location_strutturaRow(DataRowBuilder rb) : base(rb) {} 

	#region Field Definition
	///<summary>
	///Codice IPA
	///</summary>
	public String codiceipa{ 
		get {if (this["codiceipa"]==DBNull.Value)return null; return  (String)this["codiceipa"];}
		set {if (value==null) this["codiceipa"]= DBNull.Value; else this["codiceipa"]= value;}
	}
	public object codiceipaValue { 
		get{ return this["codiceipa"];}
		set {if (value==null|| value==DBNull.Value) this["codiceipa"]= DBNull.Value; else this["codiceipa"]= value;}
	}
	public String codiceipaOriginal { 
		get {if (this["codiceipa",DataRowVersion.Original]==DBNull.Value)return null; return  (String)this["codiceipa",DataRowVersion.Original];}
	}
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
	///Codice AOO
	///</summary>
	public Int32? idaoo{ 
		get {if (this["idaoo"]==DBNull.Value)return null; return  (Int32?)this["idaoo"];}
		set {if (value==null) this["idaoo"]= DBNull.Value; else this["idaoo"]= value;}
	}
	public object idaooValue { 
		get{ return this["idaoo"];}
		set {if (value==null|| value==DBNull.Value) this["idaoo"]= DBNull.Value; else this["idaoo"]= value;}
	}
	public Int32? idaooOriginal { 
		get {if (this["idaoo",DataRowVersion.Original]==DBNull.Value)return null; return  (Int32?)this["idaoo",DataRowVersion.Original];}
	}
	///<summary>
	///Codice
	///</summary>
	public Int32? idlocation{ 
		get {if (this["idlocation"]==DBNull.Value)return null; return  (Int32?)this["idlocation"];}
		set {if (value==null) this["idlocation"]= DBNull.Value; else this["idlocation"]= value;}
	}
	public object idlocationValue { 
		get{ return this["idlocation"];}
		set {if (value==null|| value==DBNull.Value) this["idlocation"]= DBNull.Value; else this["idlocation"]= value;}
	}
	public Int32? idlocationOriginal { 
		get {if (this["idlocation",DataRowVersion.Original]==DBNull.Value)return null; return  (Int32?)this["idlocation",DataRowVersion.Original];}
	}
	///<summary>
	///Sede
	///</summary>
	public Int32? idlocation_sede{ 
		get {if (this["idlocation_sede"]==DBNull.Value)return null; return  (Int32?)this["idlocation_sede"];}
		set {if (value==null) this["idlocation_sede"]= DBNull.Value; else this["idlocation_sede"]= value;}
	}
	public object idlocation_sedeValue { 
		get{ return this["idlocation_sede"];}
		set {if (value==null|| value==DBNull.Value) this["idlocation_sede"]= DBNull.Value; else this["idlocation_sede"]= value;}
	}
	public Int32? idlocation_sedeOriginal { 
		get {if (this["idlocation_sede",DataRowVersion.Original]==DBNull.Value)return null; return  (Int32?)this["idlocation_sede",DataRowVersion.Original];}
	}
	///<summary>
	///Tipologia
	///</summary>
	public Int32? idstrutturakind{ 
		get {if (this["idstrutturakind"]==DBNull.Value)return null; return  (Int32?)this["idstrutturakind"];}
		set {if (value==null) this["idstrutturakind"]= DBNull.Value; else this["idstrutturakind"]= value;}
	}
	public object idstrutturakindValue { 
		get{ return this["idstrutturakind"];}
		set {if (value==null|| value==DBNull.Value) this["idstrutturakind"]= DBNull.Value; else this["idstrutturakind"]= value;}
	}
	public Int32? idstrutturakindOriginal { 
		get {if (this["idstrutturakind",DataRowVersion.Original]==DBNull.Value)return null; return  (Int32?)this["idstrutturakind",DataRowVersion.Original];}
	}
	///<summary>
	///UPB
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
	///Denominazione (ENG)
	///</summary>
	public String title_en{ 
		get {if (this["title_en"]==DBNull.Value)return null; return  (String)this["title_en"];}
		set {if (value==null) this["title_en"]= DBNull.Value; else this["title_en"]= value;}
	}
	public object title_enValue { 
		get{ return this["title_en"];}
		set {if (value==null|| value==DBNull.Value) this["title_en"]= DBNull.Value; else this["title_en"]= value;}
	}
	public String title_enOriginal { 
		get {if (this["title_en",DataRowVersion.Original]==DBNull.Value)return null; return  (String)this["title_en",DataRowVersion.Original];}
	}
	#endregion

}
///<summary>
///2.4.11 Struttura / Unità organizzativa
///</summary>
public class location_strutturaTable : MetaTableBase<location_strutturaRow> {
	public location_strutturaTable() : base("location_struttura"){
		baseColumns = new Dictionary<string, DataColumn>(){
			{"codiceipa",createColumn("codiceipa",typeof(string),true,false)},
			{"ct",createColumn("ct",typeof(DateTime),false,false)},
			{"cu",createColumn("cu",typeof(string),false,false)},
			{"idaoo",createColumn("idaoo",typeof(int),true,false)},
			{"idlocation",createColumn("idlocation",typeof(int),false,false)},
			{"idlocation_sede",createColumn("idlocation_sede",typeof(int),false,false)},
			{"idstrutturakind",createColumn("idstrutturakind",typeof(int),false,false)},
			{"idupb",createColumn("idupb",typeof(string),false,false)},
			{"lt",createColumn("lt",typeof(DateTime),false,false)},
			{"lu",createColumn("lu",typeof(string),false,false)},
			{"title_en",createColumn("title_en",typeof(string),true,false)},
		};
	}
}
}
