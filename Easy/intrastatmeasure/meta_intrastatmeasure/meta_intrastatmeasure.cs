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
using metaeasylibrary;
using metadatalibrary;
using System.Windows.Forms;

namespace meta_intrastatmeasure
{
	/// <summary>
	/// Summary description for Class1.
	/// </summary>
	public class Meta_intrastatmeasure : Meta_easydata {
		public Meta_intrastatmeasure(DataAccess Conn, MetaDataDispatcher Dispatcher):
			base(Conn, Dispatcher, "intrastatmeasure") {
			EditTypes.Add("lista");
			ListingTypes.Add("lista");
            Name = "Unit� di misura supplementare";
		}
		protected override Form GetForm(string FormName) {
			if (FormName=="lista") {
				ActAsList();
				return MetaData.GetFormByDllName("intrastatmeasure_lista");
 
			}
			return null;
		}

        public override DataRow Get_New_Row (DataRow ParentRow, DataTable T) {
            RowChange.MarkAsAutoincrement(T.Columns["idintrastatmeasure"], null, null, 0);
            return base.Get_New_Row(ParentRow, T);

        }
		
		public override void DescribeColumns(DataTable T, string listtype) {
			base.DescribeColumns(T, listtype);

			if (listtype=="lista"){
				foreach(DataColumn C in T.Columns) 
					DescribeAColumn(T,C.ColumnName,"");

				DescribeAColumn(T, "idintrastatmeasure","Codice");
				DescribeAColumn(T, "description","Descrizione");
                DescribeAColumn(T, "code", "Sigla");
        		
			}
		}   
	}
}
