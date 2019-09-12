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
using metaeasylibrary;
using metadatalibrary;
using System.Windows.Forms;
using System.Data;

namespace meta_dbuser {
	/// <summary>
	/// Summary description for Class1.
	/// </summary>
	public class Meta_dbuser : Meta_easydata {
		public Meta_dbuser(DataAccess Conn, MetaDataDispatcher Dispatcher) 
			: base(Conn, Dispatcher, "dbuser") 
		{	
			EditTypes.Add("config");
            ListingTypes.Add("default");
            Name = "Configurazione DB";
            DefaultListType = "default";
		}
		
		protected override Form GetForm(string FormName) {
            switch (FormName) {
                case "config": {
                        ActAsList();
                        return GetFormByDllName("dbuser_config");
                    }
                case "alert": {
                        Name = "Avvisi";
                        return GetFormByDllName("dbuser_alert");
                    }
            }
			return null;
		}
	}
}
