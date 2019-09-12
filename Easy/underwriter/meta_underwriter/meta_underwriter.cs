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
//using EntiFinanziatori;
//using EnteFinanziatore;
using metadatalibrary;

namespace meta_underwriter//meta_entefinanziatore//
{
	/// <summary>
	/// Summary description for Class1.
	/// </summary>
	public class Meta_underwriter : Meta_easydata {
		public Meta_underwriter(DataAccess Conn, MetaDataDispatcher Dispatcher):
			base(Conn, Dispatcher, "underwriter") {		
			Name= "Ente finanziatore";
//			EditTypes.Add("default");
			EditTypes.Add("lista");
			ListingTypes.Add("default");
		}
		protected override Form GetForm(string FormName){
			if (FormName=="lista") {
				Name="Ente finanziatore";
				ActAsList();
				return GetFormByDllName("underwriter_lista");
				//return new frmEntiFinanziatori();
			}
			return null;
		}

        public override DataRow Get_New_Row (DataRow ParentRow, DataTable T) {
            RowChange.MarkAsAutoincrement(T.Columns["idunderwriter"], null, null, 7);
            DataRow R = base.Get_New_Row(ParentRow, T);
            int N = MetaData.MaxFromColumn(T, "idunderwriter");
            if (N < 9999000)
                R["idunderwriter"] = 9999001;
            else
                R["idunderwriter"] = N + 1;

            return R;
        }

		public override void DescribeColumns(DataTable T, string ListingType){
			base.DescribeColumns(T, ListingType);
			DescribeAColumn(T,"idunderwriter","Codice");
			DescribeAColumn(T,"description","Descrizione");
		}
	}
}
