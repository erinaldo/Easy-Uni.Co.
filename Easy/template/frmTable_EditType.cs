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
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
using metadatalibrary;

namespace Table_EditType {
    public partial class frmTable_EditType : Form {
        MetaData Meta;
        DataAccess Conn;
        CQueryHelper QHC = new CQueryHelper();
        QueryHelper QHS;
        MetaDataDispatcher Dispatcher;
        public frmTable_EditType() {
            InitializeComponent();
        }
        public void MetaData_AfterLink() {
            Meta = MetaData.GetMetaData(this);
            Dispatcher = Meta.Dispatcher;
            Conn = Meta.Conn;
            QHS = Conn.GetQueryHelper();
            //bool isAdmin = (bool)Meta.GetSys("IsSystemAdmin");


        }

        //public void MetaData_AfterActivation() { }
        //public void MetaData_AfterClear() {}
        //public void MetaData_BeforeFill() {}
        //public void MetaData_AfterFill() {}
        //public void MetaData_AfterRowSelect(DataTable T, DataRow R) {
        //public void MetaData_BeforePost() { }
        //public void MetaData_AfterPost() { }

    }
}
}
