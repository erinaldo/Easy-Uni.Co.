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
using System.Collections.Generic;
using System.Text;
using metadatalibrary;
using metaeasylibrary;
using System.Data;

namespace meta_admpay_incomeview {
    class Meta_admpay_incomeview  : Meta_easydata {
		public Meta_admpay_incomeview(DataAccess Conn, MetaDataDispatcher Dispatcher):
			base(Conn, Dispatcher, "admpay_incomeview") {	
			ListingTypes.Add("default");
		}

		public override string GetStaticFilter(string ListingType) {
			string filteresercizio;
			if (ListingType=="default"){
				filteresercizio = QHS.CmpEq("yadmpay", GetSys("esercizio"));
				return filteresercizio;
			}
			return base.GetStaticFilter (ListingType);
		}

		public override void DescribeColumns(DataTable T, string ListingType) {
			base.DescribeColumns(T, ListingType);

			if (ListingType=="default") {
				foreach(DataColumn C in T.Columns) {
					DescribeAColumn(T, C.ColumnName, "",-1);
				}
				int nPos = 1;
				DescribeAColumn(T, "yadmpay", "Eserc. Pag. Stip.", nPos++);
				DescribeAColumn(T, "nadmpay", "Num. Pag. Stip.", nPos++);
				DescribeAColumn(T, "nincome", "Num. Movimento", nPos++);
				DescribeAColumn(T, "nassessment", "Num. Accertamento", nPos++);
				DescribeAColumn(T, "registry", "Versante", nPos++);
				DescribeAColumn(T, "amount", "Importo", nPos++);
				DescribeAColumn(T, "description", "Descrizione", nPos++);
			}
		}
	}
}