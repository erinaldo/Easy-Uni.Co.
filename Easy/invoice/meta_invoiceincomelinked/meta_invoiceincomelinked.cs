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
using System.Windows.Forms;
using System.Data;
using metadatalibrary;
using metaeasylibrary;

namespace meta_invoiceincomelinked {
	/// <summary>
	/// Summary description for Meta_invoiceincomelinked.
	/// </summary>
	public class Meta_invoiceincomelinked : Meta_easydata {
		public Meta_invoiceincomelinked(DataAccess Conn, 
			MetaDataDispatcher Dispatcher):
			base(Conn,Dispatcher, "invoiceincomelinked") {
                Name = "Documenti IVA contabilizzati";
			ListingTypes.Add("default");
		}
        private string[] mykey = new string[] { "idinvkind", "yinv", "ninv" };
        public override string[] primaryKey() {
            return mykey;
        }
        public override void DescribeColumns(DataTable T, string ListingType) {
			base.DescribeColumns (T, ListingType);
			if (ListingType == "default") {
				foreach(DataColumn C in T.Columns) {
					DescribeAColumn(T, C.ColumnName, "", -1);
				}
				int nPos = 1;
				DescribeAColumn(T, "invoicekind", "Doc. IVA", nPos++);
				DescribeAColumn(T, "yinv", "Eserc. Doc. IVA", nPos++);
				DescribeAColumn(T, "ninv", "Num. Doc. IVA", nPos++);
                DescribeAColumn(T, "doc", "Documento Coll.", nPos++);
                DescribeAColumn(T, "docdate", "Data Doc. Coll.", nPos++);
                DescribeAColumn(T, "registry", "Cliente", nPos++);
                DescribeAColumn(T, "description", "Descrizione", nPos++);
                DescribeAColumn(T, "adate", "Data Contabile", nPos++);
			}
		}

	}
}
