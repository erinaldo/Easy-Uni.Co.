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

//------------------------------------------------------------------------------
// <autogenerated>
//     This code was generated by a tool.
//     Runtime Version: 1.0.3705.288
//
//     Changes to this file may cause incorrect behavior and will be lost if 
//     the code is regenerated.
// </autogenerated>
//------------------------------------------------------------------------------

namespace columntypes{//columntypes//
    using System;
    using System.Data;
    using System.Xml;
    using System.Runtime.Serialization;
    
    
    [Serializable()]
    [System.ComponentModel.DesignerCategoryAttribute("code")]
    [System.Diagnostics.DebuggerStepThrough()]
    [System.ComponentModel.ToolboxItem(true)]
    public class vistaForm : DataSet {
        
        private columntypesDataTable tablecolumntypes;
        
        public vistaForm() {
            this.InitClass();
            System.ComponentModel.CollectionChangeEventHandler schemaChangedHandler = new System.ComponentModel.CollectionChangeEventHandler(this.SchemaChanged);
            this.Tables.CollectionChanged += schemaChangedHandler;
            this.Relations.CollectionChanged += schemaChangedHandler;
        }
        
        protected vistaForm(SerializationInfo info, StreamingContext context) {
            string strSchema = ((string)(info.GetValue("XmlSchema", typeof(string))));
            if ((strSchema != null)) {
                DataSet ds = new DataSet();
                ds.ReadXmlSchema(new XmlTextReader(new System.IO.StringReader(strSchema)));
                if ((ds.Tables["columntypes"] != null)) {
                    this.Tables.Add(new columntypesDataTable(ds.Tables["columntypes"]));
                }
                this.DataSetName = ds.DataSetName;
                this.Prefix = ds.Prefix;
                this.Namespace = ds.Namespace;
                this.Locale = ds.Locale;
                this.CaseSensitive = ds.CaseSensitive;
                this.EnforceConstraints = ds.EnforceConstraints;
                this.Merge(ds, false, System.Data.MissingSchemaAction.Add);
                this.InitVars();
            }
            else {
                this.InitClass();
            }
            this.GetSerializationData(info, context);
            System.ComponentModel.CollectionChangeEventHandler schemaChangedHandler = new System.ComponentModel.CollectionChangeEventHandler(this.SchemaChanged);
            this.Tables.CollectionChanged += schemaChangedHandler;
            this.Relations.CollectionChanged += schemaChangedHandler;
        }
        
        [System.ComponentModel.Browsable(false)]
        [System.ComponentModel.DesignerSerializationVisibilityAttribute(System.ComponentModel.DesignerSerializationVisibility.Content)]
        public columntypesDataTable columntypes {
            get {
                return this.tablecolumntypes;
            }
        }
        
        public override DataSet Clone() {
            vistaForm cln = ((vistaForm)(base.Clone()));
            cln.InitVars();
            return cln;
        }
        
        protected override bool ShouldSerializeTables() {
            return false;
        }
        
        protected override bool ShouldSerializeRelations() {
            return false;
        }
        
        protected override void ReadXmlSerializable(XmlReader reader) {
            this.Reset();
            DataSet ds = new DataSet();
            ds.ReadXml(reader);
            if ((ds.Tables["columntypes"] != null)) {
                this.Tables.Add(new columntypesDataTable(ds.Tables["columntypes"]));
            }
            this.DataSetName = ds.DataSetName;
            this.Prefix = ds.Prefix;
            this.Namespace = ds.Namespace;
            this.Locale = ds.Locale;
            this.CaseSensitive = ds.CaseSensitive;
            this.EnforceConstraints = ds.EnforceConstraints;
            this.Merge(ds, false, System.Data.MissingSchemaAction.Add);
            this.InitVars();
        }
        
        protected override System.Xml.Schema.XmlSchema GetSchemaSerializable() {
            System.IO.MemoryStream stream = new System.IO.MemoryStream();
            this.WriteXmlSchema(new XmlTextWriter(stream, null));
            stream.Position = 0;
            return System.Xml.Schema.XmlSchema.Read(new XmlTextReader(stream), null);
        }
        
