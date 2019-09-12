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
using System.ComponentModel;
using System.Diagnostics;
using System.Runtime.Serialization;
#pragma warning disable 1591
// ReSharper disable InconsistentNaming
// ReSharper disable UnusedMember.Global
namespace filetype_default {
[Serializable,DesignerCategory("code"),System.Xml.Serialization.XmlSchemaProvider("GetTypedDataSetSchema")]
[System.Xml.Serialization.XmlRoot("vistaFom"),System.ComponentModel.Design.HelpKeyword("vs.data.DataSet")]
public class vistaFom: DataSet {

	#region Table members declaration
	///<summary>
	///Tipo File
	///</summary>
	[DebuggerNonUserCode,DesignerSerializationVisibility(DesignerSerializationVisibility.Hidden),Browsable(false)]
	public DataTable filetype 		=> Tables["filetype"];

	#endregion


	[DebuggerNonUserCode,DesignerSerializationVisibility(DesignerSerializationVisibility.Hidden)]
	public new DataTableCollection Tables => base.Tables;

	[DebuggerNonUserCode,DesignerSerializationVisibility(DesignerSerializationVisibility.Hidden)]
// ReSharper disable once MemberCanBePrivate.Global
	public new DataRelationCollection Relations => base.Relations;

[DebuggerNonUserCode]
public vistaFom(){
	BeginInit();
	initClass();
	EndInit();
}
[DebuggerNonUserCode]
protected vistaFom (SerializationInfo info,StreamingContext ctx):base(info,ctx) {}
[DebuggerNonUserCode]
private void initClass() {
	DataSetName = "vistaFom";
	Prefix = "";
	Namespace = "http://tempuri.org/vistaFom.xsd";

	#region create DataTables
	DataColumn C;
	//////////////////// FILETYPE /////////////////////////////////
	var tfiletype= new DataTable("filetype");
	C= new DataColumn("idfiletype", typeof(string));
	C.AllowDBNull=false;
	tfiletype.Columns.Add(C);
	C= new DataColumn("title", typeof(string));
	C.AllowDBNull=false;
	tfiletype.Columns.Add(C);
	tfiletype.Columns.Add( new DataColumn("ext", typeof(string)));
	tfiletype.Columns.Add( new DataColumn("connectionstring", typeof(string)));
	tfiletype.Columns.Add( new DataColumn("querystring", typeof(string)));
	C= new DataColumn("lu", typeof(string));
	C.AllowDBNull=false;
	tfiletype.Columns.Add(C);
	C= new DataColumn("lt", typeof(DateTime));
	C.AllowDBNull=false;
	tfiletype.Columns.Add(C);
	Tables.Add(tfiletype);
	tfiletype.PrimaryKey =  new DataColumn[]{tfiletype.Columns["idfiletype"]};


	#endregion

}
}
}
