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
using System.Globalization;
namespace incomesorted_relation {
[Serializable()][DesignerCategoryAttribute("code")][System.Xml.Serialization.XmlSchemaProviderAttribute("GetTypedDataSetSchema")]
[System.Xml.Serialization.XmlRootAttribute("vistaForm")][System.ComponentModel.Design.HelpKeywordAttribute("vs.data.DataSet")]
public partial class vistaForm: System.Data.DataSet {

	#region Table members declaration
	///<summary>
	///Classificazione Movimenti di entrata
	///</summary>
	[DebuggerNonUserCodeAttribute()][DesignerSerializationVisibility(DesignerSerializationVisibility.Hidden)][Browsable(false)]
	public DataTable incomesorted		{get { return Tables["incomesorted"];}}
	[DebuggerNonUserCodeAttribute()][DesignerSerializationVisibility(DesignerSerializationVisibility.Hidden)][Browsable(false)]
	public DataTable incomeview		{get { return Tables["incomeview"];}}
	///<summary>
	///Classificazione Movimenti
	///</summary>
	[DebuggerNonUserCodeAttribute()][DesignerSerializationVisibility(DesignerSerializationVisibility.Hidden)][Browsable(false)]
	public DataTable sorting		{get { return Tables["sorting"];}}
	///<summary>
	///Tipo di Rilevanza analitica
	///</summary>
	[DebuggerNonUserCodeAttribute()][DesignerSerializationVisibility(DesignerSerializationVisibility.Hidden)][Browsable(false)]
	public DataTable sortingkind		{get { return Tables["sortingkind"];}}
	///<summary>
	///Traduzione classificazioni
	///</summary>
	[DebuggerNonUserCodeAttribute()][DesignerSerializationVisibility(DesignerSerializationVisibility.Hidden)][Browsable(false)]
	public DataTable sortingtranslation		{get { return Tables["sortingtranslation"];}}
	[DebuggerNonUserCodeAttribute()][DesignerSerializationVisibility(DesignerSerializationVisibility.Hidden)][Browsable(false)]
	public DataTable incomesortedview		{get { return Tables["incomesortedview"];}}
	#endregion


	[DebuggerNonUserCodeAttribute()][DesignerSerializationVisibilityAttribute(DesignerSerializationVisibility.Hidden)]
	public new DataTableCollection Tables {get {return base.Tables;}}

