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

namespace sortingexpensefilter_single {
using System;
using System.Data;
[System.CodeDom.Compiler.GeneratedCodeAttribute("System.Data.Design.TypedDataSetGenerator", "2.0.0.0")]
[System.ComponentModel.DesignerCategoryAttribute("code")]
public partial class vistaForm: System.Data.DataSet {
// List of DataTables
[System.Diagnostics.DebuggerNonUserCodeAttribute()]
[System.ComponentModel.Browsable(false)]
public DataTable upb{get { return this.Tables["upb"];}}
[System.Diagnostics.DebuggerNonUserCodeAttribute()]
[System.ComponentModel.Browsable(false)]
public DataTable sorting{get { return this.Tables["sorting"];}}
[System.Diagnostics.DebuggerNonUserCodeAttribute()]
[System.ComponentModel.Browsable(false)]
public DataTable sortingkind{get { return this.Tables["sortingkind"];}}
[System.Diagnostics.DebuggerNonUserCodeAttribute()]
[System.ComponentModel.Browsable(false)]
public DataTable sortingexpensefilterview{get { return this.Tables["sortingexpensefilterview"];}}
[System.Diagnostics.DebuggerNonUserCodeAttribute()]
[System.ComponentModel.Browsable(false)]
public DataTable sortingexpensefilter{get { return this.Tables["sortingexpensefilter"];}}

[System.Diagnostics.DebuggerNonUserCodeAttribute()]
[System.ComponentModel.DesignerSerializationVisibilityAttribute(System.ComponentModel.DesignerSerializationVisibility.Hidden)]
public new System.Data.DataTableCollection Tables {get {return base.Tables;}}

[System.Diagnostics.DebuggerNonUserCodeAttribute()]
[System.ComponentModel.DesignerSerializationVisibilityAttribute(System.ComponentModel.DesignerSerializationVisibility.Hidden)]
public new System.Data.DataRelationCollection Relations {get {return base.Relations; } } 

[System.Diagnostics.DebuggerNonUserCodeAttribute()]
public vistaForm(){
this.BeginInit();
this.InitClass();
this.EndInit();
}
[System.Diagnostics.DebuggerNonUserCodeAttribute()]
private void InitClass() {
this.DataSetName = "vistaForm";
this.Prefix = "";
this.Namespace = "http://tempuri.org/vistaForm.xsd";
this.EnforceConstraints = false;
	DataTable T;
	DataColumn C;
	DataColumn [] key;
	T= new DataTable("upb");
	C= new DataColumn("idupb", typeof(System.String), "");
	C.AllowDBNull=false;
	T.Columns.Add(C);

	C= new DataColumn("codeupb", typeof(System.String), "");
	C.AllowDBNull=false;
	T.Columns.Add(C);

	C= new DataColumn("title", typeof(System.String), "");
	C.AllowDBNull=false;
	T.Columns.Add(C);

	T.Columns.Add(new DataColumn("paridupb", typeof(System.String), ""));
	T.Columns.Add(new DataColumn("idunderwriter", typeof(System.Int32), ""));
	T.Columns.Add(new DataColumn("idman", typeof(System.Int32), ""));
	T.Columns.Add(new DataColumn("requested", typeof(System.Decimal), ""));
	T.Columns.Add(new DataColumn("granted", typeof(System.Decimal), ""));
	T.Columns.Add(new DataColumn("previousappropriation", typeof(System.Decimal), ""));
	T.Columns.Add(new DataColumn("expiration", typeof(System.DateTime), ""));
	T.Columns.Add(new DataColumn("txt", typeof(System.String), ""));
	T.Columns.Add(new DataColumn("rtf", typeof(System.Byte[]), ""));
	C= new DataColumn("cu", typeof(System.String), "");
	C.AllowDBNull=false;
	T.Columns.Add(C);

	C= new DataColumn("ct", typeof(System.DateTime), "");
	C.AllowDBNull=false;
	T.Columns.Add(C);

	C= new DataColumn("lu", typeof(System.String), "");
	C.AllowDBNull=false;
	T.Columns.Add(C);

	C= new DataColumn("lt", typeof(System.DateTime), "");
	C.AllowDBNull=false;
	T.Columns.Add(C);

	T.Columns.Add(new DataColumn("assured", typeof(System.String), ""));
	C= new DataColumn("printingorder", typeof(System.String), "");
	C.AllowDBNull=false;
	T.Columns.Add(C);

	T.Columns.Add(new DataColumn("active", typeof(System.String), ""));
	Tables.Add(T);
//Primary Key
	key = new DataColumn[1]{
	T.Columns["idupb"]};
	T.PrimaryKey = key;

	T= new DataTable("sorting");
	C= new DataColumn("idsorkind", typeof(System.Int32), "");
	C.AllowDBNull=false;
	T.Columns.Add(C);

	C= new DataColumn("idsor", typeof(System.Int32), "");
	C.AllowDBNull=false;
	T.Columns.Add(C);

	C= new DataColumn("sortcode", typeof(System.String), "");
	C.AllowDBNull=false;
	T.Columns.Add(C);

	T.Columns.Add(new DataColumn("paridsor", typeof(System.Int32), ""));
	C= new DataColumn("nlevel", typeof(System.Byte), "");
	C.AllowDBNull=false;
	T.Columns.Add(C);

	C= new DataColumn("description", typeof(System.String), "");
	C.AllowDBNull=false;
	T.Columns.Add(C);

	T.Columns.Add(new DataColumn("txt", typeof(System.String), ""));
	T.Columns.Add(new DataColumn("rtf", typeof(System.Byte[]), ""));
	C= new DataColumn("cu", typeof(System.String), "");
	C.AllowDBNull=false;
	T.Columns.Add(C);

	C= new DataColumn("ct", typeof(System.DateTime), "");
	C.AllowDBNull=false;
	T.Columns.Add(C);

	C= new DataColumn("lu", typeof(System.String), "");
	C.AllowDBNull=false;
	T.Columns.Add(C);

	C= new DataColumn("lt", typeof(System.DateTime), "");
	C.AllowDBNull=false;
	T.Columns.Add(C);

	T.Columns.Add(new DataColumn("defaultn1", typeof(System.Decimal), ""));
	T.Columns.Add(new DataColumn("defaultn2", typeof(System.Decimal), ""));
	T.Columns.Add(new DataColumn("defaultn3", typeof(System.Decimal), ""));
	T.Columns.Add(new DataColumn("defaultn4", typeof(System.Decimal), ""));
	T.Columns.Add(new DataColumn("defaultn5", typeof(System.Decimal), ""));
	T.Columns.Add(new DataColumn("defaults1", typeof(System.String), ""));
	T.Columns.Add(new DataColumn("defaults2", typeof(System.String), ""));
	T.Columns.Add(new DataColumn("defaults3", typeof(System.String), ""));
	T.Columns.Add(new DataColumn("defaults4", typeof(System.String), ""));
	T.Columns.Add(new DataColumn("defaults5", typeof(System.String), ""));
	T.Columns.Add(new DataColumn("defaultv1", typeof(System.Decimal), ""));
	T.Columns.Add(new DataColumn("defaultv2", typeof(System.Decimal), ""));
	T.Columns.Add(new DataColumn("defaultv3", typeof(System.Decimal), ""));
	T.Columns.Add(new DataColumn("defaultv4", typeof(System.Decimal), ""));
	T.Columns.Add(new DataColumn("defaultv5", typeof(System.Decimal), ""));
	T.Columns.Add(new DataColumn("flagnodate", typeof(System.String), ""));
	T.Columns.Add(new DataColumn("movkind", typeof(System.String), ""));
	Tables.Add(T);
//Primary Key
	key = new DataColumn[1]{
	T.Columns["idsor"]};
	T.PrimaryKey = key;

	T= new DataTable("sortingkind");
	C= new DataColumn("idsorkind", typeof(System.Int32), "");
	C.AllowDBNull=false;
	T.Columns.Add(C);

	C= new DataColumn("description", typeof(System.String), "");
	C.AllowDBNull=false;
	T.Columns.Add(C);

	T.Columns.Add(new DataColumn("nphaseincome", typeof(System.Byte), ""));
	T.Columns.Add(new DataColumn("nphaseexpense", typeof(System.Byte), ""));
	T.Columns.Add(new DataColumn("flag", typeof(System.Byte), ""));
	C= new DataColumn("cu", typeof(System.String), "");
	C.AllowDBNull=false;
	T.Columns.Add(C);

	C= new DataColumn("ct", typeof(System.DateTime), "");
	C.AllowDBNull=false;
	T.Columns.Add(C);

	C= new DataColumn("lu", typeof(System.String), "");
	C.AllowDBNull=false;
	T.Columns.Add(C);

	C= new DataColumn("lt", typeof(System.DateTime), "");
	C.AllowDBNull=false;
	T.Columns.Add(C);

	T.Columns.Add(new DataColumn("active", typeof(System.String), ""));
	T.Columns.Add(new DataColumn("labeln1", typeof(System.String), ""));
	T.Columns.Add(new DataColumn("lockedn1", typeof(System.String), ""));
	T.Columns.Add(new DataColumn("forcedn1", typeof(System.String), ""));
	T.Columns.Add(new DataColumn("labeln2", typeof(System.String), ""));
	T.Columns.Add(new DataColumn("lockedn2", typeof(System.String), ""));
	T.Columns.Add(new DataColumn("forcedn2", typeof(System.String), ""));
	T.Columns.Add(new DataColumn("labeln3", typeof(System.String), ""));
	T.Columns.Add(new DataColumn("lockedn3", typeof(System.String), ""));
	T.Columns.Add(new DataColumn("forcedn3", typeof(System.String), ""));
	T.Columns.Add(new DataColumn("labeln4", typeof(System.String), ""));
	T.Columns.Add(new DataColumn("lockedn4", typeof(System.String), ""));
	T.Columns.Add(new DataColumn("forcedn4", typeof(System.String), ""));
	T.Columns.Add(new DataColumn("labeln5", typeof(System.String), ""));
	T.Columns.Add(new DataColumn("lockedn5", typeof(System.String), ""));
	T.Columns.Add(new DataColumn("forcedn5", typeof(System.String), ""));
	T.Columns.Add(new DataColumn("labels1", typeof(System.String), ""));
	T.Columns.Add(new DataColumn("lockeds1", typeof(System.String), ""));
	T.Columns.Add(new DataColumn("forceds1", typeof(System.String), ""));
	T.Columns.Add(new DataColumn("labels2", typeof(System.String), ""));
	T.Columns.Add(new DataColumn("lockeds2", typeof(System.String), ""));
	T.Columns.Add(new DataColumn("forceds2", typeof(System.String), ""));
	T.Columns.Add(new DataColumn("labels3", typeof(System.String), ""));
	T.Columns.Add(new DataColumn("lockeds3", typeof(System.String), ""));
	T.Columns.Add(new DataColumn("forceds3", typeof(System.String), ""));
	T.Columns.Add(new DataColumn("labels4", typeof(System.String), ""));
	T.Columns.Add(new DataColumn("lockeds4", typeof(System.String), ""));
	T.Columns.Add(new DataColumn("forceds4", typeof(System.String), ""));
	T.Columns.Add(new DataColumn("labels5", typeof(System.String), ""));
	T.Columns.Add(new DataColumn("lockeds5", typeof(System.String), ""));
	T.Columns.Add(new DataColumn("forceds5", typeof(System.String), ""));
	T.Columns.Add(new DataColumn("labelv1", typeof(System.String), ""));
	T.Columns.Add(new DataColumn("lockedv1", typeof(System.String), ""));
	T.Columns.Add(new DataColumn("forcedv1", typeof(System.String), ""));
	T.Columns.Add(new DataColumn("labelv2", typeof(System.String), ""));
	T.Columns.Add(new DataColumn("lockedv2", typeof(System.String), ""));
	T.Columns.Add(new DataColumn("forcedv2", typeof(System.String), ""));
	T.Columns.Add(new DataColumn("labelv3", typeof(System.String), ""));
	T.Columns.Add(new DataColumn("lockedv3", typeof(System.String), ""));
	T.Columns.Add(new DataColumn("forcedv3", typeof(System.String), ""));
	T.Columns.Add(new DataColumn("labelv4", typeof(System.String), ""));
	T.Columns.Add(new DataColumn("lockedv4", typeof(System.String), ""));
	T.Columns.Add(new DataColumn("forcedv4", typeof(System.String), ""));
	T.Columns.Add(new DataColumn("labelv5", typeof(System.String), ""));
	T.Columns.Add(new DataColumn("lockedv5", typeof(System.String), ""));
	T.Columns.Add(new DataColumn("forcedv5", typeof(System.String), ""));
	T.Columns.Add(new DataColumn("flagdate", typeof(System.String), ""));
	T.Columns.Add(new DataColumn("labelfordate", typeof(System.String), ""));
	T.Columns.Add(new DataColumn("nodatelabel", typeof(System.String), ""));
	T.Columns.Add(new DataColumn("totalexpression", typeof(System.String), ""));
	T.Columns.Add(new DataColumn("start", typeof(System.Int16), ""));
	T.Columns.Add(new DataColumn("stop", typeof(System.Int16), ""));
	Tables.Add(T);
//Primary Key
	key = new DataColumn[1]{
	T.Columns["idsorkind"]};
	T.PrimaryKey = key;

	T= new DataTable("sortingexpensefilterview");
	T.Columns.Add(new DataColumn("codefin", typeof(System.String), ""));
	T.Columns.Add(new DataColumn("finance", typeof(System.String), ""));
	T.Columns.Add(new DataColumn("codeupb", typeof(System.String), ""));
	T.Columns.Add(new DataColumn("upb", typeof(System.String), ""));
	T.Columns.Add(new DataColumn("regsortingkind", typeof(System.String), ""));
	T.Columns.Add(new DataColumn("registrysortcode", typeof(System.String), ""));
	T.Columns.Add(new DataColumn("registrykind", typeof(System.String), ""));
	T.Columns.Add(new DataColumn("manager", typeof(System.String), ""));
	C= new DataColumn("sortingkind", typeof(System.String), "");
	C.AllowDBNull=false;
	T.Columns.Add(C);

	T.Columns.Add(new DataColumn("sortingcode", typeof(System.String), ""));
	T.Columns.Add(new DataColumn("sorting", typeof(System.String), ""));
	C= new DataColumn("ayear", typeof(System.Int32), "");
	C.AllowDBNull=false;
	T.Columns.Add(C);

	C= new DataColumn("idautosort", typeof(System.Int32), "");
	C.AllowDBNull=false;
	T.Columns.Add(C);

	C= new DataColumn("idsorkind", typeof(System.Int32), "");
	C.AllowDBNull=false;
	T.Columns.Add(C);

	T.Columns.Add(new DataColumn("idsorkindreg", typeof(System.Int32), ""));
	T.Columns.Add(new DataColumn("ct", typeof(System.DateTime), ""));
	T.Columns.Add(new DataColumn("cu", typeof(System.String), ""));
	C= new DataColumn("jointolessspecifics", typeof(System.String), "");
	C.AllowDBNull=false;
	T.Columns.Add(C);

	T.Columns.Add(new DataColumn("idfin", typeof(System.Int32), ""));
	T.Columns.Add(new DataColumn("idupb", typeof(System.String), ""));
	C= new DataColumn("idsor", typeof(System.Int32), "");
	C.AllowDBNull=false;
	T.Columns.Add(C);

	T.Columns.Add(new DataColumn("idsorreg", typeof(System.Int32), ""));
	T.Columns.Add(new DataColumn("lt", typeof(System.DateTime), ""));
	T.Columns.Add(new DataColumn("lu", typeof(System.String), ""));
	T.Columns.Add(new DataColumn("idman", typeof(System.Int32), ""));
	Tables.Add(T);
//Primary Key
	key = new DataColumn[2]{
	T.Columns["ayear"], 	T.Columns["idautosort"]};
	T.PrimaryKey = key;

	T= new DataTable("sortingexpensefilter");
	C= new DataColumn("ayear", typeof(System.Int32), "");
	C.AllowDBNull=false;
	T.Columns.Add(C);

	C= new DataColumn("idautosort", typeof(System.Int32), "");
	C.AllowDBNull=false;
	T.Columns.Add(C);

	C= new DataColumn("idsorkind", typeof(System.Int32), "");
	C.AllowDBNull=false;
	T.Columns.Add(C);

	T.Columns.Add(new DataColumn("idsorkindreg", typeof(System.Int32), ""));
	T.Columns.Add(new DataColumn("idfin", typeof(System.Int32), ""));
	T.Columns.Add(new DataColumn("idupb", typeof(System.String), ""));
	C= new DataColumn("idsor", typeof(System.Int32), "");
	C.AllowDBNull=false;
	T.Columns.Add(C);

	T.Columns.Add(new DataColumn("idsorreg", typeof(System.Int32), ""));
	C= new DataColumn("jointolessspecifics", typeof(System.String), "");
	C.AllowDBNull=false;
	T.Columns.Add(C);

	T.Columns.Add(new DataColumn("lu", typeof(System.String), ""));
	T.Columns.Add(new DataColumn("lt", typeof(System.DateTime), ""));
	T.Columns.Add(new DataColumn("cu", typeof(System.String), ""));
	T.Columns.Add(new DataColumn("ct", typeof(System.DateTime), ""));
	T.Columns.Add(new DataColumn("idman", typeof(System.Int32), ""));
	Tables.Add(T);
//Primary Key
	key = new DataColumn[2]{
	T.Columns["ayear"], 	T.Columns["idautosort"]};
	T.PrimaryKey = key;


//Relations
DataTable TPar;
DataTable TChild;
DataColumn []CPar;
DataColumn []CChild;
TPar= Tables["upb"];
TChild= Tables["sortingexpensefilter"];
CPar = new DataColumn[1]{TPar.Columns["idupb"]};
CChild = new DataColumn[1]{TChild.Columns["idupb"]};
Relations.Add(new DataRelation("upb_sortingexpensefilter",CPar,CChild));

TPar= Tables["sortingkind"];
TChild= Tables["sortingexpensefilter"];
CPar = new DataColumn[1]{TPar.Columns["idsorkind"]};
CChild = new DataColumn[1]{TChild.Columns["idsorkind"]};
Relations.Add(new DataRelation("sortingkind_sortingexpensefilter",CPar,CChild));

TPar= Tables["sortingkind"];
TChild= Tables["sorting"];
CPar = new DataColumn[1]{TPar.Columns["idsorkind"]};
CChild = new DataColumn[1]{TChild.Columns["idsorkind"]};
Relations.Add(new DataRelation("sortingkind_sorting",CPar,CChild));

TPar= Tables["sorting"];
TChild= Tables["sortingexpensefilter"];
CPar = new DataColumn[1]{TPar.Columns["idsor"]};
CChild = new DataColumn[1]{TChild.Columns["idsor"]};
Relations.Add(new DataRelation("sorting_sortingexpensefilter",CPar,CChild));

}
}
}
