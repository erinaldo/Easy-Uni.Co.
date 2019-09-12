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
using metaeasylibrary;
using metadatalibrary;
using System.Windows.Forms;
//Pino: using automatismipercentualesingle; diventato inutile

namespace meta_taxpaymentpartsetupview{//meta_automatismipercentualeview//
	/// <summary>
	/// Summary description for meta_automatismipercentualeview
	/// </summary>
	public class Meta_taxpaymentpartsetupview : Meta_easydata {
		public Meta_taxpaymentpartsetupview(DataAccess Conn, MetaDataDispatcher Dispatcher):
			base(Conn, Dispatcher, "taxpaymentpartsetupview") {
			ListingTypes.Add("enteesattore");
			EditTypes.Add("single");
			Name = "";
		}

		protected override Form GetForm(string EditType) {
			if (EditType=="single") {
				Name="Ente esattore ripartizione percentuale";
				return MetaData.GetFormByDllName("taxpaymentpartsetupview_single");//PinoRana
			}
			return null;
		}

		public override void DescribeColumns(DataTable T, string ListingType) {
			base.DescribeColumns (T, ListingType);

			if (ListingType=="enteesattore") {
				foreach(DataColumn C in T.Columns)
					DescribeAColumn(T,C.ColumnName,"");
                DescribeAColumn(T,"taxref", "Codice ritenuta");
				DescribeAColumn(T,"registry","Ente esattore");
				DescribeAColumn(T,"percentage","Percentuale");
				HelpForm.SetFormatForColumn(T.Columns["percentage"],"p");
			}
		}

	}
}
