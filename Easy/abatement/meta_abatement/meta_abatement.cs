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

namespace meta_abatement//meta_tipodetrazione//
{
	/// <summary>
	/// Summary description for Meta_tipodetrazione.
	/// </summary>
	public class Meta_abatement : Meta_easydata
	{
		public Meta_abatement(DataAccess Conn, MetaDataDispatcher Dispatcher):
			base(Conn, Dispatcher, "abatement") 
		{
            Name = "Codici Detrazioni per Esercizio";
			EditTypes.Add("default");
			ListingTypes.Add("default");
		}

		protected override Form GetForm(string FormName)
		{
			if (FormName=="default") 
			{
				DefaultListType = "default";
				Name = "Tipo Detrazione";
				return MetaData.GetFormByDllName("abatement_default");
			}
			return null;
		}

		public override DataRow Get_New_Row(DataRow ParentRow, DataTable T)
		{
			RowChange.MarkAsAutoincrement(T.Columns["idabatement"],null,null,0);
			return base.Get_New_Row(ParentRow, T);
		}

		public override DataRow SelectOne(string ListingType, string filter, string searchtable, DataTable ToMerge)
		{
			return base.SelectOne (ListingType, filter, "abatementview", ToMerge);
		}

	}
}
