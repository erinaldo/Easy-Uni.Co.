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

namespace intracommunitytransaction_default {
    using System;
    
    
    [System.CodeDom.Compiler.GeneratedCodeAttribute("System.Data.Design.TypedDataSetGenerator", "2.0.0.0")]
    [Serializable()]
    [System.ComponentModel.DesignerCategoryAttribute("code")]
    [System.ComponentModel.ToolboxItem(true)]
    [System.Xml.Serialization.XmlSchemaProviderAttribute("GetTypedDataSetSchema")]
    [System.Xml.Serialization.XmlRootAttribute("vistaForm")]
    [System.ComponentModel.Design.HelpKeywordAttribute("vs.data.DataSet")]
    public partial class vistaForm : System.Data.DataSet {
        
        private intracommunitytransactionDataTable tableintracommunitytransaction;
        
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
                if ((ds.Tables["intracommunitytransaction"] != null)) {
                    base.Tables.Add(new intracommunitytransactionDataTable(ds.Tables["intracommunitytransaction"]));
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
        public intracommunitytransactionDataTable intracommunitytransaction {
            get {
                return this.tableintracommunitytransaction;
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
                if ((ds.Tables["intracommunitytransaction"] != null)) {
                    base.Tables.Add(new intracommunitytransactionDataTable(ds.Tables["intracommunitytransaction"]));
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
            this.tableintracommunitytransaction = ((intracommunitytransactionDataTable)(base.Tables["intracommunitytransaction"]));
            if ((initTable == true)) {
                if ((this.tableintracommunitytransaction != null)) {
                    this.tableintracommunitytransaction.InitVars();
                }
            }
        }
        
        [System.Diagnostics.DebuggerNonUserCodeAttribute()]
        private void InitClass() {
            this.DataSetName = "vistaForm";
            this.Prefix = "";
            this.Namespace = "http://tempuri.org/vistatipotransintracom.xsd";
            this.EnforceConstraints = true;
            this.SchemaSerializationMode = System.Data.SchemaSerializationMode.IncludeSchema;
            this.tableintracommunitytransaction = new intracommunitytransactionDataTable();
            base.Tables.Add(this.tableintracommunitytransaction);
        }
        
        [System.Diagnostics.DebuggerNonUserCodeAttribute()]
        private bool ShouldSerializeintracommunitytransaction() {
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
        
        public delegate void intracommunitytransactionRowChangeEventHandler(object sender, intracommunitytransactionRowChangeEvent e);
        
        [System.CodeDom.Compiler.GeneratedCodeAttribute("System.Data.Design.TypedDataSetGenerator", "2.0.0.0")]
        [System.Serializable()]
        [System.Xml.Serialization.XmlSchemaProviderAttribute("GetTypedTableSchema")]
        public partial class intracommunitytransactionDataTable : System.Data.DataTable, System.Collections.IEnumerable {
            
            private System.Data.DataColumn columnidintracommunitytransaction;
            
            private System.Data.DataColumn columndescription;
            
            private System.Data.DataColumn columncu;
            
            private System.Data.DataColumn columnct;
            
            private System.Data.DataColumn columnlu;
            
            private System.Data.DataColumn columnlt;
            
            [System.Diagnostics.DebuggerNonUserCodeAttribute()]
            public intracommunitytransactionDataTable() {
                this.TableName = "intracommunitytransaction";
                this.BeginInit();
                this.InitClass();
                this.EndInit();
            }
            
            [System.Diagnostics.DebuggerNonUserCodeAttribute()]
            internal intracommunitytransactionDataTable(System.Data.DataTable table) {
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
            protected intracommunitytransactionDataTable(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context) : 
                    base(info, context) {
                this.InitVars();
            }
            
            [System.Diagnostics.DebuggerNonUserCodeAttribute()]
            public System.Data.DataColumn idintracommunitytransactionColumn {
                get {
                    return this.columnidintracommunitytransaction;
                }
            }
            
            [System.Diagnostics.DebuggerNonUserCodeAttribute()]
            public System.Data.DataColumn descriptionColumn {
                get {
                    return this.columndescription;
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
            public intracommunitytransactionRow this[int index] {
                get {
                    return ((intracommunitytransactionRow)(this.Rows[index]));
                }
            }
            
            public event intracommunitytransactionRowChangeEventHandler intracommunitytransactionRowChanging;
            
            public event intracommunitytransactionRowChangeEventHandler intracommunitytransactionRowChanged;
            
            public event intracommunitytransactionRowChangeEventHandler intracommunitytransactionRowDeleting;
            
            public event intracommunitytransactionRowChangeEventHandler intracommunitytransactionRowDeleted;
            
            [System.Diagnostics.DebuggerNonUserCodeAttribute()]
            public void AddintracommunitytransactionRow(intracommunitytransactionRow row) {
                this.Rows.Add(row);
            }
            
            [System.Diagnostics.DebuggerNonUserCodeAttribute()]
            public intracommunitytransactionRow AddintracommunitytransactionRow(string idintracommunitytransaction, string description, string cu, System.DateTime ct, string lu, System.DateTime lt) {
                intracommunitytransactionRow rowintracommunitytransactionRow = ((intracommunitytransactionRow)(this.NewRow()));
                rowintracommunitytransactionRow.ItemArray = new object[] {
                        idintracommunitytransaction,
                        description,
                        cu,
                        ct,
                        lu,
                        lt};
                this.Rows.Add(rowintracommunitytransactionRow);
                return rowintracommunitytransactionRow;
            }
            
            [System.Diagnostics.DebuggerNonUserCodeAttribute()]
            public intracommunitytransactionRow FindByidintracommunitytransaction(string idintracommunitytransaction) {
                return ((intracommunitytransactionRow)(this.Rows.Find(new object[] {
                            idintracommunitytransaction})));
            }
            
            [System.Diagnostics.DebuggerNonUserCodeAttribute()]
            public virtual System.Collections.IEnumerator GetEnumerator() {
                return this.Rows.GetEnumerator();
            }
            
            [System.Diagnostics.DebuggerNonUserCodeAttribute()]
            public override System.Data.DataTable Clone() {
                intracommunitytransactionDataTable cln = ((intracommunitytransactionDataTable)(base.Clone()));
                cln.InitVars();
                return cln;
            }
            
            [System.Diagnostics.DebuggerNonUserCodeAttribute()]
            protected override System.Data.DataTable CreateInstance() {
                return new intracommunitytransactionDataTable();
            }
            
            [System.Diagnostics.DebuggerNonUserCodeAttribute()]
            internal void InitVars() {
                this.columnidintracommunitytransaction = base.Columns["idintracommunitytransaction"];
                this.columndescription = base.Columns["description"];
                this.columncu = base.Columns["cu"];
                this.columnct = base.Columns["ct"];
                this.columnlu = base.Columns["lu"];
                this.columnlt = base.Columns["lt"];
            }
            
            [System.Diagnostics.DebuggerNonUserCodeAttribute()]
            private void InitClass() {
                this.columnidintracommunitytransaction = new System.Data.DataColumn("idintracommunitytransaction", typeof(string), null, System.Data.MappingType.Element);
                base.Columns.Add(this.columnidintracommunitytransaction);
                this.columndescription = new System.Data.DataColumn("description", typeof(string), null, System.Data.MappingType.Element);
                base.Columns.Add(this.columndescription);
                this.columncu = new System.Data.DataColumn("cu", typeof(string), null, System.Data.MappingType.Element);
                base.Columns.Add(this.columncu);
                this.columnct = new System.Data.DataColumn("ct", typeof(System.DateTime), null, System.Data.MappingType.Element);
                base.Columns.Add(this.columnct);
                this.columnlu = new System.Data.DataColumn("lu", typeof(string), null, System.Data.MappingType.Element);
                base.Columns.Add(this.columnlu);
                this.columnlt = new System.Data.DataColumn("lt", typeof(System.DateTime), null, System.Data.MappingType.Element);
                base.Columns.Add(this.columnlt);
                this.Constraints.Add(new System.Data.UniqueConstraint("vistaFormKey1", new System.Data.DataColumn[] {
                                this.columnidintracommunitytransaction}, true));
                this.columnidintracommunitytransaction.AllowDBNull = false;
                this.columnidintracommunitytransaction.Unique = true;
                this.columndescription.AllowDBNull = false;
                this.columncu.AllowDBNull = false;
                this.columnct.AllowDBNull = false;
                this.columnlu.AllowDBNull = false;
                this.columnlt.AllowDBNull = false;
            }
            
            [System.Diagnostics.DebuggerNonUserCodeAttribute()]
            public intracommunitytransactionRow NewintracommunitytransactionRow() {
                return ((intracommunitytransactionRow)(this.NewRow()));
            }
            
            [System.Diagnostics.DebuggerNonUserCodeAttribute()]
            protected override System.Data.DataRow NewRowFromBuilder(System.Data.DataRowBuilder builder) {
                return new intracommunitytransactionRow(builder);
            }
            
            [System.Diagnostics.DebuggerNonUserCodeAttribute()]
            protected override System.Type GetRowType() {
                return typeof(intracommunitytransactionRow);
            }
            
            [System.Diagnostics.DebuggerNonUserCodeAttribute()]
            protected override void OnRowChanged(System.Data.DataRowChangeEventArgs e) {
                base.OnRowChanged(e);
                if ((this.intracommunitytransactionRowChanged != null)) {
                    this.intracommunitytransactionRowChanged(this, new intracommunitytransactionRowChangeEvent(((intracommunitytransactionRow)(e.Row)), e.Action));
                }
            }
            
            [System.Diagnostics.DebuggerNonUserCodeAttribute()]
            protected override void OnRowChanging(System.Data.DataRowChangeEventArgs e) {
                base.OnRowChanging(e);
                if ((this.intracommunitytransactionRowChanging != null)) {
                    this.intracommunitytransactionRowChanging(this, new intracommunitytransactionRowChangeEvent(((intracommunitytransactionRow)(e.Row)), e.Action));
                }
            }
            
            [System.Diagnostics.DebuggerNonUserCodeAttribute()]
            protected override void OnRowDeleted(System.Data.DataRowChangeEventArgs e) {
                base.OnRowDeleted(e);
                if ((this.intracommunitytransactionRowDeleted != null)) {
                    this.intracommunitytransactionRowDeleted(this, new intracommunitytransactionRowChangeEvent(((intracommunitytransactionRow)(e.Row)), e.Action));
                }
            }
            
            [System.Diagnostics.DebuggerNonUserCodeAttribute()]
            protected override void OnRowDeleting(System.Data.DataRowChangeEventArgs e) {
                base.OnRowDeleting(e);
                if ((this.intracommunitytransactionRowDeleting != null)) {
                    this.intracommunitytransactionRowDeleting(this, new intracommunitytransactionRowChangeEvent(((intracommunitytransactionRow)(e.Row)), e.Action));
                }
            }
            
            [System.Diagnostics.DebuggerNonUserCodeAttribute()]
            public void RemoveintracommunitytransactionRow(intracommunitytransactionRow row) {
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
                attribute2.FixedValue = "intracommunitytransactionDataTable";
                type.Attributes.Add(attribute2);
                type.Particle = sequence;
                return type;
            }
        }
        
        [System.CodeDom.Compiler.GeneratedCodeAttribute("System.Data.Design.TypedDataSetGenerator", "2.0.0.0")]
        public partial class intracommunitytransactionRow : System.Data.DataRow {
            
            private intracommunitytransactionDataTable tableintracommunitytransaction;
            
            [System.Diagnostics.DebuggerNonUserCodeAttribute()]
            internal intracommunitytransactionRow(System.Data.DataRowBuilder rb) : 
                    base(rb) {
                this.tableintracommunitytransaction = ((intracommunitytransactionDataTable)(this.Table));
            }
            
            [System.Diagnostics.DebuggerNonUserCodeAttribute()]
            public string idintracommunitytransaction {
                get {
                    return ((string)(this[this.tableintracommunitytransaction.idintracommunitytransactionColumn]));
                }
                set {
                    this[this.tableintracommunitytransaction.idintracommunitytransactionColumn] = value;
                }
            }
            
            [System.Diagnostics.DebuggerNonUserCodeAttribute()]
            public string description {
                get {
                    return ((string)(this[this.tableintracommunitytransaction.descriptionColumn]));
                }
                set {
                    this[this.tableintracommunitytransaction.descriptionColumn] = value;
                }
            }
            
            [System.Diagnostics.DebuggerNonUserCodeAttribute()]
            public string cu {
                get {
                    return ((string)(this[this.tableintracommunitytransaction.cuColumn]));
                }
                set {
                    this[this.tableintracommunitytransaction.cuColumn] = value;
                }
            }
            
            [System.Diagnostics.DebuggerNonUserCodeAttribute()]
            public System.DateTime ct {
                get {
                    return ((System.DateTime)(this[this.tableintracommunitytransaction.ctColumn]));
                }
                set {
                    this[this.tableintracommunitytransaction.ctColumn] = value;
                }
            }
            
            [System.Diagnostics.DebuggerNonUserCodeAttribute()]
            public string lu {
                get {
                    return ((string)(this[this.tableintracommunitytransaction.luColumn]));
                }
                set {
                    this[this.tableintracommunitytransaction.luColumn] = value;
                }
            }
            
            [System.Diagnostics.DebuggerNonUserCodeAttribute()]
            public System.DateTime lt {
                get {
                    return ((System.DateTime)(this[this.tableintracommunitytransaction.ltColumn]));
                }
                set {
                    this[this.tableintracommunitytransaction.ltColumn] = value;
                }
            }
        }
        
        [System.CodeDom.Compiler.GeneratedCodeAttribute("System.Data.Design.TypedDataSetGenerator", "2.0.0.0")]
        public class intracommunitytransactionRowChangeEvent : System.EventArgs {
            
            private intracommunitytransactionRow eventRow;
            
            private System.Data.DataRowAction eventAction;
            
            [System.Diagnostics.DebuggerNonUserCodeAttribute()]
            public intracommunitytransactionRowChangeEvent(intracommunitytransactionRow row, System.Data.DataRowAction action) {
                this.eventRow = row;
                this.eventAction = action;
            }
            
            [System.Diagnostics.DebuggerNonUserCodeAttribute()]
            public intracommunitytransactionRow Row {
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