        internal void InitVars() {
            this.tablecolumntypes = ((columntypesDataTable)(this.Tables["columntypes"]));
            if ((this.tablecolumntypes != null)) {
                this.tablecolumntypes.InitVars();
            }
        }
        
        private void InitClass() {
            this.DataSetName = "vistaForm";
            this.Prefix = "";
            this.Namespace = "http://tempuri.org/vistaForm.xsd";
            this.Locale = new System.Globalization.CultureInfo("en-US");
            this.CaseSensitive = false;
            this.EnforceConstraints = true;
            this.tablecolumntypes = new columntypesDataTable();
            this.Tables.Add(this.tablecolumntypes);
        }
        
        private bool ShouldSerializecolumntypes() {
            return false;
        }
        
        private void SchemaChanged(object sender, System.ComponentModel.CollectionChangeEventArgs e) {
            if ((e.Action == System.ComponentModel.CollectionChangeAction.Remove)) {
                this.InitVars();
            }
        }
        
        public delegate void columntypesRowChangeEventHandler(object sender, columntypesRowChangeEvent e);
        
        [System.Diagnostics.DebuggerStepThrough()]
        public class columntypesDataTable : DataTable, System.Collections.IEnumerable {
            
            private DataColumn columntablename;
            
            private DataColumn columnfield;
            
            private DataColumn columniskey;
            
            private DataColumn columnsqltype;
            
            private DataColumn columncol_len;
            
            private DataColumn columncol_precision;
            
            private DataColumn columncol_scale;
            
            private DataColumn columnsystemtype;
            
            private DataColumn columnsqldeclaration;
            
            private DataColumn columnallownull;
            
            private DataColumn columndefaultvalue;
            
            private DataColumn columnformat;
            
            private DataColumn columndenynull;
            
            private DataColumn columnlastmodtimestamp;
            
            private DataColumn columnlastmoduser;
            
            internal columntypesDataTable() : 
                    base("columntypes") {
                this.InitClass();
            }
            
            internal columntypesDataTable(DataTable table) : 
                    base(table.TableName) {
                if ((table.CaseSensitive != table.DataSet.CaseSensitive)) {
                    this.CaseSensitive = table.CaseSensitive;
                }
                if ((table.Locale.ToString() != table.DataSet.Locale.ToString())) {
                    this.Locale = table.Locale;
                }
                if ((table.Namespace != table.DataSet.Namespace)) {
                    this.Namespace = table.Namespace;
                }
                this.Prefix = table.Prefix;
                this.MinimumCapacity = table.MinimumCapacity;
                this.DisplayExpression = table.DisplayExpression;
            }
            
            [System.ComponentModel.Browsable(false)]
            public int Count {
                get {
                    return this.Rows.Count;
                }
            }
            
            internal DataColumn tablenameColumn {
                get {
                    return this.columntablename;
                }
            }
            
            internal DataColumn fieldColumn {
                get {
                    return this.columnfield;
                }
            }
            
            internal DataColumn iskeyColumn {
                get {
                    return this.columniskey;
                }
            }
            
            internal DataColumn sqltypeColumn {
                get {
                    return this.columnsqltype;
                }
            }
            
            internal DataColumn col_lenColumn {
                get {
                    return this.columncol_len;
                }
            }
            
            internal DataColumn col_precisionColumn {
                get {
                    return this.columncol_precision;
                }
            }
            
            internal DataColumn col_scaleColumn {
                get {
                    return this.columncol_scale;
                }
            }
            
            internal DataColumn systemtypeColumn {
                get {
                    return this.columnsystemtype;
                }
            }
            
            internal DataColumn sqldeclarationColumn {
                get {
                    return this.columnsqldeclaration;
                }
            }
            
            internal DataColumn allownullColumn {
                get {
                    return this.columnallownull;
                }
            }
            
