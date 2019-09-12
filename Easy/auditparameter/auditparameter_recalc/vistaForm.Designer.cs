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
namespace auditparameter_recalc {
[Serializable,DesignerCategory("code"),System.Xml.Serialization.XmlSchemaProvider("GetTypedDataSetSchema")]
[System.Xml.Serialization.XmlRoot("vistaForm"),System.ComponentModel.Design.HelpKeyword("vs.data.DataSet")]
public class vistaForm: DataSet {

	#region Table members declaration
	///<summary>
	///E' una tabela calcolata in automatico dal programma in fase di compilazione delle regole
	///</summary>
	[DebuggerNonUserCode,DesignerSerializationVisibility(DesignerSerializationVisibility.Hidden),Browsable(false)]
	public DataTable auditparameter 		=> Tables["auditparameter"];

	#endregion


	[DebuggerNonUserCode,DesignerSerializationVisibility(DesignerSerializationVisibility.Hidden)]
	public new DataTableCollection Tables => base.Tables;

	[DebuggerNonUserCode,DesignerSerializationVisibility(DesignerSerializationVisibility.Hidden)]
// ReSharper disable once MemberCanBePrivate.Global
	public new DataRelationCollection Relations => base.Relations;

[DebuggerNonUserCode]
public vistaForm(){
	BeginInit();
	initClass();
	EndInit();
}
[DebuggerNonUserCode]
protected vistaForm (SerializationInfo info,StreamingContext ctx):base(info,ctx) {}
[DebuggerNonUserCode]
private void initClass() {
	DataSetName = "vistaForm";
	Prefix = "";
	Namespace = "http://tempuri.org/vistaForm.xsd";

	#region create DataTables
	DataColumn C;
	//////////////////// AUDITPARAMETER /////////////////////////////////
	var tauditparameter= new DataTable("auditparameter");
	C= new DataColumn("tablename", typeof(string));
	C.AllowDBNull=false;
	tauditparameter.Columns.Add(C);
	C= new DataColumn("opkind", typeof(string));
	C.AllowDBNull=false;
	tauditparameter.Columns.Add(C);
	C= new DataColumn("isprecheck", typeof(string));
	C.AllowDBNull=false;
	tauditparameter.Columns.Add(C);
	C= new DataColumn("parameterid", typeof(short));
	C.AllowDBNull=false;
	tauditparameter.Columns.Add(C);
	tauditparameter.Columns.Add( new DataColumn("paramtable", typeof(string)));
	tauditparameter.Columns.Add( new DataColumn("paramcolumn", typeof(string)));
	tauditparameter.Columns.Add( new DataColumn("flagoldvalue", typeof(string)));
	Tables.Add(tauditparameter);
	tauditparameter.PrimaryKey =  new DataColumn[]{tauditparameter.Columns["tablename"], tauditparameter.Columns["opkind"], tauditparameter.Columns["isprecheck"], tauditparameter.Columns["parameterid"]};


	#endregion

}
}
}
