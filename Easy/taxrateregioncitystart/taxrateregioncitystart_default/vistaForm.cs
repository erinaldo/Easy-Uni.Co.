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
namespace taxrateregioncitystart_default {
[Serializable,DesignerCategory("code"),System.Xml.Serialization.XmlSchemaProvider("GetTypedDataSetSchema")]
[System.Xml.Serialization.XmlRoot("vistaForm"),System.ComponentModel.Design.HelpKeyword("vs.data.DataSet")]
public class vistaForm: DataSet {

	#region Table members declaration
	[DebuggerNonUserCode,DesignerSerializationVisibility(DesignerSerializationVisibility.Hidden),Browsable(false)]
	public DataTable geo_cityview 		=> Tables["geo_cityview"];

	///<summary>
	///Tipi di ritenuta
	///</summary>
	[DebuggerNonUserCode,DesignerSerializationVisibility(DesignerSerializationVisibility.Hidden),Browsable(false)]
	public DataTable tax 		=> Tables["tax"];

	///<summary>
	///Struttura Imposta Regionale per Comune
	///</summary>
	[DebuggerNonUserCode,DesignerSerializationVisibility(DesignerSerializationVisibility.Hidden),Browsable(false)]
	public DataTable taxrateregioncitystart 		=> Tables["taxrateregioncitystart"];

	///<summary>
	///Scaglioni Imposta Regionale per Comune
	///</summary>
	[DebuggerNonUserCode,DesignerSerializationVisibility(DesignerSerializationVisibility.Hidden),Browsable(false)]
	public DataTable taxrateregioncitybracket 		=> Tables["taxrateregioncitybracket"];

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
	//////////////////// GEO_CITYVIEW /////////////////////////////////
	var tgeo_cityview= new DataTable("geo_cityview");
	C= new DataColumn("idcity", typeof(int));
	C.AllowDBNull=false;
	tgeo_cityview.Columns.Add(C);
	tgeo_cityview.Columns.Add( new DataColumn("title", typeof(string)));
	tgeo_cityview.Columns.Add( new DataColumn("oldcity", typeof(int)));
	tgeo_cityview.Columns.Add( new DataColumn("newcity", typeof(int)));
	tgeo_cityview.Columns.Add( new DataColumn("start", typeof(DateTime)));
	tgeo_cityview.Columns.Add( new DataColumn("stop", typeof(DateTime)));
	tgeo_cityview.Columns.Add( new DataColumn("idcountry", typeof(int)));
	tgeo_cityview.Columns.Add( new DataColumn("provincecode", typeof(string)));
	tgeo_cityview.Columns.Add( new DataColumn("country", typeof(string)));
	tgeo_cityview.Columns.Add( new DataColumn("oldcountry", typeof(int)));
	tgeo_cityview.Columns.Add( new DataColumn("newcountry", typeof(int)));
	tgeo_cityview.Columns.Add( new DataColumn("countrydatestart", typeof(DateTime)));
	tgeo_cityview.Columns.Add( new DataColumn("countrydatestop", typeof(DateTime)));
	tgeo_cityview.Columns.Add( new DataColumn("idregion", typeof(int)));
	tgeo_cityview.Columns.Add( new DataColumn("region", typeof(string)));
	tgeo_cityview.Columns.Add( new DataColumn("regiondatestart", typeof(DateTime)));
	tgeo_cityview.Columns.Add( new DataColumn("regiondatestop", typeof(DateTime)));
	tgeo_cityview.Columns.Add( new DataColumn("oldregion", typeof(int)));
	tgeo_cityview.Columns.Add( new DataColumn("newregion", typeof(int)));
	tgeo_cityview.Columns.Add( new DataColumn("idnation", typeof(int)));
	tgeo_cityview.Columns.Add( new DataColumn("idcontinent", typeof(int)));
	tgeo_cityview.Columns.Add( new DataColumn("nation", typeof(string)));
	tgeo_cityview.Columns.Add( new DataColumn("nationdatestart", typeof(DateTime)));
	tgeo_cityview.Columns.Add( new DataColumn("nationdatestop", typeof(DateTime)));
	tgeo_cityview.Columns.Add( new DataColumn("oldnation", typeof(int)));
	tgeo_cityview.Columns.Add( new DataColumn("newnation", typeof(int)));
	Tables.Add(tgeo_cityview);
	tgeo_cityview.PrimaryKey =  new DataColumn[]{tgeo_cityview.Columns["idcity"]};


	//////////////////// TAX /////////////////////////////////
	var ttax= new DataTable("tax");
	C= new DataColumn("taxcode", typeof(int));
	C.AllowDBNull=false;
	ttax.Columns.Add(C);
	ttax.Columns.Add( new DataColumn("active", typeof(string)));
	ttax.Columns.Add( new DataColumn("appliancebasis", typeof(string)));
	C= new DataColumn("ct", typeof(DateTime));
	C.AllowDBNull=false;
	ttax.Columns.Add(C);
	C= new DataColumn("cu", typeof(string));
	C.AllowDBNull=false;
	ttax.Columns.Add(C);
	C= new DataColumn("description", typeof(string));
	C.AllowDBNull=false;
	ttax.Columns.Add(C);
	ttax.Columns.Add( new DataColumn("fiscaltaxcode", typeof(string)));
	ttax.Columns.Add( new DataColumn("flagunabatable", typeof(string)));
	ttax.Columns.Add( new DataColumn("geoappliance", typeof(string)));
	ttax.Columns.Add( new DataColumn("idaccmotive_cost", typeof(string)));
	ttax.Columns.Add( new DataColumn("idaccmotive_debit", typeof(string)));
	ttax.Columns.Add( new DataColumn("idaccmotive_pay", typeof(string)));
	C= new DataColumn("lt", typeof(DateTime));
	C.AllowDBNull=false;
	ttax.Columns.Add(C);
	C= new DataColumn("lu", typeof(string));
	C.AllowDBNull=false;
	ttax.Columns.Add(C);
	ttax.Columns.Add( new DataColumn("taxablecode", typeof(string)));
	ttax.Columns.Add( new DataColumn("taxkind", typeof(short)));
	Tables.Add(ttax);
	ttax.PrimaryKey =  new DataColumn[]{ttax.Columns["taxcode"]};


