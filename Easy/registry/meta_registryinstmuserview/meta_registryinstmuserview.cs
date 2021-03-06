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

﻿using System;
using System.Data;
using metadatalibrary;
using metaeasylibrary;
//$CustomUsing$


namespace meta_registryinstmuserview
{
    public class Meta_registryinstmuserview : Meta_easydata 
	{
        public Meta_registryinstmuserview(DataAccess Conn, MetaDataDispatcher Dispatcher) :
            base(Conn, Dispatcher, "registryinstmuserview") {
				Name = "Pagina di registrazione";
			EditTypes.Add("instmuser");
			ListingTypes.Add("instmuser");
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
				case "instmuser": {
						DescribeAColumn(T, "title", "Denominazione", nPos++);
						DescribeAColumn(T, "registry_cf", "Codice fiscale", nPos++);
						DescribeAColumn(T, "registry_p_iva", "Partita iva", nPos++);
						DescribeAColumn(T, "registry_active", "attivo", nPos++);
						DescribeAColumn(T, "instmqualifies_title", "Qualifica", nPos++);
						DescribeAColumn(T, "instmresearchunit_title", "Unità di Ricerca", nPos++);
						DescribeAColumn(T, "instmseztematichekind_title", "Sezione tematica prescelta", nPos++);
						DescribeAColumn(T, "instmseztematichekind_description", "Sezione tematica prescelta", nPos++);
						DescribeAColumn(T, "instmseztematichekind_2_title", "Seconda sezione tematica prescelta", nPos++);
						DescribeAColumn(T, "instmseztematichekind_2_description", "Seconda sezione tematica prescelta", nPos++);
						DescribeAColumn(T, "instmusercategorykind_title", "Categoria di afferenza", nPos++);
						DescribeAColumn(T, "instmusercategorykind_description", "Categoria di afferenza", nPos++);
						DescribeAColumn(T, "locationsorting_idsor", "Dipartimento", nPos++);
						DescribeAColumn(T, "locationsorting_idlocation", "Dipartimento", nPos++);
						DescribeAColumn(T, "registry_istituto_title", "Università Consorziata a INSTM o Ente accademico collegato", nPos++);
						DescribeAColumn(T, "sasd_title", "Settore Disciplinare", nPos++);
						DescribeAColumn(T, "registry_instmuser_interest", "Interessi di Ricerca", nPos++);
						DescribeAColumn(T, "registry_instmuser_newsletter", "Autorizzo l’invio della Newsletter istituzionale", nPos++);
						DescribeAColumn(T, "registry_instmuser_otherbelonging", "Eventuale afferenza ad altri Consorzi (specificare quale/i, uno per riga):", nPos++);
						DescribeAColumn(T, "registry_instmuser_privacy", "Presa visione dell’informativa e consenso al trattamento dei dati", nPos++);
						DescribeAColumn(T, "registry_instmuser_regulationaccept", "Do il consenso", nPos++);
						DescribeAColumn(T, "registry_instmuser_termoffice", "Data di Scadenza Incarico ", nPos++);
						T.Columns["registry_instmuser_termoffice"].ExtendedProperties["format"] = "g";
						break;
					}
					//$DescribeAColumn$
			}
		}

		public override string GetSorting(string ListingType) {

			switch (ListingType) {
				case "instmuser": {
						return "instmqualifies_title desc, instmresearchunit_title desc, instmseztematichekind_title desc, instmseztematichekind_2_title desc, instmusercategorykind_title desc";
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