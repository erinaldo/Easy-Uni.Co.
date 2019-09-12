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
using metaeasylibrary;
using metadatalibrary;
using System.Data;

namespace meta_configsmtp
{
    /// <summary>
    /// Summary description for Class1.
    /// </summary>
    public class Meta_configsmtp : Meta_easydata{
        public Meta_configsmtp(DataAccess Conn, MetaDataDispatcher Dispatcher):
            base(Conn, Dispatcher, "configsmtp"){
            EditTypes.Add("default");
            ListingTypes.Add("default");
        }

        protected override Form GetForm(string FormName){
            DefaultListType = "default";
            Name = "Gestione Notifiche";
            return MetaData.GetFormByDllName("configsmtp_default");

        }

        public override void SetDefaults(System.Data.DataTable T){
            base.SetDefaults(T);
            SetDefault(T, "flagsend", "S");
            SetDefault(T, "dummykey", 1);
        }

    }
}
