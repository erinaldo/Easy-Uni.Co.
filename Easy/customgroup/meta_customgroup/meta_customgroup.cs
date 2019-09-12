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
//Pino: using customgroup; diventato inutile


namespace meta_customgroup//meta_customgroup//
{
	/// <summary>
	/// Summary description for customgroup.
	/// </summary>
	public class Meta_customgroup : Meta_easydata 
	{
		public Meta_customgroup(DataAccess Conn, MetaDataDispatcher Dispatcher):
			base(Conn, Dispatcher, "customgroup") 
		{
			EditTypes.Add("default");
			ListingTypes.Add("default");
			Name = "Gruppi di utenti";
		}
		protected override Form GetForm(string FormName)
		{
			if (FormName=="default") 
			{
				DefaultListType="default";
				Name="Gruppi di utenti";
				ActAsList();        
				SearchEnabled = false;
				return MetaData.GetFormByDllName("customgroup_default");//PinoRana
			}
			return null;
		}

		public override void DescribeColumns
			(DataTable T, string ListingType)
		{
			base.DescribeColumns(T, ListingType);
			if ( ListingType=="default")
			{
                foreach (DataColumn C in T.Columns)
                    DescribeAColumn(T, C.ColumnName, "", -1);

                int nPos = 1;
                DescribeAColumn(T, "idcustomgroup", "Codice gruppo", nPos++);
                DescribeAColumn(T, "groupname", "Nome gruppo", nPos++);
				DescribeAColumn(T,"description","Descrizione",nPos++);
			}
		}
	}
	
}
