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

namespace meta_banktransactionview//meta_movimentobancarioview//
{
	/// <summary>
	/// Summary description for Class1.
	/// </summary>
    public class Meta_banktransactionview : Meta_easydata {
        public Meta_banktransactionview(DataAccess Conn, MetaDataDispatcher Dispatcher):
            base(Conn, Dispatcher, "banktransactionview") {		
            Name= "Movimento bancario - elenco";
			EditTypes.Add("estinzionemultipla");
			ListingTypes.Add("estinzionemultipla");
		}
		public override string GetStaticFilter(string ListingType) {
			if (ListingType=="default"){
				string filterEsercizio = "(yban='"+GetSys("esercizio")+"')";
				return filterEsercizio;
			}
			return base.GetStaticFilter (ListingType);
		}


        private string[] mykey = new string[] { "yban", "nban" };
        public override string[] primaryKey() {
            return mykey;
        }
        public override void DescribeColumns(DataTable T, string ListingType){
            base.DescribeColumns(T, ListingType);
			if (ListingType == "estinzionemultipla") 
			{
				foreach (DataColumn c in T.Columns) 
				{
					DescribeAColumn(T, c.ColumnName, "");
				}// da cambiare i nomi dei campi ma prima rivedere il form
				DescribeAColumn(T, "ydoc", "Esercizio");
				DescribeAColumn(T, "ndoc", "Numero documento");
				DescribeAColumn(T, "performed", "Flag esito");
				DescribeAColumn(T, "bankreference", "Riferimento banca");
				DescribeAColumn(T, "transactiondate", "Data operazione");
				DescribeAColumn(T, "valuedate", "Data valuta");
				DescribeAColumn(T, "amount", "Importo");
				DescribeAColumn(T, "performedamount", "Importo esitato");
				DescribeAColumn(T, "description", "Descrizione");
				DescribeAColumn(T, "registry", "Creditore/debitore");
			} 
			if (ListingType == "default") {
				foreach (DataColumn C in T.Columns) {
					DescribeAColumn(T,C.ColumnName,"",-1);
				}
				int nPos = 1;
				//DescribeAColumn(T,"yban","Eserc. Transazione", nPos++);
				DescribeAColumn(T,"nban","Progressivo", nPos++);
				DescribeAColumn(T,"transactiondate","Data Operazione", nPos++);
				DescribeAColumn(T,"valuedate","Data Valuta", nPos++);
				DescribeAColumn(T,"bankreference","Rif. Banca", nPos++);
				//DescribeAColumn(T,"amount","Importo", nPos++);
				DescribeAColumn(T,"income","Entrate", nPos++);
				DescribeAColumn(T,"expense","Uscite", nPos++);
				DescribeAColumn(T,"ypay","Eserc. Mandato", nPos++);
				DescribeAColumn(T,"npay","Num. Mandato", nPos++);
				DescribeAColumn(T,"ypro","Eserc. Reversale", nPos++);
				DescribeAColumn(T,"npro","Num. Reversale", nPos++);
                DescribeAColumn(T,"idbankimport", "Num. Importazione", nPos++);
            } 
        }   	
		protected override Form GetForm(string FormName)
		{
			if (FormName=="estinzionemultipla") 
			{
				ActAsList();
				StartEmpty = true;
				return GetFormByDllName("banktransactionview_estinzionemultipla");
			}
			return null;
		}
    }	
}
