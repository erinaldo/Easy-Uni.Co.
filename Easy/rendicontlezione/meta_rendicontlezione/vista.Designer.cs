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
namespace meta_rendicontlezione {
public class rendicontlezioneRow: MetaRow  {
	public rendicontlezioneRow(DataRowBuilder rb) : base(rb) {} 

	#region Field Definition
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
	///Lezione
	///</summary>
	public Int32? idlezione{ 
		get {if (this["idlezione"]==DBNull.Value)return null; return  (Int32?)this["idlezione"];}
		set {if (value==null) this["idlezione"]= DBNull.Value; else this["idlezione"]= value;}
	}
	public object idlezioneValue { 
		get{ return this["idlezione"];}
		set {if (value==null|| value==DBNull.Value) this["idlezione"]= DBNull.Value; else this["idlezione"]= value;}
	}
	public Int32? idlezioneOriginal { 
		get {if (this["idlezione",DataRowVersion.Original]==DBNull.Value)return null; return  (Int32?)this["idlezione",DataRowVersion.Original];}
	}
	///<summary>
	///Rendicontazione
	///</summary>
	public Int32? idrendicont{ 
		get {if (this["idrendicont"]==DBNull.Value)return null; return  (Int32?)this["idrendicont"];}
		set {if (value==null) this["idrendicont"]= DBNull.Value; else this["idrendicont"]= value;}
	}
	public object idrendicontValue { 
		get{ return this["idrendicont"];}
		set {if (value==null|| value==DBNull.Value) this["idrendicont"]= DBNull.Value; else this["idrendicont"]= value;}
	}
	public Int32? idrendicontOriginal { 
		get {if (this["idrendicont",DataRowVersion.Original]==DBNull.Value)return null; return  (Int32?)this["idrendicont",DataRowVersion.Original];}
	}
	///<summary>
	///Codice
	///</summary>
	public Int32? idrendicontlezione{ 
		get {if (this["idrendicontlezione"]==DBNull.Value)return null; return  (Int32?)this["idrendicontlezione"];}
		set {if (value==null) this["idrendicontlezione"]= DBNull.Value; else this["idrendicontlezione"]= value;}
	}
	public object idrendicontlezioneValue { 
		get{ return this["idrendicontlezione"];}
		set {if (value==null|| value==DBNull.Value) this["idrendicontlezione"]= DBNull.Value; else this["idrendicontlezione"]= value;}
	}
	public Int32? idrendicontlezioneOriginal { 
		get {if (this["idrendicontlezione",DataRowVersion.Original]==DBNull.Value)return null; return  (Int32?)this["idrendicontlezione",DataRowVersion.Original];}
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
	///Non svolta
	///</summary>
	public String nonsvolta{ 
		get {if (this["nonsvolta"]==DBNull.Value)return null; return  (String)this["nonsvolta"];}
		set {if (value==null) this["nonsvolta"]= DBNull.Value; else this["nonsvolta"]= value;}
	}
	public object nonsvoltaValue { 
		get{ return this["nonsvolta"];}
		set {if (value==null|| value==DBNull.Value) this["nonsvolta"]= DBNull.Value; else this["nonsvolta"]= value;}
	}
	public String nonsvoltaOriginal { 
		get {if (this["nonsvolta",DataRowVersion.Original]==DBNull.Value)return null; return  (String)this["nonsvolta",DataRowVersion.Original];}
	}
	public String stage{ 
		get {if (this["stage"]==DBNull.Value)return null; return  (String)this["stage"];}
		set {if (value==null) this["stage"]= DBNull.Value; else this["stage"]= value;}
	}
	public object stageValue { 
		get{ return this["stage"];}
		set {if (value==null|| value==DBNull.Value) this["stage"]= DBNull.Value; else this["stage"]= value;}
	}
	public String stageOriginal { 
		get {if (this["stage",DataRowVersion.Original]==DBNull.Value)return null; return  (String)this["stage",DataRowVersion.Original];}
	}
	public String visita{ 
		get {if (this["visita"]==DBNull.Value)return null; return  (String)this["visita"];}
		set {if (value==null) this["visita"]= DBNull.Value; else this["visita"]= value;}
	}
	public object visitaValue { 
		get{ return this["visita"];}
		set {if (value==null|| value==DBNull.Value) this["visita"]= DBNull.Value; else this["visita"]= value;}
	}
	public String visitaOriginal { 
		get {if (this["visita",DataRowVersion.Original]==DBNull.Value)return null; return  (String)this["visita",DataRowVersion.Original];}
	}
	#endregion

}
///<summary>
///Registro elettronico della lezione della 2.4.31 Scheda di rendicontazione / registro elettronico
///</summary>
public class rendicontlezioneTable : MetaTableBase<rendicontlezioneRow> {
	public rendicontlezioneTable() : base("rendicontlezione"){
		baseColumns = new Dictionary<string, DataColumn>(){
			{"ct",createColumn("ct",typeof(DateTime),false,false)},
			{"cu",createColumn("cu",typeof(string),false,false)},
			{"idlezione",createColumn("idlezione",typeof(int),false,false)},
			{"idrendicont",createColumn("idrendicont",typeof(int),false,false)},
			{"idrendicontlezione",createColumn("idrendicontlezione",typeof(int),false,false)},
			{"lt",createColumn("lt",typeof(DateTime),false,false)},
			{"lu",createColumn("lu",typeof(string),false,false)},
			{"nonsvolta",createColumn("nonsvolta",typeof(string),true,false)},
			{"stage",createColumn("stage",typeof(string),true,false)},
			{"visita",createColumn("visita",typeof(string),true,false)},
		};
	}
}
}
