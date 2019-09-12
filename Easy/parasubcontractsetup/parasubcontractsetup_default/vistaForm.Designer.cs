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

´╗┐//------------------------------------------------------------------------------
// <auto-generated>
//     This code was generated by a tool.
//     Runtime Version:2.0.50727.42
//
//     Changes to this file may cause incorrect behavior and will be lost if
//     the code is regenerated.
// </auto-generated>
//------------------------------------------------------------------------------

#pragma warning disable 1591

namespace parasubcontractsetup_default {
    using System;
    
    
    [System.CodeDom.Compiler.GeneratedCodeAttribute("System.Data.Design.TypedDataSetGenerator", "2.0.0.0")]
    [Serializable()]
    [System.ComponentModel.DesignerCategoryAttribute("code")]
    [System.ComponentModel.ToolboxItem(true)]
    [System.Xml.Serialization.XmlSchemaProviderAttribute("GetTypedDataSetSchema")]
    [System.Xml.Serialization.XmlRootAttribute("vistaForm")]
    [System.ComponentModel.Design.HelpKeywordAttribute("vs.data.DataSet")]
    public partial class vistaForm : System.Data.DataSet {
        
        private parasubcontractsetupDataTable tableparasubcontractsetup;
        
        private System.Data.SchemaSerializationMode _schemaSerializationMode = System.Data.SchemaSerializationMode.IncludeSchema;
        
        [System.Diagnostics.DebuggerNonUserCodeAttribute()]
        public vistaForm() {
            this.BeginInit();
            this.InitClass();
            System.ComponentModel.CollectionChangeEventHandler schemaChangedHandler = new System.ComponentModel.CollectionChangeEventHandler(this.SchemaChanged);
            base.Tables.CollectionChanged += schemaChangedHandler;
            base.Relations.CollectionChanged += schemaChangedHandler;
            this.EndInit();
        }
        
