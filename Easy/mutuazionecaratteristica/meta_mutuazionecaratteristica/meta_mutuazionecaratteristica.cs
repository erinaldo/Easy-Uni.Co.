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


namespace meta_mutuazionecaratteristica
{
    public class Meta_mutuazionecaratteristica : Meta_easydata 
	{
        public Meta_mutuazionecaratteristica(DataAccess Conn, MetaDataDispatcher Dispatcher) :
            base(Conn, Dispatcher, "mutuazionecaratteristica") {
				Name = "Caratteristiche della mutuazione";
			EditTypes.Add("default");
            ListingTypes.Add("default");
            //$EditTypes$
        }

		//$PrymaryKey$

		public override void SetDefaults(DataTable PrimaryTable) {
			base.SetDefaults(PrimaryTable);
			switch (edit_type) {
				case "default": {
						SetDefault(PrimaryTable, "ct", DateTime.Now);
						SetDefault(PrimaryTable, "lt", DateTime.Now);
						SetDefault(PrimaryTable, "profess", "N");
						break;
					}
					//$SetDefault$
			}
		}

		public override DataRow Get_New_Row(DataRow ParentRow, DataTable T) {
			
			RowChange.MarkAsAutoincrement(T.Columns["idmutuazionecaratteristica"], null, null, 0);
			RowChange.setMinimumTempValue(T.Columns["idmutuazionecaratteristica"], 9990000);
			//$Get_New_Row$

			DataRow R = base.Get_New_Row(ParentRow, T);
			return R;
		}

		public override bool IsValid(DataRow R, out string errmess, out string errfield) {
			if (!base.IsValid(R, out errmess, out errfield)) return false;

			switch (edit_type) {
				case "default": {
						if (R["ct"].ToString().Trim() == "") {
							errmess = "Attenzione! Il campo 'Ct' è obbligatorio";
							errfield = "ct";
							return false;
						}
						if (R["cu"].ToString().Trim() == "") {
							errmess = "Attenzione! Il campo 'Cu' è obbligatorio";
							errfield = "cu";
							return false;
						}
						if (R["cu"].ToString().Trim().Length > 64) {
							errmess = "Attenzione! Il campo 'Cu' può essere al massimo di 64 caratteri";
							errfield = "cu";
							return false;
						}
						if (R["idattivform"].ToString().Trim() == "") {
							errmess = "Attenzione! Il campo 'Identificativo' è obbligatorio";
							errfield = "idattivform";
							return false;
						}
						if (R["idcanale"].ToString().Trim() == "") {
							errmess = "Attenzione! Il campo 'Identificativo' è obbligatorio";
							errfield = "idcanale";
							return false;
						}
						if (R["iddidprog"].ToString().Trim() == "") {
							errmess = "Attenzione! Il campo 'Identificativo' è obbligatorio";
							errfield = "iddidprog";
							return false;
						}
						if (R["iddidproganno"].ToString().Trim() == "") {
							errmess = "Attenzione! Il campo 'Identificativo' è obbligatorio";
							errfield = "iddidproganno";
							return false;
						}
						if (R["iddidprogcurr"].ToString().Trim() == "") {
							errmess = "Attenzione! Il campo 'Identificativo' è obbligatorio";
							errfield = "iddidprogcurr";
							return false;
						}
						if (R["iddidprogori"].ToString().Trim() == "") {
							errmess = "Attenzione! Il campo 'Identificativo' è obbligatorio";
							errfield = "iddidprogori";
							return false;
						}
						if (R["iddidprogporzanno"].ToString().Trim() == "") {
							errmess = "Attenzione! Il campo 'Identificativo' è obbligatorio";
							errfield = "iddidprogporzanno";
							return false;
						}
						if (R["idmutuazione"].ToString().Trim() == "") {
							errmess = "Attenzione! Il campo 'Identificativo' è obbligatorio";
							errfield = "idmutuazione";
							return false;
						}
						if (R["idmutuazionecaratteristica"].ToString().Trim() == "") {
							errmess = "Attenzione! Il campo 'Identificativo' è obbligatorio";
							errfield = "idmutuazionecaratteristica";
							return false;
						}
						if (R["lt"].ToString().Trim() == "") {
							errmess = "Attenzione! Il campo 'Lt' è obbligatorio";
							errfield = "lt";
							return false;
						}
						if (R["lu"].ToString().Trim() == "") {
							errmess = "Attenzione! Il campo 'Lu' è obbligatorio";
							errfield = "lu";
							return false;
						}
						if (R["lu"].ToString().Trim().Length > 64) {
							errmess = "Attenzione! Il campo 'Lu' può essere al massimo di 64 caratteri";
							errfield = "lu";
							return false;
						}
						if (R["profess"].ToString().Trim() == "") {
							errmess = "Attenzione! Il campo 'Professionalizzante' è obbligatorio";
							errfield = "profess";
							return false;
						}
						if (R["subambito"].ToString().Trim().Length > 50) {
							errmess = "Attenzione! Il campo 'Sotto-ambito' può essere al massimo di 50 caratteri";
							errfield = "subambito";
							return false;
						}
						break;
					}
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
				case "default": {
						DescribeAColumn(T, "cf", "Crediti", nPos++);
						DescribeAColumn(T, "!idambitoareadisc_ambitoareadisc_title", "Ambito o area disciplinare", nPos++);
						DescribeAColumn(T, "!idsasd_sasd_title", "SASD", nPos++);
						DescribeAColumn(T, "!idtipoattform_tipoattform_title", "Tipo di attività formativa", nPos++);
						DescribeAColumn(T, "!idtipoattform_tipoattform_description", "Tipo di attività formativa", nPos++);
						DescribeAColumn(T, "profess", "Professionalizzante", nPos++);
						DescribeAColumn(T, "subambito", "Sotto-ambito", nPos++);
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