            internal DataColumn defaultvalueColumn {
                get {
                    return this.columndefaultvalue;
                }
            }
            
            internal DataColumn formatColumn {
                get {
                    return this.columnformat;
                }
            }
            
            internal DataColumn denynullColumn {
                get {
                    return this.columndenynull;
                }
            }
            
            internal DataColumn lastmodtimestampColumn {
                get {
                    return this.columnlastmodtimestamp;
                }
            }
            
            internal DataColumn lastmoduserColumn {
                get {
                    return this.columnlastmoduser;
                }
            }
            
            public columntypesRow this[int index] {
                get {
                    return ((columntypesRow)(this.Rows[index]));
                }
            }
            
            public event columntypesRowChangeEventHandler columntypesRowChanged;
            
            public event columntypesRowChangeEventHandler columntypesRowChanging;
            
            public event columntypesRowChangeEventHandler columntypesRowDeleted;
            
            public event columntypesRowChangeEventHandler columntypesRowDeleting;
            
            public void AddcolumntypesRow(columntypesRow row) {
                this.Rows.Add(row);
            }
            
            public columntypesRow AddcolumntypesRow(string tablename, string field, string iskey, string sqltype, int col_len, int col_precision, int col_scale, string systemtype, string sqldeclaration, string allownull, string defaultvalue, string format, string denynull, System.DateTime lastmodtimestamp, string lastmoduser) {
                columntypesRow rowcolumntypesRow = ((columntypesRow)(this.NewRow()));
                rowcolumntypesRow.ItemArray = new object[] {
                        tablename,
                        field,
                        iskey,
                        sqltype,
                        col_len,
                        col_precision,
                        col_scale,
                        systemtype,
                        sqldeclaration,
                        allownull,
                        defaultvalue,
                        format,
                        denynull,
                        lastmodtimestamp,
                        lastmoduser};
                this.Rows.Add(rowcolumntypesRow);
                return rowcolumntypesRow;
            }
            
            public columntypesRow FindBytablenamefield(string tablename, string field) {
                return ((columntypesRow)(this.Rows.Find(new object[] {
                            tablename,
                            field})));
            }
            
            public System.Collections.IEnumerator GetEnumerator() {
                return this.Rows.GetEnumerator();
            }
            
            public override DataTable Clone() {
                columntypesDataTable cln = ((columntypesDataTable)(base.Clone()));
                cln.InitVars();
                return cln;
            }
            
            protected override DataTable CreateInstance() {
                return new columntypesDataTable();
            }
            
            internal void InitVars() {
                this.columntablename = this.Columns["tablename"];
                this.columnfield = this.Columns["field"];
                this.columniskey = this.Columns["iskey"];
                this.columnsqltype = this.Columns["sqltype"];
                this.columncol_len = this.Columns["col_len"];
                this.columncol_precision = this.Columns["col_precision"];
                this.columncol_scale = this.Columns["col_scale"];
                this.columnsystemtype = this.Columns["systemtype"];
                this.columnsqldeclaration = this.Columns["sqldeclaration"];
                this.columnallownull = this.Columns["allownull"];
                this.columndefaultvalue = this.Columns["defaultvalue"];
                this.columnformat = this.Columns["format"];
                this.columndenynull = this.Columns["denynull"];
                this.columnlastmodtimestamp = this.Columns["lastmodtimestamp"];
                this.columnlastmoduser = this.Columns["lastmoduser"];
            }
            
