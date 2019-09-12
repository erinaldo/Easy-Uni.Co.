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

namespace meta_placcountlookup//Meta_placcountlookup//
{
    /// <summary>
    /// Summary description for Meta_placcountlookup.
    /// </summary>
    public class Meta_placcountlookup : Meta_easydata
    {
        public Meta_placcountlookup(DataAccess Conn, MetaDataDispatcher Dispatcher)
            :
            base(Conn, Dispatcher, "placcountlookup")
        {
            EditTypes.Add("default");
            ListingTypes.Add("default");
        }

        protected override Form GetForm(string EditType)
        {
            if (EditType == "default")
            {
                Name = "Converti voci del Conto Economico annuale";
                DefaultListType = "default";
                return GetFormByDllName("placcountlookup_default");
            }
            return null;
        }

        public override void SetDefaults(DataTable PrimaryTable)
        {
            base.SetDefaults(PrimaryTable);
        }

        public override void DescribeColumns(DataTable T, string ListingType)
        {
            base.DescribeColumns(T, ListingType);

            if (ListingType == "default")
            {
                foreach (DataColumn C in T.Columns)
                    DescribeAColumn(T, C.ColumnName, "");

                DescribeAColumn(T, "oldidplaccount", "Vecchio ID");
                DescribeAColumn(T, "newidplaccount", "Nuovo ID");
            }
        }

        public override DataRow SelectOne(string ListingType, string filter, string searchtable, DataTable Exclude)
        {
            if (ListingType == "default") return base.SelectOne(ListingType, filter, "placcountlookupview", Exclude);
            return base.SelectOne(ListingType, filter, "placcountlookup", Exclude);
        }

    }
}
