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
namespace meta_provaaula {
public class provaaulaRow: MetaRow  {
	public provaaulaRow(DataRowBuilder rb) : base(rb) {} 

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
	///Aula
	///</summary>
	public Int32? idlocation_aula{ 
		get {if (this["idlocation_aula"]==DBNull.Value)return null; return  (Int32?)this["idlocation_aula"];}
		set {if (value==null) this["idlocation_aula"]= DBNull.Value; else this["idlocation_aula"]= value;}
	}
	public object idlocation_aulaValue { 
		get{ return this["idlocation_aula"];}
		set {if (value==null|| value==DBNull.Value) this["idlocation_aula"]= DBNull.Value; else this["idlocation_aula"]= value;}
	}
	public Int32? idlocation_aulaOriginal { 
		get {if (this["idlocation_aula",DataRowVersion.Original]==DBNull.Value)return null; return  (Int32?)this["idlocation_aula",DataRowVersion.Original];}
	}
	///<summary>
	///Prova
	///</summary>
	public Int32? idprova{ 
		get {if (this["idprova"]==DBNull.Value)return null; return  (Int32?)this["idprova"];}
		set {if (value==null) this["idprova"]= DBNull.Value; else this["idprova"]= value;}
	}
	public object idprovaValue { 
		get{ return this["idprova"];}
		set {if (value==null|| value==DBNull.Value) this["idprova"]= DBNull.Value; else this["idprova"]= value;}
	}
	public Int32? idprovaOriginal { 
		get {if (this["idprova",DataRowVersion.Original]==DBNull.Value)return null; return  (Int32?)this["idprova",DataRowVersion.Original];}
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
	#endregion

}
///<summary>
///Indica in quali 2.4.24 aule si svolge la 2.4.35 prova
///</summary>
public class provaaulaTable : MetaTableBase<provaaulaRow> {
	public provaaulaTable() : base("provaaula"){
		baseColumns = new Dictionary<string, DataColumn>(){
			{"ct",createColumn("ct",typeof(DateTime),false,false)},
			{"cu",createColumn("cu",typeof(string),false,false)},
			{"idlocation_aula",createColumn("idlocation_aula",typeof(int),false,false)},
			{"idprova",createColumn("idprova",typeof(int),false,false)},
			{"lt",createColumn("lt",typeof(DateTime),false,false)},
			{"lu",createColumn("lu",typeof(string),false,false)},
		};
	}
}
}