            private void InitClass() {
                this.columntablename = new DataColumn("tablename", typeof(string), null, System.Data.MappingType.Element);
                this.Columns.Add(this.columntablename);
                this.columnfield = new DataColumn("field", typeof(string), null, System.Data.MappingType.Element);
                this.Columns.Add(this.columnfield);
                this.columniskey = new DataColumn("iskey", typeof(string), null, System.Data.MappingType.Element);
                this.Columns.Add(this.columniskey);
                this.columnsqltype = new DataColumn("sqltype", typeof(string), null, System.Data.MappingType.Element);
                this.Columns.Add(this.columnsqltype);
                this.columncol_len = new DataColumn("col_len", typeof(int), null, System.Data.MappingType.Element);
                this.Columns.Add(this.columncol_len);
                this.columncol_precision = new DataColumn("col_precision", typeof(int), null, System.Data.MappingType.Element);
                this.Columns.Add(this.columncol_precision);
                this.columncol_scale = new DataColumn("col_scale", typeof(int), null, System.Data.MappingType.Element);
                this.Columns.Add(this.columncol_scale);
                this.columnsystemtype = new DataColumn("systemtype", typeof(string), null, System.Data.MappingType.Element);
                this.Columns.Add(this.columnsystemtype);
                this.columnsqldeclaration = new DataColumn("sqldeclaration", typeof(string), null, System.Data.MappingType.Element);
                this.Columns.Add(this.columnsqldeclaration);
                this.columnallownull = new DataColumn("allownull", typeof(string), null, System.Data.MappingType.Element);
                this.Columns.Add(this.columnallownull);
                this.columndefaultvalue = new DataColumn("defaultvalue", typeof(string), null, System.Data.MappingType.Element);
                this.Columns.Add(this.columndefaultvalue);
                this.columnformat = new DataColumn("format", typeof(string), null, System.Data.MappingType.Element);
                this.Columns.Add(this.columnformat);
                this.columndenynull = new DataColumn("denynull", typeof(string), null, System.Data.MappingType.Element);
                this.Columns.Add(this.columndenynull);
                this.columnlastmodtimestamp = new DataColumn("lastmodtimestamp", typeof(System.DateTime), null, System.Data.MappingType.Element);
                this.Columns.Add(this.columnlastmodtimestamp);
                this.columnlastmoduser = new DataColumn("lastmoduser", typeof(string), null, System.Data.MappingType.Element);
                this.Columns.Add(this.columnlastmoduser);
                this.Constraints.Add(new UniqueConstraint("vistaFormKey1", new DataColumn[] {
                                this.columntablename,
                                this.columnfield}, true));
                this.columntablename.AllowDBNull = false;
                this.columnfield.AllowDBNull = false;
                this.columniskey.AllowDBNull = false;
                this.columnsqltype.AllowDBNull = false;
                this.columnsqldeclaration.AllowDBNull = false;
                this.columnallownull.AllowDBNull = false;
                this.columndenynull.AllowDBNull = false;
            }
            
            public columntypesRow NewcolumntypesRow() {
                return ((columntypesRow)(this.NewRow()));
            }
            
            protected override DataRow NewRowFromBuilder(DataRowBuilder builder) {
                return new columntypesRow(builder);
            }
            
            protected override System.Type GetRowType() {
                return typeof(columntypesRow);
            }
            
            protected override void OnRowChanged(DataRowChangeEventArgs e) {
                base.OnRowChanged(e);
                if ((this.columntypesRowChanged != null)) {
                    this.columntypesRowChanged(this, new columntypesRowChangeEvent(((columntypesRow)(e.Row)), e.Action));
                }
            }
            
            protected override void OnRowChanging(DataRowChangeEventArgs e) {
                base.OnRowChanging(e);
                if ((this.columntypesRowChanging != null)) {
                    this.columntypesRowChanging(this, new columntypesRowChangeEvent(((columntypesRow)(e.Row)), e.Action));
                }
            }
            
            protected override void OnRowDeleted(DataRowChangeEventArgs e) {
                base.OnRowDeleted(e);
                if ((this.columntypesRowDeleted != null)) {
                    this.columntypesRowDeleted(this, new columntypesRowChangeEvent(((columntypesRow)(e.Row)), e.Action));
                }
            }
            
