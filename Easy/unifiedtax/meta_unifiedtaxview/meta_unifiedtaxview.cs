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
using metadatalibrary;
using metaeasylibrary;

namespace meta_unifiedtaxview
{
    public class Meta_unifiedtaxview : Meta_easydata 
    {
        public Meta_unifiedtaxview(DataAccess Conn, MetaDataDispatcher Dispatcher):
        base(Conn, Dispatcher, "unifiedtaxview") 
		{
			EditTypes.Add("default");
			ListingTypes.Add("default");
			Name = "";
		}

        protected override Form GetForm(string FormName)  {
            if (FormName == "default")
            {
                DefaultListType = "default";
                Name = "Ritenute centralizzate";
                return MetaData.GetFormByDllName("unifiedtaxview_default");
            }
            return null;
        }
        public override void DescribeColumns(DataTable T, string ListingType)
        {
            base.DescribeColumns(T, ListingType);
            if (ListingType=="default") {
                    foreach (DataColumn C in T.Columns)
                    {
                        DescribeAColumn(T, C.ColumnName, "", -1);
                    }

                    int nPos = 1;
                    DescribeAColumn(T, "ayear", "Eserc.", nPos++);
                    DescribeAColumn(T, "idunifiedf24ep", "Num.", nPos++);
                    DescribeAColumn(T, "ymov", "Eserc. Mov.", nPos++);
                    DescribeAColumn(T, "nmov", "Num. Mov.", nPos++);
                    DescribeAColumn(T, "npay", "Num. Mandato.", nPos++);
                    DescribeAColumn(T, "registry", "Percipiente", nPos++);
                    DescribeAColumn(T, "adate", "Data", nPos++);
                    DescribeAColumn(T, "taxref", "Cod. ritenuta", nPos++);
                    DescribeAColumn(T, "description", "Desc. ritenuta", nPos++);
                    DescribeAColumn(T, "taxcategory", "Categoria", nPos++);
                    DescribeAColumn(T, "taxable", "Imponibile", nPos++);
                    DescribeAColumn(T, "taxableoriginal", "Impon. originale", nPos++);
                    DescribeAColumn(T, "employrate", "Aliq. dip.", nPos++);
                    DescribeAColumn(T, "employnumerator", "Num. dip.", nPos++);
                    DescribeAColumn(T, "employdenominator", "Denom. dip.", nPos++);
                    DescribeAColumn(T, "employtax", "Rit. dip.", nPos++);
                    DescribeAColumn(T, "adminrate", "Aliq. amm.", nPos++);
                    DescribeAColumn(T, "adminnumerator", "Num. amm.", nPos++);
                    DescribeAColumn(T, "admindenominator", "Denom. amm.", nPos++);
                    DescribeAColumn(T, "admintax", "Rit. amm.", nPos++);
                    DescribeAColumn(T, "competencydate", "Data comp.", nPos++);
                    DescribeAColumn(T, "datetaxpay", "Data liq.", nPos++);
                    DescribeAColumn(T, "cf", "Codice fiscale", nPos++);
                    DescribeAColumn(T, "address", "Indirizzo", nPos++);
                    DescribeAColumn(T, "cap", "C.A.P.", nPos++);
                    DescribeAColumn(T, "city", "Comune", nPos++);
                    DescribeAColumn(T, "country", "Provincia", nPos++);
                    DescribeAColumn(T, "nation", "Nazione", nPos++);
                    DescribeAColumn(T, "location", "LocalitÓ", nPos++);
                    DescribeAColumn(T, "department", "Dipartimento", nPos++);
            }
        }

    }
}