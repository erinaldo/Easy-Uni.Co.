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
using metaeasylibrary;
using metadatalibrary;
using funzioni_configurazione;

namespace meta_csa_role {
	/// <summary>
	/// </summary>
	public class Meta_csa_role : Meta_easydata {
        public Meta_csa_role(DataAccess Conn, MetaDataDispatcher Dispatcher)
            :
            base(Conn, Dispatcher, "csa_role")
        {
			Name= "Ruoli CSA";
			EditTypes.Add("default");
            ListingTypes.Add("default");
		}
		protected override Form GetForm(string FormName){
			if (FormName=="default")
                return GetFormByDllName("csa_role_default");
     			return null;
		}

        public override DataRow SelectOne(string ListingType, string filter, string searchtable, DataTable ToMerge)
        {
            if (ListingType == "default")
            {
                return base.SelectOne(ListingType, filter, "csa_roleview", ToMerge);
            }
            return base.SelectOne(ListingType, filter, searchtable, ToMerge);
        }

	}
}