            protected override void OnRowDeleting(DataRowChangeEventArgs e) {
                base.OnRowDeleting(e);
                if ((this.columntypesRowDeleting != null)) {
                    this.columntypesRowDeleting(this, new columntypesRowChangeEvent(((columntypesRow)(e.Row)), e.Action));
                }
            }
            
            public void RemovecolumntypesRow(columntypesRow row) {
                this.Rows.Remove(row);
            }
        }
        
        [System.Diagnostics.DebuggerStepThrough()]
        public class columntypesRow : DataRow {
            
            private columntypesDataTable tablecolumntypes;
            
            internal columntypesRow(DataRowBuilder rb) : 
                    base(rb) {
                this.tablecolumntypes = ((columntypesDataTable)(this.Table));
            }
            
            public string tablename {
                get {
                    return ((string)(this[this.tablecolumntypes.tablenameColumn]));
                }
                set {
                    this[this.tablecolumntypes.tablenameColumn] = value;
                }
            }
            
            public string field {
                get {
                    return ((string)(this[this.tablecolumntypes.fieldColumn]));
                }
                set {
                    this[this.tablecolumntypes.fieldColumn] = value;
                }
            }
            
            public string iskey {
                get {
                    return ((string)(this[this.tablecolumntypes.iskeyColumn]));
                }
                set {
                    this[this.tablecolumntypes.iskeyColumn] = value;
                }
            }
            
            public string sqltype {
                get {
                    return ((string)(this[this.tablecolumntypes.sqltypeColumn]));
                }
                set {
                    this[this.tablecolumntypes.sqltypeColumn] = value;
                }
            }
            
            public int col_len {
                get {
                    try {
                        return ((int)(this[this.tablecolumntypes.col_lenColumn]));
                    }
                    catch (InvalidCastException e) {
                        throw new StrongTypingException("Cannot get value because it is DBNull.", e);
                    }
                }
                set {
                    this[this.tablecolumntypes.col_lenColumn] = value;
                }
            }
            
            public int col_precision {
                get {
                    try {
                        return ((int)(this[this.tablecolumntypes.col_precisionColumn]));
                    }
                    catch (InvalidCastException e) {
                        throw new StrongTypingException("Cannot get value because it is DBNull.", e);
                    }
                }
                set {
                    this[this.tablecolumntypes.col_precisionColumn] = value;
                }
            }
            
            public int col_scale {
                get {
                    try {
                        return ((int)(this[this.tablecolumntypes.col_scaleColumn]));
                    }
                    catch (InvalidCastException e) {
                        throw new StrongTypingException("Cannot get value because it is DBNull.", e);
                    }
                }
                set {
                    this[this.tablecolumntypes.col_scaleColumn] = value;
                }
            }
            
            public string systemtype {
                get {
                    try {
                        return ((string)(this[this.tablecolumntypes.systemtypeColumn]));
                    }
                    catch (InvalidCastException e) {
                        throw new StrongTypingException("Cannot get value because it is DBNull.", e);
                    }
                }
                set {
                    this[this.tablecolumntypes.systemtypeColumn] = value;
                }
            }
            
            public string sqldeclaration {
                get {
                    return ((string)(this[this.tablecolumntypes.sqldeclarationColumn]));
                }
                set {
                    this[this.tablecolumntypes.sqldeclarationColumn] = value;
                }
            }
            
            public string allownull {
                get {
                    return ((string)(this[this.tablecolumntypes.allownullColumn]));
                }
                set {
                    this[this.tablecolumntypes.allownullColumn] = value;
                }
            }
            
            public string defaultvalue {
                get {
                    try {
                        return ((string)(this[this.tablecolumntypes.defaultvalueColumn]));
                    }
                    catch (InvalidCastException e) {
                        throw new StrongTypingException("Cannot get value because it is DBNull.", e);
                    }
                }
                set {
                    this[this.tablecolumntypes.defaultvalueColumn] = value;
                }
            }
            