	//////////////////// TAXRATEREGIONCITYSTART /////////////////////////////////
	var ttaxrateregioncitystart= new DataTable("taxrateregioncitystart");
	C= new DataColumn("idcity", typeof(int));
	C.AllowDBNull=false;
	ttaxrateregioncitystart.Columns.Add(C);
	C= new DataColumn("taxcode", typeof(int));
	C.AllowDBNull=false;
	ttaxrateregioncitystart.Columns.Add(C);
	C= new DataColumn("idtaxrateregioncitystart", typeof(int));
	C.AllowDBNull=false;
	ttaxrateregioncitystart.Columns.Add(C);
	C= new DataColumn("start", typeof(DateTime));
	C.AllowDBNull=false;
	ttaxrateregioncitystart.Columns.Add(C);
	C= new DataColumn("lt", typeof(DateTime));
	C.AllowDBNull=false;
	ttaxrateregioncitystart.Columns.Add(C);
	C= new DataColumn("lu", typeof(string));
	C.AllowDBNull=false;
	ttaxrateregioncitystart.Columns.Add(C);
	ttaxrateregioncitystart.Columns.Add( new DataColumn("enforcement", typeof(string)));
	Tables.Add(ttaxrateregioncitystart);
	ttaxrateregioncitystart.PrimaryKey =  new DataColumn[]{ttaxrateregioncitystart.Columns["idcity"], ttaxrateregioncitystart.Columns["taxcode"], ttaxrateregioncitystart.Columns["idtaxrateregioncitystart"]};


	//////////////////// TAXRATEREGIONCITYBRACKET /////////////////////////////////
	var ttaxrateregioncitybracket= new DataTable("taxrateregioncitybracket");
	C= new DataColumn("idcity", typeof(int));
	C.AllowDBNull=false;
	ttaxrateregioncitybracket.Columns.Add(C);
	C= new DataColumn("taxcode", typeof(int));
	C.AllowDBNull=false;
	ttaxrateregioncitybracket.Columns.Add(C);
	C= new DataColumn("idtaxrateregioncitystart", typeof(int));
	C.AllowDBNull=false;
	ttaxrateregioncitybracket.Columns.Add(C);
	C= new DataColumn("nbracket", typeof(int));
	C.AllowDBNull=false;
	ttaxrateregioncitybracket.Columns.Add(C);
	ttaxrateregioncitybracket.Columns.Add( new DataColumn("minamount", typeof(decimal)));
	ttaxrateregioncitybracket.Columns.Add( new DataColumn("maxamount", typeof(decimal)));
	ttaxrateregioncitybracket.Columns.Add( new DataColumn("rate", typeof(decimal)));
	C= new DataColumn("lt", typeof(DateTime));
	C.AllowDBNull=false;
	ttaxrateregioncitybracket.Columns.Add(C);
	C= new DataColumn("lu", typeof(string));
	C.AllowDBNull=false;
	ttaxrateregioncitybracket.Columns.Add(C);
	Tables.Add(ttaxrateregioncitybracket);
	ttaxrateregioncitybracket.PrimaryKey =  new DataColumn[]{ttaxrateregioncitybracket.Columns["idcity"], ttaxrateregioncitybracket.Columns["taxcode"], ttaxrateregioncitybracket.Columns["idtaxrateregioncitystart"], ttaxrateregioncitybracket.Columns["nbracket"]};


	#endregion


	#region DataRelation creation
	var cPar = new []{taxrateregioncitystart.Columns["idcity"], taxrateregioncitystart.Columns["taxcode"], taxrateregioncitystart.Columns["idtaxrateregioncitystart"]};
	var cChild = new []{taxrateregioncitybracket.Columns["idcity"], taxrateregioncitybracket.Columns["taxcode"], taxrateregioncitybracket.Columns["idtaxrateregioncitystart"]};
	Relations.Add(new DataRelation("taxrateregioncitystart_taxrateregioncitybracket",cPar,cChild,false));

	cPar = new []{geo_cityview.Columns["idcity"]};
	cChild = new []{taxrateregioncitystart.Columns["idcity"]};
	Relations.Add(new DataRelation("geo_cityview_taxrateregioncitystart",cPar,cChild,false));

	cPar = new []{tax.Columns["taxcode"]};
	cChild = new []{taxrateregioncitystart.Columns["taxcode"]};
	Relations.Add(new DataRelation("tax_taxrateregioncitystart",cPar,cChild,false));

	#endregion

}
}
}