	[DebuggerNonUserCodeAttribute()][DesignerSerializationVisibilityAttribute(DesignerSerializationVisibility.Hidden)]
	public new DataRelationCollection Relations {get {return base.Relations; } } 

[DebuggerNonUserCodeAttribute()]
public vistaForm(){
	BeginInit();
	InitClass();
	EndInit();
}
[DebuggerNonUserCodeAttribute()]
private void InitClass() {
	DataSetName = "vistaForm";
	Prefix = "";
	Namespace = "http://tempuri.org/vistaForm.xsd";
this.SchemaSerializationMode = System.Data.SchemaSerializationMode.IncludeSchema;
	EnforceConstraints = false;

	#region create DataTables
	DataTable T;
	DataColumn C;
	//////////////////// incomesorted /////////////////////////////////
	T= new DataTable("incomesorted");
	C= new DataColumn("idsor", typeof(System.Int32));
	C.AllowDBNull=false;
	T.Columns.Add(C);
	C= new DataColumn("idinc", typeof(System.Int32));
	C.AllowDBNull=false;
	T.Columns.Add(C);
	C= new DataColumn("idsubclass", typeof(System.Int16));
	C.AllowDBNull=false;
	T.Columns.Add(C);
	T.Columns.Add( new DataColumn("amount", typeof(System.Decimal)));
	T.Columns.Add( new DataColumn("description", typeof(System.String)));
	T.Columns.Add( new DataColumn("txt", typeof(System.String)));
	T.Columns.Add( new DataColumn("rtf", typeof(System.Byte[])));
	C= new DataColumn("cu", typeof(System.String));
	C.AllowDBNull=false;
	T.Columns.Add(C);
	C= new DataColumn("ct", typeof(System.DateTime));
	C.AllowDBNull=false;
	T.Columns.Add(C);
	C= new DataColumn("lu", typeof(System.String));
	C.AllowDBNull=false;
	T.Columns.Add(C);
	C= new DataColumn("lt", typeof(System.DateTime));
	C.AllowDBNull=false;
	T.Columns.Add(C);
	T.Columns.Add( new DataColumn("flagnodate", typeof(System.String)));
	T.Columns.Add( new DataColumn("tobecontinued", typeof(System.String)));
	T.Columns.Add( new DataColumn("start", typeof(System.DateTime)));
	T.Columns.Add( new DataColumn("stop", typeof(System.DateTime)));
	T.Columns.Add( new DataColumn("valuen1", typeof(System.Decimal)));
	T.Columns.Add( new DataColumn("valuen2", typeof(System.Decimal)));
	T.Columns.Add( new DataColumn("valuen3", typeof(System.Decimal)));
	T.Columns.Add( new DataColumn("valuen4", typeof(System.Decimal)));
	T.Columns.Add( new DataColumn("valuen5", typeof(System.Decimal)));
	T.Columns.Add( new DataColumn("values1", typeof(System.String)));
	T.Columns.Add( new DataColumn("values2", typeof(System.String)));
	T.Columns.Add( new DataColumn("values3", typeof(System.String)));
	T.Columns.Add( new DataColumn("values4", typeof(System.String)));
	T.Columns.Add( new DataColumn("values5", typeof(System.String)));
	T.Columns.Add( new DataColumn("paridsor", typeof(System.Int32)));
	T.Columns.Add( new DataColumn("paridsubclass", typeof(System.Int16)));
	T.Columns.Add( new DataColumn("valuev1", typeof(System.Decimal)));
	T.Columns.Add( new DataColumn("valuev2", typeof(System.Decimal)));
	T.Columns.Add( new DataColumn("valuev3", typeof(System.Decimal)));
	T.Columns.Add( new DataColumn("valuev4", typeof(System.Decimal)));
	T.Columns.Add( new DataColumn("valuev5", typeof(System.Decimal)));
	T.Columns.Add( new DataColumn("ayear", typeof(System.Int16)));
	Tables.Add(T);
	T.PrimaryKey =  new DataColumn[]{T.Columns["idsor"], T.Columns["idinc"], T.Columns["idsubclass"]};


	//////////////////// incomeview /////////////////////////////////
	T= new DataTable("incomeview");
	C= new DataColumn("idinc", typeof(System.Int32));
	C.AllowDBNull=false;
	T.Columns.Add(C);
	C= new DataColumn("nphase", typeof(System.Byte));
	C.AllowDBNull=false;
	T.Columns.Add(C);
	C= new DataColumn("phase", typeof(System.String));
	C.AllowDBNull=false;
	T.Columns.Add(C);
	C= new DataColumn("ymov", typeof(System.Int16));
	C.AllowDBNull=false;
	T.Columns.Add(C);
	C= new DataColumn("nmov", typeof(System.Int32));
	C.AllowDBNull=false;
	T.Columns.Add(C);
	T.Columns.Add( new DataColumn("parentymov", typeof(System.Int16)));
	T.Columns.Add( new DataColumn("parentnmov", typeof(System.Int32)));
	T.Columns.Add( new DataColumn("parentidinc", typeof(System.Int32)));
	C= new DataColumn("ayear", typeof(System.Int16));
	C.AllowDBNull=false;
	T.Columns.Add(C);
	T.Columns.Add( new DataColumn("idfin", typeof(System.Int32)));
	T.Columns.Add( new DataColumn("codefin", typeof(System.String)));
	T.Columns.Add( new DataColumn("finance", typeof(System.String)));
	T.Columns.Add( new DataColumn("idupb", typeof(System.String)));
	T.Columns.Add( new DataColumn("codeupb", typeof(System.String)));
	T.Columns.Add( new DataColumn("upb", typeof(System.String)));
	T.Columns.Add( new DataColumn("idreg", typeof(System.Int32)));
	T.Columns.Add( new DataColumn("registry", typeof(System.String)));
	T.Columns.Add( new DataColumn("idman", typeof(System.Int32)));
	T.Columns.Add( new DataColumn("manager", typeof(System.String)));
	T.Columns.Add( new DataColumn("ypro", typeof(System.Int16)));
	T.Columns.Add( new DataColumn("npro", typeof(System.Int32)));
	T.Columns.Add( new DataColumn("doc", typeof(System.String)));
	T.Columns.Add( new DataColumn("docdate", typeof(System.DateTime)));
	C= new DataColumn("description", typeof(System.String));
	C.AllowDBNull=false;
	T.Columns.Add(C);
	T.Columns.Add( new DataColumn("amount", typeof(System.Decimal)));
	T.Columns.Add( new DataColumn("ayearstartamount", typeof(System.Decimal)));
	T.Columns.Add( new DataColumn("curramount", typeof(System.Decimal)));
	T.Columns.Add( new DataColumn("available", typeof(System.Decimal)));
	T.Columns.Add( new DataColumn("unpartitioned", typeof(System.Decimal)));
	T.Columns.Add( new DataColumn("flag", typeof(System.Byte)));
	C= new DataColumn("totflag", typeof(System.Byte));
	C.AllowDBNull=false;
	T.Columns.Add(C);
	T.Columns.Add( new DataColumn("flagarrear", typeof(System.String)));
	T.Columns.Add( new DataColumn("autokind", typeof(System.Byte)));
	T.Columns.Add( new DataColumn("autocode", typeof(System.Int32)));
	T.Columns.Add( new DataColumn("idpayment", typeof(System.Int32)));
	T.Columns.Add( new DataColumn("expiration", typeof(System.DateTime)));
	C= new DataColumn("adate", typeof(System.DateTime));
	C.AllowDBNull=false;
	T.Columns.Add(C);
	T.Columns.Add( new DataColumn("nbill", typeof(System.Int32)));
	T.Columns.Add( new DataColumn("idpro", typeof(System.Int32)));
	C= new DataColumn("cu", typeof(System.String));
	C.AllowDBNull=false;
	T.Columns.Add(C);
	C= new DataColumn("ct", typeof(System.DateTime));
	C.AllowDBNull=false;
	T.Columns.Add(C);
	C= new DataColumn("lu", typeof(System.String));
	C.AllowDBNull=false;
	T.Columns.Add(C);
	C= new DataColumn("lt", typeof(System.DateTime));
	C.AllowDBNull=false;
	T.Columns.Add(C);
	Tables.Add(T);
	T.PrimaryKey =  new DataColumn[]{T.Columns["idinc"], T.Columns["ayear"]};


	//////////////////// sorting /////////////////////////////////
	T= new DataTable("sorting");
	C= new DataColumn("idsorkind", typeof(System.Int32));
	C.AllowDBNull=false;
	T.Columns.Add(C);
	C= new DataColumn("idsor", typeof(System.Int32));
	C.AllowDBNull=false;
	T.Columns.Add(C);
	C= new DataColumn("sortcode", typeof(System.String));
	C.AllowDBNull=false;
	T.Columns.Add(C);
	T.Columns.Add( new DataColumn("paridsor", typeof(System.Int32)));
	C= new DataColumn("nlevel", typeof(System.Byte));
	C.AllowDBNull=false;
	T.Columns.Add(C);
	C= new DataColumn("description", typeof(System.String));
	C.AllowDBNull=false;
	T.Columns.Add(C);
	T.Columns.Add( new DataColumn("txt", typeof(System.String)));
	T.Columns.Add( new DataColumn("rtf", typeof(System.Byte[])));
	C= new DataColumn("cu", typeof(System.String));
	C.AllowDBNull=false;
	T.Columns.Add(C);
	C= new DataColumn("ct", typeof(System.DateTime));
	C.AllowDBNull=false;
	T.Columns.Add(C);
	C= new DataColumn("lu", typeof(System.String));
	C.AllowDBNull=false;
	T.Columns.Add(C);
	C= new DataColumn("lt", typeof(System.DateTime));
	C.AllowDBNull=false;
	T.Columns.Add(C);
	T.Columns.Add( new DataColumn("defaultn1", typeof(System.Decimal)));
	T.Columns.Add( new DataColumn("defaultn2", typeof(System.Decimal)));
	T.Columns.Add( new DataColumn("defaultn3", typeof(System.Decimal)));
	T.Columns.Add( new DataColumn("defaultn4", typeof(System.Decimal)));
	T.Columns.Add( new DataColumn("defaultn5", typeof(System.Decimal)));
	T.Columns.Add( new DataColumn("defaults1", typeof(System.String)));
	T.Columns.Add( new DataColumn("defaults2", typeof(System.String)));
	T.Columns.Add( new DataColumn("defaults3", typeof(System.String)));
	T.Columns.Add( new DataColumn("defaults4", typeof(System.String)));
	T.Columns.Add( new DataColumn("defaults5", typeof(System.String)));
	T.Columns.Add( new DataColumn("flagnodate", typeof(System.String)));
	T.Columns.Add( new DataColumn("movkind", typeof(System.String)));
	T.Columns.Add( new DataColumn("printingorder", typeof(System.String)));
	T.Columns.Add( new DataColumn("defaultv1", typeof(System.Decimal)));
	T.Columns.Add( new DataColumn("defaultv2", typeof(System.Decimal)));
	T.Columns.Add( new DataColumn("defaultv3", typeof(System.Decimal)));
	T.Columns.Add( new DataColumn("defaultv4", typeof(System.Decimal)));
	T.Columns.Add( new DataColumn("defaultv5", typeof(System.Decimal)));
	T.Columns.Add( new DataColumn("idsor01", typeof(System.Int32)));
	T.Columns.Add( new DataColumn("idsor02", typeof(System.Int32)));
	T.Columns.Add( new DataColumn("idsor03", typeof(System.Int32)));
	T.Columns.Add( new DataColumn("idsor04", typeof(System.Int32)));
	T.Columns.Add( new DataColumn("idsor05", typeof(System.Int32)));
	Tables.Add(T);
	T.PrimaryKey =  new DataColumn[]{T.Columns["idsor"]};


	//////////////////// sortingkind /////////////////////////////////
	T= new DataTable("sortingkind");
	C= new DataColumn("idsorkind", typeof(System.Int32));
	C.AllowDBNull=false;
	T.Columns.Add(C);
	C= new DataColumn("description", typeof(System.String));
	C.AllowDBNull=false;
	T.Columns.Add(C);
	T.Columns.Add( new DataColumn("nphaseincome", typeof(System.Byte)));
	T.Columns.Add( new DataColumn("nphaseexpense", typeof(System.Byte)));
	T.Columns.Add( new DataColumn("flag", typeof(System.Byte)));
	C= new DataColumn("cu", typeof(System.String));
	C.AllowDBNull=false;
	T.Columns.Add(C);
	C= new DataColumn("ct", typeof(System.DateTime));
	C.AllowDBNull=false;
	T.Columns.Add(C);
	C= new DataColumn("lu", typeof(System.String));
	C.AllowDBNull=false;
	T.Columns.Add(C);
	C= new DataColumn("lt", typeof(System.DateTime));
	C.AllowDBNull=false;
	T.Columns.Add(C);
	T.Columns.Add( new DataColumn("labeln1", typeof(System.String)));
	T.Columns.Add( new DataColumn("lockedn1", typeof(System.String)));
	T.Columns.Add( new DataColumn("forcedn1", typeof(System.String)));
	T.Columns.Add( new DataColumn("labeln2", typeof(System.String)));
	T.Columns.Add( new DataColumn("lockedn2", typeof(System.String)));
	T.Columns.Add( new DataColumn("forcedn2", typeof(System.String)));
	T.Columns.Add( new DataColumn("labeln3", typeof(System.String)));
	T.Columns.Add( new DataColumn("lockedn3", typeof(System.String)));
	T.Columns.Add( new DataColumn("forcedn3", typeof(System.String)));
	T.Columns.Add( new DataColumn("labeln4", typeof(System.String)));
	T.Columns.Add( new DataColumn("lockedn4", typeof(System.String)));
	T.Columns.Add( new DataColumn("forcedn4", typeof(System.String)));
	T.Columns.Add( new DataColumn("labeln5", typeof(System.String)));
	T.Columns.Add( new DataColumn("lockedn5", typeof(System.String)));
	T.Columns.Add( new DataColumn("forcedn5", typeof(System.String)));
	T.Columns.Add( new DataColumn("labels1", typeof(System.String)));
	T.Columns.Add( new DataColumn("lockeds1", typeof(System.String)));
	T.Columns.Add( new DataColumn("forceds1", typeof(System.String)));
	T.Columns.Add( new DataColumn("labels2", typeof(System.String)));
	T.Columns.Add( new DataColumn("lockeds2", typeof(System.String)));
	T.Columns.Add( new DataColumn("forceds2", typeof(System.String)));
	T.Columns.Add( new DataColumn("labels3", typeof(System.String)));
	T.Columns.Add( new DataColumn("lockeds3", typeof(System.String)));
	T.Columns.Add( new DataColumn("forceds3", typeof(System.String)));
	T.Columns.Add( new DataColumn("labels4", typeof(System.String)));
	T.Columns.Add( new DataColumn("lockeds4", typeof(System.String)));
	T.Columns.Add( new DataColumn("forceds4", typeof(System.String)));
	T.Columns.Add( new DataColumn("labels5", typeof(System.String)));
	T.Columns.Add( new DataColumn("lockeds5", typeof(System.String)));
	T.Columns.Add( new DataColumn("forceds5", typeof(System.String)));
	T.Columns.Add( new DataColumn("flagdate", typeof(System.String)));
	T.Columns.Add( new DataColumn("labelfordate", typeof(System.String)));
	T.Columns.Add( new DataColumn("nodatelabel", typeof(System.String)));
	T.Columns.Add( new DataColumn("totalexpression", typeof(System.String)));
	T.Columns.Add( new DataColumn("labelv1", typeof(System.String)));
	T.Columns.Add( new DataColumn("lockedv1", typeof(System.String)));
	T.Columns.Add( new DataColumn("forcedv1", typeof(System.String)));
	T.Columns.Add( new DataColumn("labelv2", typeof(System.String)));
	T.Columns.Add( new DataColumn("lockedv2", typeof(System.String)));
	T.Columns.Add( new DataColumn("forcedv2", typeof(System.String)));
	T.Columns.Add( new DataColumn("labelv3", typeof(System.String)));
	T.Columns.Add( new DataColumn("lockedv3", typeof(System.String)));
	T.Columns.Add( new DataColumn("forcedv3", typeof(System.String)));
	T.Columns.Add( new DataColumn("labelv4", typeof(System.String)));
	T.Columns.Add( new DataColumn("lockedv4", typeof(System.String)));
	T.Columns.Add( new DataColumn("forcedv4", typeof(System.String)));
	T.Columns.Add( new DataColumn("labelv5", typeof(System.String)));
	T.Columns.Add( new DataColumn("lockedv5", typeof(System.String)));
	T.Columns.Add( new DataColumn("forcedv5", typeof(System.String)));
	Tables.Add(T);
	T.PrimaryKey =  new DataColumn[]{T.Columns["idsorkind"]};


	//////////////////// sortingtranslation /////////////////////////////////
	T= new DataTable("sortingtranslation");
	C= new DataColumn("idsortingmaster", typeof(System.Int32));
	C.AllowDBNull=false;
	T.Columns.Add(C);
	C= new DataColumn("idsortingchild", typeof(System.Int32));
	C.AllowDBNull=false;
	T.Columns.Add(C);
	T.Columns.Add( new DataColumn("numerator", typeof(System.Int32)));
	T.Columns.Add( new DataColumn("denominator", typeof(System.Int32)));
	T.Columns.Add( new DataColumn("defaultn1", typeof(System.String)));
	T.Columns.Add( new DataColumn("defaultn2", typeof(System.String)));
	T.Columns.Add( new DataColumn("defaultn3", typeof(System.String)));
	T.Columns.Add( new DataColumn("defaultn4", typeof(System.String)));
	T.Columns.Add( new DataColumn("defaultn5", typeof(System.String)));
	T.Columns.Add( new DataColumn("defaults1", typeof(System.String)));
	T.Columns.Add( new DataColumn("defaults2", typeof(System.String)));
	T.Columns.Add( new DataColumn("defaults3", typeof(System.String)));
	T.Columns.Add( new DataColumn("defaults4", typeof(System.String)));
	T.Columns.Add( new DataColumn("defaults5", typeof(System.String)));
	T.Columns.Add( new DataColumn("flagnodate", typeof(System.String)));
	C= new DataColumn("cu", typeof(System.String));
	C.AllowDBNull=false;
	T.Columns.Add(C);
	C= new DataColumn("ct", typeof(System.DateTime));
	C.AllowDBNull=false;
	T.Columns.Add(C);
	C= new DataColumn("lu", typeof(System.String));
	C.AllowDBNull=false;
	T.Columns.Add(C);
	C= new DataColumn("lt", typeof(System.DateTime));
	C.AllowDBNull=false;
	T.Columns.Add(C);
	T.Columns.Add( new DataColumn("percentage", typeof(System.Decimal)));
	T.Columns.Add( new DataColumn("defaultv1", typeof(System.String)));
	T.Columns.Add( new DataColumn("defaultv2", typeof(System.String)));
	T.Columns.Add( new DataColumn("defaultv3", typeof(System.String)));
	T.Columns.Add( new DataColumn("defaultv4", typeof(System.String)));
	T.Columns.Add( new DataColumn("defaultv5", typeof(System.String)));
	Tables.Add(T);
	T.PrimaryKey =  new DataColumn[]{T.Columns["idsortingchild"], T.Columns["idsortingmaster"]};


	//////////////////// incomesortedview /////////////////////////////////
	T= new DataTable("incomesortedview");
	C= new DataColumn("idinc", typeof(System.Int32));
	C.AllowDBNull=false;
	T.Columns.Add(C);
	C= new DataColumn("nphase", typeof(System.Byte));
	C.AllowDBNull=false;
	T.Columns.Add(C);
	C= new DataColumn("phase", typeof(System.String));
	C.AllowDBNull=false;
	T.Columns.Add(C);
	C= new DataColumn("ymov", typeof(System.Int16));
	C.AllowDBNull=false;
	T.Columns.Add(C);
	C= new DataColumn("nmov", typeof(System.Int32));
	C.AllowDBNull=false;
	T.Columns.Add(C);
	C= new DataColumn("idsubclass", typeof(System.Int16));
	C.AllowDBNull=false;
	T.Columns.Add(C);
	C= new DataColumn("idsorkind", typeof(System.Int32));
	C.AllowDBNull=false;
	T.Columns.Add(C);
	C= new DataColumn("codesorkind", typeof(System.String));
	C.AllowDBNull=false;
	T.Columns.Add(C);
	C= new DataColumn("idsor", typeof(System.Int32));
	C.AllowDBNull=false;
	T.Columns.Add(C);
	C= new DataColumn("sortcode", typeof(System.String));
	C.AllowDBNull=false;
	T.Columns.Add(C);
	C= new DataColumn("sorting", typeof(System.String));
	C.AllowDBNull=false;
	T.Columns.Add(C);
	T.Columns.Add( new DataColumn("amount", typeof(System.Decimal)));
	T.Columns.Add( new DataColumn("description", typeof(System.String)));
	C= new DataColumn("adate", typeof(System.DateTime));
	C.AllowDBNull=false;
	T.Columns.Add(C);
	C= new DataColumn("cu", typeof(System.String));
	C.AllowDBNull=false;
	T.Columns.Add(C);
	C= new DataColumn("ct", typeof(System.DateTime));
	C.AllowDBNull=false;
	T.Columns.Add(C);
	C= new DataColumn("lu", typeof(System.String));
	C.AllowDBNull=false;
	T.Columns.Add(C);
	C= new DataColumn("lt", typeof(System.DateTime));
	C.AllowDBNull=false;
	T.Columns.Add(C);
	T.Columns.Add( new DataColumn("flagnodate", typeof(System.String)));
	T.Columns.Add( new DataColumn("tobecontinued", typeof(System.String)));
	T.Columns.Add( new DataColumn("start", typeof(System.DateTime)));
	T.Columns.Add( new DataColumn("stop", typeof(System.DateTime)));
	T.Columns.Add( new DataColumn("valuen1", typeof(System.Decimal)));
	T.Columns.Add( new DataColumn("valuen2", typeof(System.Decimal)));
	T.Columns.Add( new DataColumn("valuen3", typeof(System.Decimal)));
	T.Columns.Add( new DataColumn("valuen4", typeof(System.Decimal)));
	T.Columns.Add( new DataColumn("valuen5", typeof(System.Decimal)));
	T.Columns.Add( new DataColumn("values1", typeof(System.String)));
	T.Columns.Add( new DataColumn("values2", typeof(System.String)));
	T.Columns.Add( new DataColumn("values3", typeof(System.String)));
	T.Columns.Add( new DataColumn("values4", typeof(System.String)));
	T.Columns.Add( new DataColumn("values5", typeof(System.String)));
	T.Columns.Add( new DataColumn("valuev1", typeof(System.Decimal)));
	T.Columns.Add( new DataColumn("valuev2", typeof(System.Decimal)));
	T.Columns.Add( new DataColumn("valuev3", typeof(System.Decimal)));
	T.Columns.Add( new DataColumn("valuev4", typeof(System.Decimal)));
	T.Columns.Add( new DataColumn("valuev5", typeof(System.Decimal)));
	T.Columns.Add( new DataColumn("paridsorkind", typeof(System.Int32)));
	T.Columns.Add( new DataColumn("parcodesorkind", typeof(System.String)));
	T.Columns.Add( new DataColumn("paridsor", typeof(System.Int32)));
	T.Columns.Add( new DataColumn("paridsubclass", typeof(System.Int16)));
	T.Columns.Add( new DataColumn("idfin", typeof(System.Int32)));
	T.Columns.Add( new DataColumn("codefin", typeof(System.String)));
	T.Columns.Add( new DataColumn("finance", typeof(System.String)));
	T.Columns.Add( new DataColumn("idupb", typeof(System.String)));
	T.Columns.Add( new DataColumn("codeupb", typeof(System.String)));
	T.Columns.Add( new DataColumn("upb", typeof(System.String)));
	T.Columns.Add( new DataColumn("idsor01", typeof(System.Int32)));
	T.Columns.Add( new DataColumn("idsor02", typeof(System.Int32)));
	T.Columns.Add( new DataColumn("idsor03", typeof(System.Int32)));
	T.Columns.Add( new DataColumn("idsor04", typeof(System.Int32)));
	T.Columns.Add( new DataColumn("idsor05", typeof(System.Int32)));
	C= new DataColumn("ayear", typeof(System.Int16));
	C.AllowDBNull=false;
	T.Columns.Add(C);
	C= new DataColumn("totflag", typeof(System.Byte));
	C.AllowDBNull=false;
	T.Columns.Add(C);
	C= new DataColumn("flagarrear", typeof(System.String));
	C.ReadOnly=true;
	T.Columns.Add(C);
	T.Columns.Add( new DataColumn("registry", typeof(System.String)));
	T.Columns.Add( new DataColumn("npro", typeof(System.Int32)));
	C= new DataColumn("incomedescr", typeof(System.String));
	C.AllowDBNull=false;
	T.Columns.Add(C);
	T.Columns.Add( new DataColumn("nproceedstransmission", typeof(System.Int32)));
	T.Columns.Add( new DataColumn("yproceedstransmission", typeof(System.Int16)));
	Tables.Add(T);
	T.PrimaryKey =  new DataColumn[]{T.Columns["idinc"], T.Columns["idsubclass"], T.Columns["idsor"]};


	#endregion


	#region DataRelation creation
	DataColumn []CPar;
	DataColumn []CChild;
	CPar = new DataColumn[1]{sortingkind.Columns["idsorkind"]};
	CChild = new DataColumn[1]{sorting.Columns["idsorkind"]};
	Relations.Add(new DataRelation("sortingkind_sorting",CPar,CChild,false));

	CPar = new DataColumn[2]{sortingtranslation.Columns["idsortingchild"], sortingtranslation.Columns["idsortingmaster"]};
	CChild = new DataColumn[2]{incomesorted.Columns["idsor"], incomesorted.Columns["paridsor"]};
	Relations.Add(new DataRelation("sortingtranslation_incomesorted",CPar,CChild,false));

	CPar = new DataColumn[1]{sorting.Columns["idsor"]};
	CChild = new DataColumn[1]{incomesorted.Columns["idsor"]};
	Relations.Add(new DataRelation("sortingincomesorted",CPar,CChild,false));

	CPar = new DataColumn[1]{incomeview.Columns["idinc"]};
	CChild = new DataColumn[1]{incomesorted.Columns["idinc"]};
	Relations.Add(new DataRelation("incomeview_incomesorted",CPar,CChild,false));

	#endregion

}
}
}
