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
using System.Data;
using System.Windows.Forms;
using metaeasylibrary;
using metadatalibrary;

namespace meta_stip_tassa {
    public class Meta_stip_tassa : Meta_easydata {
        public Meta_stip_tassa(DataAccess Conn, MetaDataDispatcher Dispatcher)
            : base(Conn, Dispatcher, "stip_tassa") {
            EditTypes.Add("default");
            ListingTypes.Add("default");
        }
        protected override Form GetForm(string FormName) {
            if (FormName == "default") {
                Name = "Tassa Ess3";
                return MetaData.GetFormByDllName("stip_tassa_default");
            }
            return null;
        }
        public override void DescribeColumns(DataTable T, string ListingType) {
            base.DescribeColumns(T, ListingType);
            if (ListingType == "default") {
                foreach (DataColumn C in T.Columns)
                    DescribeAColumn(T, C.ColumnName, "", -1);
                int nPos = 1;
                DescribeAColumn(T, ".idstiptassa", "# Tassa", nPos++);
                DescribeAColumn(T, "codicetassa", "Codice Tassa", nPos++);
                DescribeAColumn(T, "descrizione", "Descrizione", nPos++);
            }
        }

        override public DataRow Get_New_Row(DataRow ParentRow, DataTable T) {
            RowChange.MarkAsAutoincrement(T.Columns["idstiptassa"], null, null, 7);
            DataRow R = base.Get_New_Row(ParentRow, T);
            return R;
        }


        public override bool IsValid(DataRow R, out string errmess, out string errfield) {
            if (!base.IsValid(R, out errmess, out errfield))
                return false;
            return true;
        }

      

    }
}