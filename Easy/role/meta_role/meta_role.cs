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
//Pino: using cdruololista_Anagrafica; diventato inutile

namespace meta_role//meta_cdruolo//
{
	/// <summary>
	/// Summary description for Class1.
	/// </summary>
	public class Meta_role : Meta_easydata {
		public Meta_role(DataAccess Conn, MetaDataDispatcher Dispatcher):
			base(Conn, Dispatcher, "role") {
			EditTypes.Add("anagrafica");
			ListingTypes.Add("default");
			ListingTypes.Add("solodescrizione");
		}

		protected override Form GetForm(string FormName) {
			if (FormName=="anagrafica") {
				Name="Ruoli";
				ActAsList();
				return MetaData.GetFormByDllName("role_anagrafica");
			}

			return null;
		}			

		public override void SetDefaults(DataTable T) {
			base.SetDefaults(T);
			SetDefault(T,"active","S");
		}
	
		public override void DescribeColumns(DataTable T, string listtype) {
			base.DescribeColumns(T, listtype);
			if (listtype=="solodescrizione"){
				foreach(DataColumn C in T.Columns) DescribeAColumn(T,C.ColumnName,"");
				DescribeAColumn(T,"description","Descrizione");
			}
			if (listtype=="default"){
				foreach(DataColumn C in T.Columns) DescribeAColumn(T,C.ColumnName,"");
				DescribeAColumn(T, "idrole","Codice");
				DescribeAColumn(T, "description","Descrizione");
				DescribeAColumn(T, "active","Attivo");
				DescribeAColumn(T, "!classificazione", "Classificazione", 
					"registryclass.description");
			}
		}   
	}
}
