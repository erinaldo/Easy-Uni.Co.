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

using System;
using System.Data;
using metadatalibrary;
using metaeasylibrary;
//$CustomUsing$


namespace meta_location_struttura
{
    public class Meta_location_struttura : Meta_easydata 
	{
        public Meta_location_struttura(DataAccess Conn, MetaDataDispatcher Dispatcher) :
            base(Conn, Dispatcher, "location_struttura") {
				Name = "Struttura / Unità organizzativa";
			EditTypes.Add("struttura");
            ListingTypes.Add("struttura");
            EditTypes.Add("struttura_seg_child");
            ListingTypes.Add("struttura_seg_child");
            //$EditTypes$
        }

		//$PrymaryKey$

		public override void SetDefaults(DataTable PrimaryTable) {
			base.SetDefaults(PrimaryTable);
			switch (edit_type) {
				case "struttura": {
						break;
					}
				case "struttura_seg_child": {
						break;
					}
					//$SetDefault$
			}
		}

		public override DataRow Get_New_Row(DataRow ParentRow, DataTable T) {
			
			//$Get_New_Row$

			DataRow R = base.Get_New_Row(ParentRow, T);
			return R;
		}

		public override bool IsValid(DataRow R, out string errmess, out string errfield) {
			if (!base.IsValid(R, out errmess, out errfield)) return false;

			switch (edit_type) {
				//$IsValid$
			}

			return true;
		}

		public override void DescribeColumns(DataTable T, string ListingType) {
			base.DescribeColumns(T, ListingType);

			foreach (DataColumn C in T.Columns) {
				DescribeAColumn(T, C.ColumnName, "", -1);
			}
			int nPos = 1;
					
			switch (ListingType) {
				case "struttura": {
						DescribeAColumn(T, "idlocation", "Codice", nPos++);
						DescribeAColumn(T, "!idstrutturakind_strutturakind_title", "Tipologia", nPos++);
						DescribeAColumn(T, "title_en", "Denominazione (ENG)", nPos++);
						break;
					}
				case "struttura_seg_child": {
						DescribeAColumn(T, "idlocation", "Codice", nPos++);
						DescribeAColumn(T, "!idstrutturakind_strutturakind_title", "Tipologia", nPos++);
						DescribeAColumn(T, "title_en", "Denominazione (ENG)", nPos++);
						break;
					}
				//$DescribeAColumn$
			}
		}

		public override string GetSorting(string ListingType) {

			switch (ListingType) {
				//$GetSorting$
			}
			return base.GetSorting(ListingType);
		}

		public override string GetStaticFilter(string ListingType) {
			switch (ListingType) {
				//$GetStaticFilter$
			}
			return base.GetStaticFilter(ListingType);
		}
		
		//$CustomCode$
    }
}