            public string format {
                get {
                    try {
                        return ((string)(this[this.tablecolumntypes.formatColumn]));
                    }
                    catch (InvalidCastException e) {
                        throw new StrongTypingException("Cannot get value because it is DBNull.", e);
                    }
                }
                set {
                    this[this.tablecolumntypes.formatColumn] = value;
                }
            }
            
            public string denynull {
                get {
                    return ((string)(this[this.tablecolumntypes.denynullColumn]));
                }
                set {
                    this[this.tablecolumntypes.denynullColumn] = value;
                }
            }
            
            public System.DateTime lastmodtimestamp {
                get {
                    try {
                        return ((System.DateTime)(this[this.tablecolumntypes.lastmodtimestampColumn]));
                    }
                    catch (InvalidCastException e) {
                        throw new StrongTypingException("Cannot get value because it is DBNull.", e);
                    }
                }
                set {
                    this[this.tablecolumntypes.lastmodtimestampColumn] = value;
                }
            }
            
            public string lastmoduser {
                get {
                    try {
                        return ((string)(this[this.tablecolumntypes.lastmoduserColumn]));
                    }
                    catch (InvalidCastException e) {
                        throw new StrongTypingException("Cannot get value because it is DBNull.", e);
                    }
                }
                set {
                    this[this.tablecolumntypes.lastmoduserColumn] = value;
                }
            }
            
            public bool Iscol_lenNull() {
                return this.IsNull(this.tablecolumntypes.col_lenColumn);
            }
            
            public void Setcol_lenNull() {
                this[this.tablecolumntypes.col_lenColumn] = System.Convert.DBNull;
            }
            
            public bool Iscol_precisionNull() {
                return this.IsNull(this.tablecolumntypes.col_precisionColumn);
            }
            
            public void Setcol_precisionNull() {
                this[this.tablecolumntypes.col_precisionColumn] = System.Convert.DBNull;
            }
            
            public bool Iscol_scaleNull() {
                return this.IsNull(this.tablecolumntypes.col_scaleColumn);
            }
            
            public void Setcol_scaleNull() {
                this[this.tablecolumntypes.col_scaleColumn] = System.Convert.DBNull;
            }
            
            public bool IssystemtypeNull() {
                return this.IsNull(this.tablecolumntypes.systemtypeColumn);
            }
            
            public void SetsystemtypeNull() {
                this[this.tablecolumntypes.systemtypeColumn] = System.Convert.DBNull;
            }
            
            public bool IsdefaultvalueNull() {
                return this.IsNull(this.tablecolumntypes.defaultvalueColumn);
            }
            
            public void SetdefaultvalueNull() {
                this[this.tablecolumntypes.defaultvalueColumn] = System.Convert.DBNull;
            }
            
            public bool IsformatNull() {
                return this.IsNull(this.tablecolumntypes.formatColumn);
            }
            
            public void SetformatNull() {
                this[this.tablecolumntypes.formatColumn] = System.Convert.DBNull;
            }
            
            public bool IslastmodtimestampNull() {
                return this.IsNull(this.tablecolumntypes.lastmodtimestampColumn);
            }
            
            public void SetlastmodtimestampNull() {
                this[this.tablecolumntypes.lastmodtimestampColumn] = System.Convert.DBNull;
            }
            
            public bool IslastmoduserNull() {
                return this.IsNull(this.tablecolumntypes.lastmoduserColumn);
            }
            
            public void SetlastmoduserNull() {
                this[this.tablecolumntypes.lastmoduserColumn] = System.Convert.DBNull;
            }
        }
        
        [System.Diagnostics.DebuggerStepThrough()]
        public class columntypesRowChangeEvent : EventArgs {
            
            private columntypesRow eventRow;
            
            private DataRowAction eventAction;
            
            public columntypesRowChangeEvent(columntypesRow row, DataRowAction action) {
                this.eventRow = row;
                this.eventAction = action;
            }
            
            public columntypesRow Row {
                get {
                    return this.eventRow;
                }
            }
            
            public DataRowAction Action {
                get {
                    return this.eventAction;
                }
            }
        }
    }
}
