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
using System.Windows.Forms;
using metaeasylibrary;
using metadatalibrary;

namespace meta_otherinail//meta_altrecollaborazioniinail//
{
	/// <summary>
	/// Summary description for Meta_altrecollaborazioniinail.
	/// </summary>
	public class Meta_otherinail : Meta_easydata
	{
		public Meta_otherinail(DataAccess Conn, MetaDataDispatcher Dispatcher):
			base(Conn, Dispatcher, "otherinail") 
		{		
			EditTypes.Add("default");
			ListingTypes.Add("default");
		}

		protected override Form GetForm(string FormName)
		{
			if (FormName=="default")
			{
				Name = "Altre Collaborazioni INAIL";
				DefaultListType = "default";
				return GetFormByDllName("otherinail_default");
			}
			return null;
		}

		public override DataRow Get_New_Row(DataRow ParentRow, DataTable T)
		{
			RowChange.SetSelector(T,"idcon");
			RowChange.MarkAsAutoincrement(T.Columns["idotherinail"],null,null,7);
			return base.Get_New_Row (ParentRow, T);
		}

		public override void DescribeColumns(DataTable T, string ListingType)
		{
			base.DescribeColumns(T, ListingType);
			if (ListingType=="default")
			{
				foreach(DataColumn C in T.Columns) DescribeAColumn(T,C.ColumnName,"");
				DescribeAColumn(T,"idotherinail","Cod. Collaborazione");
				DescribeAColumn(T,"taxable","Imponibile Assicurativo");
				DescribeAColumn(T,"start","Data Inizio");
				DescribeAColumn(T,"stop","Data Fine");
				DescribeAColumn(T,"nmonths","Numero Mesi");
			}
		}

		/*public override void SetDefaults(DataTable PrimaryTable)
		{
			base.SetDefaults (PrimaryTable);
			SetDefault(PrimaryTable,"esercizio",GetSys("esercizio"));
		}*/
	}
}
