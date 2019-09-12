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

﻿using System;
using System.Collections.Generic;
using System.Text;
using System.Data;
using System.Windows.Forms;
using metadatalibrary;
using metaeasylibrary;
namespace meta_colvalue
{
    
    public class Meta_colvalue : Meta_easydata {
        public Meta_colvalue(DataAccess Conn, MetaDataDispatcher Dispatcher)
            :
            base(Conn, Dispatcher, "colvalue") {
            EditTypes.Add("default");
            ListingTypes.Add("default");
        }
        protected override Form GetForm(string FormName) {
            if (FormName == "default") {
                Name = "Descrizione valore codificato";
                DefaultListType = "default";
                return MetaData.GetFormByDllName("colvalue_default");
            }
            return null;
        }

        public override void DescribeColumns(DataTable T, string ListingType) {
            base.DescribeColumns(T, ListingType);
            foreach (DataColumn C in T.Columns) {
                DescribeAColumn(T, C.ColumnName, "", -1);
            }

            if (ListingType == "default") {
                int nPos = 1;
                //DescribeAColumn(T, "tablename", "Tabella", nPos++);
                //DescribeAColumn(T, "colname", "campo", nPos++);
                DescribeAColumn(T, "value", "valore", nPos++);
                DescribeAColumn(T, "title", "Significato", nPos++);
                DescribeAColumn(T, "description", "Spiegazione", nPos++);

            }
            return;
        }

    }

}
