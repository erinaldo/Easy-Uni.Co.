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
using System.Collections.Generic;
using System.Text;
using System.Data;
using System.Windows.Forms;
using metadatalibrary;
using metaeasylibrary;

namespace meta_csa_importver_partition_income{
    /// <summary>
    /// </summary>
    public class Meta_csa_importver_partition_income:Meta_easydata {
        public Meta_csa_importver_partition_income(DataAccess Conn, MetaDataDispatcher Dispatcher) :
            base(Conn, Dispatcher, "csa_importver_partition_income") {
            EditTypes.Add("detail");
            EditTypes.Add("elenco");
            ListingTypes.Add("default");
            ListingTypes.Add("elenco");
            ListingTypes.Add("ritenuta");
            ListingTypes.Add("contributo");
            ListingTypes.Add("recupero");
        }
        protected override Form GetForm(string FormName) {
            if (FormName == "detail") {
                Name = "Dettaglio";
                return MetaData.GetFormByDllName("csa_importver_partition_income_detail");
                }
            if (FormName == "elenco") {
                DefaultListType = "elenco";
                Name = "Movimenti Entrata Generati (Ripartizione Versamenti)";
                return MetaData.GetFormByDllName("csa_importver_partition_income_elenco");
            }
            return null;
            }

        public override void SetDefaults(DataTable T) {
            base.SetDefaults(T);
            }

        public override DataRow SelectOne(string ListingType, string filter, string searchtable, DataTable ToMerge) {
            if (ListingType == "elenco" || ListingType == "recupero" || ListingType == "ritenuta" || ListingType == "contributo") {
                return base.SelectOne(ListingType, filter, "csa_importver_partition_incomeview", ToMerge);
            }
            return base.SelectOne(ListingType, filter, searchtable, ToMerge);
            }

        public override void DescribeColumns(DataTable T, string ListingType) {
            base.DescribeColumns(T, ListingType);
            if (ListingType == "default") {
                foreach (DataColumn C in T.Columns) {
                    DescribeAColumn(T, C.ColumnName, "", -1);
                    }
                int nPos = 1;
                DescribeAColumn(T, "ndetail", "#", nPos++);
                DescribeAColumn(T, "amount", "Importo", nPos++);
                DescribeAColumn(T, "!phase", "Fase Mov. Fin.", "incomeview.phase", nPos++);
                DescribeAColumn(T, "!ymov", "Eserc. Mov. Fin.", "incomeview.ymov", nPos++);
                DescribeAColumn(T, "!nmov", "Num. Mov. Fin.", "incomeview.nmov", nPos++);
            }
            }

        }

    }

