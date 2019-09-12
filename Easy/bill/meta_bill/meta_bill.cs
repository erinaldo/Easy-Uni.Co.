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
using metaeasylibrary;
using metadatalibrary;
using System.Windows.Forms;
using System.Data;

namespace meta_bill {
	/// <summary>
	/// Summary description for Meta_bill.
	/// </summary>
	public class Meta_bill : Meta_easydata {
		public Meta_bill(DataAccess Conn, MetaDataDispatcher Dispatcher):
			base(Conn, Dispatcher, "bill") {
			EditTypes.Add("default");
			ListingTypes.Add("default");
			ListingTypes.Add("spesa");
			ListingTypes.Add("entrata");
			DefaultListType = "default";
		}

		protected override Form GetForm(string FormName) {
			if (FormName=="default") {
				Name = "Partita pendente";
				return GetFormByDllName("bill_default");
			}
			return null;
		}
        public override string GetFilterForSearch(DataTable T) {
            return null;
        }

	    private string[] mykey = new string[] { "billkind","ybill","nbill" };
	    public override string[] primaryKey() {
	        return mykey;
	    }


		public override void SetDefaults(DataTable PrimaryTable) {
			base.SetDefaults (PrimaryTable);
			SetDefault(PrimaryTable, "ybill", GetSys("esercizio"));
			SetDefault(PrimaryTable, "adate", GetSys("datacontabile"));
		}

        //public override void DescribeColumns(DataTable T, string listtype) {
        //    base.DescribeColumns(T, listtype);
        //    if (listtype=="default"){
        //        foreach (DataColumn C in T.Columns) {
        //            DescribeAColumn(T, C.ColumnName, "", -1);
        //        }
        //        int nPos = 1;
        //        DescribeAColumn(T, "ybill", "Esercizio", nPos++);
        //        DescribeAColumn(T, "nbill", "Num. bolletta", nPos++);
        //        DescribeAColumn(T, "billkind", "Tipo", nPos++);
        //        DescribeAColumn(T, "adate", "Data contabile", nPos++);
        //        DescribeAColumn(T, "registry", "Anagrafica", nPos++);
        //        DescribeAColumn(T, "motive", "Causale", nPos++);
        //        DescribeAColumn(T, "total", "Importo Totale", nPos++);
        //        DescribeAColumn(T, "active", "Da regolarizzare", nPos++);
        //        DescribeAColumn(T, "regularizationnote", "Note", nPos++);
        //        DescribeAColumn(T, "treasurer", "Cassiere", nPos++);
        //    }
        //} 

		public override DataRow SelectOne(string ListingType, string filter, string searchtable, DataTable Exclude) {
			switch (ListingType) {
                case "default":
				case "entrata":
				case "spesa":
					return base.SelectOne(ListingType, filter, "billview", Exclude);
			}
			return base.SelectOne(ListingType, filter, searchtable, Exclude);
		}
	}
}