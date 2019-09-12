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


namespace meta_taxratecitystartview
{
    public class Meta_taxratecitystartview : Meta_easydata
    {
        public Meta_taxratecitystartview(DataAccess Conn, MetaDataDispatcher Dispatcher)
            :
            base(Conn, Dispatcher, "taxratecitystartview")
        {
            ListingTypes.Add("default");
        }
       
        public override void DescribeColumns(DataTable T, string ListingType)
        {
            base.DescribeColumns(T, ListingType);
            foreach (DataColumn C in T.Columns)
                DescribeAColumn(T, C.ColumnName, "");
            int nPos = 1;
            DescribeAColumn(T, "city", "Comune", nPos++);
            DescribeAColumn(T, "country", "Provincia", nPos++);
            DescribeAColumn(T, "start","Data decorrenza", nPos++);
            DescribeAColumn(T, "idtaxratecitystart", "#", nPos++);
            DescribeAColumn(T, "annotations", "Annotazioni", nPos++);
        }
        public override string GetSorting(string ListingType) {
            if (ListingType == "default") {
                return "city ASC,start DESC,idtaxratecitystart DESC";
            }
            return base.GetSorting(ListingType);
        }
    }
}
