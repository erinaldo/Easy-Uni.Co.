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


namespace meta_registryaziendeview
{
    public class Meta_registryaziendeview : Meta_easydata 
	{
        public Meta_registryaziendeview(DataAccess Conn, MetaDataDispatcher Dispatcher) :
            base(Conn, Dispatcher, "registryaziendeview") {
				Name = "Enti e Aziende";
			EditTypes.Add("aziende");
            ListingTypes.Add("aziende");
            //$EditTypes$
        }

		private string[] mykey = new string[] {"idreg"};

		public override string[] primaryKey() {
			return mykey;
		}

		//$SetDefault$

		public override DataRow Get_New_Row(DataRow ParentRow, DataTable T) {
			
			//$Get_New_Row$

			DataRow R = base.Get_New_Row(ParentRow, T);
			return R;
		}

		public override bool IsValid(DataRow R, out string errmess, out string errfield) {
			if (!base.IsValid(R, out errmess, out errfield)) return false;

									if (R.Table.Columns.Contains("active") && R["active"].ToString().Trim() == "") {
							errmess = "Attenzione! Il campo 'attivo' è obbligatorio";
							errfield = "active";
							return false;
						}
						if (R.Table.Columns.Contains("annotation") && R["annotation"].ToString().Trim().Length > 400) {
							errmess = "Attenzione! Il campo 'Annotazioni' può essere al massimo di 400 caratteri";
							errfield = "annotation";
							return false;
						}
						if (R.Table.Columns.Contains("ccp") && R["ccp"].ToString().Trim().Length > 12) {
							errmess = "Attenzione! Il campo 'Conto corrente postale di Riscossione' può essere al massimo di 12 caratteri";
							errfield = "ccp";
							return false;
						}
						if (R.Table.Columns.Contains("cf") && R["cf"].ToString().Trim().Length > 16) {
							errmess = "Attenzione! Il campo 'Codice fiscale' può essere al massimo di 16 caratteri";
							errfield = "cf";
							return false;
						}
						if (R.Table.Columns.Contains("foreigncf") && R["foreigncf"].ToString().Trim().Length > 40) {
							errmess = "Attenzione! Il campo 'Codice fiscale estero' può essere al massimo di 40 caratteri";
							errfield = "foreigncf";
							return false;
						}
						if (R.Table.Columns.Contains("idcategory") && R["idcategory"].ToString().Trim().Length > 2) {
							errmess = "Attenzione! Il campo 'ID Categoria (tabella category)' può essere al massimo di 2 caratteri";
							errfield = "idcategory";
							return false;
						}
						if (R.Table.Columns.Contains("idcentralizedcategory") && R["idcentralizedcategory"].ToString().Trim().Length > 20) {
							errmess = "Attenzione! Il campo 'ID Classificazione centralizzata anagrafica (tabella centralizedcategory)' può essere al massimo di 20 caratteri";
							errfield = "idcentralizedcategory";
							return false;
						}
						if (R.Table.Columns.Contains("idregistryclass") && R["idregistryclass"].ToString().Trim().Length > 2) {
							errmess = "Attenzione! Il campo 'ID Tipologie classificazione (tabella registryclass)' può essere al massimo di 2 caratteri";
							errfield = "idregistryclass";
							return false;
						}
						if (R.Table.Columns.Contains("ipa_fe") && R["ipa_fe"].ToString().Trim().Length > 7) {
							errmess = "Attenzione! Il campo 'Codice Univoco Ufficio di PCC o Codice Univoco Ufficio di IPA, prelevato dal sito www.indicepa.gov.it.' può essere al massimo di 7 caratteri";
							errfield = "ipa_fe";
							return false;
						}
						if (R.Table.Columns.Contains("location") && R["location"].ToString().Trim().Length > 50) {
							errmess = "Attenzione! Il campo 'ubicazione' può essere al massimo di 50 caratteri";
							errfield = "location";
							return false;
						}
						if (R.Table.Columns.Contains("p_iva") && R["p_iva"].ToString().Trim().Length > 15) {
							errmess = "Attenzione! Il campo 'Partita iva' può essere al massimo di 15 caratteri";
							errfield = "p_iva";
							return false;
						}
						if (R.Table.Columns.Contains("residence") && R["residence"].ToString().Trim() == "") {
							errmess = "Attenzione! Il campo 'Tipo residenza (chiave di tabella residence)' è obbligatorio";
							errfield = "residence";
							return false;
						}
						if (R.Table.Columns.Contains("title") && R["title"].ToString().Trim() == "") {
							errmess = "Attenzione! Il campo 'Denominazione' è obbligatorio";
							errfield = "title";
							return false;
						}
						if (R.Table.Columns.Contains("title") && R["title"].ToString().Trim().Length > 100) {
							errmess = "Attenzione! Il campo 'Denominazione' può essere al massimo di 100 caratteri";
							errfield = "title";
							return false;
						}
						if (R.Table.Columns.Contains("idnace") && R["idnace"].ToString().Trim().Length > 50) {
							errmess = "Attenzione! Il campo 'Codice NACE' può essere al massimo di 50 caratteri";
							errfield = "idnace";
							return false;
						}
						if (R.Table.Columns.Contains("title_en") && R["title_en"].ToString().Trim().Length > 150) {
							errmess = "Attenzione! Il campo 'Denominazione (ENG)' può essere al massimo di 150 caratteri";
							errfield = "title_en";
							return false;
						}
			//$IsValid$

			return true;
		}

		public override void DescribeColumns(DataTable T, string ListingType) {
			base.DescribeColumns(T, ListingType);

			foreach (DataColumn C in T.Columns) {
				DescribeAColumn(T, C.ColumnName, "", -1);
			}
			int nPos = 1;
					
			switch (ListingType) {
				case "aziende": {
						DescribeAColumn(T, "registryclass_description", "ID Tipologie classificazione (tabella registryclass)", nPos++);
						DescribeAColumn(T, "title", "Denominazione", nPos++);
						DescribeAColumn(T, "registry_cf", "Codice fiscale", nPos++);
						DescribeAColumn(T, "registry_p_iva", "Partita iva", nPos++);
						DescribeAColumn(T, "registry_active", "attivo", nPos++);
						DescribeAColumn(T, "ateco_title", "Classificazione Ateco", nPos++);
						DescribeAColumn(T, "nace_idnace", "Codice NACE", nPos++);
						DescribeAColumn(T, "naturagiur_title", "Natura Giuridica", nPos++);
						DescribeAColumn(T, "numerodip_title", "Numero di dipendenti", nPos++);
						DescribeAColumn(T, "registry_aziende_txt_en", "Txt_en", nPos++);
						break;
					}
				//$DescribeAColumn$
			}
		}

		public override string GetSorting(string ListingType) {

			switch (ListingType) {
				case "aziende": {
						return "ateco_title desc, naturagiur_title desc, numerodip_title desc";
					}
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