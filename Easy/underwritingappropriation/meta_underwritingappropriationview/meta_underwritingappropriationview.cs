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

namespace meta_underwritingappropriationview {
    public class Meta_underwritingappropriationview : Meta_easydata
    {
        public Meta_underwritingappropriationview(DataAccess Conn, MetaDataDispatcher Dispatcher)
            :
            base(Conn, Dispatcher, "underwritingappropriationview")
        {

            ListingTypes.Add("default");
        }
        private string[] mykey = new string[] { "ayear", "idexp", "idunderwriting"};
        public override string[] primaryKey() {
            return mykey;
        }
        public override string GetStaticFilter(string ListingType) {
            string filteresercizio = QHS.CmpEq("ayear", GetSys("esercizio"));
            string basefilter = base.GetStaticFilter(ListingType);
            if (basefilter == null || basefilter == "")
                return filteresercizio;
            return QHS.AppAnd(basefilter, filteresercizio);
            }

        public override void DescribeColumns(DataTable T, string ListingType)
        {
            base.DescribeColumns(T, ListingType);

            if (ListingType == "default")
            {
                foreach (DataColumn C in T.Columns) DescribeAColumn(T, C.ColumnName, "");
                int nPos = 1;
                DescribeAColumn(T, "codeunderwriting", "Cod.Finanziamento",nPos ++);
                DescribeAColumn(T, "underwriting", "Finanziamento", nPos++);
                DescribeAColumn(T, "upb", "UPB", nPos++);
                DescribeAColumn(T, "codefin", "Cod.Bilancio", nPos++);
                DescribeAColumn(T, "fin", "Bilancio", nPos++);
                DescribeAColumn(T, "expensephase", "Fase", nPos++);
                DescribeAColumn(T, "ymov", "Esercizio", nPos++);
                DescribeAColumn(T, "nmov", "Numero,", nPos++);
                DescribeAColumn(T, "amount", "Importo", nPos++);
                DescribeAColumn(T, "registry", "Anagrafica", nPos++);
                DescribeAColumn(T, "manager", "Responsabile", nPos++);
            }
        }


    }
}
