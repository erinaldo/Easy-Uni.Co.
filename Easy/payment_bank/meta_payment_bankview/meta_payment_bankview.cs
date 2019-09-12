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
using metaeasylibrary;
using metadatalibrary;

namespace meta_payment_bankview {
	/// <summary>
	/// Summary description for Meta_payment_bankview.
	/// </summary>
	public class Meta_payment_bankview : Meta_easydata {
		public Meta_payment_bankview (DataAccess Conn, MetaDataDispatcher Dispatcher):
			base(Conn, Dispatcher, "payment_bankview") {
			ListingTypes.Add("default");
			ListingTypes.Add("elenco");
			Name = "Movimento Bancario";
		}
        private string[] mykey = new string[] { "idpay", "kpay" };
        public override string[] primaryKey() {
            return mykey;
        }
        public override void DescribeColumns(DataTable T, string ListingType) {
			base.DescribeColumns (T, ListingType);
			int nPos = 1;
			if (ListingType == "default") {
				foreach(DataColumn C in T.Columns) {
					DescribeAColumn(T, C.ColumnName, "", -1);
				}
                DescribeAColumn(T, "kpay", ".#Mandato", nPos++);
				DescribeAColumn(T, "ypay", "Eserc. Mandato", nPos++);
				DescribeAColumn(T, "npay", "Num. Mandato", nPos++);
				DescribeAColumn(T, "idpay", "Num. Mov. Bancario", nPos++);
				DescribeAColumn(T, "registry", "Percipiente", nPos++);
				DescribeAColumn(T, "amount", "Importo", nPos++);
				DescribeAColumn(T, "description", "Descrizione", nPos++);
			}
			if (ListingType == "elenco") {
				foreach(DataColumn C in T.Columns) {
					DescribeAColumn(T, C.ColumnName, "", -1);
				}
                DescribeAColumn(T, "kpay", ".#Mandato", nPos++);
				DescribeAColumn(T, "ypay", "Eserc. Mandato", nPos++);
				DescribeAColumn(T, "npay", "Num. Mandato", nPos++);
				DescribeAColumn(T, "idpay", "Num. Mov. Bancario", nPos++);
				DescribeAColumn(T, "registry", "Percipiente", nPos++);
				DescribeAColumn(T, "amount", "Importo", nPos++);
				DescribeAColumn(T, "description", "Descrizione", nPos++);
			}
		}
	}
}