        [System.Diagnostics.DebuggerNonUserCodeAttribute()]
        protected vistaForm(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context) : 
                base(info, context, false) {
            if ((this.IsBinarySerialized(info, context) == true)) {
                this.InitVars(false);
                System.ComponentModel.CollectionChangeEventHandler schemaChangedHandler1 = new System.ComponentModel.CollectionChangeEventHandler(this.SchemaChanged);
                this.Tables.CollectionChanged += schemaChangedHandler1;
                this.Relations.CollectionChanged += schemaChangedHandler1;
                return;
            }
            string strSchema = ((string)(info.GetValue("XmlSchema", typeof(string))));
            if ((this.DetermineSchemaSerializationMode(info, context) == System.Data.SchemaSerializationMode.IncludeSchema)) {
                System.Data.DataSet ds = new System.Data.DataSet();
                ds.ReadXmlSchema(new System.Xml.XmlTextReader(new System.IO.StringReader(strSchema)));
                if ((ds.Tables["parasubcontractsetup"] != null)) {
                    base.Tables.Add(new parasubcontractsetupDataTable(ds.Tables["parasubcontractsetup"]));
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
                this.ReadXmlSchema(new System.Xml.XmlTextReader(new System.IO.StringReader(strSchema)));
            }
            this.GetSerializationData(info, context);
            System.ComponentModel.CollectionChangeEventHandler schemaChangedHandler = new System.ComponentModel.CollectionChangeEventHandler(this.SchemaChanged);
            base.Tables.CollectionChanged += schemaChangedHandler;
            this.Relations.CollectionChanged += schemaChangedHandler;
        }
        
        [System.Diagnostics.DebuggerNonUserCodeAttribute()]
        [System.ComponentModel.Browsable(false)]
        [System.ComponentModel.DesignerSerializationVisibility(System.ComponentModel.DesignerSerializationVisibility.Content)]
        public parasubcontractsetupDataTable parasubcontractsetup {
            get {
                return this.tableparasubcontractsetup;
            }
        }
        
        [System.Diagnostics.DebuggerNonUserCodeAttribute()]
        [System.ComponentModel.BrowsableAttribute(true)]
        [System.ComponentModel.DesignerSerializationVisibilityAttribute(System.ComponentModel.DesignerSerializationVisibility.Visible)]
        public override System.Data.SchemaSerializationMode SchemaSerializationMode {
            get {
                return this._schemaSerializationMode;
            }
            set {
                this._schemaSerializationMode = value;
            }
        }
        
        [System.Diagnostics.DebuggerNonUserCodeAttribute()]
        [System.ComponentModel.DesignerSerializationVisibilityAttribute(System.ComponentModel.DesignerSerializationVisibility.Hidden)]
        public new System.Data.DataTableCollection Tables {
            get {
                return base.Tables;
            }
        }
        
        [System.Diagnostics.DebuggerNonUserCodeAttribute()]
        [System.ComponentModel.DesignerSerializationVisibilityAttribute(System.ComponentModel.DesignerSerializationVisibility.Hidden)]
        public new System.Data.DataRelationCollection Relations {
            get {
                return base.Relations;
            }
        }
        
        [System.Diagnostics.DebuggerNonUserCodeAttribute()]
        protected override void InitializeDerivedDataSet() {
            this.BeginInit();
            this.InitClass();
            this.EndInit();
        }
        
        [System.Diagnostics.DebuggerNonUserCodeAttribute()]
        public override System.Data.DataSet Clone() {
            vistaForm cln = ((vistaForm)(base.Clone()));
            cln.InitVars();
            cln.SchemaSerializationMode = this.SchemaSerializationMode;
            return cln;
        }
        
        [System.Diagnostics.DebuggerNonUserCodeAttribute()]
        protected override bool ShouldSerializeTables() {
            return false;
        }
        
        [System.Diagnostics.DebuggerNonUserCodeAttribute()]
        protected override bool ShouldSerializeRelations() {
            return false;
        }
        
        [System.Diagnostics.DebuggerNonUserCodeAttribute()]
        protected override void ReadXmlSerializable(System.Xml.XmlReader reader) {
            if ((this.DetermineSchemaSerializationMode(reader) == System.Data.SchemaSerializationMode.IncludeSchema)) {
                this.Reset();
                System.Data.DataSet ds = new System.Data.DataSet();
                ds.ReadXml(reader);
                if ((ds.Tables["parasubcontractsetup"] != null)) {
                    base.Tables.Add(new parasubcontractsetupDataTable(ds.Tables["parasubcontractsetup"]));
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
                this.ReadXml(reader);
                this.InitVars();
            }
        }
        
        [System.Diagnostics.DebuggerNonUserCodeAttribute()]
        protected override System.Xml.Schema.XmlSchema GetSchemaSerializable() {
            System.IO.MemoryStream stream = new System.IO.MemoryStream();
            this.WriteXmlSchema(new System.Xml.XmlTextWriter(stream, null));
            stream.Position = 0;
            return System.Xml.Schema.XmlSchema.Read(new System.Xml.XmlTextReader(stream), null);
        }
        
        [System.Diagnostics.DebuggerNonUserCodeAttribute()]
        internal void InitVars() {
            this.InitVars(true);
        }
        
        [System.Diagnostics.DebuggerNonUserCodeAttribute()]
        internal void InitVars(bool initTable) {
            this.tableparasubcontractsetup = ((parasubcontractsetupDataTable)(base.Tables["parasubcontractsetup"]));
            if ((initTable == true)) {
                if ((this.tableparasubcontractsetup != null)) {
                    this.tableparasubcontractsetup.InitVars();
                }
            }
        }
        
        [System.Diagnostics.DebuggerNonUserCodeAttribute()]
        private void InitClass() {
            this.DataSetName = "vistaForm";
            this.Prefix = "";
            this.Namespace = "http://tempuri.org/VistaPersContratto.xsd";
            this.EnforceConstraints = true;
            this.SchemaSerializationMode = System.Data.SchemaSerializationMode.IncludeSchema;
            this.tableparasubcontractsetup = new parasubcontractsetupDataTable();
            base.Tables.Add(this.tableparasubcontractsetup);
        }
        
        [System.Diagnostics.DebuggerNonUserCodeAttribute()]
        private bool ShouldSerializeparasubcontractsetup() {
            return false;
        }
        
        [System.Diagnostics.DebuggerNonUserCodeAttribute()]
        private void SchemaChanged(object sender, System.ComponentModel.CollectionChangeEventArgs e) {
            if ((e.Action == System.ComponentModel.CollectionChangeAction.Remove)) {
                this.InitVars();
            }
        }
        
        [System.Diagnostics.DebuggerNonUserCodeAttribute()]
        public static System.Xml.Schema.XmlSchemaComplexType GetTypedDataSetSchema(System.Xml.Schema.XmlSchemaSet xs) {
            vistaForm ds = new vistaForm();
            System.Xml.Schema.XmlSchemaComplexType type = new System.Xml.Schema.XmlSchemaComplexType();
            System.Xml.Schema.XmlSchemaSequence sequence = new System.Xml.Schema.XmlSchemaSequence();
            xs.Add(ds.GetSchemaSerializable());
            System.Xml.Schema.XmlSchemaAny any = new System.Xml.Schema.XmlSchemaAny();
            any.Namespace = ds.Namespace;
            sequence.Items.Add(any);
            type.Particle = sequence;
            return type;
        }
        
        public delegate void parasubcontractsetupRowChangeEventHandler(object sender, parasubcontractsetupRowChangeEvent e);
        
        [System.CodeDom.Compiler.GeneratedCodeAttribute("System.Data.Design.TypedDataSetGenerator", "2.0.0.0")]
        [System.Serializable()]
        [System.Xml.Serialization.XmlSchemaProviderAttribute("GetTypedTableSchema")]
        public partial class parasubcontractsetupDataTable : System.Data.DataTable, System.Collections.IEnumerable {
            
            private System.Data.DataColumn columnayear;
            
            private System.Data.DataColumn columnnumerationkind;
            
            private System.Data.DataColumn columncu;
            
            private System.Data.DataColumn columnct;
            
            private System.Data.DataColumn columnlu;
            
            private System.Data.DataColumn columnlt;
            
            [System.Diagnostics.DebuggerNonUserCodeAttribute()]
            public parasubcontractsetupDataTable() {
                this.TableName = "parasubcontractsetup";
                this.BeginInit();
                this.InitClass();
                this.EndInit();
            }
            
            [System.Diagnostics.DebuggerNonUserCodeAttribute()]
            internal parasubcontractsetupDataTable(System.Data.DataTable table) {
                this.TableName = table.TableName;
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
            }
            
            [System.Diagnostics.DebuggerNonUserCodeAttribute()]
            protected parasubcontractsetupDataTable(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context) : 
                    base(info, context) {
                this.InitVars();
            }
            
            [System.Diagnostics.DebuggerNonUserCodeAttribute()]
            public System.Data.DataColumn ayearColumn {
                get {
                    return this.columnayear;
                }
            }
            
            [System.Diagnostics.DebuggerNonUserCodeAttribute()]
            public System.Data.DataColumn numerationkindColumn {
                get {
                    return this.columnnumerationkind;
                }
            }
            
            [System.Diagnostics.DebuggerNonUserCodeAttribute()]
            public System.Data.DataColumn cuColumn {
                get {
                    return this.columncu;
                }
            }
            
            [System.Diagnostics.DebuggerNonUserCodeAttribute()]
            public System.Data.DataColumn ctColumn {
                get {
                    return this.columnct;
                }
            }
            
            [System.Diagnostics.DebuggerNonUserCodeAttribute()]
            public System.Data.DataColumn luColumn {
                get {
                    return this.columnlu;
                }
            }
            
            [System.Diagnostics.DebuggerNonUserCodeAttribute()]
            public System.Data.DataColumn ltColumn {
                get {
                    return this.columnlt;
                }
            }
            
            [System.Diagnostics.DebuggerNonUserCodeAttribute()]
            [System.ComponentModel.Browsable(false)]
            public int Count {
                get {
                    return this.Rows.Count;
                }
            }
            
            [System.Diagnostics.DebuggerNonUserCodeAttribute()]
            public parasubcontractsetupRow this[int index] {
                get {
                    return ((parasubcontractsetupRow)(this.Rows[index]));
                }
            }
            
            public event parasubcontractsetupRowChangeEventHandler parasubcontractsetupRowChanging;
            
            public event parasubcontractsetupRowChangeEventHandler parasubcontractsetupRowChanged;
            
            public event parasubcontractsetupRowChangeEventHandler parasubcontractsetupRowDeleting;
            
            public event parasubcontractsetupRowChangeEventHandler parasubcontractsetupRowDeleted;
            
            [System.Diagnostics.DebuggerNonUserCodeAttribute()]
            public void AddparasubcontractsetupRow(parasubcontractsetupRow row) {
                this.Rows.Add(row);
            }
            
            [System.Diagnostics.DebuggerNonUserCodeAttribute()]
            public parasubcontractsetupRow AddparasubcontractsetupRow(int ayear, string numerationkind, string cu, System.DateTime ct, string lu, System.DateTime lt) {
                parasubcontractsetupRow rowparasubcontractsetupRow = ((parasubcontractsetupRow)(this.NewRow()));
                rowparasubcontractsetupRow.ItemArray = new object[] {
                        ayear,
                        numerationkind,
                        cu,
                        ct,
                        lu,
                        lt};
                this.Rows.Add(rowparasubcontractsetupRow);
                return rowparasubcontractsetupRow;
            }
            
            [System.Diagnostics.DebuggerNonUserCodeAttribute()]
            public parasubcontractsetupRow FindByayear(int ayear) {
                return ((parasubcontractsetupRow)(this.Rows.Find(new object[] {
                            ayear})));
            }
            
            [System.Diagnostics.DebuggerNonUserCodeAttribute()]
            public virtual System.Collections.IEnumerator GetEnumerator() {
                return this.Rows.GetEnumerator();
            }
            
            [System.Diagnostics.DebuggerNonUserCodeAttribute()]
            public override System.Data.DataTable Clone() {
                parasubcontractsetupDataTable cln = ((parasubcontractsetupDataTable)(base.Clone()));
                cln.InitVars();
                return cln;
            }
            
            [System.Diagnostics.DebuggerNonUserCodeAttribute()]
            protected override System.Data.DataTable CreateInstance() {
                return new parasubcontractsetupDataTable();
            }
            
            [System.Diagnostics.DebuggerNonUserCodeAttribute()]
            internal void InitVars() {
                this.columnayear = base.Columns["ayear"];
                this.columnnumerationkind = base.Columns["numerationkind"];
                this.columncu = base.Columns["cu"];
                this.columnct = base.Columns["ct"];
                this.columnlu = base.Columns["lu"];
                this.columnlt = base.Columns["lt"];
            }
            
            [System.Diagnostics.DebuggerNonUserCodeAttribute()]
            private void InitClass() {
                this.columnayear = new System.Data.DataColumn("ayear", typeof(int), null, System.Data.MappingType.Element);
                base.Columns.Add(this.columnayear);
                this.columnnumerationkind = new System.Data.DataColumn("numerationkind", typeof(string), null, System.Data.MappingType.Element);
                base.Columns.Add(this.columnnumerationkind);
                this.columncu = new System.Data.DataColumn("cu", typeof(string), null, System.Data.MappingType.Element);
                base.Columns.Add(this.columncu);
                this.columnct = new System.Data.DataColumn("ct", typeof(System.DateTime), null, System.Data.MappingType.Element);
                base.Columns.Add(this.columnct);
                this.columnlu = new System.Data.DataColumn("lu", typeof(string), null, System.Data.MappingType.Element);
                base.Columns.Add(this.columnlu);
                this.columnlt = new System.Data.DataColumn("lt", typeof(System.DateTime), null, System.Data.MappingType.Element);
                base.Columns.Add(this.columnlt);
                this.Constraints.Add(new System.Data.UniqueConstraint("vistaFormKey1", new System.Data.DataColumn[] {
                                this.columnayear}, true));
                this.columnayear.AllowDBNull = false;
                this.columnayear.Unique = true;
            }
            
            [System.Diagnostics.DebuggerNonUserCodeAttribute()]
            public parasubcontractsetupRow NewparasubcontractsetupRow() {
                return ((parasubcontractsetupRow)(this.NewRow()));
            }
            
            [System.Diagnostics.DebuggerNonUserCodeAttribute()]
            protected override System.Data.DataRow NewRowFromBuilder(System.Data.DataRowBuilder builder) {
                return new parasubcontractsetupRow(builder);
            }
            
            [System.Diagnostics.DebuggerNonUserCodeAttribute()]
            protected override System.Type GetRowType() {
                return typeof(parasubcontractsetupRow);
            }
            
            [System.Diagnostics.DebuggerNonUserCodeAttribute()]
            protected override void OnRowChanged(System.Data.DataRowChangeEventArgs e) {
                base.OnRowChanged(e);
                if ((this.parasubcontractsetupRowChanged != null)) {
                    this.parasubcontractsetupRowChanged(this, new parasubcontractsetupRowChangeEvent(((parasubcontractsetupRow)(e.Row)), e.Action));
                }
            }
            
            [System.Diagnostics.DebuggerNonUserCodeAttribute()]
            protected override void OnRowChanging(System.Data.DataRowChangeEventArgs e) {
                base.OnRowChanging(e);
                if ((this.parasubcontractsetupRowChanging != null)) {
                    this.parasubcontractsetupRowChanging(this, new parasubcontractsetupRowChangeEvent(((parasubcontractsetupRow)(e.Row)), e.Action));
                }
            }
            
            [System.Diagnostics.DebuggerNonUserCodeAttribute()]
            protected override void OnRowDeleted(System.Data.DataRowChangeEventArgs e) {
                base.OnRowDeleted(e);
                if ((this.parasubcontractsetupRowDeleted != null)) {
                    this.parasubcontractsetupRowDeleted(this, new parasubcontractsetupRowChangeEvent(((parasubcontractsetupRow)(e.Row)), e.Action));
                }
            }
            
            [System.Diagnostics.DebuggerNonUserCodeAttribute()]
            protected override void OnRowDeleting(System.Data.DataRowChangeEventArgs e) {
                base.OnRowDeleting(e);
                if ((this.parasubcontractsetupRowDeleting != null)) {
                    this.parasubcontractsetupRowDeleting(this, new parasubcontractsetupRowChangeEvent(((parasubcontractsetupRow)(e.Row)), e.Action));
                }
            }
            
            [System.Diagnostics.DebuggerNonUserCodeAttribute()]
            public void RemoveparasubcontractsetupRow(parasubcontractsetupRow row) {
                this.Rows.Remove(row);
            }
            
            [System.Diagnostics.DebuggerNonUserCodeAttribute()]
            public static System.Xml.Schema.XmlSchemaComplexType GetTypedTableSchema(System.Xml.Schema.XmlSchemaSet xs) {
                System.Xml.Schema.XmlSchemaComplexType type = new System.Xml.Schema.XmlSchemaComplexType();
                System.Xml.Schema.XmlSchemaSequence sequence = new System.Xml.Schema.XmlSchemaSequence();
                vistaForm ds = new vistaForm();
                xs.Add(ds.GetSchemaSerializable());
                System.Xml.Schema.XmlSchemaAny any1 = new System.Xml.Schema.XmlSchemaAny();
                any1.Namespace = "http://www.w3.org/2001/XMLSchema";
                any1.MinOccurs = new decimal(0);
                any1.MaxOccurs = decimal.MaxValue;
                any1.ProcessContents = System.Xml.Schema.XmlSchemaContentProcessing.Lax;
                sequence.Items.Add(any1);
                System.Xml.Schema.XmlSchemaAny any2 = new System.Xml.Schema.XmlSchemaAny();
                any2.Namespace = "urn:schemas-microsoft-com:xml-diffgram-v1";
                any2.MinOccurs = new decimal(1);
                any2.ProcessContents = System.Xml.Schema.XmlSchemaContentProcessing.Lax;
                sequence.Items.Add(any2);
                System.Xml.Schema.XmlSchemaAttribute attribute1 = new System.Xml.Schema.XmlSchemaAttribute();
                attribute1.Name = "namespace";
                attribute1.FixedValue = ds.Namespace;
                type.Attributes.Add(attribute1);
                System.Xml.Schema.XmlSchemaAttribute attribute2 = new System.Xml.Schema.XmlSchemaAttribute();
                attribute2.Name = "tableTypeName";
                attribute2.FixedValue = "parasubcontractsetupDataTable";
                type.Attributes.Add(attribute2);
                type.Particle = sequence;
                return type;
            }
        }
        
        [System.CodeDom.Compiler.GeneratedCodeAttribute("System.Data.Design.TypedDataSetGenerator", "2.0.0.0")]
        public partial class parasubcontractsetupRow : System.Data.DataRow {
            
            private parasubcontractsetupDataTable tableparasubcontractsetup;
            
            [System.Diagnostics.DebuggerNonUserCodeAttribute()]
            internal parasubcontractsetupRow(System.Data.DataRowBuilder rb) : 
                    base(rb) {
                this.tableparasubcontractsetup = ((parasubcontractsetupDataTable)(this.Table));
            }
            
            [System.Diagnostics.DebuggerNonUserCodeAttribute()]
            public int ayear {
                get {
                    return ((int)(this[this.tableparasubcontractsetup.ayearColumn]));
                }
                set {
                    this[this.tableparasubcontractsetup.ayearColumn] = value;
                }
            }
            
            [System.Diagnostics.DebuggerNonUserCodeAttribute()]
            public string numerationkind {
                get {
                    try {
                        return ((string)(this[this.tableparasubcontractsetup.numerationkindColumn]));
                    }
                    catch (System.InvalidCastException e) {
                        throw new System.Data.StrongTypingException("The value for column \'numerationkind\' in table \'parasubcontractsetup\' is DBNull.", e);
                    }
                }
                set {
                    this[this.tableparasubcontractsetup.numerationkindColumn] = value;
                }
            }
            
            [System.Diagnostics.DebuggerNonUserCodeAttribute()]
            public string cu {
                get {
                    try {
                        return ((string)(this[this.tableparasubcontractsetup.cuColumn]));
                    }
                    catch (System.InvalidCastException e) {
                        throw new System.Data.StrongTypingException("The value for column \'cu\' in table \'parasubcontractsetup\' is DBNull.", e);
                    }
                }
                set {
                    this[this.tableparasubcontractsetup.cuColumn] = value;
                }
            }
            
            [System.Diagnostics.DebuggerNonUserCodeAttribute()]
            public System.DateTime ct {
                get {
                    try {
                        return ((System.DateTime)(this[this.tableparasubcontractsetup.ctColumn]));
                    }
                    catch (System.InvalidCastException e) {
                        throw new System.Data.StrongTypingException("The value for column \'ct\' in table \'parasubcontractsetup\' is DBNull.", e);
                    }
                }
                set {
                    this[this.tableparasubcontractsetup.ctColumn] = value;
                }
            }
            
            [System.Diagnostics.DebuggerNonUserCodeAttribute()]
            public string lu {
                get {
                    try {
                        return ((string)(this[this.tableparasubcontractsetup.luColumn]));
                    }
                    catch (System.InvalidCastException e) {
                        throw new System.Data.StrongTypingException("The value for column \'lu\' in table \'parasubcontractsetup\' is DBNull.", e);
                    }
                }
                set {
                    this[this.tableparasubcontractsetup.luColumn] = value;
                }
            }
            
            [System.Diagnostics.DebuggerNonUserCodeAttribute()]
            public System.DateTime lt {
                get {
                    try {
                        return ((System.DateTime)(this[this.tableparasubcontractsetup.ltColumn]));
                    }
                    catch (System.InvalidCastException e) {
                        throw new System.Data.StrongTypingException("The value for column \'lt\' in table \'parasubcontractsetup\' is DBNull.", e);
                    }
                }
                set {
                    this[this.tableparasubcontractsetup.ltColumn] = value;
                }
            }
            
            [System.Diagnostics.DebuggerNonUserCodeAttribute()]
            public bool IsnumerationkindNull() {
                return this.IsNull(this.tableparasubcontractsetup.numerationkindColumn);
            }
            
            [System.Diagnostics.DebuggerNonUserCodeAttribute()]
            public void SetnumerationkindNull() {
                this[this.tableparasubcontractsetup.numerationkindColumn] = System.Convert.DBNull;
            }
            
            [System.Diagnostics.DebuggerNonUserCodeAttribute()]
            public bool IscuNull() {
                return this.IsNull(this.tableparasubcontractsetup.cuColumn);
            }
            
            [System.Diagnostics.DebuggerNonUserCodeAttribute()]
            public void SetcuNull() {
                this[this.tableparasubcontractsetup.cuColumn] = System.Convert.DBNull;
            }
            
            [System.Diagnostics.DebuggerNonUserCodeAttribute()]
            public bool IsctNull() {
                return this.IsNull(this.tableparasubcontractsetup.ctColumn);
            }
            
            [System.Diagnostics.DebuggerNonUserCodeAttribute()]
            public void SetctNull() {
                this[this.tableparasubcontractsetup.ctColumn] = System.Convert.DBNull;
            }
            
            [System.Diagnostics.DebuggerNonUserCodeAttribute()]
            public bool IsluNull() {
                return this.IsNull(this.tableparasubcontractsetup.luColumn);
            }
            
            [System.Diagnostics.DebuggerNonUserCodeAttribute()]
            public void SetluNull() {
                this[this.tableparasubcontractsetup.luColumn] = System.Convert.DBNull;
            }
            
            [System.Diagnostics.DebuggerNonUserCodeAttribute()]
            public bool IsltNull() {
                return this.IsNull(this.tableparasubcontractsetup.ltColumn);
            }
            
            [System.Diagnostics.DebuggerNonUserCodeAttribute()]
            public void SetltNull() {
                this[this.tableparasubcontractsetup.ltColumn] = System.Convert.DBNull;
            }
        }
        
        [System.CodeDom.Compiler.GeneratedCodeAttribute("System.Data.Design.TypedDataSetGenerator", "2.0.0.0")]
        public class parasubcontractsetupRowChangeEvent : System.EventArgs {
            
            private parasubcontractsetupRow eventRow;
            
            private System.Data.DataRowAction eventAction;
            
            [System.Diagnostics.DebuggerNonUserCodeAttribute()]
            public parasubcontractsetupRowChangeEvent(parasubcontractsetupRow row, System.Data.DataRowAction action) {
                this.eventRow = row;
                this.eventAction = action;
            }
            
            [System.Diagnostics.DebuggerNonUserCodeAttribute()]
            public parasubcontractsetupRow Row {
                get {
                    return this.eventRow;
                }
            }
            
            [System.Diagnostics.DebuggerNonUserCodeAttribute()]
            public System.Data.DataRowAction Action {
                get {
                    return this.eventAction;
                }
            }
        }
    }
}

#pragma warning restore 1591