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

namespace meta_paymentcommunicated//meta_pagamentotrasmessoview//
{
	/// <summary>
	/// Summary description for Class1.
	/// </summary>
	public class Meta_paymentcommunicated : Meta_easydata
	{
		public Meta_paymentcommunicated(DataAccess Conn, MetaDataDispatcher Dispatcher):
			base(Conn, Dispatcher, "paymentcommunicated")
		{
			Name= "Pagamento Trasmesso";
			ListingTypes.Add("default");
		}

		public override string GetNoRowFoundMessage(string listingtype)
		{
			return "Non sono stati trovati pagamenti il cui mandato sia stato trasmesso in banca";
		}

        string[] mykey = new string[] { "idexp" };
        public override string[] primaryKey() {
            return mykey;
        }

        public override void DescribeColumns(DataTable T, string ListingType) 
		{			
			base.DescribeColumns(T, ListingType);
			if (ListingType=="default")
			{
				foreach(DataColumn C in T.Columns) 
				{
					DescribeAColumn(T, C.ColumnName, "",-1);
				}
				DescribeAColumn(T, "idexp", "",-1);
				DescribeAColumn(T, "ymov", "Esercizio Movimento",1);
				DescribeAColumn(T, "nmov", "Num. Movimento",2);
				DescribeAColumn(T, "curramount", "Importo Corrente",3);
				DescribeAColumn(T, "amount", "Importo",4);
				DescribeAColumn(T, "npay", "Num. Mandato",5);
				DescribeAColumn(T, "printdate", "Data Stampa Mandato",6);
				DescribeAColumn(T, "npaymenttransmission", "Num. Distinta di Trasm.",7);
				DescribeAColumn(T, "competencydate", "Data Trasmissione Distinta",8);
			}
		}
	}
}
