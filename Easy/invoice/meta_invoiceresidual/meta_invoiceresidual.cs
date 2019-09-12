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


namespace meta_invoiceresidual {
	/// <summary>
	/// Summary description for Class1.
	/// </summary>
	public class Meta_invoiceresidual : Meta_easydata {
		public Meta_invoiceresidual(DataAccess Conn, MetaDataDispatcher Dispatcher):
			base(Conn, Dispatcher, "invoiceresidual") {
			Name = "Documenti IVA da contabilizzare";
			ListingTypes.Add("default");
		}

		public override string GetSorting(string ListingType)
		{
			string sorting;
			if (ListingType=="default")
			{
				sorting = "idinvkind asc,yinv desc,ninv desc, registry asc,upb asc";
				return sorting;
			}
			return base.GetSorting (ListingType);
		}

        private string[] mykey = new string[] { "idinvkind", "yinv", "ninv" };
        public override string[] primaryKey() {
            return mykey;
        }
        public override void DescribeColumns(DataTable T, string ListingType) 
		{
			base.DescribeColumns (T, ListingType);

			if (ListingType=="default") {
				foreach (DataColumn C in T.Columns)
					DescribeAColumn(T,C.ColumnName,"",-1);
				int nPos = 1;
				DescribeAColumn(T,"idinvkind",".#",nPos++);
                DescribeAColumn(T,"codeinvkind", "Tipo documento", nPos++);
				DescribeAColumn(T,"yinv","Esercizio",nPos++);
				DescribeAColumn(T,"ninv","Numero",nPos++);
                DescribeAColumn(T, "doc", "Documento", nPos++);
                DescribeAColumn(T, "docdate", "Data doc.", nPos++);
				DescribeAColumn(T,"registry","Cliente/Fornitore",nPos++);
				DescribeAColumn(T, "upb", "UPB",nPos++);
				DescribeAColumn(T,"description","Descrizione",nPos++);
    			DescribeAColumn(T,"ycon","Eserc. Contr. Prof.",nPos++);
				DescribeAColumn(T,"ncon","Contr. Prof.",nPos++);
//				DescribeAColumn(T,"adate","Data reg.",nPos++);
				DescribeAColumn(T,"taxabletotal","Tot.Imponibile",nPos++);
				DescribeAColumn(T,"ivatotal","Tot.IVA",nPos++);
				DescribeAColumn(T,"linkeddocum","Tot.Contabilizzato",nPos++);
				DescribeAColumn(T,"residual","Tot.Residuo",21);
			}
		}
	}
}
