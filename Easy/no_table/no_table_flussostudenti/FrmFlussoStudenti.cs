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
using System.Collections.Generic;
using System.Data;
using System.Windows.Forms;
using metadatalibrary;
using metaeasylibrary;
using funzioni_configurazione;
using movimentofunctions;
using System.Data.OleDb;
using System.IO;
using System.Globalization;
using System.Linq;
using ep_functions;
using System.Net.Mail;
using System.Runtime.InteropServices.WindowsRuntime;
using System.Runtime.Remoting.Messaging;
using meta_estimate;
using meta_estimatedetail;
using meta_flussocreditidetail;
using meta_flussoincassi;
using meta_income;
using meta_incomeyear;
using meta_incomelast;
using meta_invoice;
using meta_invoicedetail;
using meta_ivaregister;
using q = metadatalibrary.MetaExpression;
using CrystalDecisions.CrystalReports.Engine;
using meta_registry;
using CrystalDecisions.Shared;
using meta_flussocrediti;
using meta_flussoincassidetail;
using meta_registryreference;

namespace no_table_flussostudenti {

    // ReSharper disable once UnusedMember.Global
    public partial class Frmflussostudenti : Form {
        private CQueryHelper _qhc;

        private QueryHelper _qhs;

        //private object _idsorkindMiurE;
        private object _idsorkindSiopeE;
        private int _nphaseSiopeE;

        private enum TipoElaborazioneIncassi {
            imponibile,
            iva,
            totali
        }

        public Frmflussostudenti() {
            InitializeComponent();
            var dir = Path.Combine(Environment.GetFolderPath(Environment.SpecialFolder.ProgramFiles),
                "flussostudenti/prog/temp");
            if (Directory.Exists(dir)) {
                saveOutputFileDlg.InitialDirectory = dir;
            }
        }

        private ISecurity _security;
        private IMetaDataDispatcher _dispatcher;
        private IMetaData _meta;
        private IDataAccess _conn;
        private IFormController _ctrl;

        // ReSharper disable once InconsistentNaming
        private int esercizio;
        private IMetaModel _model;

        // ReSharper disable once UnusedMember.Global
        public void MetaData_AfterLink() {
            _meta = this.getInstance<IMetaData>();
            _conn = this.getInstance<IDataAccess>();
            _dispatcher = this.getInstance<IMetaDataDispatcher>();
            _security = this.getInstance<ISecurity>();
            _ctrl = this.getInstance<IFormController>();
            _model = MetaFactory.factory.getSingleton<IMetaModel>();
            _qhc = new CQueryHelper();
            _qhs = _conn.GetQueryHelper();
            esercizio = _security.GetEsercizio();
            var filterEsercizio = _qhs.CmpEq("ayear", esercizio);
            GetData.CacheTable(DS.license);
            GetData.CacheTable(DS.config, filterEsercizio, null, false);
            GetData.CacheTable(DS.estimatekind, null, "description", true);
            GetData.CacheTable(DS.estimatekind, null, "description", true);

            GetData.CacheTable(DS.finmotive);
            GetData.CacheTable(DS.report);
            GetData.CacheTable(DS.finmotivedetail, filterEsercizio, null, false);
            GetData.CacheTable(DS.invoicekind, null, "idinvkind", true);
            GetData.CacheTable(DS.ivakind, null, null, false);
            GetData.CacheTable(DS.invoicekindregisterkind);
            DataAccess.SetTableForReading(DS.registry1, "registry");
            _ctrl.CanCancel = false;
            _ctrl.CanInsert = false;
            _ctrl.CanInsertCopy = false;
            _ctrl.CanSave = false;
            _ctrl.SearchEnabled = false;              
            _idsorkindSiopeE =
                _conn.readValue("sortingkind", q.eq("codesorkind", "SIOPE_E_18"), "idsorkind"); //era 07E_SIOPE
            _nphaseSiopeE =
                CfgFn.GetNoNullInt32(
                    _conn.readValue("sortingkind", q.eq("idsorkind", _idsorkindSiopeE), "nphaseincome"));


            btnElaboraContabilizzazioni.Enabled = false;
           
            _allButton = new[] {
                new ImportButton(btnImportaFlussoCrediti, _tracciatoFlussostudentiFaseuno),
                new ImportButton(btnImportaFlussoIncassi, _tracciatoFlussostudentiFasedue),
            };

            foreach (var ib in _allButton) {
                ib.Btn.ContextMenu = CMenu;
            }
            GestisciEditType();
        }


        void MostraTab(TabControl Tab, TabPage TPage, TabPage TPage2, TabPage TPag3) {
            //  Mostra solo i TabPage indicati
            foreach (TabPage page in Tab.TabPages) {
                if (!((page== TPage)||(page == TPage2)|| (page == TPag3))) Tab.TabPages.Remove(page);
            }
            if (Tab.TabPages.Count == 0) Tab.Visible = false;
            // ho impostato la propriet� autosize a true sul form, per permettere il ridimensionamento automatico
        }

        void GestisciEditType() {
            switch (_meta.editType) {
                case "importaflussi": {MostraTab(tabFunzioni,tabPageImportaFlussi,null, null); MostraTab(tabGrid,tabPageCreditiImportati, tabPageIncassiImportati,null); break; }
                case "elaboracrediti": { MostraTab(tabFunzioni,tabPageElaboraCrediti,null,null); MostraTab(tabGrid, tabPageDettContratti, null,null); break; }
                case "elaboraincassiconsospesi": {
                    chkAncheSenzaSospesi.Checked = false;
                    MostraTab(tabFunzioni,tabPageElaboraIncassi,null,null);
                    MostraTab(tabGrid,tabPageFattureCreate,null,null);
                    break;
                }
                case "elaboraincassisenzasospesi": {
                    chkAncheSenzaSospesi.Checked = true;
                    MostraTab(tabFunzioni,tabPageElaboraIncassi,null,null);
                    MostraTab(tabGrid,tabPageFattureCreate, null, null);
                    break;
                }
            }

        }



        private void addColumnDati(DataTable tExcel, string fase) {
            switch (fase) {
                case "faseuno": {
                    tExcel.Columns.Add("codice_fiscale_studente", typeof(string));
                    tExcel.Columns.Add("causale", typeof(string));
                    tExcel.Columns.Add("codice_bollettino_univoco", typeof(string));
                    tExcel.Columns.Add("operazione", typeof(string));
                    tExcel.Columns.Add("data_inizio_competenza", typeof(DateTime));
                    tExcel.Columns.Add("data_fine_competenza", typeof(DateTime));
                    tExcel.Columns.Add("codice_causale_ep_ricavo", typeof(string));
                    tExcel.Columns.Add("codice_causale_ep_credito", typeof(string));
                    tExcel.Columns.Add("codice_causale_finanziaria", typeof(string));
                    tExcel.Columns.Add("codice_upb", typeof(string));
                    tExcel.Columns.Add("importo", typeof(decimal));
                    tExcel.Columns.Add("codice_tipo_contratto", typeof(string));
                    tExcel.Columns.Add("data_contabile", typeof(DateTime));
                    tExcel.Columns.Add("nome_studente", typeof(string));
                    tExcel.Columns.Add("cognome_studente", typeof(string));
                    break;
                }
                //Non usato al momento
                case "faseuno_essetre": {
                    tExcel.Columns.Add("codice_tassa", typeof(string));
                    tExcel.Columns.Add("codice_voce", typeof(string));
                    tExcel.Columns.Add("codice_corso_laurea", typeof(string));
                    tExcel.Columns.Add("codice_fiscale_studente", typeof(string));
                    tExcel.Columns.Add("causale", typeof(string));
                    tExcel.Columns.Add("codice_bollettino_univoco", typeof(string));
                    tExcel.Columns.Add("numero_bollettino", typeof(string));
                    tExcel.Columns.Add("operazione", typeof(string));
                    tExcel.Columns.Add("data_inizio_competenza", typeof(DateTime));
                    tExcel.Columns.Add("data_fine_competenza", typeof(DateTime));
                    tExcel.Columns.Add("importo", typeof(decimal));
                    tExcel.Columns.Add("codice_tipo_contratto", typeof(string));
                    tExcel.Columns.Add("data_contabile", typeof(DateTime));
                    tExcel.Columns.Add("data_scadenza", typeof(DateTime));
                    tExcel.Columns.Add("nome_studente", typeof(string));
                    tExcel.Columns.Add("cognome_studente", typeof(string));
                    break;
                }
                default: {
                    tExcel.Columns.Add("codice_fiscale_studente", typeof(string));
                    tExcel.Columns.Add("numero_sospeso_attivo", typeof(string));
                    tExcel.Columns.Add("data_incasso", typeof(DateTime));
                    tExcel.Columns.Add("codice_bollettino_univoco", typeof(string));
                    tExcel.Columns.Add("importo", typeof(decimal));
                    break;
                }
            }

        }


        /// <summary>
        /// Importa flusso studenti da file Excel
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        private void btnFileInput_Click(object sender, EventArgs e) {

            var crediti = leggiFile(true);
            if (crediti == null) {
                return;
            }

            importaFlussoCrediti(crediti);
        }



        private struct ImportButton {
            public readonly Button Btn;
            public readonly string[] Tracciato;

            public ImportButton(Button btn, string[] tracciato) {
                Btn = btn;
                Tracciato = tracciato;
            }
        }

        private ImportButton[] _allButton;

        private void MenuEnterPwd_Click(object sender, EventArgs e) {
            if (!(sender is MenuItem)) return;
            object mysender = ((MenuItem) sender).Parent.GetContextMenu()?.SourceControl;
            foreach (var ib in _allButton) {
                if (ib.Btn != mysender) continue;
                new FrmShowTracciato(getTracciato(ib.Tracciato), getTableTracciato(ib.Tracciato), "struttura")
                    .ShowDialog();
                return;
            }
        }

        LeggiFile getReader(string[] tracciato) {
            var reader = new LeggiFile();
            var dr = openInputFileDlg.ShowDialog();
            if (dr != DialogResult.OK) {
                MessageBox.Show("Non � stato scelto alcun file");
                txtInputFile.Text = "";
                return null;
            }

            fileName = openInputFileDlg.FileName;

            if (reader.Init(tracciato, fileName)) return reader;
            MessageBox.Show("Non � stato importato alcun dato", "Avviso");
            return null;
        }

        private void menuItem1_Click(object sender, EventArgs e) {
            if (!(sender is MenuItem)) return;
            object mysender = ((MenuItem) sender).Parent.GetContextMenu()?.SourceControl;
            string[] tracciato = null;
            DataTable tableTracciato = null;
            foreach (var ib in _allButton) {
                if (ib.Btn != mysender) continue;
                tracciato = ib.Tracciato;
                tableTracciato = getTableTracciato(ib.Tracciato);
                break;
            }

            var reader = getReader(tracciato);
            if (reader == null) return;

            reader.GetNext();
            var rec = reader.GetCurrRecord();

            reader.Close();
            new FrmShowTracciato(rec, tableTracciato, "primo record").ShowDialog();
        }




        /// <summary>
        /// Legge un foglio excel crediti o incassi 
        /// </summary>
        /// <param name="faseCrediti"></param>
        /// <returns></returns>
        private DataTable leggiFile(bool faseCrediti) {
            var dr = openInputFileDlg.ShowDialog();
            if (dr != DialogResult.OK) {
                MessageBox.Show("Non � stato scelto alcun file");
                txtInputFile.Text = "";
                return null;
            }

            fileName = openInputFileDlg.FileName;
            DataTable t = null;
            if (fileName.EndsWith("xls") || fileName.EndsWith("xlsx") || fileName.EndsWith("csv")) {
                try {
                    t = readCurrentSheet(faseCrediti);
                    if (t == null) return null;
                    txtInputFile.Text = fileName;
                }
                catch (Exception ex) {
                    MessageBox.Show(this, $"Errore nell\'apertura del file! Processo Terminato\n{ex.Message}");
                    return null;
                }
            }
            else {
                MessageBox.Show("Il file deve avere formato xls, xlsx o csv", "Errore");
            }

            _ctrl.FreshForm(true, false);
            return t;
        }

        static string getExcelType(DataColumn c) {
            if (c.DataType == typeof(int)) return "Integer";
            if (c.DataType == typeof(string)) return "Text";
            if (c.DataType == typeof(decimal)) return "Currency";
            if (c.DataType == typeof(DateTime)) return "DateTime";
            MessageBox.Show("Tipo " + c.DataType + " non trovato");
            return "Text";
        }

        /// <summary>
        /// Legge i dati dal foglio excel
        /// </summary>
        /// <param name="faseCrediti"></param>
        /// <returns></returns>
        private DataTable readCurrentSheet(bool faseCrediti) {
            var dtToImport = new DataTable();

            if (faseCrediti) {
                addColumnDati(dtToImport, "faseuno");
                impostaCaption(dtToImport, "faseuno");
            }
            else {
                addColumnDati(dtToImport, "fasedue");
                impostaCaption(dtToImport, "fasedue");
            }

            // Lettura file excel
            if (fileName.EndsWith("xls") || fileName.EndsWith("xlsx")) {
                dtToImport.Clear();
                var c = new ExcelImport();
                c.ImportTable(fileName, dtToImport, false, 2);
            }
            else {
                // Lettura file .CSV
                var pathOnly = Path.GetDirectoryName(fileName);
                if (pathOnly == null) return null;
                var connectionString = ExcelImport.CsvConnString(pathOnly, false);
                var onlyfileName = Path.GetFileName(fileName);
                var inicontent = "[" + onlyfileName + "]\r\n" +
                                 "Format = Delimited(;)\r\n" +
                                 "MaxScanRows=0\r\n" +
                                 "DecimalSymbol=,\r\n" +
                                 "CurrencyThousandSymbol=.\r\n" +
                                 "CurrencyDigits=2\r\n" +
                                 "ColNameHeader = False";
                for (var i = 0; i < dtToImport.Columns.Count; i++) {
                    var nCol = i + 1;
                    var c = dtToImport.Columns[i];
                    var colDef = "Col" + nCol + "=" + c.ColumnName + " " + getExcelType(c);
                    inicontent += "\r\n" + colDef;
                }

                var fNameIni = Path.Combine(pathOnly, "schema.ini");
                File.WriteAllText(fNameIni, inicontent);

                try {
                    // open the connection to the file
                    using (var connection = new OleDbConnection(connectionString)) {
                        connection.Open();
                        var sql = $"SELECT * FROM [{onlyfileName}]";

                        // create an adapter
                        using (var adapter = new OleDbDataAdapter(sql, connection)) {
                            // clear the datatable to avoid old data persistant
                            dtToImport.Locale = CultureInfo.CurrentCulture;
                            dtToImport.Clear();
                            adapter.Fill(dtToImport);
                        }

                        connection.Close();
                    }
                }
                catch (Exception ex) {
                    MessageBox.Show(this, ex.Message);
                    return null;
                }

                const int rowsToSkip = 0;
                // pulizia nomi colonne da eventuali spazi
                foreach (DataColumn c in dtToImport.Columns) {
                    c.ColumnName = c.ColumnName.Trim();
                }

                for (var i = 0; i <= rowsToSkip; i++) {
                    dtToImport.Rows[i].Delete();
                }

                dtToImport.AcceptChanges();
                File.Delete(fNameIni);

            }

            bool ok;
            try {
                if (faseCrediti) {
                    ok = verificaCrediti(dtToImport);
                    tabGrid.SelectedIndex = 0;
                }

                else {
                    ok = verificaIncassi(dtToImport);
                    tabGrid.SelectedIndex = 1;
                }
            }
            catch (Exception e) {
                QueryCreator.ShowException(this, "Errore nella elaborazione del file excel ", e);
                return null;
            }

            if (!ok){
                MessageBox.Show(this, $@"L'esame del file {fileName} ha fatto rilevare degli errori");
                return null;
            }

            return dtToImport;
        }

        ///// <summary>
        ///// Al momento inutilizzato perch� forse  � troppo oneroso memorizzare tutti i flussi sul db
        ///// </summary>
        ///// <param name="flussocrediti"></param>
        ///// <param name="nomeCompletoFile"></param>
        //private void scriviFileInRigaFlusso(DataRow flussocrediti, string nomeCompletoFile) {

        //    var fs = new FileStream(nomeCompletoFile, FileMode.Open, FileAccess.Read);
        //    var n = (int)fs.Length;
        //    if (n == 0) {
        //        return;
        //    }
        //    var byteArray = new byte[n];
        //    fs.Read(byteArray, 0, n);

        //    fs.Close();
        //    flussocrediti["flusso"] = byteArray;

        //    //Meta.SaveFormData();
        //}

        void impostaCaption(DataTable dt, string fase) {
            switch (fase) {
                case "faseuno": {
                    dt.Columns["codice_fiscale_studente"].Caption = "Cod. Fiscale Studente";
                    dt.Columns["causale"].Caption = "Causale";
                    dt.Columns["codice_bollettino_univoco"].Caption = "Cod. Bollettino Univoco";
                    dt.Columns["operazione"].Caption = "Operazione";
                    dt.Columns["data_inizio_competenza"].Caption = "Data Inizio Competenza";
                    dt.Columns["data_fine_competenza"].Caption = "Data Fine Competenza";
                    dt.Columns["codice_causale_ep_ricavo"].Caption = "Causale EP Ricavo o di Annullamento";
                    dt.Columns["codice_causale_ep_credito"].Caption = "Causale EP Credito";
                    dt.Columns["codice_causale_finanziaria"].Caption = "Causale finanziaria";
                    dt.Columns["codice_upb"].Caption = "Codice UPB";
                    dt.Columns["importo"].Caption = "Importo";
                    dt.Columns["codice_tipo_contratto"].Caption = "Codice Tipo Contratto";
                    dt.Columns["data_contabile"].Caption = "Data Contabile";
                    dt.Columns["nome_studente"].Caption = "Nome studente";
                    dt.Columns["cognome_studente"].Caption = "Cognome studente";
                    break;
                }
                case "faseuno_essetre": {
                    dt.Columns["codice_tassa"].Caption = "Cod. Tassa";
                    dt.Columns["codice_voce"].Caption = "Cod. Voce";
                    dt.Columns["codice_corso_laurea"].Caption = "Cod. Corso Laurea";
                    dt.Columns["causale"].Caption = "Causale";
                    dt.Columns["codice_bollettino_univoco"].Caption = "Cod. Bollettino Univoco";
                    dt.Columns["operazione"].Caption = "Operazione";
                    dt.Columns["data_inizio_competenza"].Caption = "Data Inizio Competenza";
                    dt.Columns["data_fine_competenza"].Caption = "Data Fine Competenza";
                    dt.Columns["importo"].Caption = "Importo";
                    dt.Columns["codice_tipo_contratto"].Caption = "Codice Tipo Contratto";
                    dt.Columns["data_contabile"].Caption = "Data Contabile";
                    dt.Columns["nome_studente"].Caption = "Nome studente";
                    dt.Columns["cognome_studente"].Caption = "Cognome studente";
                    break;
                }
                default: {
                    dt.Columns["codice_fiscale_studente"].Caption = "Cod. Fiscale Studente";
                    dt.Columns["numero_sospeso_attivo"].Caption = " Numero Sospeso Attivo";
                    dt.Columns["data_incasso"].Caption = "Data Contabile";
                    dt.Columns["codice_bollettino_univoco"].Caption = "Cod. Bollettino Univoco";
                    break;
                }
            }
        }

        private readonly string[] _tracciatoFlussostudentiFaseuno = {
            "codice_fiscale_studente;Codice Fiscale Studente;Stringa;16",
            "causale;Causale (da inserire nel descrizione del dettaglio contratto);Stringa;150",
            "codice_bollettino_univoco;Codice Bollettino Univoco;Stringa;50",
            "operazione;Inserimento/Annullamento;Codificato;1;I|A",
            "data_inizio_competenza; Data Inizio Competenza;Data;10",
            "data_fine_competenza; Data Fine Competenza;Data;10",
            "codice_causale_ep_ricavo;Codice Causale EP Ricavo;Stringa;50",
            "codice_causale_ep_credito;Codice Causale EP Credito (opzionale);Stringa;50",
            "codice_causale_finanziaria;Codice Causale Finanziaria;Stringa;50",
            "codice_upb;Codice UPB;Stringa;50",
            "importo;Importo;Numero;22",
            "codice_tipo_contratto;Codice Tipo Contratto (gi� esistente);Stringa;50",
            "data_contabile; Data Contabile;Data;10",
            "nome_studente;Nome Studente (ai fini di creare un'anagrafica specifica);Stringa;50",
            "cognome_studente;Cognome Studente (ai fini di creare un'anagrafica specifica);Stringa;50"
        };

        //string[] _tracciatoFlussostudentiFaseunoEssetre =
        //   {
        //        "codice_tassa;Codice Tassa;Stringa;50",
        //        "codice_voce;Codice Voce;Stringa;50",
        //        "codice_corso_laurea;Codice Corso di Laurea;Stringa;50",
        //        "codice_fiscale_studente;Codice Fiscale Studente;Stringa;16",
        //        "causale;Causale (da inserire nel descrizione del dettaglio contratto);Stringa;150",
        //        "codice_bollettino_univoco;Codice Bollettino Univoco;Stringa;50",
        //        "numero_bollettino; Numero Bollettino; Intero;10",
        //        "operazione;Inserimento/Annullamento;Codificato;1;I|A",
        //        "data_inizio_competenza; Data Inizio Competenza;Data;10",
        //        "data_fine_competenza; Data Fine Competenza;Data;10",
        //        "importo;Importo;Numero;22",
        //        "codice_tipo_contratto;Codice Tipo Contratto (gi� esistente);Stringa;50",
        //        "data_contabile; Data Contabile;Data;10",
        //        "nome_studente;Nome Studente (ai fini di creare un'anagrafica specifica);Stringa;50",
        //        "cognome_studente;Cognome Studente (ai fini di creare un'anagrafica specifica);Stringa;50"
        //   };

        private readonly string[] _tracciatoFlussostudentiFasedue = {
            "codice_fiscale_studente;Codice Fiscale Studente;Stringa;16",
            "numero_sospeso_attivo; Numero Sospeso Attivo; Intero;10",
            "data_incasso; Data Incasso;Data;10",
            "codice_bollettino_univoco;Codice Bollettino Univoco;Stringa;50",
            "importo;Importo Totale;Numero;22"
        };


        private readonly Dictionary<string, int> _registry = new Dictionary<string, int>();

        private object creaAnagraficaSeNonEsiste(object oCf, object oNome, object oCognome, object causaleCredito,
            object oEmail, out string errori) {
            errori = "";
            if ((oCf == null) || (oCf == DBNull.Value)) {
                errori = "Codice fiscale studente non valorizzato";
                return DBNull.Value;
            }

            var codicefiscale = oCf.ToString().ToUpper();
            if (_registry.ContainsKey(codicefiscale)) return _registry[codicefiscale];


            var anagr = DS.registry.Select(_qhs.AppAnd(_qhs.CmpEq("cf", codicefiscale), _qhs.CmpEq("active", "S")));
            if (anagr.Length > 0) return anagr[0]["idreg"];
            var filterreg = _qhs.AppAnd(_qhs.CmpEq("cf", codicefiscale), _qhs.CmpEq("active", "S"));

            var idreg = _conn.DO_READ_VALUE("registry", filterreg, "idreg");

            if ((idreg != DBNull.Value) && (idreg != null)) {
                _registry[codicefiscale] = CfgFn.GetNoNullInt32(idreg);
                return _registry[codicefiscale];
            }

            var metaRegistry = _dispatcher.Get("registry");
            metaRegistry.SetDefaults(DS.Tables["registry"]);
            var newReg = metaRegistry.Get_New_Row(null, DS.Tables["registry"]);

            _registry[codicefiscale] = CfgFn.GetNoNullInt32(newReg["idreg"]);

            newReg["idregistryclass"] = 22; // persona fisica;
            newReg["title"] = $"{oCognome} {oNome}";
            newReg["surname"] = oCognome;
            newReg["forename"] = oNome;
            newReg["cf"] = codicefiscale;
            newReg["active"] = "S";
            newReg["residence"] = 1;
            newReg["authorization_free"] = "N";
            newReg["idaccmotivecredit"] = causaleCredito;
           

            if (oEmail != DBNull.Value) {
                try {
                    var emailAddress = new MailAddress(oEmail.ToString());
                    var metaRegistryReference = _dispatcher.Get("registryreference");
                    metaRegistryReference.SetDefaults(DS.Tables["registryreference"]);

                    MetaData.SetDefault(DS.Tables["registryreference"], "idreg", newReg["idreg"]);
                    var rp = metaRegistryReference.Get_New_Row(null, DS.Tables["registryreference"]);

                    rp["referencename"] = "predefinito";
                    rp["email"] = emailAddress;
                    newReg["email_fe"] = emailAddress;
                    rp["flagdefault"] = "S";
                }
                catch {
                    errori = $"Indirizzo e-mail {oEmail} non valido.";
                    return DBNull.Value;
                }

            }

            // Ci chiedono di non considerare pi� errore bloccante l'avere un codice fiscale errato
            // perch� i dati arrivano cos� dalla banca

            // Ricava alcune informazioni dal codice fiscale

            if (codicefiscale.Length != 16) {
                errori = "Il codice fiscale " + codicefiscale + " deve essere composto da 16 caratteri!";
                //return DBNull.Value;
                return newReg["idreg"];
            }

            bool isValid;
            var lastChar = CalcolaCodiceFiscale.GetLastChar(codicefiscale.Substring(0, 15), out isValid);
            if ((!isValid) || (codicefiscale[15] != lastChar)) {
                errori = "Il codice fiscale risulta errato alla verifica dell'ultimo carattere  '" + lastChar + "'";
                return newReg["idreg"];
            }

            codicefiscale = CalcolaCodiceFiscale.normalizza(codicefiscale);
            var italiano = (codicefiscale[11] != 'Z');
            var sesso = InfoDaCodiceFiscale.Sesso(codicefiscale);
            var datanascita = InfoDaCodiceFiscale.dataNascita(_security, codicefiscale);
            if (sesso == null) errori = "Errore nella decodifica del sesso";
            if (datanascita == null) errori = "Errore nella decodifica della data di nascita";


            object idcomune = DBNull.Value;
            object idnazione = DBNull.Value;

            if (italiano) {
                idcomune = InfoDaCodiceFiscale.comune(_conn, codicefiscale);
                if (idcomune == null || idcomune.ToString() == "") {
                    errori = $@"Impossibile ricavare il comune di nascita dal codice '{
                            codicefiscale.Substring(11, 4)
                        }'";
                    return newReg["idreg"];
                }
            }
            else {
                idnazione = InfoDaCodiceFiscale.nazione(_conn, codicefiscale);
                if (idnazione == null || idnazione.ToString() == "") {
                    errori = $@"Impossibile ricavare lo stato estero di nascita dal codice '{
                            codicefiscale.Substring(11, 4)
                        }'";
                    return newReg["idreg"];
                }
            }

            if (sesso != null) newReg["gender"] = sesso;
            if (datanascita != null) newReg["birthdate"] = datanascita;
            if (idcomune != null) newReg["idcity"] = idcomune;
            if (idnazione != null) newReg["idnation"] = idnazione;

            return newReg["idreg"];
        }


        private string getTracciato(string[] tracciato) {
            var res = "";
            var pos = 0;
            foreach (var t in tracciato) {
                var ss = t.Split(';');
                var field =
                    $"{ss[0].PadLeft(30)}: Pos.{pos.ToString().PadLeft(5)} lunghezza {ss[3].PadLeft(4)} Tipo: {ss[2].PadLeft(15)}";
                if (ss[2].ToLower() == "codificato") {
                    field += $" Codifica:{ss[4]}";
                }

                field += $" Descrizione: {ss[1]}";
                field += "\r\n";
                pos += CfgFn.GetNoNullInt32(ss[3]);
                res += field;
            }

            return res;
        }

        private DataTable getTableTracciato(IEnumerable<string> tracciato) {
            var pos = 0;
            var T = new DataTable("t");
            T.Columns.Add("nome", typeof(string));
            T.Columns.Add("posizione", typeof(int));
            T.Columns.Add("lunghezza", typeof(string));
            T.Columns.Add("tipo", typeof(string));
            T.Columns.Add("codifica", typeof(string));
            T.Columns.Add("Descrizione", typeof(string));

            foreach (var t in tracciato) {
                var r = T.NewRow();
                var ss = t.Split(';');
                r["nome"] = ss[0];
                r["posizione"] = pos;
                r["lunghezza"] = CfgFn.GetNoNullInt32(ss[3]);
                r["tipo"] = ss[2];
                if (ss.Length == 5) r["codifica"] = ss[4];
                r["Descrizione"] = ss[1];
                pos += CfgFn.GetNoNullInt32(ss[3]);
                T.Rows.Add(r);
            }

            return T;
        }


        private object excelGetField(string tracciatoField, object val, out string errore) {
            errore = "";

            var ff = tracciatoField.Split(';');
            var fieldname = ff[0].ToLower().Trim();
            var ftype = ff[2].ToLower().Trim(); //(intero/numero/stringa/codificato/data)

            errore = "";
            //int len = Convert.ToInt32(ff[3]);
            if (val == null) return DBNull.Value;
            if (val == DBNull.Value) return val;
            if (val.ToString() == "") return DBNull.Value;
            try {
                switch (ftype) {
                    case "intero": {
                        var x = val.ToString().Trim().TrimStart('0');
                        return x == "" ? 0 : Convert.ToInt32(x);
                    }
                    case "stringa":
                        return val.ToString().TrimEnd(' ');
                    case "numero":
                        decimal numero;
                        if (isNumeric(val, out numero))
                            return Convert.ToDecimal(numero);
                        //return decimal.Parse(val.ToString().Replace(",","."), CultureInfo.InvariantCulture);
                        else {
                            errore = " Errore interno nel tracciato per tipo numerico " + fieldname + " di tipo " +
                                     ftype + " e di valore " +
                                     val.ToString().Trim().TrimStart('0');
                            return DBNull.Value;
                        }
                    case "data": // DateTime.FromOADate and DateTime.ToOADate
                        //return DateTime.FromOADate(Convert.ToDouble(val));
                        return ToDatetime(val);
                    case "codificato": {
                        var codici = ff[4].Split('|');
                        if (codici.Any(t => val.ToString().ToLower() == t.ToLower())) {
                            return val;
                        }

                        errore = " Errore interno nel tracciato per tipo codificato " + fieldname + " di tipo " +
                                 ftype +
                                 " e di valore " +
                                 val.ToString().Trim().TrimStart('0');
                        return DBNull.Value;
                    }
                    default: {
                        errore = " Errore interno nel tracciato per tipo " + ftype + " e valore " +
                                 val.ToString().Trim().TrimStart('0');
                        return DBNull.Value;
                    }
                }
            }
            catch {
                errore = " Errore nella decodifica del campo " + fieldname + " di tipo " + ftype + " e di valore " +
                         val.ToString().Trim().TrimStart('0');
                return DBNull.Value;
            }

        }

        private static class ToCc {
            public static object getDate(object o) {
                if (o == null) return null;
                if (o == DBNull.Value) return null;
                if (o.GetType().ToString() == "DateTme") return o;

                DateTime d;
                var res = DateTime.TryParse(o.ToString(), out d);
                if (res) return d;
                return o;
            }

        }

        private object ToDatetime(object data) {
            if (data == DBNull.Value)
                return data;
            data = ToCc.getDate(data);
            var d = (DateTime) data;
            var minValue = new DateTime(1753, 1, 1);
            if (d < minValue)
                return minValue;
            var maxValue = new DateTime(9999, 12, 31);
            if (d > maxValue)
                return maxValue;

            return data;

        }


        /// <summary>
        /// Prende un valore dal foglio di excel, le riga partono da 1 e le colonne partono da 1
        /// </summary>
        /// <param name="colnumber"></param>
        /// <param name="fieldname"></param>
        /// <param name="r"></param>
        /// <param name="fase"></param>
        /// <param name="errore"></param>
        /// <returns></returns>
        object getVal(int colnumber, string fieldname, DataRow r, string fase, out string errore) {
            var fmt = fase == "faseuno"
                ? _tracciatoFlussostudentiFaseuno[colnumber - 1]
                : _tracciatoFlussostudentiFasedue[colnumber - 1];

            return excelGetField(fmt, r[fieldname], out errore);
        }

        bool verificaCrediti(DataTable dt) {
            clearAllDict();
            foreach (DataColumn c in dt.Columns) {
                if (!dt.Columns.Contains(c.ColumnName)) {
                    MessageBox.Show(this, "File non compatibile con il Tracciato del Flusso Studenti");
                    return false;
                }
            }


            if (!dt.Columns.Contains("riga")) {
                dt.Columns.Add("riga");
                dt.Columns["riga"].DataType = typeof(string);
                dt.Columns["riga"].Caption = "Riga";
            }

            if (!dt.Columns.Contains("errori")) {
                dt.Columns.Add("errori");
                dt.Columns["errori"].DataType = typeof(string);
                dt.Columns["errori"].Caption = "Errori";
            }

            DataSet ds1;
            if (dt.DataSet == null) {
                ds1 = new DataSet();
                ds1.Tables.Add(dt);
            }
            else {
                ds1 = dt.DataSet;
            }

            dgrCrediti.SetDataBinding(ds1, dt.TableName);

            HelpForm.SetDataGrid(dgrCrediti, dt);
            HelpForm.SetGridStyle(dgrCrediti, dt);

            var ok = dt.Rows.Count != 0;

            var nrigacorrente = 1;

            var errCf = false;
            foreach (DataRow r in dt.Rows) {
                // Ciclare su DataTable
                // string lastcol = ExcelColumnFromNumber(tracciato_flussostudenti_faseuno.Length);
                //string row = nrigacorrente.ToString();
                string errore;
                var err = "";
                object oDataContabileOld = DBNull.Value;
                var oCodiceFiscaleStudente = getVal(1, "codice_fiscale_studente", r, "faseuno", out errore);
                if (errore != "") err = err + " " + errore;
                if (oCodiceFiscaleStudente == DBNull.Value) break;

                getVal(2, "causale", r, "faseuno", out errore);
                if (errore != "") err = err + " " + errore;
                getVal(3, "codice_bollettino_univoco", r, "faseuno", out errore);
                if (errore != "") err = err + " " + errore;
                getVal(4, "operazione", r, "faseuno", out errore);
                if (errore != "") err = err + " " + errore;
                getVal(5, "data_inizio_competenza", r, "faseuno", out errore);
                if (errore != "") err = err + " " + errore;
                getVal(6, "data_fine_competenza", r, "faseuno", out errore);
                if (errore != "") err = err + " " + errore;
                var oCodiceCausaleEpRicavo = getVal(7, "codice_causale_ep_ricavo", r, "faseuno", out errore);
                if (errore != "") err = err + " " + errore;
                var oCodiceCausaleEpCredito = getVal(8, "codice_causale_ep_credito", r, "faseuno", out errore);
                if (errore != "") err = err + " " + errore;
                var oCodiceCausaleFinanziaria = getVal(9, "codice_causale_finanziaria", r, "faseuno", out errore);
                if (errore != "") err = err + " " + errore;
                var oCodiceUpb = getVal(10, "codice_upb", r, "faseuno", out errore);
                if (errore != "") err = err + " " + errore;
                var oImporto = getVal(11, "importo", r, "faseuno", out errore);
                if (errore != "") err = err + " " + errore;
                var oCodiceTipoContratto = getVal(12, "codice_tipo_contratto", r, "faseuno", out errore);
                if (errore != "") err = err + " " + errore;
                var oDataContabile = getVal(13, "data_contabile", r, "faseuno", out errore);
                if (errore != "") err = err + " " + errore;
                getVal(14, "nome_studente", r, "faseuno", out errore);
                if (errore != "") err = err + " " + errore;
                getVal(15, "cognome_studente", r, "faseuno", out errore);
                if (errore != "") err = err + " " + errore;


                if (err != "") ok = false;

                if (CfgFn.GetNoNullDecimal(oImporto) <= 0) {
                    errore = " Valore non previsto per il campo importo" + " di valore " +
                             oImporto.ToString().Trim() + " : inserire un importo maggiore di zero";
                    err += " " + errore;
                    ok = false;

                }

                CalcolaCodiceFiscale.CheckCF(oCodiceFiscaleStudente.ToString(), out errore);

                if (errore != "") {
                    errore = $" Nel codice fiscale {oCodiceFiscaleStudente} compaiono i seguenti errori: {errore}";
                    err += " " + errore;
                    errCf = true;
                    // ok = false;
                }

                var idupb = getIdUpb(oCodiceUpb, out errore);
                if (idupb == DBNull.Value && errore != "") {
                    err += " " + errore;
                    ok = false;
                }

                var idcausaleEpRicavo = getCausaleEp(oCodiceCausaleEpRicavo, out errore);
                if ((idcausaleEpRicavo == DBNull.Value) && (errore != "")) {
                    err += " " + errore;
                    ok = false;
                }

                var idcausaleEpCredito = getCausaleEp(oCodiceCausaleEpCredito, out errore);
                if ((idcausaleEpCredito == DBNull.Value) && (errore != "")) {
                    err += " " + errore;
                    ok = false;
                }

                var idcodiceTipoContratto = checkTipoContrattoAttivo(oCodiceTipoContratto, out errore);
                if ((idcodiceTipoContratto == null) && (errore != "")) {
                    err += " " + errore;
                    ok = false;
                }

                var idCodiceCausaleFinanziaria = getFinMotive(oCodiceCausaleFinanziaria, out errore);
                if ((idCodiceCausaleFinanziaria == DBNull.Value) && (errore != "")) {
                    err += " " + errore;
                    ok = false;
                }

                var idfin = getBilancioFromCausaleFin(idCodiceCausaleFinanziaria, out errore);
                if ((idfin == DBNull.Value) && (errore != "")) {
                    err += " " + errore;
                    ok = false;
                }

                var idsorSiope = getSiopeForAccMotive(idcausaleEpRicavo, out errore);
                if ((idsorSiope == null) && (errore != "")) {
                    err += " " + errore;
                    ok = false;
                }

                if (oDataContabile == DBNull.Value) {
                    errore = "La data contabile � obbligatoria";
                    err += " " + errore;
                    ok = false;
                }

                if ((oDataContabileOld != DBNull.Value) && (oDataContabileOld != oDataContabile)) {
                    errore = "Le righe del file devono avere tutte la stessa data contabile";
                    err += " " + errore;
                    ok = false;
                }


                r["riga"] = nrigacorrente;
                //R["codice_fiscale_studente"] = o_codice_fiscale_studente;
                //R["causale"] = o_causale;
                //R["codice_bollettino_univoco"] = o_codice_bollettino_univoco;
                //R["operazione"] = o_operazione;
                //R["data_inizio_competenza"] = o_data_inizio_competenza;
                //R["data_fine_competenza"] = o_data_fine_competenza;
                //R["codice_causale_ep_ricavo"] = o_codice_causale_ep_ricavo;
                //R["codice_causale_ep_credito"] = o_codice_causale_ep_credito;
                //R["codice_causale_finanziaria"] = o_codice_causale_finanziaria;
                //R["codice_upb"] = o_codice_upb;
                //R["importo"] = o_importo;
                //R["codice_tipo_contratto"] = o_codice_tipo_contratto;
                //R["data_contabile"] = o_data_contabile;
                //R["nome_studente"] = o_nome_studente;
                //R["cognome_studente"] = o_cognome_studente;
                r["errori"] = err;

                nrigacorrente++;
            }

            if (errCf && ok) {
                MessageBox.Show(this,
                    "Si sono verificati errori nella convalida di alcuni codici fiscali, potrebbero essere generate anagrafiche incomplete");
            }

            if (ok) {
                MessageBox.Show(this, "Importate " + (nrigacorrente - 1) + " righe.");
                //btnelaboraFlussoCrediti.Enabled = true;
            }


            return ok;
        }

        /// <summary>
        /// Genera le  scritture e movimenti di budget per tutti i contratti attivi nel dataset DS
        /// Effettua letture in estimatedetail per ogni riga di estimate
        /// </summary>
        /// <returns></returns>
        bool generaScrittureContrattiAttivi() {
            foreach (var rEstim in DS.estimate) {
                DS.estimatedetail.Clear();
                DS.estimatedetail.safeMergeFromDb(_conn, q.mCmp(rEstim, "idestimkind", "yestim", "nestim"));
                var epm = new EP_Manager(_meta as MetaData, null, null, null, null, null, null, null, null, "estimate");
                epm.disableIntegratedPosting();
                epm.silent = true;
                epm.setForcedCurrentRow(rEstim);
                epm.afterPost(true);
            }

            if (DS.estimate.Rows.Count > 0) {
                MessageBox.Show("Le scritture sui contratti attivi sono state generate.","Avviso");
            }
            return true;
        }

        /// <summary>
        /// Effettua letture in invoicedetail per ogni riga di DS.invoice
        /// </summary>
        /// <returns></returns>
        void generoScrittureFatture() {
            foreach (var rInvoice in DS.invoice) {
                DS.invoicedetail.Clear();
                DS.invoicedetail.safeMergeFromDb(_conn, q.mCmp(rInvoice, "idinvkind", "yinv", "ninv"));
                var epm = new EP_Manager(_meta as MetaData, null, null, null, null, null, null, null, null, "invoice");
                epm.disableIntegratedPosting();
                epm.silent = true;
                epm.setForcedCurrentRow(rInvoice);
                epm.afterPost(true);
            }

            if (DS.invoice.Rows.Count > 0) MessageBox.Show("Le scritture sulle fatture sono state generate.", "Avviso");
        }

        ///// <summary>
        ///// Salva il Dataset e genera le scritture dei c.attivi
        ///// </summary>
        ///// <returns></returns>
        //bool salvaeGeneraScritture() {
        //    var myPostData = new Easy_PostData();
        //    myPostData.initClass(DS, _conn);
        //    var res = myPostData.DO_POST();
        //    if (res) {
        //        res = generaScrittureContrattiAttivi();
        //    }

        //    return res;
        //}

        void fillMovimento(DataRow eS, object idman, object idreg, string description) {
            if (idreg == null) idreg = DBNull.Value;
            if (idman == null) idman = DBNull.Value;

            var dataCont = _security.GetDataContabile();
            eS.BeginEdit();
            eS["ymov"] = esercizio;
            eS["adate"] = dataCont;
            eS["idman"] = idman;
            //E_S["idunderwriting"] = idunderwriting;
            eS["idreg"] = idreg;
            eS["description"] = description;
            //E_S["amount"]=CfgFn.RoundValuta(amount);
            eS.EndEdit();
        }


        void fillImputazioneMovimento(DataRow impMov, decimal amount, object idfin, object idupb) {
            impMov["amount"] = amount;
            impMov["idfin"] = idfin;
            impMov["idupb"] = idupb;
        }


        private readonly Dictionary<string, int> _accMotiveSiope = new Dictionary<string, int>();

        int? getSiopeForAccMotive(object idaccmotive, out string errori) {
            errori = "";

            if (idaccmotive == DBNull.Value || idaccmotive == null) {
                errori = " La causale di Ricavo non � stata specificata";
                return null;
            }

            var sIdAccMotive = idaccmotive.ToString();
            if (_accMotiveSiope.ContainsKey(idaccmotive.ToString())) return _accMotiveSiope[sIdAccMotive];
            var idsor = _conn.readValue("accmotivesortingview",
                q.eq("idaccmotive", sIdAccMotive) & q.eq("idsorkind", _idsorkindSiopeE), "idsor");
            if (idsor == null || idsor == DBNull.Value) {
                string codeMotive = _conn.readValue("accmotive", q.eq("idaccmotive", idaccmotive), "codemotive")?.ToString();
                errori = " La causale di Ricavo " + (codeMotive??"") +
                         " deve essere associata a un codice SIOPE. E' necessario completare la configurazione.";
                return null;
            }

            _accMotiveSiope[sIdAccMotive] = CfgFn.GetNoNullInt32(idsor);
            return _accMotiveSiope[sIdAccMotive];

        }

        private readonly Dictionary<int, object> _sospesiAttivi = new Dictionary<int, object>();
        private readonly Dictionary<int, object> _causaliSospesiAttivi = new Dictionary<int, object>();
        private readonly Dictionary<string, int> _sospesiAttiviByCausali = new Dictionary<string, int>();

        object getSospesiAttivi(object numeroSospesoAttivo, out string errori) {
            errori = "";
            if (numeroSospesoAttivo == DBNull.Value || numeroSospesoAttivo == null) return DBNull.Value;
            var numeroSospesoAttivoI = CfgFn.GetNoNullInt32(numeroSospesoAttivo);
            if (numeroSospesoAttivoI == 0) return DBNull.Value;
            if (_sospesiAttivi.ContainsKey(numeroSospesoAttivoI)) return _sospesiAttivi[numeroSospesoAttivoI];
            var filter = _qhs.AppAnd(_qhs.CmpEq("ybill", esercizio), _qhs.CmpEq("billkind", "C"),
                _qhs.CmpEq("nbill", numeroSospesoAttivoI));
            var t = _conn.SQLRunner($"select nbill  from bill   where {filter}", false);
            if (t == null) {
                errori = "Errore nell'accesso al db" + _conn.SecureGetLastError();
                return DBNull.Value;
            }

            if (t.Rows.Count == 0) {
                errori = "Il sospeso attivo n�" + numeroSospesoAttivo +
                         " non � ancora presente su DB. E' necessario eseguire prima l'importazione del giornale di Cassa. ";
                _sospesiAttivi[numeroSospesoAttivoI] = DBNull.Value;
                return DBNull.Value;
            }
            else {
                _sospesiAttivi[numeroSospesoAttivoI] = t.Rows[0]["nbill"];
                return _sospesiAttivi[numeroSospesoAttivoI];
            }

        }

        private readonly Dictionary<string, string> _tipoContrattoAttivoGestioneDifferita =
            new Dictionary<string, string>();

        string getGestioneDifferita(object idestimkind, out string errori) {
            errori = "";
            if (idestimkind == DBNull.Value || idestimkind == null) return "S";
            string sIdEstimKind = idestimkind.ToString();
            if (_tipoContrattoAttivoGestioneDifferita.ContainsKey(sIdEstimKind))
                return _tipoContrattoAttivoGestioneDifferita[sIdEstimKind];

            var oFlag = _conn.readValue("estimatekind", q.eq("idestimkind", idestimkind), "flag");
            if (oFlag == null || oFlag == DBNull.Value) {
                errori = $"Il tipo contratto attivo  {idestimkind} non � stato trovato";
                return "N";
            }

            var flag = CfgFn.GetNoNullInt32(oFlag);
            var differita = CfgFn.DecodeToString(flag, 1);
            _tipoContrattoAttivoGestioneDifferita[sIdEstimKind] = differita;
            return differita;
        }

        private readonly Dictionary<string, string> _tipoContrattoAttivoCollegabileAFattura =
            new Dictionary<string, string>();

        bool getCollegabileAFattura(object idestimkind) {
            if (idestimkind == DBNull.Value || idestimkind == null)return  true;
            var sIdEstimKind = idestimkind.ToString();

            if (_tipoContrattoAttivoCollegabileAFattura.ContainsKey(sIdEstimKind))
                return _tipoContrattoAttivoCollegabileAFattura[sIdEstimKind].ToString()=="S";

            var linktoinvoice = _conn.readValue("estimatekind", q.eq("idestimkind", idestimkind), "linktoinvoice");
            if (linktoinvoice == null || linktoinvoice == DBNull.Value) {
                MessageBox.Show( $"Il tipo contratto attivo  {sIdEstimKind} non � stato trovato","Errore");
                return false;
            }

            _tipoContrattoAttivoCollegabileAFattura[sIdEstimKind] = linktoinvoice.ToString().ToUpper();
            return _tipoContrattoAttivoCollegabileAFattura[sIdEstimKind].ToString()=="S";
        }

        private readonly Dictionary<string, DataRow> _attrsContrattoAttivo = new Dictionary<string, DataRow>();

        private DataRow getAttributiTipoContrattoAttivo(object idestimkind, out string errore) {
            errore = "";

            if (idestimkind == null || DBNull.Value.Equals(idestimkind)) {
                errore = "Il tipo di contratto attivo dev'essere specificato.";
                return null;
            }

            var sIdEstimKind = idestimkind.ToString();
            if (_attrsContrattoAttivo.ContainsKey(sIdEstimKind)) {
                return _attrsContrattoAttivo[sIdEstimKind];
            }

            var dt = _conn.readTable("estimatekind", q.eq("idestimkind", idestimkind),
                "idsor01, idsor02, idsor03, idsor04, idsor05");

            if (dt == null || dt.Rows.Count == 0) {
                errore = $"Il tipo contratto attivo '{idestimkind}' non � stato trovato.";
                return null;
            }

            _attrsContrattoAttivo[sIdEstimKind] = dt.Rows[0];
            return dt.Rows[0];
        }

        private readonly Dictionary<string, DataRow> _attrsUpb = new Dictionary<string, DataRow>();

        private DataRow getAttributiUpb(object idupb, out string errore) {
            errore = "";
            if (idupb == null || DBNull.Value.Equals(idupb)) {
                //errore = "L'identificativo dell'UPB dev'essere specificato.";
                return null;
            }

            var sIdUpb = idupb.ToString();

            if (_attrsUpb.ContainsKey(sIdUpb)) {
                return _attrsUpb[sIdUpb];
            }

            var dt = _conn.readTable("upb", q.eq("idupb", idupb), "idsor01, idsor02, idsor03, idsor04, idsor05");
            if (dt == null || dt.Rows.Count == 0) {
                errore = $@"L'UPB con identificativo '{sIdUpb}' non � stato trovato.";
                return null;
            }

            _attrsUpb[sIdUpb] = dt.Rows[0];
            return dt.Rows[0];
        }

        object getCausaliSospesiAttivi(object numeroSospesoAttivo, out string errori) {
            errori = "";
            if (numeroSospesoAttivo == DBNull.Value || numeroSospesoAttivo == null) return null;
            var numeroSospesoAttivoI = CfgFn.GetNoNullInt32(numeroSospesoAttivo);
            if (numeroSospesoAttivoI == 0) return null;
            if (_causaliSospesiAttivi.ContainsKey(numeroSospesoAttivoI))
                return _causaliSospesiAttivi[numeroSospesoAttivoI];

            var causaleSospeso = _conn.readValue("bill",
                q.eq("ybill", esercizio) & q.eq("billkind", "C") & q.eq("nbill", numeroSospesoAttivoI), "motive");

            if (causaleSospeso == null || causaleSospeso == DBNull.Value) {
                errori =
                    $@"Il sospeso attivo n�{
                            numeroSospesoAttivo
                        } non � ancora presente su DB. E' necessario eseguire prima l'importazione del giornale di Cassa. ";
                return DBNull.Value;
            }

            _causaliSospesiAttivi[numeroSospesoAttivoI] = causaleSospeso;
            return causaleSospeso;

        }



        /// <summary>
        /// Ottiene il numero di sospeso ricercando mediante il campo  causale (motive), esercizio e tipo (Credito)
        /// </summary>
        /// <param name="causale"></param>
        /// <returns></returns>
        int? getSospesiAttiviFromCausali(string causale) {
            if (string.IsNullOrEmpty(causale)) return null;

            if (_sospesiAttiviByCausali.ContainsKey(causale)) return _sospesiAttiviByCausali[causale];

            // non ha trovato la coppia causale / numero sospeso
            var causalePerConfronto = causale;
            if (!causalePerConfronto.StartsWith("/PUR/LGPE-RIVERSAMENTO/URI/")) {
                causalePerConfronto = $"/PUR/LGPE-RIVERSAMENTO/URI/{causale}";
            }

            var filter = q.eq("ybill", esercizio) & q.eq("billkind", "C") & q.like("motive", "%"+causalePerConfronto + "%");
            var nbill = _conn.readValue("bill", filter, "nbill");

            if ((nbill == null || nbill == DBNull.Value) && causale!=causalePerConfronto) {
                filter = q.eq("ybill", esercizio) & q.eq("billkind", "C") & q.like("motive", causalePerConfronto + "%");
                nbill = _conn.readValue("bill", filter, "nbill");
            }

            if (nbill == null || nbill == DBNull.Value) {
                //errori = "Il sospeso attivo avente causale " + causale +
                //         " non � ancora presente su DB. E' necessario eseguire prima l'importazione del giornale di Cassa. ";
                return null;
            }

            _sospesiAttiviByCausali[causale] = CfgFn.GetNoNullInt32(nbill);
            return _sospesiAttiviByCausali[causale];
        }


        /// <summary>
        /// Verifica che i dettagli contratto attivo aventi un dato codiceBollettinoUnivoco sia pari ad un valore dato
        /// </summary>
        /// <param name="codiceBollettinoUnivoco"></param>
        /// <param name="importo"></param>
        /// <param name="errMess"></param>
        /// <returns></returns>
        bool verifyImportoTotaleIncasso(object codiceBollettinoUnivoco, decimal importo, out string errMess) {
            // Questo metodo verifica che ogni incasso della fase "due" abbia un importo che copra completamente
            // la somma dei dettagli contratto attivo non annullati (stop = null) a parit� di codice bollettino univoco 
            errMess = "";
            var rows = DS.estimatedetail._getFromDb(_conn,
                q.eq("iduniqueformcode", codiceBollettinoUnivoco) & q.isNull("stop") );

            var sumAmountDettagli = rows.Sum(r1 => CfgFn.GetNoNullDecimal(r1["taxable"]));

            if (sumAmountDettagli == importo) return true;
            errMess += "Il bollettino n� " + codiceBollettinoUnivoco + " non pu� essere incassato." +
                       " Il suo importo " + importo +
                       " non � uguale alla somma dei dettagli dei contratti attivi" +
                       " non annullati che � pari a :" + sumAmountDettagli;

            return false;
        }

        void fillIncomeSorted(DataRow newMovRow, object idsor, decimal amount) {
            if (idsor == DBNull.Value || idsor == null) return;

            var metaSortedMov = _dispatcher.Get("incomesorted");
            metaSortedMov.SetDefaults(DS.incomesorted);
            DS.Tables["incomesorted"].Columns["idsor"].DefaultValue = idsor;
            var sortedMovRow = metaSortedMov.Get_New_Row(newMovRow, DS.incomesorted);
            sortedMovRow["idsor"] = idsor;
            sortedMovRow["amount"] = amount;
            sortedMovRow["idinc"] = newMovRow["idinc"];
            sortedMovRow["ayear"] = esercizio;
            sortedMovRow["cu"] = "import";
            sortedMovRow["ct"] = DateTime.Now;
            sortedMovRow["lu"] = "import";
            sortedMovRow["lt"] = DateTime.Now;
        }

        /// <summary>
        /// Metodo che importa una tabella con un formato concordato con l'universit� di Roma Tor Vergata
        /// In particolare la tabella contiene il codice bollettino univoco (per noi iduniqueformcode) ed il numero di sospeso attivo.
        /// </summary>
        /// <param name="dt"></param>
        /// <returns></returns>
        void importaTabellaFlussoIncassi(DataTable dt) {
            var dtToImport = dt;

            DS.flussoincassi.Clear();
            DS.flussoincassidetail.Clear();
            RowChange.SetOptimized(DS.flussoincassi,true);
            RowChange.ClearMaxCache(DS.flussoincassi);
            RowChange.SetOptimized(DS.flussoincassidetail,true);
            RowChange.ClearMaxCache(DS.flussoincassidetail);

            // riempie il Dataset con le righe degli incassi e dei dettagli
            // a partire dalla tabella temporanea mData1

            var metaFlussoIncassi = _dispatcher.Get("flussoincassi");
            metaFlussoIncassi.SetDefaults(DS.flussoincassi);
            MetaData.SetDefault(DS.flussoincassi, "ayear", _security.GetEsercizio());

            var metaFlussoIncassiDetail = _dispatcher.Get("flussoincassidetail");
            metaFlussoIncassiDetail.SetDefaults(DS.flussoincassi);

            if (dtToImport.Select().Length > 0) {
                var view = new DataView(dtToImport) {Sort = "data_incasso,numero_sospeso_attivo"};
               
                var newTable = view.ToTable(true, "data_incasso", "numero_sospeso_attivo");
                // Ciclo per la creazione di una riga in Flusso Incassi
                foreach (var rFlusso in newTable.Select()) {
                    var oNumeroSospesoAttivo = rFlusso["numero_sospeso_attivo"];
                    var oDataIncasso = rFlusso["data_incasso"];
                    object iuv = DBNull.Value;
                    string errore;
                    var causale = getCausaliSospesiAttivi(oNumeroSospesoAttivo, out errore);
                    if (causale == null) {
                        DS.flussoincassi.Clear();
                        DS.flussoincassidetail.Clear();
                        MessageBox.Show(
                            "Ci sono righe senza numero di sospeso attivo, l'importazione non pu� essere effettuata.",
                            "Errore");
                        return;
                    }
                    var rNewFlussoIncassi = metaFlussoIncassi.Get_New_Row(null, DS.flussoincassi);
                    rNewFlussoIncassi["codiceflusso"] = Path.GetFileName(fileName);
                    rNewFlussoIncassi["trn"] = DBNull.Value;
                    rNewFlussoIncassi["causale"] = causale;

                    if (causale.ToString().ToUpper().StartsWith("/RFS/") ||
                        causale.ToString().ToUpper().StartsWith("/RFB/")) {
                        string[] parts = causale.ToString().ToUpper().Split('/');
                        iuv = parts[1];
                    }

                    rNewFlussoIncassi["dataincasso"] = oDataIncasso;
                    rNewFlussoIncassi["nbill"] = oNumeroSospesoAttivo;

                    rNewFlussoIncassi["ct"] = DateTime.Now;
                    rNewFlussoIncassi["cu"] = "import_flussostudenti";
                    rNewFlussoIncassi["lt"] = DateTime.Now;
                    rNewFlussoIncassi["lu"] = "import_flussostudenti";


                    // Ciclo per creare le righe corrispondenti in flussoincassiDetail
                    object idupb = null;
                    decimal importoTotaleFlusso = 0;
                    foreach (var rFlussoDetail in dtToImport._Filter(
                        q.eq("data_incasso", oDataIncasso) & q.eq("numero_sospeso_attivo", oNumeroSospesoAttivo))) {
                        var oCodiceBollettinoUnivoco = rFlussoDetail["codice_bollettino_univoco"];
                        var oImporto = rFlussoDetail["importo"];
                        var oCodiceFiscaleStudente = rFlussoDetail["codice_fiscale_studente"];

                        var rNewFlussoIncassiDetail =
                            metaFlussoIncassiDetail.Get_New_Row(rNewFlussoIncassi, DS.flussoincassidetail);
                        rNewFlussoIncassiDetail["importo"] = oImporto;
                        rNewFlussoIncassiDetail["iduniqueformcode"] = oCodiceBollettinoUnivoco;
                        rNewFlussoIncassiDetail["cf"] = oCodiceFiscaleStudente;
                        rNewFlussoIncassiDetail["cu"] = "import_flussostudenti";
                        rNewFlussoIncassiDetail["lu"] = "import_flussostudenti";
                        rNewFlussoIncassiDetail["iuv"] = iuv;
                        //Ad un flusso incassi potrebbero essere collegati crediti aventi pi� upb, che potrebbero avere attributi di sicurezza discordi
                        if (idupb == null || idupb == DBNull.Value) {
                            if (idupb == DBNull.Value) {
                                idupb = _conn.readValue("flussocreditidetail",
                                    q.eq("iduniqueformcode", oCodiceBollettinoUnivoco) & q.isNotNull("idupb"),
                                    "min(idupb)");
                            }
                        }

                        importoTotaleFlusso += CfgFn.GetNoNullDecimal(oImporto);
                    }

                    if (idupb != null && idupb != DBNull.Value) {
                        var attrs = getAttributiUpb(idupb, out errore);
                        if (attrs != null) {
                            rNewFlussoIncassi["idsor01"] = attrs["idsor01"];
                            rNewFlussoIncassi["idsor02"] = attrs["idsor02"];
                            rNewFlussoIncassi["idsor03"] = attrs["idsor03"];
                            rNewFlussoIncassi["idsor04"] = attrs["idsor04"];
                            rNewFlussoIncassi["idsor05"] = attrs["idsor05"];
                        }
                    }

                    rNewFlussoIncassi["importo"] = importoTotaleFlusso;
                }
            }

            var myPostData = new Easy_PostData();
            myPostData.initClass(DS, _conn);
            var res = myPostData.DO_POST();

            if (!res) {
                MessageBox.Show(this, "Errore nel salvataggio");
                return;
            }

            MessageBox.Show(this, "Elaborazione  completata");
        }

        /// <summary>
        /// Riempie la tabella flusso crediti in base al tracciato excel concordato con Roma Tor Vergata
        /// </summary>
        /// <param name="dtToImport"></param>
        /// <returns></returns>
        void importaFlussoCrediti(DataTable dtToImport) {
            // Riempie le tabelle flussocrediti e flussocreditidetail
            _registry.Clear();
            DS.flussocrediti.Clear();
            DS.flussocreditidetail.Clear();
            DS.estimate.Clear();
            DS.estimatedetail.Clear();
            DS.invoice.Clear();
            DS.invoicedetail.Clear();
            DS.ivaregister.Clear();
            DS.registry.Clear();
            // riempie il Dataset con le righe de i crediti e dei dettagli
            // a partire dalla tabella temporanea mData 

            var metaFlussoCrediti = _dispatcher.Get("flussocrediti");
            metaFlussoCrediti.SetDefaults(DS.flussocrediti);

            var metaFlussoCreditiDetail = _dispatcher.Get("flussocreditidetail");
            metaFlussoCreditiDetail.SetDefaults(DS.flussocreditidetail);

            if (dtToImport.Rows.Count > 0) {
                //Salvataggio preventivo anagrafiche
                string errore;
                foreach (DataRow rr in dtToImport.Rows) {
                    var oCodiceFiscaleStudente = rr["codice_fiscale_studente"];

                    if ((oCodiceFiscaleStudente == null) || (oCodiceFiscaleStudente == DBNull.Value)) {
                        DS.registry.Clear();
                        MessageBox.Show(this, "Codice fiscale studente non valorizzato", "Errore");
                        return;
                    }

                    var oNomeStudente = rr["nome_studente"];
                    var oCognomeStudente = rr["cognome_studente"];

                    // Aggiunta dell'eventuale anagrafica                    
                    var idcausaleEpCredito = getCausaleEp(rr["codice_causale_ep_credito"], out errore);
                    if ((idcausaleEpCredito == DBNull.Value) && (errore != "")) {
                        DS.registry.Clear();
                        MessageBox.Show(errore, "Errore");
                        return;
                    }

                    var oIdreg = creaAnagraficaSeNonEsiste(oCodiceFiscaleStudente, oNomeStudente, oCognomeStudente,
                        idcausaleEpCredito, DBNull.Value,
                        out errore);
                    if (oIdreg == DBNull.Value) {
                        DS.registry.Clear();
                        MessageBox.Show(errore, "Errore in creazione nuova anagrafica");
                        return;
                    }
                }

                var myPostD = new Easy_PostData();
                myPostD.initClass(DS, _conn);
                var resPost = myPostD.DO_POST();
                if (!resPost) return;

              
                if (!resPost) return;

                _registry.Clear();
                foreach (DataRow r in DS.registry.Rows) {
                    _registry[r["cf"].ToString().ToUpper()] = CfgFn.GetNoNullInt32(r["idreg"]);
                }

                // leggo la prima riga in quanto dovr� creare un solo contratto con tanti dettagli 
                // quante sono le anagrafiche pertanto data contabile, tipo contratto e causale ricavo saranno uguali
                var rFirst = dtToImport.Rows[0];
                var idestimkind = checkTipoContrattoAttivo(rFirst["codice_tipo_contratto"], out errore);

                var oDataContabile = rFirst["data_contabile"];
                var rNewFlussoCrediti = metaFlussoCrediti.Get_New_Row(null, DS.flussocrediti);

                // Nota: aggiungere la gestione degli errori
                var attrs = getAttributiTipoContrattoAttivo(idestimkind, out errore);
                if (attrs == null) {
                    MessageBox.Show(errore, "");
                    return;
                }

                rNewFlussoCrediti["datacreazioneflusso"] = _security.GetSys("datacontabile");
                rNewFlussoCrediti["flusso"] = DBNull.Value;
                rNewFlussoCrediti["istransmitted"] =
                    "S"; //il flusso che importiamo si intenda gi� trasmesso da un programma esterno
                rNewFlussoCrediti["filename"] = fileName;
                rNewFlussoCrediti["docdate"] = oDataContabile;
                rNewFlussoCrediti["idestimkind"] = idestimkind;
                rNewFlussoCrediti["idsor01"] = attrs["idsor01"];
                rNewFlussoCrediti["idsor02"] = attrs["idsor02"];
                rNewFlussoCrediti["idsor03"] = attrs["idsor03"];
                rNewFlussoCrediti["idsor04"] = attrs["idsor04"];
                rNewFlussoCrediti["idsor05"] = attrs["idsor05"];
                rNewFlussoCrediti["ct"] = DateTime.Now;
                rNewFlussoCrediti["cu"] = "import_flussostudenti";
                rNewFlussoCrediti["lt"] = DateTime.Now;
                rNewFlussoCrediti["lu"] = "import_flussostudenti";
                var rFlussoCrediti = rNewFlussoCrediti;
                List<string> bollettiniAnnullati= new List<string>();

                // Ciclo per la creazione di una riga in Flusso CreditiDetail
                foreach (DataRow rigaTracciatoCrediti in dtToImport.Rows) {
                    var oCodiceBollettinoUnivoco = rigaTracciatoCrediti["codice_bollettino_univoco"];
                    var oImporto = rigaTracciatoCrediti["importo"];
                    var oOperazione = rigaTracciatoCrediti["operazione"];
                    oDataContabile = rigaTracciatoCrediti["data_contabile"];
                    var idupb = getIdUpb(rigaTracciatoCrediti["codice_upb"], out errore);

                    //object stop = rFlussoDetail["data_scadenza"];
                    var competencystart = rigaTracciatoCrediti["data_inizio_competenza"];
                    var competencystop = rigaTracciatoCrediti["data_fine_competenza"];
                    var description = rigaTracciatoCrediti["causale"];

                    if ((idupb == DBNull.Value) && (errore != "")) {
                        MessageBox.Show(errore, "");
                        return;
                    }

                    var idCodiceCausaleFinanziaria = getFinMotive(rigaTracciatoCrediti["codice_causale_finanziaria"],
                        out errore);
                    if ((idCodiceCausaleFinanziaria == DBNull.Value) && (errore != "")) {
                        MessageBox.Show(errore, "");
                        return;
                    }

                    var idcausaleEpRicavo = getCausaleEp(rigaTracciatoCrediti["codice_causale_ep_ricavo"], out errore);
                    if ((idcausaleEpRicavo == DBNull.Value) && (errore != "")) {
                        MessageBox.Show(errore, "");
                        return;
                    }

                    var idcausaleEpCredito =
                        getCausaleEp(rigaTracciatoCrediti["codice_causale_ep_credito"], out errore);
                    if ((idcausaleEpCredito == DBNull.Value) && (errore != "")) {
                        MessageBox.Show(errore, "");
                        return;
                    }

                    var oCodiceFiscaleStudente = rigaTracciatoCrediti["codice_fiscale_studente"];
                    var oNomeStudente = rigaTracciatoCrediti["nome_studente"];
                    var oCognomeStudente = rigaTracciatoCrediti["cognome_studente"];

                    // Aggiunta dell'eventuale anagrafica

                    var oIdreg = creaAnagraficaSeNonEsiste(oCodiceFiscaleStudente, oNomeStudente, oCognomeStudente,
                        idcausaleEpCredito, null,
                        out errore);
                    if (oIdreg == DBNull.Value) {
                        MessageBox.Show(errore, "Errore in creazione nuova anagrafica");
                        continue;
                    }

                    if (oOperazione.ToString() == "I") {
                        #region inserimento nuovo dettaglio credito in base alla riga del tracciato

                        var rNewFlussocreditiDetail =
                            metaFlussoCreditiDetail.Get_New_Row(rFlussoCrediti, DS.flussocreditidetail) as
                                flussocreditidetailRow;
                        // NON compiliamo lo IUV 
                        //rNewFlussocreditiDetail["idflusso"] =  ;
                        //rNewFlussocreditiDetail["iddetail"] =  ;
                        // ReSharper disable once PossibleNullReferenceException
                        rNewFlussocreditiDetail["importoversamento"] = oImporto;
                        rNewFlussocreditiDetail["idestimkind"] = DBNull.Value;
                        rNewFlussocreditiDetail["yestim"] = DBNull.Value;
                        rNewFlussocreditiDetail["nestim"] = DBNull.Value;
                        rNewFlussocreditiDetail["rownum"] = DBNull.Value;
                        rNewFlussocreditiDetail["idinvkind"] = DBNull.Value;
                        rNewFlussocreditiDetail["yinv"] = DBNull.Value;
                        rNewFlussocreditiDetail["ninv"] = DBNull.Value;
                        rNewFlussocreditiDetail["invrownum"] = DBNull.Value;
                        rNewFlussocreditiDetail["idfinmotive"] = idCodiceCausaleFinanziaria;
                        rNewFlussocreditiDetail["iduniqueformcode"] = oCodiceBollettinoUnivoco;
                        rNewFlussocreditiDetail["idaccmotiverevenue"] = idcausaleEpRicavo;
                        rNewFlussocreditiDetail["idaccmotivecredit"] = idcausaleEpCredito;
                        rNewFlussocreditiDetail["idaccmotiveundotax"] = DBNull.Value;
                        rNewFlussocreditiDetail["idaccmotiveundotaxpost"] = DBNull.Value;
                        //rNewFlussocreditiDetail["start"] = DBNull.Value;
                        rNewFlussocreditiDetail["stop"] = DBNull.Value;
                        rNewFlussocreditiDetail["competencystart"] = competencystart;
                        rNewFlussocreditiDetail["competencystop"] = competencystop;
                        rNewFlussocreditiDetail["description"] = description;
                        rNewFlussocreditiDetail["cf"] = oCodiceFiscaleStudente.ToString().ToUpper();

                        rNewFlussocreditiDetail["idreg"] = oIdreg;
                        rNewFlussocreditiDetail["idupb"] = idupb;
                        rNewFlussocreditiDetail["ct"] = DateTime.Now;
                        rNewFlussocreditiDetail["cu"] = "import_flussostudenti";
                        rNewFlussocreditiDetail["lt"] = DateTime.Now;
                        rNewFlussocreditiDetail["lu"] = "import_flussostudenti";

                        #endregion
                    }
                    else {
                        #region annullamento credito 

                        if (bollettiniAnnullati.Contains(oCodiceBollettinoUnivoco.ToString())) {
                            MessageBox.Show(
                                $"E' presente due o pi� volte l'annullamento del bollettino {oCodiceBollettinoUnivoco}. Solo uno di essi sar� considerato.",
                                "Avviso");
                            continue;
                        }
                        var existentRowsToAnnull = DS.flussocreditidetail.getFromDb(_conn,
                            q.eq("iduniqueformcode", oCodiceBollettinoUnivoco) & q.isNull("stop") &
                            q.isNull("annulment"));

                        if (existentRowsToAnnull.Length == 0) {
                            errore = $"Bollettino numero {oCodiceBollettinoUnivoco} non trovato (o gi� annullato) nei crediti esistenti. L'annullo di tale bollettino non sar� considerato.";
                            MessageBox.Show(errore, "Avviso");
                            continue;
                        }
                        bollettiniAnnullati.Add(oCodiceBollettinoUnivoco.ToString());

                        //Crea una riga di annullamento per ogni riga esistente da annullare e ne imposta il campo annullato
                        foreach (var rToAnnull in existentRowsToAnnull) {
                            rToAnnull.annulmentValue =
                                oDataContabile; //Imposta il campo ANNULLATO nel dettaglio credito esistente

                            var rNewFlussocreditiDetail =
                                metaFlussoCreditiDetail.Get_New_Row(rFlussoCrediti, DS.flussocreditidetail) as
                                    flussocreditidetailRow;

                            //copia alcuni campi dalla riga originale da annullare
                            foreach (var field in new[] {
                                "importoversamento", "idestimkind", "yestim", "nestim", "rownum", "idinvkind", "yinv",
                                "ninv", "invrownum"
                            }) {
                                // ReSharper disable once PossibleNullReferenceException
                                rNewFlussocreditiDetail[field] = rToAnnull[field];
                            }

                            // ReSharper disable once PossibleNullReferenceException
                            rNewFlussocreditiDetail.flag = 0;
                            rNewFlussocreditiDetail["idfinmotive"] = idCodiceCausaleFinanziaria;
                            rNewFlussocreditiDetail["iduniqueformcode"] = oCodiceBollettinoUnivoco;
                            rNewFlussocreditiDetail["idaccmotiverevenue"] = idcausaleEpRicavo;
                            rNewFlussocreditiDetail["idaccmotivecredit"] = idcausaleEpCredito;

                            rNewFlussocreditiDetail["idaccmotiveundotax"] = idcausaleEpRicavo;
                            rNewFlussocreditiDetail["idaccmotiveundotaxpost"] = idcausaleEpRicavo;
                            rNewFlussocreditiDetail["stop"] = oDataContabile;

                            rNewFlussocreditiDetail["competencystart"] = competencystart;
                            rNewFlussocreditiDetail["competencystop"] = competencystop;
                            rNewFlussocreditiDetail["description"] = description;
                            rNewFlussocreditiDetail["cf"] = oCodiceFiscaleStudente.ToString().ToUpper();

                            rNewFlussocreditiDetail["idreg"] = oIdreg;
                            rNewFlussocreditiDetail["idupb"] = idupb;
                            rNewFlussocreditiDetail["ct"] = DateTime.Now;
                            rNewFlussocreditiDetail["cu"] = "import_flussostudenti";
                            rNewFlussocreditiDetail["lt"] = DateTime.Now;
                            rNewFlussocreditiDetail["lu"] = "import_flussostudenti";

                        }

                        #endregion
                    }


                }
            }

            

            var myPostData = new Easy_PostData();
            myPostData.initClass(DS, _conn);
            var res = myPostData.DO_POST();
         
            if (!res) {
                MessageBox.Show(this, "Errore nel salvataggio del flusso");
            }
            else {
                MessageBox.Show(this, "Elaborazione del file completata");
            }
        }


        private void viewAutomatismi(DataSet ds) {
            string filterEntrata = null;
            if (ds.Tables["income"] != null) {
                var var = ds.Tables["income"];
                var rr = ds.Tables["income"].Select();
                if (rr.Length == 0) return;
                if (rr.Length > 100) return;
                filterEntrata = _qhs.FieldIn("idinc", rr, "idinc");
            }

            ShowAutomatismi.Show(_meta as MetaData, null, filterEntrata, null, null).ShowDialog(this);
        }

        void copyRelation(DataSet dest, DataRelation sourceRel) {
            if (dest.Relations.Contains(sourceRel.RelationName)) return;
            if (!dest.Tables.Contains(sourceRel.ParentTable.TableName)) {
                dest.Merge(sourceRel.ParentTable, false, MissingSchemaAction.Add);
            }
            if (!dest.Tables.Contains(sourceRel.ChildTable.TableName)) {
                dest.Merge(sourceRel.ChildTable, false, MissingSchemaAction.Add);                
            }
            
            DataTable parentDest = dest.Tables[sourceRel.ParentTable.TableName];
            DataTable childDest = dest.Tables[sourceRel.ChildTable.TableName];
            
            var destParentColumns = sourceRel.ParentColumns.Select(c => parentDest.Columns[c.ColumnName]).ToArray();
            var childParentColumns = sourceRel.ChildColumns.Select(c => childDest.Columns[c.ColumnName]).ToArray();
            var destRel = new DataRelation(sourceRel.RelationName, destParentColumns, childParentColumns);
            dest.Relations.Add(destRel);
        }

        bool doSave(out DataSet dSupdated) {
            dSupdated = null;

            if (!DS.HasChanges()) {
                MessageBox.Show("Nessun movimento da generare", "Avviso");
                return false;
            }

            var dsp = DS.Copy();
            var faseincasso = CfgFn.GetNoNullInt32(_security.GetSys("maxincomephase"));

            var ga = new GestioneAutomatismi(this, _conn as DataAccess, _dispatcher as MetaDataDispatcher,
                dsp, 1, faseincasso, "income", true);
            ga.integraCopiaDatiDaDatasetPrincipaleASecondario();
            copyRelation(ga.DSP, dsp.Relations["FK_estimatedetail_estimate"]);
            copyRelation(ga.DSP, dsp.Relations["FK_flussoincassi_flussoincassidetail"]);
            copyRelation(ga.DSP, dsp.Relations["flussocrediti_flussocreditidetail"]);

            copyRelation(ga.DSP, dsp.Relations["estimatedetail_flussocreditidetail"]);
            copyRelation(ga.DSP, dsp.Relations["invoicedetail_flussocreditidetail"]);
            copyRelation(ga.DSP, dsp.Relations["invoice_incomeinvoice"]);

            //copyRelation(ga.DSP, dsp.Relations["income_incomevar"]); gi� ci dovrebbe essere

            copyRelation(ga.DSP, dsp.Relations["invoice_invoicedetail"]);

            copyRelation(ga.DSP, dsp.Relations["ivaregisterinvoice"]);
            copyRelation(ga.DSP, dsp.Relations["flussocrediti_webpayment"]);

            copyRelation(ga.DSP, dsp.Relations["income_incomeinvoice"]);
            copyRelation(ga.DSP, dsp.Relations["income_invoicedetail"]);
            copyRelation(ga.DSP, dsp.Relations["income_invoicedetail1"]);

            copyRelation(ga.DSP, dsp.Relations["income_incomeestimate"]);
            copyRelation(ga.DSP, dsp.Relations["estimate_incomeestimate"]);
            copyRelation(ga.DSP, dsp.Relations["income_estimatedetail"]);
            copyRelation(ga.DSP, dsp.Relations["income_estimatedetail1"]);
            copyRelation(ga.DSP, dsp.Relations["estimate_incomeestimate"]);
            copyRelation(ga.DSP, dsp.Relations["estimate_incomeestimate"]);

            var res = true;
            if (DS.income.Rows.Count > 0) {
                ga.GeneraClassificazioniAutomatiche(ga.DSP, true);
                res = ga.GeneraAutomatismiAfterPost(true);
                if (!res) {
                    MessageBox.Show(this,
                        "Si � verificato un errore o si � deciso di non salvare! L'operazione sar� terminata");
                    return false;
                }
            }

            
            res = ga.doPost(_dispatcher as MetaDataDispatcher);

            if (res) {
                MessageBox.Show("Salvataggio dati effettuato.", "Avviso");
                viewAutomatismi(ga.DSP);
            }
            //if (!res) {
            //    MessageBox.Show(this,
            //        "Operazione annullata dall'utente","Avviso");             
            //}
            DS.AcceptChanges();
            DS.incomeestimate.Clear();
            DS.incomeinvoice.Clear();
            //DS.estimatedetail.Clear();
            DS.incomelast.Clear();
            DS.income.Clear();
            DS.incomeyear.Clear();

            dSupdated = ga.DSP;

            aggiornaChiaviDs(dSupdated); //travasa i dati da DSP a DS

            ricalcolaFlagElaborato();

          

            return res;
        }

        void ricalcolaFlagElaborato() {
            //var someThingDone = false;
            foreach (var flusso in DS.flussoincassi) {
                // Costruisce l'elenco dei dettagli da esportare
                _conn.CallSP("compute_flussoincassiflagelaborato", new object[] { esercizio, flusso.idflusso });
            }
        }


        private bool creaAccertamentiDettagliContratti(estimatedetailRow []estimatedetailRow) {
            bool res = creaAccertamentiDaDettagliContrattiAttivi(estimatedetailRow, TipoElaborazioneIncassi.imponibile,false);
            if (res) res= creaAccertamentiDaDettagliContrattiAttivi(estimatedetailRow, TipoElaborazioneIncassi.iva,false);
            if (res) res = creaAccertamentiDaDettagliContrattiAttivi(estimatedetailRow, TipoElaborazioneIncassi.totali,false);
            return res;
        }

        /// <summary>
        /// Crea gli accertamenti relativi ad uno iuv o tutti quelli presenti nel dataset ove lo iuv sia null
        /// Non cancella nulla dal ds
        /// </summary>
        /// <param name="estimatedetailRows"></param>
        /// <returns></returns>
        bool creaAccertamentiDaDettagliContrattiAttivi(estimatedetailRow []estimatedetailRows, TipoElaborazioneIncassi tipoElaborazione,bool faseIncassi) {
            // To Do: modificare l'interfaccia uniformando le chiamate
            var fasecontratto = CfgFn.GetNoNullInt32(_security.GetSys("estimatephase"));
            var fasecred = CfgFn.GetNoNullInt32(_security.GetSys("incomeregphase"));
            var fasebilancio = CfgFn.GetNoNullInt32(_security.GetSys("incomefinphase"));

            var faseinizio = 1;
            var fasefine = fasecontratto;

            var metaIncome = _dispatcher.Get("income");
            var metaIncomeYear = _dispatcher.Get("incomeyear");
            var metaIncomeLast = _dispatcher.Get("incomelast");
            var metaIncomeEstimate = _dispatcher.Get("incomeestimate");
            var metaEstimateDetail = _dispatcher.Get("estimatedetail");
            metaIncome.SetDefaults(DS.income);
            metaIncomeYear.SetDefaults(DS.incomeyear);
            metaIncomeLast.SetDefaults(DS.incomelast);
            metaIncomeEstimate.SetDefaults(DS.incomeestimate);
            metaEstimateDetail.SetDefaults(DS.estimatedetail);
            MetaData.SetDefault(DS.income, "parentidinc", DBNull.Value);
            //estimatedetailRow[] selectedRows;
            //if (estimatedetailRow != null) {
            //    selectedRows = new estimatedetailRow[1];
            //    selectedRows[0] = estimatedetailRow;
            //}
            //else {
            //    selectedRows = DS.estimatedetail.allCurrent().ToArray();
            //}

            //if (selectedRows.Length == 0) {
            //    MessageBox.Show("Righe di Dettaglio Assenti", "Errore");
            //    return false;
            //}

            var currcausale = 1; // contabilizzazione totale

            var mov = DS.income;
            var impMov = DS.incomeyear;


            MetaData.SetDefault(DS.incomeyear, "ayear", esercizio);

            DataRow incomeToLink = null;
            // Crea Contabilizzazioni dei dettagli contratto attivo elencati
            foreach (var rDet in estimatedetailRows) {
                if (rDet["stop"] != DBNull.Value) continue;

                var currUpb = rDet.idupb;
                var currUpbIva = rDet.idupb_iva;
                
                switch (tipoElaborazione) {
                    case TipoElaborazioneIncassi.totali:
                        //Elaborazione pre modifica split fasi - esegue solo con upb_iva == null
                        if (currUpb==null || currUpbIva != null)
                            continue; //i totali devono avere un upb_iva NON impostato per essere elaborati
                        break;
                    case TipoElaborazioneIncassi.imponibile:
                        if (currUpb == null || currUpbIva==null) continue;// imponibile  o iva � ammesso solo se c'� currUPB
                        break;
                    case TipoElaborazioneIncassi.iva:
                        if (currUpb == null || currUpbIva==null) continue;// imponibile  o iva � ammesso solo se c'� currUPB
                        break;
                }

                // possono essere dettagli contratto attivo non collegati a  fattura
                // Prima di tutto vedo se la contabilizzazione � differita
                string errore;
                var gestionedifferita = getGestioneDifferita(rDet.idestimkind, out errore);
                if (gestionedifferita == "S" && ! faseIncassi) continue; //salta questo dettaglio
                var aDate = _conn.readValue("estimate", q.mCmp(rDet, "idestimkind", "yestim", "nestim"), "adate");

                DataRow parentR = null;
                //spostato sotto
                //var amount = rDet.taxable;
                if (tipoElaborazione == TipoElaborazioneIncassi.iva) {
                    if (rDet.idinc_ivaValue != DBNull.Value) continue;
                }
                else {
                    if (rDet.idinc_taxableValue != DBNull.Value) continue;
                }

                decimal imponibile = CfgFn.GetNoNullDecimal(rDet.taxable);
                decimal sconto = CfgFn.GetNoNullDecimal(rDet.discount);
                decimal quantita =CfgFn.GetNoNullDecimal(rDet.number);
                decimal imponibiletot = CfgFn.GetNoNullDecimal(CfgFn.RoundValuta((imponibile * quantita* (1 - sconto))));
                var iva = CfgFn.GetNoNullDecimal(rDet.tax);

                object idUpbSelected=DBNull.Value;
                decimal amount = 0;
                switch (tipoElaborazione) {
                    case TipoElaborazioneIncassi.totali:
                        //Elaborazione pre modifica split fasi - esegue solo con upb_iva == null
                        currcausale = 1;
                        amount =imponibiletot+iva;
                        idUpbSelected = currUpb;
                        break;
                    case TipoElaborazioneIncassi.imponibile:
                        // currUpb � sicuramente null
                        currcausale = 3;
                        amount =imponibiletot;
                        idUpbSelected = currUpb;
                        break;
                    case TipoElaborazioneIncassi.iva:
                        // curUpbIva � sicuramente != null
                        currcausale = 2;
                        amount = iva;
                        idUpbSelected = currUpbIva;
                        break;
                }


                if (amount == 0) continue; // non dovrebbe essere mai zero 
                for (var faseCorrente = faseinizio; faseCorrente <= fasefine; faseCorrente++) {
                    mov.Columns["nphase"].DefaultValue = faseCorrente;

                    var newEntrataRow = metaIncome.Get_New_Row(parentR, mov);
                    if (faseCorrente == fasecontratto) incomeToLink = newEntrataRow;
                    parentR = newEntrataRow;
                    // Selezione UPB e Voce di Bilancio in modo completamente automatico
                    var idmanagerSelected = _conn.readValue("upb", q.eq("idupb", idUpbSelected), "idman");

                    // Determinazione del capitolo di bilancio in base alla causale finanziaria 
                    var idfinSelected = getBilancioFromCausaleFin(rDet["idfinmotive"], out errore);
                    if (errore != "") {
                        MessageBox.Show(errore+" nel dettaglio "+rDet.detaildescription+ " codice bollettino "+rDet.iduniqueformcode,
                            "Errore");
                        return false;
                    }

                    fillMovimento(newEntrataRow, idmanagerSelected, rDet["idreg"],
                        rDet["detaildescription"].ToString());

                    newEntrataRow["doc"] =
                        $"C.A.{rDet["idestimkind"]}/{rDet["yestim"].ToString().Substring(2, 2)}/{rDet["nestim"].ToString().PadLeft(6, '0')}";

                    newEntrataRow["docdate"] = aDate ?? DBNull.Value;

                    newEntrataRow["nphase"] = faseCorrente;
                    if (faseCorrente < fasecred) {
                        newEntrataRow["idreg"] = DBNull.Value;
                    }
                    else {
                        newEntrataRow["idreg"] = rDet["idreg"];
                    }

                    var newImpMov = impMov.NewRow();

                    fillImputazioneMovimento(newImpMov, CfgFn.GetNoNullDecimal(amount), idfinSelected, idUpbSelected);


                    newImpMov["idinc"] = newEntrataRow["idinc"];
                    newImpMov["ayear"] = esercizio;

                    if (faseCorrente < fasebilancio) {
                        newImpMov["idfin"] = DBNull.Value;
                        newImpMov["idupb"] = DBNull.Value;
                    }

                    impMov.Rows.Add(newImpMov);

                }

                //Aggiunge la riga in IncomeEstimate
                var incEstimRow = metaIncomeEstimate.Get_New_Row(incomeToLink, DS.incomeestimate);
                incEstimRow["movkind"] = currcausale;
                incEstimRow["idestimkind"] = rDet["idestimkind"];
                incEstimRow["yestim"] = rDet["yestim"];
                incEstimRow["nestim"] = rDet["nestim"];

                //Effettua i collegamenti con il dettaglio
                if (incomeToLink != null) {
                    if ((tipoElaborazione != TipoElaborazioneIncassi.iva)) rDet["idinc_taxable"] = incomeToLink["idinc"];
                    if ((tipoElaborazione == TipoElaborazioneIncassi.iva)) rDet["idinc_iva"] = incomeToLink["idinc"];
                    
                    
                }
            }

            return true;

        }

        //void editRelatedEstimate(DataRow r) {
        //    if (r == null) return;
        //    var toMeta = _dispatcher.Get("estimate");
        //    if (toMeta == null) return;

        //    toMeta.Edit(this, "default", false);
        //    var listtype = toMeta.DefaultListType;
        //    toMeta.SelectRow(r, listtype);
        //}

        private void VisualizzaRigaSelezionata(DataRow Riga, string table, string view, string listType, string editType) {
            if (Riga == null) return;
            string filter = QueryCreator.WHERE_KEY_CLAUSE(Riga, DataRowVersion.Default, true);
            if (editType == null) editType = "default";
            var MElenco = _dispatcher.Get(table);
            if (MElenco == null) return;
           
            bool result = MElenco.Edit(this, editType, false);  
            //DataRow R = MElenco.SelectOne(listType, filter, null, null);
            MElenco.SelectRow(Riga, listType);
        }

        bool verificaIncassi(DataTable dt) {
            clearAllDict();
            foreach (DataColumn c in dt.Columns) {
                if (!dt.Columns.Contains(c.ColumnName)) {
                    MessageBox.Show(this, "File non compatibile con il Tracciato del Flusso Incassi");
                    return false;
                }
            }

            if (!dt.Columns.Contains("riga")) {
                dt.Columns.Add("riga");
                dt.Columns["riga"].DataType = typeof(string);
                dt.Columns["riga"].Caption = "Riga";
            }

            if (!dt.Columns.Contains("errori")) {
                dt.Columns.Add("errori");
                dt.Columns["errori"].DataType = typeof(string);
                dt.Columns["errori"].Caption = "Errori";
            }

            var ds1 = new DataSet();

            ds1.Tables.Add(dt);
            dgrIncassi.SetDataBinding(ds1, dt.TableName);

            HelpForm.SetDataGrid(dgrIncassi, dt);
            HelpForm.SetGridStyle(dgrIncassi, dt);

            /*
             *  "codice_fiscale_studente;Codice Fiscale Studente;Stringa;16",
                        "numero_sospeso_attivo; Numero Sospeso Attivo; Intero;10",
                        "data_incasso; Data Incasso;Data;8",
                        "codice_bollettino_univoco;Codice Bollettino Univoco;Stringa;50",
                        "importo;Importo Totale;Numero;22"
             * */

            var ok = true;

            var errCf = false;
            var nrigacorrente = 1;
            foreach (DataRow r in dt.Rows) {
                string errore;
                var err = "";
                var oCodiceFiscaleStudente = getVal(1, "codice_fiscale_studente", r, "fasedue", out errore);
                if (errore != "") err = err + " " + errore;
                if (oCodiceFiscaleStudente == DBNull.Value) break;
                var oNumeroSospesoAttivo = getVal(2, "numero_sospeso_attivo", r, "fasedue", out errore);
                if (errore != "") err = err + " " + errore;
                var oDataIncasso = getVal(3, "data_incasso", r, "fasedue", out errore);
                if (errore != "") err = err + " " + errore;
                var oCodiceBollettinoUnivoco = getVal(4, "codice_bollettino_univoco", r, "fasedue", out errore);
                if (errore != "") err = err + " " + errore;
                var oImporto = getVal(5, "importo", r, "fasedue", out errore);
                if (errore != "") err = err + " " + errore;


                if (err != "") ok = false;

                if (CfgFn.GetNoNullDecimal(oImporto) <= 0) {
                    errore =
                        $" Valore non previsto per il campo importo di valore {oImporto.ToString().Trim()} : inserire un importo maggiore di zero";
                    err += " " + errore;
                    ok = false;
                }

                CalcolaCodiceFiscale.CheckCF(oCodiceFiscaleStudente.ToString(), out errore);

                if (errore != "") {
                    errore = $" Nel codice fiscale {oCodiceFiscaleStudente} compaiono i seguenti errori: {errore}";
                    err += " " + errore;
                    errCf = true;
                    // ok = false;
                }

                var nbill = getSospesiAttivi(oNumeroSospesoAttivo, out errore);
                if (nbill == DBNull.Value && errore != "") {
                    err += " " + errore;
                    ok = false;
                }

                if (oDataIncasso == DBNull.Value) {
                    errore = "La data incasso � obbligatoria";
                    err += " " + errore;
                    ok = false;
                }

                var okImporto = verifyImportoTotaleIncasso(oCodiceBollettinoUnivoco, CfgFn.GetNoNullDecimal(oImporto),
                    out errore);
                if (errore != "" && !okImporto) {
                    err += " " + errore;
                    ok = false;
                }

                r["riga"] = nrigacorrente;
                r["errori"] = err;

                nrigacorrente++;
            }


            if (errCf && ok) {
                MessageBox.Show(this, "Si sono verificati errori nella convalida di alcuni codici fiscali.");
            }

            //if (ok) {
            //    MessageBox.Show(this, "Importate " + (nrigacorrente - 1).ToString() + " righe.");
            //    btnElaboraIncassi.Enabled = true;

            //}
            //else {
            //    btnElaboraIncassi.Enabled = false;

            //}


            return ok;
        }


        private bool isNumeric(object str, out decimal valore) {
            valore = 0;
            try {
                valore = Convert.ToDecimal(str);
                //valore = decimal.Parse(str.ToString().Replace(",", "."), CultureInfo.InvariantCulture);
                return true;
            }
            catch (Exception) {
                return false;
            }
        }


        private readonly Dictionary<string, int> _vociBilancioEntrata = new Dictionary<string, int>();

        object getBilancioFromCausaleFin(object idfinmotive, out string errori) {
            errori = "";
            if (idfinmotive == DBNull.Value || idfinmotive == null) {
                errori = " Causale finanziaria non trovata";
                return DBNull.Value;
            }

            var idfinmotiveS = idfinmotive.ToString();
            if (_vociBilancioEntrata.ContainsKey(idfinmotiveS)) return _vociBilancioEntrata[idfinmotiveS];
            var idfin = _conn.readValue("finmotivedetail",
                q.eq("ayear", esercizio) & q.eq("idfinmotive", idfinmotiveS), "idfin");
            if (idfin == null || idfin == DBNull.Value) {
                errori = "Voce di bilancio associata alla causale finanziaria non trovata";
                return DBNull.Value;
            }

            _vociBilancioEntrata[idfinmotiveS] = CfgFn.GetNoNullInt32(idfin);
            return _vociBilancioEntrata[idfinmotiveS];

        }

        private readonly Dictionary<string, string> _upb = new Dictionary<string, string>();

        private object getIdUpb(object oCodiceUpb, out string errori) {
            errori = "";
            if (oCodiceUpb == DBNull.Value || oCodiceUpb == null) {
                errori = "UPB non trovato";
                return DBNull.Value;
            }

            var sCodiceUpb = oCodiceUpb.ToString();

            if (_upb.ContainsKey(sCodiceUpb)) return _upb[sCodiceUpb];
            var idupb = _conn.readValue("upb", q.eq("codeupb", sCodiceUpb), "idupb");
            if (idupb == DBNull.Value || idupb == null) {
                errori = $"UPB avente codice {oCodiceUpb} non trovato";
                return DBNull.Value;
            }

            _upb[sCodiceUpb] = idupb.ToString();
            return _upb[sCodiceUpb];
        }


        private string checkTipoContrattoAttivo(object oCodiceTipoContratto, out string errori) {
            errori = "";
            if (oCodiceTipoContratto == DBNull.Value) return null;
            string idestimkind = null;

            var rEstimKind = DS.estimatekind.Filter(q.eq("idestimkind", oCodiceTipoContratto));
            if (rEstimKind.Length == 0) {
                errori = $"Tipo Contratto Attivo avente codice {oCodiceTipoContratto} non trovato";
            }
            else {
                idestimkind = rEstimKind[0].idestimkind;
            }

            return idestimkind;
        }

        private int? impostaDefaultIvaKind(object oCodiceTipoContratto, out string errori) {
            errori = "";
            var rEstimKind = DS.estimatekind.Filter(q.eq("idestimkind", oCodiceTipoContratto));
            if (rEstimKind.Length == 0) {
                errori = $"Tipo Contratto Attivo avente codice {oCodiceTipoContratto} non trovato";
                return null;
            }

            var rKind = rEstimKind[0];
            var idivakindForced = rKind.idivakind_forced;
            MetaData.SetDefault(DS.estimatedetail, "idivakind", idivakindForced);

            if (idivakindForced != null) {
                var taxrate = DS.ivakind.Filter(q.eq("idivakind", idivakindForced))[0].rateValue;
                    //_conn.readValue("ivakind", q.eq("idivakind", idivakindForced), "rate");
                MetaData.SetDefault(DS.estimatedetail, "taxrate", taxrate);
                return idivakindForced;
            }

            MetaData.SetDefault(DS.estimatedetail, "idivakind", DBNull.Value);
            MetaData.SetDefault(DS.estimatedetail, "taxrate", DBNull.Value);
            //errori = "Tipo Iva Esente non configurato in Contratto Attivo avente codice " +oCodiceTipoContratto.ToString();
            return null;
        }


        private readonly Dictionary<object, object> _accmotive = new Dictionary<object, object>();

        object getCausaleEp(object codiceCausale, out string errori) {
            errori = "";
            if (codiceCausale == DBNull.Value || codiceCausale == null) {
                errori = "Causale EP non trovata";
                return DBNull.Value;
            }

            if (_accmotive.ContainsKey(codiceCausale)) return _accmotive[codiceCausale];

            var idaccmotive = _conn.readValue("accmotive", q.eq("codemotive", codiceCausale), "idaccmotive");
            if (idaccmotive == null || idaccmotive == DBNull.Value) {
                errori = $"Causale EP avente codice {codiceCausale} non trovata";
                return DBNull.Value;
            }

            _accmotive[codiceCausale] = idaccmotive;
            return _accmotive[codiceCausale];
        }

        void clearAllDict() {
            _upb.Clear();
            _accmotive.Clear();
            _vociBilancioEntrata.Clear();
            _finmotive.Clear();
            //accMotiveMiur.Clear();
            _accMotiveSiope.Clear();
            _sospesiAttivi.Clear();
            _sospesiAttiviByCausali.Clear();
            _causaliSospesiAttivi.Clear();
            _tipoContrattoAttivoGestioneDifferita.Clear();
            _tipoContrattoAttivoCollegabileAFattura.Clear();
        }

        private readonly Dictionary<string, string> _finmotive = new Dictionary<string, string>();

        private object getFinMotive(object oCodiceCausaleFinanziaria, out string errori) {
            errori = "";

            if (oCodiceCausaleFinanziaria == DBNull.Value || oCodiceCausaleFinanziaria == null) {
                errori = " La causale finanziaria non � stata specificata";
                return DBNull.Value;
            }

            var sCodeMotive = oCodiceCausaleFinanziaria.ToString();
            if (_finmotive.ContainsKey(sCodeMotive)) return _finmotive[sCodeMotive];
            var idfinmotive = _conn.readValue("finmotive", q.eq("codemotive", sCodeMotive), "idfinmotive");

            if ((idfinmotive == DBNull.Value) || (idfinmotive == null)) {
                errori = $"Causale finanziaria avente codice {sCodeMotive} non trovata";
                return DBNull.Value;
            }

            _finmotive[sCodeMotive] = idfinmotive.ToString();
            return idfinmotive.ToString();
        }




        /// <summary>
        /// Crea i contratti attivi dalle righe di dettaglio flusso crediti non ancora elaborate e non annullate (stop null)
        /// Le righe considerate sono quelle senza tipo contratto attivo  e senza tipo fattura, oppure con tipo contratto ma senza n. contratto
        /// Svuota e riempie estimate, estimatedetail, flussocrediti*
        /// </summary>
        /// <returns></returns>
        private bool fillEstimate() {
            DS.estimate.Clear();
            DS.estimatedetail.Clear();
            DS.invoice.Clear();
            DS.invoicedetail.Clear();
            DS.ivaregister.Clear();
            DS.registry.Clear();
            DS.flussocrediti.Clear();
            DS.flussocreditidetail.Clear();
            DS.income.Clear();
            DS.incomeestimate.Clear();
            DS.incomeinvoice.Clear();

            var metaEstimate = MetaData.GetMetaData(this, "estimate");
            metaEstimate.SetDefaults(DS.estimate);
            var metaEstimateDetail = MetaData.GetMetaData(this, "estimatedetail");
            metaEstimateDetail.SetDefaults(DS.estimatedetail);

            var ivaKind = _conn.RUN_SELECT("ivakind", "idivakind,rate", null, null, null, false);
            var ivaTaxRate = new Dictionary<int, object>();
            foreach (var r in ivaKind.Select()) {
                ivaTaxRate[CfgFn.GetNoNullInt32(r["idivakind"])] = r["rate"];
            }
            // Conn.readSimpleDictionary<int, object>("ivakind", "idivakind", "taxrate");


            RowChange.MarkAsAutoincrement(DS.estimate.Columns["nestim"], null, null, 0);
            MetaData.SetDefault(DS.estimate, "nestim", -100000);

            var errore = "";
            var tempNestim = 0;
            MetaData.SetDefault(DS.incomeyear, "ayear", esercizio);
            // elabora tutto il pregresso
            var upbSecurity = _conn.Security.SelectCondition("upb", false);
            var filterUpbSec = MetaExpressionParser.From(upbSecurity);
            filterUpbSec?.cascadeSetTable("upb");

            var condizioneSuDettCrediti = q.doPar(q.or(
                    q.doPar(q.and(q.isNull("idestimkind") & q.isNull("idinvkind") & q.isNull("stop") &
                                  q.isNull("annulment"))),
                    q.doPar(q.and(q.isNotNull("idestimkind") & q.isNull("nestim") & q.isNull("stop") &
                                  q.isNull("annulment")))
                )
            );
            var allRows =DS.flussocreditidetail.readTableJoined(_conn,"upb",
                 condizioneSuDettCrediti,
                filterUpbSec,"idupb"
                );
            //attenzione: sfrutta il comportamento interno della readTableJoined, che ha gi� modificato gli alias delle condizioni in input

            var overallCondition =  (filterUpbSec==null? condizioneSuDettCrediti : condizioneSuDettCrediti & filterUpbSec).toSql(_qhs);

            //Legge i flussi collegati, ci vuole una doppia join per�
            string colonneFlussoCrediti = string.Join(",", 
                (from c in DS.flussocrediti.Columns._names() where QueryCreator.IsReal(DS.flussocrediti.Columns[c])
                            select "flussocrediti."+c  ).ToArray());
            condizioneSuDettCrediti.cascadeSetTable("flussocreditidetail");//superfluo ma non fa male
            var getFlussiSql = $"SELECT {colonneFlussoCrediti} FROM flussocrediti "+
                    $" WHERE idflusso in (select idflusso from flussocreditidetail "+
                               " JOIN UPB on UPB.idupb=flussocreditidetail.idupb "+
                               $" WHERE {overallCondition} "+
                    ")";
            DS.flussocrediti._sqlGetFromDb(_conn, getFlussiSql);
            Dictionary<int?,flussocreditiRow> flussoCreditiDict = new Dictionary<int?, flussocreditiRow>();
            foreach (var r in DS.flussocrediti) flussoCreditiDict[r.idflusso] = r;


            foreach (var rCreditiDetail in allRows) {
                // Dovr� creare un solo contratto con tanti dettagli 
                // quante sono le anagrafiche pertanto data contabile, tipo contratto e causale ricavo saranno uguali

                var importo = rCreditiDetail.importoversamento;
                var idfinmotive = rCreditiDetail.idfinmotive;
                var iduniqueformcode = rCreditiDetail.iduniqueformcode;
                var idaccmotiverevenue = rCreditiDetail.idaccmotiverevenue;
                var idaccmotivecredit = rCreditiDetail.idaccmotivecredit;
                var idupb = rCreditiDetail.idupb;
                var idreg = rCreditiDetail.idreg;
                var competencystart = rCreditiDetail.competencystart;
                var competencystop = rCreditiDetail.competencystop;
                var description = rCreditiDetail.description;
                var nform = rCreditiDetail.nform;

                var number = CfgFn.GetNoNullDecimal(rCreditiDetail["number"]);
                if (number == 0) number = 1;
                var taxable = CfgFn.GetNoNullDecimal(importo) / number;

                flussocreditiRow rCrediti = null;
                if (flussoCreditiDict.ContainsKey(rCreditiDetail.idflusso)) {
                    rCrediti=flussoCreditiDict[rCreditiDetail.idflusso];
                }
                
                var idcodiceTipoContratto = rCreditiDetail.idestimkind ?? rCrediti.idestimkind;
                //attualmente sempre NULL, NO! i crediti provenienti da portale ce l'hanno o possono avercelo

                if (rCrediti["datacreazioneflusso"] == DBNull.Value) continue;

                var datacreazioneflusso = (DateTime) rCrediti["datacreazioneflusso"];
                if (datacreazioneflusso.Year != esercizio) continue;
                idcodiceTipoContratto = checkTipoContrattoAttivo(idcodiceTipoContratto, out errore);
                if (errore != "") {
                    MessageBox.Show(errore, "Errore");
                    return false;
                }

                var docdate = rCrediti.docdate;
                var idsor01 = rCrediti.idsor01;
                var idsor02 = rCrediti.idsor02;
                var idsor03 = rCrediti.idsor03;
                var idsor04 = rCrediti.idsor04;
                var idsor05 = rCrediti.idsor05;

                if (idaccmotivecredit == null) {
                    MessageBox.Show("Causale di Credito assente", "Errore");
                    return false;
                }

                var rEstimateArr = DS.estimate.get(_conn, q.eq("idestimkind", idcodiceTipoContratto) &
                                                          q.eq("idaccmotivecredit", idaccmotivecredit) &
                                                          q.eq("adate", _security.GetDataContabile()) &
                                                          q.eq("docdate",  (((object)docdate)?? DBNull.Value)) &
                                                          q.eq("yestim", esercizio));
                int? idivakindDefault;
                estimateRow rEstimate;
                //prende la riga di contratto esistente o ne crea una nuova
                if (rEstimateArr != null && rEstimateArr.Length > 0) {
                    rEstimate = rEstimateArr[0];
                    idivakindDefault = impostaDefaultIvaKind(idcodiceTipoContratto, out errore);
                    DS.estimatedetail.get(_conn,
                        q.mCmp(rEstimate, "idestimkind", "yestim", "nestim")); //non credo serva
                }
                else {
                    tempNestim++;
                    MetaData.SetDefault(DS.estimate, "idestimkind", idcodiceTipoContratto);
                    MetaData.SetDefault(DS.estimate, "yestim", esercizio);

                    idivakindDefault = impostaDefaultIvaKind(idcodiceTipoContratto, out errore);
                    if (errore != "") {
                        MessageBox.Show(errore, "Errore");
                        return false;
                    }

                    var rNewEstimate = metaEstimate.Get_New_Row(null, DS.estimate) as estimateRow;
                    rNewEstimate.nestim = tempNestim;
                    rNewEstimate.adate = _security.GetDataContabile();
                    rNewEstimate.docdate = docdate;
                    rNewEstimate.description = "Import.Flusso Studenti";

                    rNewEstimate.idsor01 = idsor01;
                    rNewEstimate.idsor02 = idsor02;
                    rNewEstimate.idsor03 = idsor03;
                    rNewEstimate.idsor04 = idsor04;
                    rNewEstimate.idsor05 = idsor05;


                    rNewEstimate.idaccmotivecredit = idaccmotivecredit;
                    rEstimate = rNewEstimate;

                }

                var idivakind = idivakindDefault;
                object taxrate = DBNull.Value;
                if (rCreditiDetail["idivakind"] != DBNull.Value) {
                    idivakind = rCreditiDetail.idivakind;
                }

                if (idivakind != null) {
                    var iIdIVakind = CfgFn.GetNoNullInt32(idivakind);
                    taxrate = ivaTaxRate[iIdIVakind];
                }

                var rNewDetail = metaEstimateDetail.Get_New_Row(rEstimate, DS.estimatedetail) as estimatedetailRow;
                rNewDetail.idreg = idreg;
                rNewDetail.detaildescription = description;
                rNewDetail.iduniqueformcode = iduniqueformcode;
                rNewDetail.competencystart = competencystart;
                rNewDetail.competencystop = competencystop;
                rNewDetail.taxable = taxable;
                rNewDetail.tax = rCreditiDetail.tax;
                rNewDetail.idivakind = idivakind;
                rNewDetail.taxrateValue = taxrate;

                rNewDetail.number = number;
                rNewDetail.toinvoice = "N"; // sono di tipo non fatturabile 
                rNewDetail.nform = nform; // numero bollettino solo a titolo informativo
                var gestionedifferita = getGestioneDifferita(rNewDetail.idestimkind, out errore);
                if (gestionedifferita == "S") {
                    rNewDetail["flag"] = CfgFn.GetNoNullInt32(rNewDetail["flag"]) | 1;
                }

                if (idaccmotiverevenue == null) {
                    errore =
                        $"Manca la causale di ricavo nel dettaglio crediti del bollettino n.{nform ?? iduniqueformcode}";
                    MessageBox.Show(errore, "Errore");
                    return false;
                }

                rNewDetail["idaccmotive"] = idaccmotiverevenue;
                string erroreSiope;
                var idSiope = getSiopeForAccMotive(idaccmotiverevenue, out erroreSiope);
                if (erroreSiope != "") {
                    MessageBox.Show(erroreSiope, "Errore");
                    return false;
                }

                if (idSiope != null) {
                    rNewDetail.idsor_siope = idSiope;
                }

                if (idupb == null) {
                    errore = $"Manca l'UPB nel dettaglio crediti del bollettino n.{nform}";
                    MessageBox.Show(errore, "Errore");
                    return false;
                }

                rNewDetail.idupb = idupb;

                if (idfinmotive == null) {
                    errore =
                        $"Manca la causale finanziaria nel dettaglio crediti del bollettino n.{nform ?? iduniqueformcode}";
                    MessageBox.Show(errore, "Errore");
                    return false;
                }

                rNewDetail.idfinmotive = idfinmotive;

                //collega il dettaglio credito al dettaglio flusso crediti
                rCreditiDetail.idestimkind = rEstimate.idestimkind;
                rCreditiDetail.yestim = rEstimate.yestim;
                rCreditiDetail.nestim = rEstimate.nestim;
                rCreditiDetail.rownum = rNewDetail.rownum;

                rNewDetail.idsor1 = rCreditiDetail.idsor1;
                rNewDetail.idsor2 = rCreditiDetail.idsor2;
                rNewDetail.idsor3 = rCreditiDetail.idsor3;

            }
          

            return true;
        }

        /// <summary>
        /// Elabora gli annullamenti, ossia le righe dettaglio flusso crediti con stop NOT null e flag & 1 =0
        /// Riempie flussocreditidetail e anche incomevar e incomesorted (per annullare gli accertamenti)
        /// Preventivamente svuota income, incomevar, incomesorted
        /// </summary>
        /// <returns></returns>
        private bool fillAnnulment() {
            // Ciclo per l'annullamento dei dettagli
            bool result = true;
            var iduniqueformcodeToAnnul = new List<string>();

            DS.income.Clear();
            DS.incomevar.Clear();
            DS.incomesorted.Clear();
            var metaIncomeVar = _dispatcher.Get("incomevar");

            MetaData.SetDefault(DS.incomeyear, "ayear", esercizio);
            //var filterNonElaborati = _qhs.AppAnd(_qhs.IsNotNull("stop"), _qhs.BitClear("isnull(flag,0)",0));

            q filtroCreditiAnnullati = q.eq(q.year("stop"),esercizio) & q.doPar(q.isNull("flag") | q.bitClear("flag", 0));


            DS.flussocreditidetail.readTableJoined(_conn, "upb", filtroCreditiAnnullati,
                _conn.Security.SelectCondition("upb", false)?.toMetaExpression(), "idupb");
            //DS.flussocreditidetail.mergeFromDb(_conn, filtroCreditiAnnullati);
            //DataAccess.RUN_SELECT_INTO_TABLE(_conn, DS.flussocreditidetail, "idflusso", filterNonElaborati, null, true);
            iduniqueformcodeToAnnul.Clear();

            // Richiede che le righe in flussocrediti da annullare siano gi� corredate della chiave del dettaglio contratto attivo
            foreach (var rCreditoAnnullo in DS.flussocreditidetail.Filter(filtroCreditiAnnullati)) {
                var iduniqueformcode = rCreditoAnnullo.iduniqueformcode;
                if (iduniqueformcode == null) continue;
                if (iduniqueformcodeToAnnul.Contains(iduniqueformcode)) continue;
                iduniqueformcodeToAnnul.Add(iduniqueformcode);

                // inserimenti
                // Leggo i dettagli contratto attivo da annullare facendo una ricerca per codice bollettino univoco
                // potrebbero essere anche in memoria se creo un contratto e contestualmente annullo certi dettagli
                //   oppure se ci sono pi� crediti annullati riferiti allo stesso contratto attivo
                var stop = rCreditoAnnullo.stop;

                //vanno prese dal flussocreditidetail collegate al dettaglio contratto attivo che stiamo annullando
                var idaccmotiveundotax = rCreditoAnnullo.idaccmotiveundotax;
                var idaccmotiveundotaxpost = rCreditoAnnullo.idaccmotiveundotaxpost;

                var filter = q.eq("iduniqueformcode", iduniqueformcode) & q.isNull("stop");

                //if (rCreditiDetail["idestimkind"] == DBNull.Value) {
                //    //MessageBox.Show(this, "La riga di annullo numero " + rCreditiDetail["iddetail"] + " non � associata ad un contratto attivo", "Errore");
                //    continue;
                //}

                // ora mi leggo i dettagli contratto attivo che provengono da salvataggi precedenti 
                DS.estimatedetail.safeMergeFromDb(_conn, filter); //questo restituisce solo le righe eventualmente aggiunte

                //E' necessario il doppio passaggio perch� alcune righe potrebbero essere gi� in memoria, ossia presenti nella stessa elaborazione                
                var estimateDetailRows = DS.estimatedetail.Filter(filter);

                //annulla i dettagli aventi quello iduniqueformcode
                foreach (var estimateDetailRow in estimateDetailRows) {
                    //Non deve compilare i campi della riga di annullo, non � richiesto
                    //rCreditoAnnullo["idestimkind"] = estimateDetailRow["idestimkind"];
                    //rCreditoAnnullo["yestim"] = estimateDetailRow["yestim"];
                    //rCreditoAnnullo["nestim"] = estimateDetailRow["nestim"];
                    //rCreditoAnnullo["rownum"] = estimateDetailRow["rownum"];
                     bool annoPrecedente = CfgFn.GetNoNullInt32(estimateDetailRow["yestim"]) < esercizio;
                    object idcausaleEpAnnullamento = annoPrecedente ? idaccmotiveundotaxpost : idaccmotiveundotax;

                   

                    //legge il contratto attivo in memoria ove non gi� presente
                    DS.estimate.get(_conn, q.mCmp(estimateDetailRow, "idestimkind", "yestim", "nestim"));

                    // Crea una variazione dell'accertamento che contabilizza il dettaglio di importo pari a -importo
                    var idincTaxable = estimateDetailRow["idinc_taxable"];
                    var fltmovI = _qhs.CmpEq("idinc", idincTaxable);
                    if (idincTaxable == DBNull.Value) {
                        estimateDetailRow["stop"] = stop;
                        estimateDetailRow["idaccmotiveannulment"] = idcausaleEpAnnullamento;
                        continue;
                    }
                    var amount = CfgFn.GetNoNullDecimal(estimateDetailRow["taxable"]) +
                                 CfgFn.GetNoNullDecimal(estimateDetailRow["tax"]);

                    decimal available = CfgFn.GetNoNullDecimal( _conn.readValue("incometotal",
                        q.eq("idinc", idincTaxable) & q.eq("ayear", esercizio), "available"));
                    if (available < amount) {
                        MessageBox.Show(
                            $"Il dettaglio {estimateDetailRow.idestimkind} {estimateDetailRow.yestim} {estimateDetailRow.nestim} riga {estimateDetailRow.rownum}" +
                            $" {estimateDetailRow.detaildescription} non pu� essere annullato perch� gi� incassato",
                            "Errore");
                        continue;
                    }
                    estimateDetailRow["stop"] = stop;
                    estimateDetailRow["idaccmotiveannulment"] = idcausaleEpAnnullamento;

                    //var nvar = 1;
                    //if (_conn.RUN_SELECT_COUNT("incomevar", fltmovI, false) > 0) {
                    //    var maxNvar = _conn.DO_READ_VALUE("incomevar", fltmovI, "max(nvar)");
                    //    nvar = CfgFn.GetNoNullInt32(maxNvar) + 1;
                    //}

                    MetaData.SetDefault(DS.incomevar,"idinc",idincTaxable);
                    var var = metaIncomeVar.Get_New_Row(null, DS.incomevar);
                    metaIncomeVar.SetDefaults(DS.incomevar);
                    var["yvar"] = esercizio;
                    //var["nvar"] = nvar;
                    var["adate"] = _security.GetDataContabile();
                    var["idinc"] = idincTaxable;
                    var["autokind"] = 11; // annullamento totale
                    var["amount"] = -amount;
                    var["description"] = $"Annul. bollettino univoco numero {iduniqueformcode}";

                    // Vario anche le classificazioni impostate allineandole con l'importo corrente
                    _conn.RUN_SELECT_INTO_TABLE(DS.incomesorted, null, fltmovI, null, true);
                    var rSorted = DS.incomesorted.Select(_qhc.CmpEq("idinc", idincTaxable));
                    foreach (var rSor in rSorted) {
                        rSor["amount"] = CfgFn.GetNoNullDecimal(rSor["amount"]) - amount;
                    }
                }

                rCreditoAnnullo["flag"] = CfgFn.GetNoNullInt32(rCreditoAnnullo["flag"]) | 1;

            }

            //Salva i dati
            //var myPostData = new Easy_PostData();
            //myPostData.initClass(DS, _conn);
            //var res = myPostData.DO_POST();
            //return res;
            return result;
        }


        #region generazione fatture da crediti da web

        // riempe la struttura dati GroupedInvoice da utilizzare per la successiva
        // eventuale generazione delle fatture raggruppate x idreg e per idinvkind

        private Dictionary<int, DataRow> registryByIdReg = new Dictionary<int, DataRow>();

        DataRow getRegistry(int idReg) {
            if (registryByIdReg.ContainsKey(idReg)) return registryByIdReg[idReg];
            DataTable t = _conn.readTable("registry", q.eq("idreg", idReg),"idreg,email_fe,pec_fe,flag_pa,title");
            if (t.Rows.Count == 0) return null;
            registryByIdReg[idReg] = t.Rows[0];
            return registryByIdReg[idReg];
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="fattureDaCreare">iduniqueformcode dei crediti su cui vanno create le fatture</param>
        /// <param name="filtroComune"></param>
        /// <returns></returns>
        private Dictionary<int, List<int>> fillGroupedInvoice(List<string> fattureDaCreare, q filtroComune) {
            var groupedInvoice = new Dictionary<int, List<int>>();
            var righe = DS.flussocreditidetail.readDetachedJoin(_conn, "upb", filtroComune,
                _security.SelectCondition("upb", true).toMetaExpression(), "idupb");
            //var righe = DS.flussocreditidetail.getDetachedRowsFromDb(_conn, filtroComune); //Da fatturare
            if (righe == null) return groupedInvoice; //nulla da fatturare
            var righeAnagr = DS.flussocreditidetail.readDetachedJoin(_conn, "registry", filtroComune, null, "idreg");

            foreach (var rCreditiDetail in righe) {
                var idreg = CfgFn.GetNoNullInt32(rCreditiDetail.idreg);

                var idinvkind = CfgFn.GetNoNullInt32(rCreditiDetail.idinvkind);
                if (idreg != 0 && !groupedInvoice.ContainsKey(CfgFn.GetNoNullInt32(idreg))) {
                    groupedInvoice.Add(idreg, new List<int>());
                }

                if (idinvkind != 0 && groupedInvoice[idreg].IndexOf(idinvkind) == -1) {
                    groupedInvoice[idreg].Add(idinvkind);
                }
            }

            return groupedInvoice;
        }


        private object calcolaDocumento(DataRow r, DataColumn c, IDataAccess conn) {
            var codiceDoc = r["idinvkind"];
            var formatString = DS.invoicekind.Filter(q.eq("idinvkind", codiceDoc))[0].formatstring ?? "{0:yy}/{1:d6}";
            var aa = new DateTime(CfgFn.GetNoNullInt32(r["yinv"]), 1, 1);
            var doc = string.Format(formatString, aa, r["ninv"]);
            //System.Diagnostics.Debug.WriteLine($"documento [{doc}]");
            return doc;
        }

        private  List<string>  GetFattureDaCreare(bool soloConSospesi, out string errori) {
            List<string>  fattureDaCreare = new List<string>();
            errori = "";
            // ciclo incassi non elaborati
            var filterNonElaborati = q.eq("ayear", esercizio) & q.eq("elaborato", "N");
            if (soloConSospesi) filterNonElaborati = filterNonElaborati & q.isNotNull("nbill");
            if (txtNumFlussoIncassi.Text != "") {
                int nFlussoDato = 0;
                if (int.TryParse(txtNumFlussoIncassi.Text, out nFlussoDato)) {
                    filterNonElaborati = filterNonElaborati & q.eq("idflusso", nFlussoDato);
                }
            }

            var righeFlussoIncassi = DS.flussoincassi.mergeFromDb(_conn, filterNonElaborati);
            
            //legge tutti i dettaglio flusso incassi in un colpo solo
            DS.flussoincassidetail.safeReadTableJoined(_conn, "flussoincassi", null,filterNonElaborati, "idflusso");

            

           

            string secUpb = _conn.Security.SelectCondition("upb",true);
            string joinUPB = "";
            string whereUPB = "";
            if (secUpb != null) {
                var qSec = MetaExpressionParser.From(secUpb);
                qSec.cascadeSetTable("upb");
                joinUPB = " JOIN UPB ON flussocreditidetail ON flussocreditidetail.idupb=UPB.idupb ";
                whereUPB = " AND "+qSec.toSql(_qhs,_conn);
            }

            //legge i dettagli flusso crediti in un colpo solo
            filterNonElaborati.cascadeSetTable("flussoincassidetailview","flussoincassi");//altrimenti non posso usarla con sqlCredDet

            string sqlCredDet = "SELECT " + QueryCreator.ColumnNameList(DS.flussocreditidetail)+
                    " FROM flussocreditidetail "+
                    joinUPB +
                    " WHERE ("+
                                "(iuv in (select iuv from flussoincassidetailview where "+ filterNonElaborati.toSql(_qhs)+") ) OR "+
                                "(iduniqueformcode in (select iduniqueformcode from flussoincassidetailview where "+ filterNonElaborati.toSql(_qhs)+")) "+
                                ")"+
                      " AND (flussocreditidetail.stop is null) AND (flussocreditidetail.annulment is null) "+
                                whereUPB;
            DS.flussocreditidetail._sqlSafeMergeFromDb(_conn,sqlCredDet);
                
                
            //    .safeReadTableJoined(_conn, "flussoincassidetailview",
            //    q.doPar(q.or(
            //                q.eq(q.field("iuv", "flussocreditidetail"), q.field("iuv", "flussoincassidetailview")),
            //                q.eq(q.field("iduniqueformcode", "flussocreditidetail"),q.field("iduniqueformcode", "flussoincassidetailview"))
            //             )) 
            //    & q.isNull(q.field("stop","flussocreditidetail")) & q.isNull(q.field("annulment","flussocreditidetail")),
            //    filterNonElaborati,"idflusso"                
            //);

            //aggiungere la lettura di flussoincassidetail in join con flussoincassi filtrato come sopra
            foreach (var rFlussoIncassi in righeFlussoIncassi) { //DS.flussoincassi.Select()
                var idflusso = rFlussoIncassi["idflusso"];
                var dettincassi = DS.flussoincassidetail.get(_conn, q.eq("idflusso", idflusso));

                foreach (var rFileDet in dettincassi) {
                    var iuv = rFileDet.iuv;
                    //if (iuv == null) continue;
                    // Leggo i dettagli contratto attivo da incassare facendo una ricerca per codice bollettino univoco
                    //  salta i dettagli annullati
                    flussocreditidetailRow[] dettCrediti = null;
                    if (iuv != null) {
                        q filterCrediti = (q.eq("iuv", iuv) & q.isNull("stop")) & q.isNull("annulment");
                        dettCrediti = DS.flussocreditidetail.Filter(filterCrediti);
                        //if (dettCrediti._IsEmpty()) {
                        //    dettCrediti = DS.flussocreditidetail.readTableJoined(_conn, "upb",filterCrediti,
                        //        _security.SelectCondition("upb",true).toMetaExpression(),"idupb");
                        //}
                        ////
                    }

                    if ((dettCrediti == null || dettCrediti.Length == 0) &&
                      !string.IsNullOrEmpty(rFileDet.iduniqueformcode)) {
                        q filterCrediti = (q.eq("iduniqueformcode", rFileDet.iduniqueformcode) & q.isNull("stop")) & q.isNull("annulment");
                        dettCrediti = DS.flussocreditidetail.Filter(filterCrediti);
                        //if (dettCrediti._IsEmpty()) {
                        //    dettCrediti = DS.flussocreditidetail.readTableJoined(_conn, "upb",filterCrediti,
                        //        _security.SelectCondition("upb",true).toMetaExpression(),"idupb");
                        //}
                    }
                    foreach (var rCredito in dettCrediti) {
                        var codiceBollettino = rCredito.iduniqueformcode;
                        if (string.IsNullOrEmpty(codiceBollettino)) continue;
                        if (fattureDaCreare.Contains(codiceBollettino)) {
                            continue;
                        }
                        bool contrattoCollegabileAFattura = false;

                        // Leggo i dettagli contratto attivo da incassare facendo una ricerca per codice bollettino univoco
                        // salta i dettagli annullati
                        var rows = DS.estimatedetail.Filter(q.eq("iduniqueformcode", codiceBollettino) &
                                                            q.isNull("stop"));
                        if (rows._IsEmpty()) {
                            rows = DS.estimatedetail.readTableJoined(_conn, "upb",
                                q.eq("iduniqueformcode", codiceBollettino) & q.isNull("stop"),
                                _security.SelectCondition("upb",true).toMetaExpression(),
                                "idupb");
                        }
                        foreach (var rEstimDet in rows) {
                            // Se il contratto attivo � di tipo collegabile a fattura lo salto
                            var collegabileafattura = getCollegabileAFattura(rEstimDet.idestimkind);
                            // Non dobbiamo incassare dettagli contratti attivi di tipo collegabile a fattura
                            // perch� in tal caso dobbiamo incassare la fattura
                            if (collegabileafattura) {
                                contrattoCollegabileAFattura = true;
                                break;
                            }
                        }

                        if (!contrattoCollegabileAFattura) {
                            fattureDaCreare.Add(codiceBollettino);
                        }
                    }
                }
            }

            return fattureDaCreare;
        }

        private bool GetDettFatturaSenzaScritture (DataRow InvDet) {
            string idrelated = EP_functions.GetIdForDocument(InvDet);
          
            if (_conn.RUN_SELECT_COUNT("entrydetail", _qhs.CmpEq("idrelated", idrelated), false) > 0)
                return false;
            else return true;
        }



        // ritorna -1 per errore siope, -2 per errore salvataggio saldi
        // List<int>  indicano idflusso delle fatture generate;
        private int generaFatture(List<string> fattureDaCreare, out List<int> elencoIdFlussiCreditiCollegati) {
            // la verifica sul campo istransmitted='S' di flussocrediti � superfluea in quanto fattureDaCreare
            // contiene i iduniqueformcode (sul quale filtra fillGroupedInvoice) che sono stati presi dagli incassi e quindi � ovvio supporre che essendoci
            // gi� l'incasso il flusso debba necessariamente essere stato preventivamente trasmessso

            elencoIdFlussiCreditiCollegati = new List<int>();
            DS.ivaregister.Clear();
            var filtroComune = q.isNull("ninv") & q.isNotNull("idinvkind") & q.isNull("yinv") &
                               q.isNull("idestimkind") & q.isNull("stop") & q.isNull("annulment") & 
                               q.fieldIn("iduniqueformcode", fattureDaCreare.Cast<object>().ToArray());

            //Calcola un elenco in cui ad ogni idreg � associato un elenco di idinvkind 
            var groupedInvoice = fillGroupedInvoice(fattureDaCreare, filtroComune);
            if (groupedInvoice.Count == 0) {
                //MessageBox.Show("Nessuna fattura da generare dagli incassi.", "Avviso");
                return 0; //nulla da generare
            }

            var metaInvoiceDetail = MetaData.GetMetaData(this, "invoicedetail");
            metaInvoiceDetail.SetDefaults(DS.invoicedetail);
            var metaInvoice = MetaData.GetMetaData(this, "invoice");
            metaInvoice.SetDefaults(DS.invoice);
            var metaIvaRegister = MetaData.GetMetaData(this, "ivaregister");
            metaIvaRegister.SetDefaults(DS.ivaregister);

            //string invoiceFlagregister = DS.config[0].invoice_flagregister?.ToUpper() ?? "N";

            var idcurrencyEuro =
                CfgFn.GetNoNullInt32(_conn.readValue("currency", q.eq("codecurrency", "EUR"), "idcurrency"));

            var doc = DS.invoice.Columns["doc"];
            DS.invoice.ExtendedProperties["docautomatico"] = "S";
            DS.invoice.setAutoincrement(doc.ColumnName, null, null, 6);
            DS.invoice.setCustomAutoincrement(doc.ColumnName, calcolaDocumento);

            var totFatGenerate = 0;
            //if (invoiceFlagregister == "S") {
            //    DS.ivaregister.setAutoincrement("ninv", null, null, 6);
            //    DS.ivaregister.setMySelector("ninv", "idinvkind", 0);
            //    DS.ivaregister.setMySelector("ninv", "yinv", 0);
            //    DS.ivaregister.setMySelector("ninv", "idivaregisterkind", 0);
            //    MetaData.SetDefault(DS.ivaregister, "yinv", esercizio); 

            //    DS.Relations.Remove("ivaregisterinvoice");
            //    DS.defineRelation("ivaregisterinvoice", "ivaregister", "invoice", "idinvkind", "yinv", "ninv");

            //    DS.invoice.clearAutoIncrement("ninv");                
            //}
            object flagiva_immediate_or_deferred = _conn.readValue("config",q.eq("ayear", esercizio), "flagiva_immediate_or_deferred");

            #region testata invoice


            foreach (var invoicesByIdreg in groupedInvoice) { //tutti gli studenti/utenti web
                Application.DoEvents();
                var idreg = invoicesByIdreg.Key;

                bool anagraficaPubblicaAmministrazione = isPARegistry( idreg);

                var groupedInvoiceByidinvkindRow = new Dictionary<int, invoiceRow>();
                DS.flussocreditidetail.safeReadTableJoined(_conn, "upb",q.eq("idreg", idreg) & filtroComune,
                                _security.SelectCondition("upb",true).toMetaExpression(),"idupb");
                //DS.flussocreditidetail.safeMergeFromDb(_conn, q.eq("idreg", idreg) & filtroComune);
                var righeCreditiDetail = DS.flussocreditidetail.Filter(q.eq("idreg", idreg) & filtroComune);
                // Da fatturare per idreg, idinvkind corrente e collegate ad incassi per iduniqueformcode

                flussocreditidetailRow rigaCreditoDetail;
                if (righeCreditiDetail == null || !righeCreditiDetail._HasRows()) {
                    //non dovrebbe mai succedere, per costruzione
                    continue;
                }
                rigaCreditoDetail = righeCreditiDetail.First();


                var rigaCredito = DS.flussocrediti.get(_conn, q.eq("idflusso", rigaCreditoDetail.idflusso)).First();

                //per ogni raggruppamento crea una riga in invoice e la mette in groupedInvoiceByidinvkindRow
                foreach (var idinvkind in invoicesByIdreg.Value) { //tutti i tipi di fatture associati allo studente
                    DataRow regRow = getRegistry(idreg);

                    #region testata invoice 

                    if (groupedInvoiceByidinvkindRow.ContainsKey(idinvkind)) continue;//Nino: per costruzione lo ritengo superfluo

                    var registerToLink = DS.invoicekindregisterkind.get(_conn, q.eq("idinvkind", idinvkind));

                    DS.invoice.setDefault("idinvkind",idinvkind);
                    var rInvoice = metaInvoice.Get_New_Row(null, DS.invoice) as invoiceRow;
                    totFatGenerate++;


                    var adesso = DateTime.Now;

                    // ReSharper disable once PossibleNullReferenceException
                    rInvoice.idinvkind = idinvkind;

                    rInvoice.yinvValue = adesso.Year;
                    rInvoice.active = "S";
                    rInvoice.adate = DateTime.Today;
                    rInvoice.docdate = DateTime.Today;
                    rInvoice.description = "Fattura da Portale Web";
                    //rInvoice["doc"] = "";


                    //task 14005 si richiede la valorizzazione dei campi per la f.e.
                    rInvoice.idfepaymethod = "MP05"; //Bonifico
                    rInvoice.idfepaymethodcondition = "TP02"; //Pagamento completo
                    rInvoice.email_ven_clienteValue = regRow["email_fe"];
                    rInvoice.pec_ven_clienteValue = regRow["pec_fe"];

                    rInvoice.exchangerate = 1;
                    //rInvoice.flagdeferred = "N"; //TODO nota doc - IN QUESTA VERSIONE SOLO PRIVATI OK
                    rInvoice.idreg = idreg;
                    rInvoice.officiallyprinted = "N";

                    rInvoice.idcurrency = idcurrencyEuro;

                    rInvoice.idexpirationkind = null;
                    //rInvoice["idtreasurer"] = idtreasurer; //pre da upb quindi DEVO impostare da creditidetail e quindi nel dettaglio

                    rInvoice["flagintracom"] = "N"; //TODO da verificare su doc - PER ORA OK fatture estere seguir� analisi
                    rInvoice.flag_ddt = "N";
                    rInvoice.flag = 2;
                    rInvoice.idaccmotivedebit = rigaCreditoDetail.idaccmotivecredit;

                    rInvoice.autoinvoice = "N";
                    rInvoice.idsor01 = rigaCredito.idsor01; //TODO nota Doc - Risolto dovrebbe andar bene cos�
                    rInvoice.idsor02 = rigaCredito.idsor02;
                    rInvoice.idsor03 = rigaCredito.idsor03;
                    rInvoice.idsor04 = rigaCredito.idsor04;
                    rInvoice.idsor05 = rigaCredito.idsor05;

                    rInvoice.toincludeinpaymentindicator = "N";
                    rInvoice.resendingpcc = "N";
                    rInvoice.touniqueregister =
                        "N"; //TODO  PER IL MOMENTO SOLO PRIVATI RES IN ITALIA OK - Per persona giuridica potrebbe essere 'S' ?? - e Se vale 'S' va calcolato un n� di registro Nota Nino su doc
                    rInvoice.idstampkind = "NO";
                    rInvoice.flag_auto_split_payment = "N"; //TODO Nota su doc
                    rInvoice.flag_enable_split_payment =
                        "N"; //TODO  default 'N' ma bisogna a questo punto analizzare la logica di valorizzazione. IN Questa versione SOLO privati dovrebbe andar bene 
                    rInvoice.flag_reverse_charge = "N";
                    rInvoice["flagbit"] = 0;
                    rInvoice["requested_doc"] = 0;

                    if (anagraficaPubblicaAmministrazione) {
                        rInvoice.flag_enable_split_payment = "S";
                        rInvoice.flagdeferred = "N";
                    }
                    else {
                        rInvoice.flag_enable_split_payment = "N";
                        rInvoice.flagdeferred = "S";
                    }

                    //if (flagiva_immediate_or_deferred == null || flagiva_immediate_or_deferred == DBNull.Value) {
                    //    flagiva_immediate_or_deferred = "I";
                    //}
                    //if (flagiva_immediate_or_deferred.ToString() == "D") {
                    //    rInvoice[ "flagdeferred"]= "S";
                    //}
                    //else {
                    //    rInvoice[ "flagdeferred"]= "N";
                    //}


                    //if (rInvoice["flagintracom"].ToString().ToUpper() != "N"
                    //    || rInvoice["flag_reverse_charge"].ToString().ToUpper() == "S"
                    //) {                        
                    //    rInvoice.flagdeferred = "N";                        
                    //}
                      

                    //if (invoiceFlagregister == "N") { //in questo caso crea prima le fatture poi i registri
                    foreach (var reg in registerToLink) {
                        MetaData.SetDefault(DS.ivaregister, "idivaregisterkind", reg["idivaregisterkind"]);
                        var rIvaRegister = metaIvaRegister.Get_New_Row(rInvoice, DS.ivaregister);
                    }
                    //}

                    groupedInvoiceByidinvkindRow.Add(idinvkind, rInvoice);

                    if (elencoIdFlussiCreditiCollegati.IndexOf((int) rigaCreditoDetail.idflusso) < 0) {
                        elencoIdFlussiCreditiCollegati.Add((int) rigaCreditoDetail.idflusso);
                    }

                    #endregion

                } // 2� foreach su idinvkind (tipo di fattura) di ogni idreg 

                #region invoicedetail


                foreach (var rCreditiDetail in righeCreditiDetail) {
                    Application.DoEvents();
                    string erroreSiope;
                    var rigaList = DS.list.get(_conn, q.eq("idlist", rCreditiDetail["idlist"]))._First();

                    var idinvkind = CfgFn.GetNoNullInt32(rCreditiDetail["idinvkind"]);
                    var invoiceRow = groupedInvoiceByidinvkindRow[idinvkind];
                    var rInvoiceDetail = metaInvoiceDetail.Get_New_Row(invoiceRow,DS.invoicedetail) as invoicedetailRow; //associata a testata per idinvkind corretto!
                    //rCreditiDetail["stop"] = DBNull.Value;  
                    if (rInvoiceDetail.rownum < 1000) rInvoiceDetail.rownum = 1000;
                    rCreditiDetail.idinvkind = rInvoiceDetail.idinvkind;
                    rCreditiDetail.yinv = rInvoiceDetail.yinv;
                    rCreditiDetail.ninv = rInvoiceDetail.ninv;
                    rCreditiDetail.invrownum = rInvoiceDetail.rownum;

                    rInvoiceDetail.annotations = rCreditiDetail.annotations;
                    // ReSharper disable once PossibleNullReferenceException
                    //rInvoiceDetail.annotations = null;
                    rInvoiceDetail.competencystart = rCreditiDetail.competencystart;
                    //rInvoiceDetail.paymentcompetency = null;
                    rInvoiceDetail.competencystop = rCreditiDetail.competencystop;
                    rInvoiceDetail.detaildescription = rCreditiDetail.description; //rigaList.description;
                    //rInvoiceDetail.discount = null;
                    rInvoiceDetail.idaccmotive = rCreditiDetail.idaccmotiverevenue;
                    //rInvoiceDetail.idmankind = null;
                    rInvoiceDetail["idupb"] = rCreditiDetail["idupb"];

                    rInvoiceDetail["idupb_iva"] = rCreditiDetail.idupb_iva; // ["idupb_iva"];

                    if (invoiceRow["idtreasurer"] == DBNull.Value
                    ) {
                        object idtreasurer = DBNull.Value;
                        if (rCreditiDetail["idupb"] != null) {
                            var rupb = DS.upb.get(_conn, q.eq("idupb", rCreditiDetail["idupb"]));
                            if (rupb != null) {
                                idtreasurer = rupb._First()["idtreasurer"];
                            }
                        }
                        //TODO - prendo il primo tesoriere esistente tra tutti i dettaglicrediti
                        invoiceRow["idtreasurer"] =
                            idtreasurer; //per prenderlo da upb mi serve idupb creditidetail e quindi lo si deve impostare qui !
                    }


                    rInvoiceDetail["number"] = CfgFn.GetNoNullDecimal(rCreditiDetail["number"]);
                    rInvoiceDetail["tax"] = CfgFn.GetNoNullDecimal(rCreditiDetail["tax"]);
                    rInvoiceDetail["taxable"] = CfgFn.GetNoNullDecimal(rCreditiDetail["importoversamento"]) /
                                                CfgFn.GetNoNullDecimal(
                                                    rCreditiDetail["number"]); //TODO: Cos� � Prezzo unitario !!
                    rInvoiceDetail["unabatable"] = 0;
                    rInvoiceDetail["idestimkind"] = rCreditiDetail["idestimkind"];
                    rInvoiceDetail["nestim"] = rCreditiDetail["nestim"];
                    rInvoiceDetail["yestim"] = rCreditiDetail["yestim"];
                    rInvoiceDetail["idivakind"] = CfgFn.GetNoNullInt32(rCreditiDetail["idivakind"]);
                    rInvoiceDetail["idinvkind"] = CfgFn.GetNoNullInt32(rCreditiDetail["idinvkind"]);
                    rInvoiceDetail.idsor1 = rCreditiDetail.idsor1;
                    rInvoiceDetail["idsor2"] = CfgFn.GetNoNullInt32(rCreditiDetail["idsor2"]);
                    rInvoiceDetail["idsor3"] = CfgFn.GetNoNullInt32(rCreditiDetail["idsor3"]);

                    rInvoiceDetail["idlist"] = rCreditiDetail.idlist;

                    rInvoiceDetail.idunit = rigaList.idunit;
                    rInvoiceDetail.idpackage = rigaList.idpackage;
                    rInvoiceDetail.unitsforpackage = CfgFn.GetNoNullInt32(rigaList.unitsforpackage);
                    rInvoiceDetail.unitsforpackage =
                        rInvoiceDetail.unitsforpackage == 0 ? 1 : rInvoiceDetail.unitsforpackage;

                    var npackage = (decimal) rInvoiceDetail["number"] / (int) rInvoiceDetail.unitsforpackage;

                    rInvoiceDetail["npackage"] = npackage;
                    rInvoiceDetail.flag = rCreditiDetail.flag;
                    rInvoiceDetail["flagbit"] = 0;
                    rInvoiceDetail.idfinmotive = rCreditiDetail.idfinmotive;
                    rInvoiceDetail.iduniqueformcode = rCreditiDetail.iduniqueformcode;
                    var idSiope = getSiopeForAccMotive(rCreditiDetail.idaccmotiverevenue, out erroreSiope);
                    if (!string.IsNullOrEmpty(erroreSiope)) {
                        MessageBox.Show(erroreSiope, @"Errore"); //?? mostrare errore e interrompere ?
                        return -1;
                    }

                    if (idSiope != null) {
                        rInvoiceDetail["idsor_siope"] = idSiope;
                    }

                    calcolaIvaIvaindetraibile(rInvoiceDetail, invoiceRow);
                }


                #endregion


            } // 1� foreach su idreg (studenti)

            #endregion
            
            DataSet d = DS.Copy();
            foreach (DataTable t in d.Tables) {
                if (t.HasChanges()) continue;
                t.Clear();
            }
            d.WriteXml("flussoIncassiDataSet.xml");

            //Salva i dati per assegnare i numeri alle fatture
            var myPostData = new Easy_PostData();
            myPostData.initClass(DS, _conn);
            bool res = myPostData.DO_POST();
            if (res) MessageBox.Show("Le fatture sono state generate", "Avviso");
            if (!res) return -2;

            return totFatGenerate;
        }

        bool isPARegistry(int idreg) {
            DataRow reg = getRegistry(idreg);
            object flag_pa = reg["flag_pa"];
            //object flag_pa = _conn.readValue("registry", q.eq("idreg", idreg), "flag_pa");
            if (flag_pa?.ToString().ToUpperInvariant() == "S") return true;
            return false;
        }

        private bool GetGeneralFlagSplitPayment() {
            if (DS.config.Rows.Count > 0) {
                DataRow rSetup = DS.config.Rows[0];
                if (rSetup["flagsplitpayment"] == DBNull.Value)
                    return false;
                return (rSetup["flagsplitpayment"].ToString() == "S");
            }
            else
                return false;
        }

        #endregion


        #region stampa fattura

        DataTable createPrimaryTable() {
            //if (DS.Tables["export"] != null) {
            //	myPrymaryTable = DS.Tables["export"];
            //	return myPrymaryTable;
            //}

            var myPrimaryTable = new DataTable("export");
            //var dataContabile = _security.GetDataContabile();

            //Create a dummy primary key
            var dcpk = new DataColumn("DummyPrimaryKeyField", typeof(int)) {DefaultValue = 1};
            myPrimaryTable.Columns.Add(dcpk);
            myPrimaryTable.PrimaryKey = new[] {dcpk};

            myPrimaryTable.Columns.Add(new DataColumn("reportname", typeof(string)));
            myPrimaryTable.Columns.Add(new DataColumn("ayear", typeof(int)) {DefaultValue = esercizio});
            myPrimaryTable.Columns.Add(new DataColumn("printkind", typeof(string)) {DefaultValue = "I"});
            myPrimaryTable.Columns.Add(new DataColumn("idinvkind", typeof(int)));
            myPrimaryTable.Columns.Add(new DataColumn("ninv_start", typeof(int)));
            myPrimaryTable.Columns.Add(new DataColumn("ninv_stop", typeof(int)));
            myPrimaryTable.Columns.Add(new DataColumn("official", typeof(string)) {DefaultValue = "N"});
            myPrimaryTable.Columns.Add(new DataColumn("showcfpiva", typeof(string)) {DefaultValue = "C"});
            myPrimaryTable.Columns.Add(new DataColumn("autoinvoice", typeof(string)) {DefaultValue = "N"});

            var r = myPrimaryTable.NewRow();
            myPrimaryTable.Rows.Add(r);
            //DS.Tables.Add(myPrymaryTable);
            return myPrimaryTable;
        }

        private bool stampaInviaMailFatture(invoiceRow fattura) {
            string errmess;
            string pdfFileName;
            registryRow registryrow;
            var msgprefix = "Si � verificato un errore ";

            bool res = stampaFattura(fattura, out errmess, out pdfFileName, out registryrow);
            if (res) {
                Application.DoEvents();
                var sm = new SendMail {Conn = _conn as DataAccess};
                var idreg = registryrow.idreg;
                var registryreferencerow = DS.registryreference
                    .get(_conn, q.eq("idreg", idreg) & q.eq("activeweb", "S"))._First();
                if (registryreferencerow == null) return false;

                try {
                    var metaUniversitaRow = DS.generalreportparameter.get(_conn,
                        q.eq("idparam", "DenominazioneUniversita") & q.isNull("stop"));
                    string universita = "";
                    if (metaUniversitaRow != null) {
                        universita = metaUniversitaRow._First()["paramvalue"].ToString();
                    }

                    sm.addAttachment(pdfFileName);
                    sm.To = registryreferencerow.email;
                    sm.Subject = "Invio fattura per articoli acquistati sul portale dell'Universit� " + universita;
                    sm.MessageBody =
                        "In allegato alla presente si invia la fattura per quanto acquistato sul nostro sito web";

                    sm.UseSMTPLoginAsFromField = true;
                    if (!sm.Send()) {
                        if (sm.ErrorMessage.Trim() != "") {
                            MessageBox.Show(
                                $"{msgprefix}nell\'invio della fattura a mezzo e-mail: ({fattura.ninv}/{fattura.yinv} - {fattura.idinvkind}) - {sm.ErrorMessage.Trim()}");
                            return false;
                        }
                    }

                    //System.Threading.Thread.Sleep(5000);
                }
                catch (Exception e) {
                    MessageBox.Show(
                        $"{msgprefix}nell\'invio della fattura a mezzo e-mail: ({fattura.ninv}/{fattura.yinv} - {fattura.idinvkind}) - {e.Message}");
                    return false;
                }

            }
            else {
                MessageBox.Show(
                    $"{msgprefix}nella stampa della fattura: ({fattura.ninv}/{fattura.yinv} - {fattura.idinvkind}) - {errmess}");
                return false;
            }

            return true;
        }


        private bool stampaFattura(invoiceRow invoice, out string errmess, out string pdfFileName,
            out registryRow registryrow) {
            pdfFileName = "";
            registryrow = null;
            var nomeReport = "fatturavendita";
            var drReg = DS.registry.getDetachedRowsFromDb(_conn, q.eq("idreg", invoice.idreg) & q.eq("active", "S"));
            if (drReg == null) {
                errmess = $"Registry non trovato: \'{invoice.idreg}\'";
                return false;
            }

            registryrow = drReg._First();

            DataTable myPrymaryTable = createPrimaryTable();
            myPrymaryTable.Rows[0]["printkind"] = "I";
            myPrymaryTable.Rows[0]["reportname"] = nomeReport;
            myPrymaryTable.Rows[0]["idinvkind"] = invoice.idinvkind;
            myPrymaryTable.Rows[0]["ninv_start"] = invoice.ninv; //Significa che DEVONO essere state salvate !
            myPrymaryTable.Rows[0]["ninv_stop"] = invoice.ninv; //Significa che DEVONO essere state salvate !
            if (registryrow.p_iva == null)
                myPrymaryTable.Rows[0]["showcfpiva"] = "C";
            else
                myPrymaryTable.Rows[0]["showcfpiva"] = "P";

            var modulereport = DS.report.getDetachedRowsFromDb(_conn, q.eq("reportname", nomeReport));

            if (modulereport == null) {
                errmess = "Report: '" + nomeReport + "' non trovato.";
                return false;
            }

            ;
            var rep = modulereport._First();
            var par = myPrymaryTable.Rows[0];

            var myRptDoc = Easy_DataAccess.GetReport(_conn as Easy_DataAccess, rep, par, out errmess);
            if (myRptDoc == null) {
                return false;
            }

            string tempdir = Path.GetTempPath();
            if (!tempdir.EndsWith("\\")) tempdir += "\\";
            var tempfilename = Guid.NewGuid() + ".pdf";
            pdfFileName = tempdir + tempfilename;
            return exportToPdf(myRptDoc, tempfilename, tempdir);
        }

        /// <summary>
        /// Restituisce il percorso del report in formato PDF a cui puntare con Response.Redirect
        /// </summary>
        /// <param name="rd"></param>
        /// <param name="fileName"></param>
        /// <param name="relativePath"></param>
        /// <returns></returns>
        private bool exportToPdf(ReportDocument rd, string fileName, string relativePath) {
            var tempfilename = relativePath + fileName;
            // Declare variables and get the export options.
            //ExportOptions exportOpts = new ExportOptions();
            //PdfRtfWordFormatOptions pdfRtfWordOpts = new PdfRtfWordFormatOptions ();

            // Set the export format.
            //pdfRtfWordOpts.FirstPageNumber = 1;
            //pdfRtfWordOpts.LastPageNumber = 2;
            //pdfRtfWordOpts.UsePageRange = true;
            //RD.ExportOptions.FormatOptions = pdfRtfWordOpts;
            rd.ExportOptions.ExportFormatType = ExportFormatType.PortableDocFormat;
            rd.ExportOptions.ExportDestinationType = ExportDestinationType.DiskFile;

            DiskFileDestinationOptions diskOpts = new DiskFileDestinationOptions {DiskFileName = tempfilename};
            rd.ExportOptions.DestinationOptions = diskOpts;

            // Export the report
            try {
                rd.Export();
                return File.Exists(tempfilename);
            }
            catch (Exception e) {
                if (!e.ToString().Contains("0x8000030E")) return false;
                MessageBox.Show(this,
                    "E' necessario disinstallare l'aggiornamento di windows KB3102429 per poter effettuare la stampa.\nSeguono istruzioni su come procedere.",
                    "Avviso");
                System.Diagnostics.Process.Start("disinstalla_kb3102429.pdf");
                return false;
            }
        }

        #endregion

        ///// <summary>
        ///// Ricalcola iva e ivaindetraibile in base a imponibile, quantit�, tasso cambio e sconto
        ///// </summary>
        ///// <param name="rInvoicedetail"></param>
        private void calcolaIvaIvaindetraibile(DataRow rInvoicedetail, invoiceRow rInvoice) {
            double newnpackage = CfgFn.GetNoNullDouble(rInvoicedetail["npackage"]);
            double tassocambio = CfgFn.GetNoNullDouble(CfgFn.GetNoNullDouble(rInvoice["exchangerate"]));
            var rIvaKind = DS.ivakind.f_Eq("idivakind", rInvoicedetail["idivakind"]).FirstOrDefault();            
            double aliquota = CfgFn.GetNoNullDouble(rIvaKind?.rateValue);
                
                    //_conn.readValue("ivakind", q.eq("idivakind", rInvoicedetail["idivakind"]), "rate"));
            double percindeduc = CfgFn.GetNoNullDouble(rIvaKind?.unabatabilitypercentageValue);
                //q.eq("idivakind", rInvoicedetail["idivakind"]), "unabatabilitypercentage");
            double imponibile = CfgFn.GetNoNullDouble(rInvoicedetail["taxable"]);
            double quantitaConfezioni = newnpackage;
            double sconto = CfgFn.GetNoNullDouble(rInvoicedetail["discount"]);
            double imponibiletot = CfgFn.RoundValuta((imponibile * quantitaConfezioni * (1 - sconto)));
            double imponibiletotEur = CfgFn.RoundValuta(imponibiletot * tassocambio);
            double ivaEur = CfgFn.RoundValuta(imponibiletotEur * aliquota);
            double impindeducEur = CfgFn.RoundValuta(ivaEur * percindeduc);

            rInvoicedetail["tax"] = ivaEur;
            rInvoicedetail["unabatable"] = impindeducEur;
        }

        ///// <summary>
        ///// Imposta un flag su tutte le righe di flussocrediti ancora non elaborate ma annullate  avente 
        /////     iduniqueformcode presente in iduniqueformcodeToAnnul
        ///// </summary>
        ///// <param name="D"></param>
        ///// <param name="ErrMsg"></param>
        ///// <returns></returns>
        //bool myAnnulmentUpdater(DataSet D, out string ErrMsg) {
        //    ErrMsg = null;
        //    object annulDate = Meta.Conn.GetSys("datacontabile");
        //    foreach(object iduniqueformcode in iduniqueformcodeToAnnul) {
        //        Meta.Conn.DO_SYS_CMD("update flussocreditidetail set flag=isnull(flag,0) | 1 where " +
        //               QHS.AppAnd(QHS.CmpEq("iduniqueformcode", iduniqueformcode), QHS.IsNotNull("annulment"), QHS.BitClear("flag", 0)),
        //               out ErrMsg);                
        //        if (ErrMsg != null) return false;
        //    }
        //    return true;
        //}

        void azzeraMovimentiFinanziariEntrata() {
            DS.income.Clear();
            DS.incomelast.Clear();
            DS.income.Clear();
            DS.incomeyear.Clear();
            DS.incomesorted.Clear();
            DS.incomeinvoice.Clear();
        }

        bool creaFatture(bool soloConSospesi) {
            string error = "";
            var fattureDaCreare = GetFattureDaCreare(soloConSospesi, out error);
            List<int> fattureGenerateByIdFlusso;
            int fattureCreate = generaFatture(fattureDaCreare, out fattureGenerateByIdFlusso);

            if (fattureCreate == 0) {
                MessageBox.Show("Non sono state trovate fatture da generare.", "Avviso");
                return true;
            }

            VisualizzaFatture();

            if (fattureCreate < 0) {
                if (fattureCreate == -1) MessageBox.Show("Errore nella generazione fatture - probabile errore siope", "Errore");
                if (fattureCreate == -2) MessageBox.Show("Errore nella generazione fatture - errore salvando i dati","Errore");
                return false; //-1 errore siope
            }

            if (!doStampaInviaMailFatture()) {
                MessageBox.Show("Errore nell'invio delle mail per le fatture", "Errore");
            }

            generoScrittureFatture();
            

            return true;
        }

        
        bool generaIncassiFatture(bool soloConSospesi, out string error) {
            error = "";
            DataSet dSupdated;

            azzeraMovimentiFinanziariEntrata();

            bool res = creaIncassiFatture(soloConSospesi);
            if (!res) {
                error = " (Crea Incassi Fatture)";
                return false;
            }
            if (res && !DS.HasChanges()) {                
                MessageBox.Show("Nessun incasso da generare");
                
            }
            if (res && DS.HasChanges()) {
                if (doSave(out dSupdated)) {
                    MessageBox.Show("Gli incassi per le fatture sono stati generati");
                }
            }

           azzeraTutto();

            return res;

        }

        /// <summary>
        /// In ds i dati aggiornati su flussocrediti flussoincassi invoice estimate ivaregister
        /// </summary>
        /// <param name="dSupdated"></param>
        /// <returns></returns>
        private bool aggiornaChiaviDs(DataSet sourceDataSet) {
            try {
                DS.AcceptChanges();
                DS.flussocrediti.Clear();
                DS.flussocreditidetail.Clear();
                DS.flussoincassi.Clear();
                DS.flussoincassidetail.Clear();

                if (sourceDataSet.Tables.Contains("flussocrediti"))DS.flussocrediti.Merge(sourceDataSet.Tables["flussocrediti"], false);
                if (sourceDataSet.Tables.Contains("flussocreditidetail"))DS.flussocreditidetail.Merge(sourceDataSet.Tables["flussocreditidetail"], false);
                if (sourceDataSet.Tables.Contains("flussoincassi"))DS.flussoincassi.Merge(sourceDataSet.Tables["flussoincassi"], false);
                if (sourceDataSet.Tables.Contains("flussoincassidetail"))DS.flussoincassidetail.Merge(sourceDataSet.Tables["flussoincassidetail"], false);

                DS.invoice.Clear();
                DS.invoicedetail.Clear();
                DS.ivaregister.Clear();
                if (sourceDataSet.Tables.Contains("invoice")) DS.invoice.Merge(sourceDataSet.Tables["invoice"], false);
                if (sourceDataSet.Tables.Contains("invoicedetail"))DS.invoicedetail.Merge(sourceDataSet.Tables["invoicedetail"], false);
                if (sourceDataSet.Tables.Contains("ivaregister"))DS.ivaregister.Merge(sourceDataSet.Tables["ivaregister"], false);

                DS.estimate.Clear();
                DS.estimatedetail.Clear();
                if (sourceDataSet.Tables.Contains("estimate")) DS.estimate.Merge(sourceDataSet.Tables["estimate"]);
                if (sourceDataSet.Tables.Contains("estimatedetail"))DS.estimatedetail.Merge(sourceDataSet.Tables["estimatedetail"]);
            }
            catch (Exception ex) {
                MessageBox.Show(this,
                    $"Errore nell\'aggiornamento delle chiavi del db! Processo Terminato\n{ex.Message}");
                return false;
            }

            return true;
        }

        private void VisualizzaFatture() {
            __regTitles.Clear();
            for (int i = 0; i < DS.invoice.Rows.Count; i++) {
                AddVoceCreditore(DS.invoice.Rows[i]);
            }
            HelpForm.SetDataGrid(dgrFattureElaborate, DS.invoice);
        }

        
        /// <summary>
        /// Invia le mail per le fatture presenti in DS.invoice
        /// stampe fatture pdf e invio mail - DEVONO ESSERE gi� salvate per poter generare i pdf perch� viene richiesto il n� di fattura iniziale/finale
        /// </summary>
        /// <returns></returns>
        private bool doStampaInviaMailFatture() {
            //
            //TODO rivedere perch� in caso di errore le fatture NON vengono inviate al cliente web ed occorrerebbe 'contrassegnarle' per re-inviarle  ??

            foreach (var invoicerow in DS.invoice) {
                var res = stampaInviaMailFatture(invoicerow);
                if (!res) return false;
            }

          


            return true;
        }
 
 
                
        /// <summary>
        /// Crea gli incassi per i contratti attivi, ed eventualmente anche gli accertamenti. Valorizza la data inizio per i dettagli contratto a generazione differita
        /// </summary>
        /// <param name="soloConSospesi"></param>
        /// <returns></returns>
        private bool creaIncassiContrattiAttivi(bool soloConSospesi) {
            //Dictionary<int, decimal> flussoIncassiAmounts = new Dictionary<int, decimal>();
            DS.estimatedetail.Clear();
            DS.invoice.Clear();
            DS.invoicedetail.Clear();
            DS.ivaregister.Clear();
        
            DS.flussoincassi.Clear();
            DS.flussoincassidetail.Clear();

            DS.flussocrediti.Clear();
            DS.flussocreditidetail.Clear();
        
            var filterNonElaborati = q.eq("ayear", esercizio) & q.eq("elaborato", "N");
            if (soloConSospesi) filterNonElaborati = filterNonElaborati & q.isNotNull("nbill");
            if (txtNumFlussoIncassi.Text != "") {
                int nFlussoDato = 0;
                if (int.TryParse(txtNumFlussoIncassi.Text, out nFlussoDato)) {
                    filterNonElaborati = filterNonElaborati & q.eq("idflusso", nFlussoDato);
                }
            }

            DS.flussoincassi.getFromDb(_conn, filterNonElaborati);
            DS.flussoincassidetail.readTableJoined(_conn, "flussoincassi", null, filterNonElaborati, "idflusso");

            var filterCrediti = q.or(
                                        q.eq(q.field("iuv","flussoincassidetail"),q.field("iuv","flussocreditidetail")),
                                        q.eq(q.field("iduniqueformcode","flussoincassidetail"),q.field("iduniqueformcode","flussocreditidetail"))
                                     )
                                
                                & q.isNull("stop") & q.isNull("annulment");
            string colonneDettCrediti   = string.Join(",", 
                    (from c in DS.flussocreditidetail.Columns._names() where QueryCreator.IsReal(DS.flussocreditidetail.Columns[c]) //& c!="barcodeimage" & c!="qrcodeimage"
                    select "flussocreditidetail."+c  ).ToArray());
            var condUpb = _security.SelectCondition("upb", true).toMetaExpression();
            
            var joinUpbSql = "";
            var condUpbSql = "";
            if (condUpb != null) {
                condUpb.cascadeSetTable("upb");
                joinUpbSql = " join upb on flussocreditidetail.idupb = upb.idupb ";
                condUpbSql = " AND " + condUpb.toSql(_qhs);
            }

            string sqlGetCrediti = $"SELECT  {colonneDettCrediti} from flussocreditidetail " +
                                   joinUpbSql +
                                   "WHERE EXISTS(SELECT * FROM  flussoincassidetail "+
                                   " JOIN flussoincassi ON flussoincassi.idflusso=flussoincassidetail.idflusso " +
                                            "WHERE " +
                                                     " (flussoincassidetail.iuv = flussocreditidetail.iuv OR flussoincassidetail.iduniqueformcode = flussocreditidetail.iduniqueformcode) " +
                                             " AND "+filterNonElaborati.toSql(_qhs)+ 
                                   ")"+
                                   " AND flussocreditidetail.stop is null and flussocreditidetail.annulment is null "+
                                   
                                   condUpbSql;
            DS.flussocreditidetail._sqlGetFromDb(_conn,sqlGetCrediti);

            string colonneDettContratti = string.Join(",",
                (from c in DS.estimatedetail.Columns._names() where QueryCreator.IsReal(DS.estimatedetail.Columns[c])
                                    select "estimatedetail."+c  ).ToArray());

            string sqlGetContratti =
                                $" SELECT {colonneDettContratti} from estimatedetail where iduniqueformcode in ("+
                                $"SELECT flussocreditidetail.iduniqueformcode from flussocreditidetail " +
                                   joinUpbSql +
                                   "WHERE EXISTS (SELECT * FROM  flussoincassidetail "+
                                    " JOIN flussoincassi ON flussoincassi.idflusso=flussoincassidetail.idflusso " +
                                    " WHERE " +
                                           " (flussoincassidetail.iuv = flussocreditidetail.iuv OR flussoincassidetail.iduniqueformcode = flussocreditidetail.iduniqueformcode) " +
                                            " AND "+filterNonElaborati.toSql(_qhs)+
                                        ")"+
                                   " AND flussocreditidetail.stop is null and flussocreditidetail.annulment is null "+
                                   condUpbSql+
                                ") and stop is null";
            //La sicurezza l'abbiamo gi� filtrata sui crediti, non c'� bisogno di filtrarla anche sul dettaglio contratto
            DS.estimatedetail._sqlGetFromDb(_conn,sqlGetContratti,0);

            infoCreaIncassi info = new infoCreaIncassi();
            foreach (var r in DS.flussocreditidetail) {
                info.addDettFlussoCrediti(r);
            }
            foreach (var r in DS.flussoincassidetail) {
                info.addDettFlussoIncassi(r);
            }
            
            foreach (var r in DS.estimatedetail) {
                info.addDettContratto(r);
            }
            RowChange.SetOptimized(DS.income, true);
            RowChange.ClearMaxCache(DS.income);

            bool res = creaIncassiContrattiAttivi(soloConSospesi, TipoElaborazioneIncassi.imponibile,info);
            if (res)res = creaIncassiContrattiAttivi(soloConSospesi, TipoElaborazioneIncassi.iva, info);
            if (res)res = creaIncassiContrattiAttivi(soloConSospesi, TipoElaborazioneIncassi.totali, info);
            
          
            return res;
        }

        public class infoCreaIncassi {
            public Dictionary<string,List<flussocreditidetailRow>> creditiPerIuv = new Dictionary<string, List<flussocreditidetailRow>>();
            public Dictionary<string,List<flussocreditidetailRow>> creditiPerUniqueFormCode = new Dictionary<string, List<flussocreditidetailRow>>();
            public Dictionary<string,List<estimatedetailRow>> dettContrattoPerUniqueFormCode = new Dictionary<string, List<estimatedetailRow>>();  
            public Dictionary<string,List<invoicedetailRow>> dettFatturaPerUniqueFormCode = new Dictionary<string, List<invoicedetailRow>>();  
            public Dictionary<int, decimal> flussoIncassiAmounts= new Dictionary<int, decimal>();
            public Dictionary<int, incomeRow> incomeByIdInc= new Dictionary<int, incomeRow>();
            public Dictionary<int, incomeyearRow> incomeYearByIdInc= new Dictionary<int, incomeyearRow>();
            public Dictionary<int, List<flussoincassidetailRow>> dettFlussoIncassiPerIdFlusso = new Dictionary<int, List<flussoincassidetailRow>>();

            public void addDettFlussoIncassi(flussoincassidetailRow r) {
                if (!dettFlussoIncassiPerIdFlusso.ContainsKey(r.idflusso.Value)) {
                    dettFlussoIncassiPerIdFlusso[r.idflusso.Value] = new List<flussoincassidetailRow>();
                }
                dettFlussoIncassiPerIdFlusso[r.idflusso.Value].Add(r);
            }

            public void addDettContratto(estimatedetailRow r) {
                if (r.iduniqueformcode != null) {
                    if (!dettContrattoPerUniqueFormCode.ContainsKey(r.iduniqueformcode)) {
                        dettContrattoPerUniqueFormCode[r.iduniqueformcode]= new List<estimatedetailRow>();
                    }
                    dettContrattoPerUniqueFormCode[r.iduniqueformcode].Add(r);
                }
            }
            public void addDettFattura(invoicedetailRow r) {
                if (r.iduniqueformcode != null) {
                    if (!dettFatturaPerUniqueFormCode.ContainsKey(r.iduniqueformcode)) {
                        dettFatturaPerUniqueFormCode[r.iduniqueformcode]= new List<invoicedetailRow>();
                    }
                    dettFatturaPerUniqueFormCode[r.iduniqueformcode].Add(r);
                }
            }


            public void addDettFlussoCrediti(flussocreditidetailRow r) {
                if (r.iuv != null) {
                    if (!creditiPerIuv.ContainsKey(r.iuv)) creditiPerIuv[r.iuv]= new List<flussocreditidetailRow>();
                    creditiPerIuv[r.iuv].Add(r);
                }
                if (r.iduniqueformcode != null) {
                    if (!creditiPerUniqueFormCode.ContainsKey(r.iduniqueformcode)) creditiPerUniqueFormCode[r.iduniqueformcode]= new List<flussocreditidetailRow>();
                    creditiPerUniqueFormCode[r.iduniqueformcode].Add(r);
                }
            }
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="conSospesi"></param>
        /// <param name="tipoElaborazione"></param>
        /// <param name="flussoIncassiAmounts"></param>
        /// <returns></returns>
        private bool creaIncassiContrattiAttivi( bool soloConSospesi, 
            TipoElaborazioneIncassi tipoElaborazione, infoCreaIncassi info ) {
            // In questo metodo genero gli incassi di contratti attivi solo se non sono
            // collegabili a fattura (in base alla configurazione del tipo contratto attivo).
            // Infatti per quelli collegabili dovremo incassare le fatture
            var incInvoice = _dispatcher.Get("incomeinvoice"); //Contabilizzazione fattura
            incInvoice.SetDefaults(DS.incomeinvoice);
            var ep = new EP_functions(_dispatcher as MetaDataDispatcher);
            // Questa funzione viene modificata allo scopo di leggere i dati da db includendo anche il pregresso

            var mov = DS.income;
            var impMov = DS.incomeyear;
            var impLast = DS.incomelast;

            var fasecontratto = CfgFn.GetNoNullInt32(_security.GetSys("estimatephase"));
            var fasemassima = CfgFn.GetNoNullInt32(_security.GetSys("maxincomephase"));
            var fasebilancio = CfgFn.GetNoNullInt32(_security.GetSys("incomefinphase"));

            var faseinizio = fasecontratto + 1;
            var fasefine = fasemassima;

            var inc = _dispatcher.Get("income");
            var incY = _dispatcher.Get("incomeyear");
            var incL = _dispatcher.Get("incomelast");

            inc.SetDefaults(DS.income);
            incY.SetDefaults(DS.incomeyear);
            incL.SetDefaults(DS.incomelast);

            MetaData.SetDefault(DS.incomeyear, "ayear", esercizio);

     

            var bollettiniElaborati = new Dictionary<string, bool>();
            var iuvElaborati = new Dictionary<string, bool>();
          
            

            //fattureDaCreare = new List<string>();
            foreach (var rFlussoIncassi in DS.flussoincassi.all()) { //DS.flussoincassi.Select()
                decimal sumAmountContrattiAttivi = 0;
                if (!info.flussoIncassiAmounts.ContainsKey((int) rFlussoIncassi.idflusso)) {
                    info.flussoIncassiAmounts.Add((int) rFlussoIncassi.idflusso, 0);
                }

                // Verifica esistenza della bolletta su DB
                var nbill = rFlussoIncassi["nbill"];
                string errore;
                if (soloConSospesi || nbill != DBNull.Value) {
                    nbill = getSospesiAttivi(nbill, out errore);
                    if (nbill == DBNull.Value) {
                        // Non � stato creato ancora sul db mediante l'importazione del giornale di cassa
                        continue;
                    }
                }

                var idflusso = rFlussoIncassi.idflusso;
                if (!info.dettFlussoIncassiPerIdFlusso.ContainsKey(idflusso.Value)) continue;
                
                foreach (var rFileDet in info.dettFlussoIncassiPerIdFlusso[idflusso.Value]) {
                    var iuv = rFileDet.iuv;
                    //if (iuv == null) continue;
                    // Leggo i dettagli contratto attivo da incassare facendo una ricerca per codice bollettino univoco
                    //  salta i dettagli annullati
                    List<flussocreditidetailRow> dettCrediti = null;
                    if ((!string.IsNullOrEmpty(iuv)) && info.creditiPerIuv.ContainsKey(iuv)) {
                       dettCrediti = info.creditiPerIuv[iuv];                       
                    }
                    if ((dettCrediti == null) &&
                        (!string.IsNullOrEmpty(rFileDet.iduniqueformcode)) && info.creditiPerUniqueFormCode.ContainsKey(rFileDet.iduniqueformcode)
                        ) {
                        dettCrediti= info.creditiPerUniqueFormCode[rFileDet.iduniqueformcode];                        
                    }

                    if (dettCrediti == null) {
                        MessageBox.Show(
                            $"Non � stato trovato un credito per il bollettino di codice {rFileDet.iduniqueformcode} o iuv {iuv}",
                            "Avviso");
                        continue;
                    }

                    // Ciclo sui dettagli crediti a parit� di codice bollettino
                    foreach (var rCredito in dettCrediti) {
                        var codiceBollettino = rCredito.iduniqueformcode;
                        if (string.IsNullOrEmpty(codiceBollettino)) continue;
                      

                        if (bollettiniElaborati.ContainsKey(codiceBollettino)) {
                            continue;
                        }
                        bollettiniElaborati.Add(codiceBollettino, true);

                        // Leggo i dettagli contratto attivo da incassare facendo una ricerca per codice bollettino univoco
                        //  salta i dettagli annullati
                        List<estimatedetailRow> rows = null;
                        if (info.dettContrattoPerUniqueFormCode.ContainsKey(codiceBollettino)) {
                            rows = info.dettContrattoPerUniqueFormCode[codiceBollettino];
                        }
                     
                        
                        if (rows==null) continue;
                        //int faseInizioPerQuestoContratto = faseinizio;
                        foreach (var rEstimDet in rows) {
                            // Se il contratto attivo � di tipo collegabile a fattura lo salto
                            string errori;

                            var currUpb = rEstimDet.idupb;
                            var currUpbIva = rEstimDet.idupb_iva;

                            switch (tipoElaborazione) {
                                case TipoElaborazioneIncassi.totali:
                                    //Elaborazione pre modifica split fasi - esegue solo con upb_iva == null
                                    if (currUpb == null || currUpbIva != null)
                                        continue; //i totali devono avere un upb_iva NON impostato per essere elaborati
                                    break;
                                case TipoElaborazioneIncassi.imponibile:
                                    if (currUpb == null || currUpbIva==null) continue;
                                    break;
                                case TipoElaborazioneIncassi.iva:
                                    if (currUpb == null || currUpbIva==null) continue;
                                    break;
                            }

                            decimal imponibile = CfgFn.GetNoNullDecimal(rEstimDet.taxable);
                            decimal sconto = CfgFn.GetNoNullDecimal(rEstimDet.discount);
                            decimal quantita =CfgFn.GetNoNullDecimal(rEstimDet.number);
                            decimal imponibiletot = CfgFn.GetNoNullDecimal(CfgFn.RoundValuta((imponibile * quantita* (1 - sconto))));
                            var iva = CfgFn.GetNoNullDecimal(rEstimDet.tax);

                            decimal amountBase = 0;
                            switch (tipoElaborazione) {
                                case TipoElaborazioneIncassi.totali:
                                    //Elaborazione pre modifica split fasi - esegue solo con upb_iva == null
                                    amountBase = imponibiletot + iva;
                                    break;
                                case TipoElaborazioneIncassi.imponibile:
                                    // curUpbIva � sicuramente != null
                                    amountBase = imponibiletot;
                                    break;
                                case TipoElaborazioneIncassi.iva:
                                    // curUpbIva � sicuramente != null
                                    amountBase = iva ;
                                    break;
                            }

                            if (amountBase == 0) continue;

                            var collegabileafattura = getCollegabileAFattura(rEstimDet.idestimkind);
                            // Non dobbiamo incassare dettagli contratti attivi di tipo collegabile a fattura
                            // perch� in tal caso dobbiamo incassare la fattura
                            if (collegabileafattura) {
                                continue;
                            }

                            var gestionedifferita = getGestioneDifferita(rEstimDet.idestimkind, out errori);
                            var filterEstimate = q.mCmp(rEstimDet, "idestimkind", "yestim", "nestim");

                            if (gestionedifferita == "S") {
                                // Dobbiamo generare dalla prima fase di entrata
                                var resFin = creaAccertamentiDaDettagliContrattiAttivi(new estimatedetailRow[] {rEstimDet},tipoElaborazione ,true);
                                if (!resFin) {
                                    MessageBox.Show(this,
                                        $"Errore nell'elaborazione della generazione dell'accertamento per il bollettino di codice {rFileDet.iduniqueformcode} o iuv {iuv}");
                                    return false;
                                }

                                rEstimDet["start"] = rFlussoIncassi["dataincasso"];
                                DS.estimate.safeMergeFromDb(_conn, filterEstimate);
                                //DataAccess.RUN_SELECT_INTO_TABLE(_conn, DS.estimate, null, filterEstimate, null, true);
                            }

                           
                            //_conn.DO_READ_VALUE("estimate", filterEstimate, "idaccmotivecredit");

                            // Dettaglio contratto                        
                            // Accertamento che contabilizza il dettaglio di importo pari a -importo
                            var idincToAttach = tipoElaborazione==TipoElaborazioneIncassi.iva? rEstimDet["idinc_iva"]:rEstimDet["idinc_taxable"];
                            if (idincToAttach == DBNull.Value) {
                                MessageBox.Show(
                                    $"Accertamento non trovato per il bollettino di codice {rFileDet.iduniqueformcode} o iuv {iuv}",
                                    "Errore");
                                continue;
                            }
                            //if (idincToAttach == DBNull.Value && gestionedifferita=="S") {
                            //    faseInizioPerQuestoContratto = 1;
                            //}
                            int idincInt = CfgFn.GetNoNullInt32(idincToAttach);

                            var fltmovI = q.eq("idinc", idincToAttach); //QHS.CmpEq("idinc", idincTaxable);
                            incomeRow parentR = null;
                            incomeyearRow parentYearR = null;
                            if (info.incomeByIdInc.ContainsKey(idincInt)) {
                                parentR = info.incomeByIdInc[idincInt];
                                parentYearR = info.incomeYearByIdInc[idincInt];
                            }
                            else {
                                if (gestionedifferita == "N") {
                                    var available =_conn.readValue("incometotal", fltmovI & q.eq("ayear", esercizio), "available");
                                    if (CfgFn.GetNoNullDecimal(available) < amountBase) {
                                        MessageBox.Show($"Il bollettino {codiceBollettino} risulta collegato ad un accertamento gi� incassato. Disponibile: {available} incasso: {amountBase}", "Avviso");
                                        continue;
                                    }
                                }
                                
                                

                                // Cerco la riga di accertamento
                                var movs =  DS.income.get(_conn,fltmovI); //DS.income.mergeFromDb(_conn, fltmovI));
                                //DataAccess.RUN_SELECT_INTO_TABLE(_conn, DS.income, null, fltmovI, null, true);
                                var movYears = DS.incomeyear.get(_conn, fltmovI & q.eq("ayear", esercizio)); //mergeFromDb(_conn, fltmovI & q.eq("ayear", esercizio)); 
                                //DataAccess.RUN_SELECT_INTO_TABLE(_conn, DS.incomeyear, null,QHS.AppAnd(fltmovI, QHS.CmpEq("ayear", _security.GetEsercizio())), null, true);
                               
                                //DS.income.Filter(fltmovI);
                                //DS.incomeyear.Filter(fltmovI);
                                if (movs.Length == 0) continue;
                                if (movYears.Length == 0) continue;
                                parentR = movs[0];
                                info.incomeByIdInc[idincInt] = parentR;
                                parentYearR = movYears[0];
                                info.incomeByIdInc[idincInt] = parentR;
                            }
                          

                            //string filterMovIC = QHC.CmpEq("idinc", idincTaxable);

                          


                            for (var faseCorrente = faseinizio; faseCorrente <= fasefine; faseCorrente++) {
                                mov.Columns["nphase"].DefaultValue = faseCorrente;

                               
                                //spostato sotto
                                //var amount = CfgFn.GetNoNullDecimal(parentYearR.amount);

                                // Selezione UPB e Voce di Bilancio in modo completamente automatico
                                object idUpbSelected;
                                object idmanagerSelected;

                                // Determinazione del capitolo di bilancio in base alla causale finanziaria impostata sul dettaglio
                                object idfinSelected = DBNull.Value;
                                if (fasebilancio < faseinizio) {
                                    idUpbSelected = parentYearR.idupb;
                                    idfinSelected = parentYearR.idfin;
                                    idmanagerSelected = (object) parentR.idman ?? DBNull.Value;
                                }
                                else {
                                    idUpbSelected = (tipoElaborazione == TipoElaborazioneIncassi.iva)? rEstimDet.idupb_iva:rEstimDet.idupb;
                                    idmanagerSelected = _conn.readValue("upb", q.eq("idupb", idUpbSelected), "idman");
                                    getBilancioFromCausaleFin(rEstimDet.idfinmotive, out errore);
                                    if (errore != "") {
                                        MessageBox.Show(errore, "Errore");
                                        return false;
                                    }
                                }

                                decimal amount = amountBase; // CfgFn.GetNoNullDecimal(parentYearR == null ?amountBase: parentYearR.amount);
                                if (amount == 0) break;

                                var newEntrataRow = inc.Get_New_Row(parentR, mov) as incomeRow;

                                fillMovimento(newEntrataRow, idmanagerSelected, (object) parentR.idreg ?? DBNull.Value,parentR.description);

                                newEntrataRow.doc =
                                    $"C.A.{rEstimDet.idestimkind}/{rEstimDet.yestim.ToString().Substring(2, 2)}/{rEstimDet.nestim.ToString().PadLeft(6, '0')}";

                                newEntrataRow.docdate = rFlussoIncassi.dataincasso;

                                newEntrataRow.nphase = Convert.ToByte(faseCorrente);

                                var newImpMov = impMov.NewRow() as incomeyearRow;

                                fillImputazioneMovimento(newImpMov, amount, idfinSelected, idUpbSelected);

                                newImpMov.idinc = newEntrataRow.idinc;
                                newImpMov.ayear = Convert.ToInt16(esercizio);

                                impMov.Rows.Add(newImpMov);

                                if (faseCorrente == _nphaseSiopeE) {
                                    var idsor = getSiopeForAccMotive(rEstimDet["idaccmotive"], out errori);
                                    fillIncomeSorted(newEntrataRow, idsor, amount);
                                }

                                if (faseCorrente == fasemassima) {
                                    var newLastMov = incL.Get_New_Row(newEntrataRow, impLast) as incomelastRow;
                                    // aggiunge le informazioni sul numero bolletta se sono state specificate nel flusso 
                                    if (nbill != DBNull.Value) {
                                        newLastMov.nbill = (int) nbill;
                                        var flag = CfgFn.GetNoNullInt32(newLastMov.flag);
                                        flag = flag | 1;
                                        newLastMov.flag = Convert.ToByte(flag);
                                    }

                                    newLastMov.idinc = newEntrataRow.idinc;

                                    object idacc = DBNull.Value;

                                    if (ep.attivo) {
                                        var idaccmotive = _conn.readValue("estimate", filterEstimate, "idaccmotivecredit");
                                        idacc = ep.GetCustomerAccountForRegistry(idaccmotive, newEntrataRow.idreg);
                                    }

                                    if (idacc != DBNull.Value) {
                                        newLastMov.idacccredit = (string) idacc;
                                    }

                                    sumAmountContrattiAttivi += amount;
                                }

                                parentR = newEntrataRow;
                            } // Fasi
                        } //dettagli contratto attivo
                    } //Dettaglio crediti
                } //dettaglio incassi

                //test effettuato alla conclusione delle tre chiamate
                //if (rFlussoIncassi.importo == sumAmountContrattiAttivi) {
                //    rFlussoIncassi.elaborato = "S";
                //}
                info.flussoIncassiAmounts[(int) rFlussoIncassi.idflusso] += sumAmountContrattiAttivi;
            } //flusso incassi

            return true;
        }

        string invoiceDescription(DataRow r) {
            return "Fattura " +
                   r["idinvkind"] + "/" +
                   r["yinv"].ToString().Substring(2, 2) + "/" +
                   r["ninv"].ToString().PadLeft(6, '0');
        }

        private bool creaIncassiFatture( bool soloConSospesi) {
            Dictionary<int, decimal> flussoIncassiAmounts = new Dictionary<int, decimal>();
            azzeraTutto();

            var filterNonElaborati = q.eq("ayear", esercizio) & q.eq("elaborato", "N");
            if (soloConSospesi) filterNonElaborati = filterNonElaborati & q.isNotNull("nbill");
            if (txtNumFlussoIncassi.Text != "") {
                int nFlussoDato = 0;
                if (int.TryParse(txtNumFlussoIncassi.Text, out nFlussoDato)) {
                    filterNonElaborati = filterNonElaborati & q.eq("idflusso", nFlussoDato);
                }
            }

            DS.flussoincassi.mergeFromDb(_conn, filterNonElaborati);
            DS.flussoincassidetail.readTableJoined(_conn, "flussoincassi", null, filterNonElaborati, "idflusso");

            var info= new infoCreaIncassi();
            foreach (var r in DS.flussoincassidetail) {
                info.addDettFlussoIncassi(r);
            }
            var condUpb = _security.SelectCondition("upb", true).toMetaExpression();
            var joinUpbSql = "";
            var condUpbSql = "";
            if (condUpb != null) {
                joinUpbSql = " join upb on flussocrediti.idupb = upb.idupb ";
                condUpbSql = " AND " + condUpb.toSql(_qhs);
            }

            string colonneDettFature = string.Join(",",
                (from c in DS.invoicedetail.Columns._names() where QueryCreator.IsReal(DS.invoicedetail.Columns[c])
                    select "invoicedetail."+c  ).ToArray());


            string sqlGetFatture =
                $" SELECT  {colonneDettFature} from invoicedetail where iduniqueformcode in ("+
                $"SELECT flussocreditidetail.iduniqueformcode from flussocreditidetail " +
                joinUpbSql +
                " WHERE EXISTS(SELECT * from flussoincassidetail  " +
                        " JOIN flussoincassi ON flussoincassi.idflusso=flussoincassidetail.idflusso " +
                        " WHERE (flussoincassidetail.iuv = flussocreditidetail.iuv OR flussoincassidetail.iduniqueformcode = flussocreditidetail.iduniqueformcode) " +
                            " AND "+filterNonElaborati.toSql(_qhs)+
                        ")"+
                " AND flussocreditidetail.stop is null and flussocreditidetail.annulment is null "+
        
                condUpbSql+
                $") AND (yinv <= {esercizio}) ";
            //La sicurezza l'abbiamo gi� filtrata sui crediti, non c'� bisogno di filtrarla anche sul dettaglio contratto
            DS.invoicedetail._sqlGetFromDb(_conn,sqlGetFatture);
            foreach (var r in DS.invoicedetail) {
                info.addDettFattura(r);
            }
            if (DS.invoicedetail.Rows.Count == 0) {
                MessageBox.Show("Non sono stati trovati dettagli fattura da incassare di questo anno o anni precedenti.", "Avviso");
                return true;
            }

             
            bool res = creaIncassiFatture(soloConSospesi, TipoElaborazioneIncassi.imponibile, flussoIncassiAmounts,info);
            if (res) res = creaIncassiFatture(soloConSospesi, TipoElaborazioneIncassi.iva, flussoIncassiAmounts,info);
            if (res) res = creaIncassiFatture(soloConSospesi, TipoElaborazioneIncassi.totali, flussoIncassiAmounts,info);
         

            VisualizzaFatture();
            if (DS.invoice.Rows.Count == 0) {
                MessageBox.Show("Non sono state trovate fatture collegati ai crediti incassati.", "Avviso");
            }
            return res;
        }

        /// <summary>
        /// Elabora un flusso incassi 
        /// </summary>
        /// <returns></returns>
        private bool creaIncassiFatture( bool soloConSospesi, TipoElaborazioneIncassi tipoElaborazione,
                    Dictionary<int, decimal> flussoIncassiAmounts, infoCreaIncassi info) {
            var incInvoice = _dispatcher.Get("incomeinvoice");
            incInvoice.SetDefaults(DS.incomeinvoice);
            
                       
            var metaIncome = MetaData.GetMetaData(this, "income");
            var metaIncomeYear = MetaData.GetMetaData(this, "incomeyear");
            var metaIncomeLast = MetaData.GetMetaData(this, "incomelast");

            metaIncome.SetDefaults(DS.income);
            metaIncomeYear.SetDefaults(DS.incomeyear);
            metaIncomeLast.SetDefaults(DS.incomelast);

            // Partendo da una riga di flussoincassi / flussoincassidetail
            // ciclo sui dettagli fattura filtrati solo sullo IUV e non contabilizzati
            // Mi leggo ilmovimento finanziario padre (l'accertamento che contabilizza eventuale dettaglio contratto attivo) 
            // 1) leggo il dettaglio contratto attivo associato alla fattura  vedendo prima se sta in memoria , 
            // perch� l'ho esaminato nella fase precedente e mi prendo l'accertamento che sta in memoria construendo le nuove fasi successive
            // 2) Se invece non trovo il dettaglio contratto attivo in memoria perch� privo di IUV, 
            // deve rileggere da db eventuale contabilizzazione e prendere quella come riga padre. 
            // Se invece il dettaglio contratto attivo non � contabilizzato, saltare la riga. 
            // Assumiamo che il dettaglio contratto attivo deve essere gi� stato contabilizzato,
            // 3) Se il dettaglio Fattura non � collegato ad alun dettaglio contratto attivo, generiamo tutte le fasi
            // finanziarie, dalla prima fino all'ultima

            //DS.incomeinvoice.Clear(); comune a tutte e tre le fasi - svuoto prima

            var bollettiniElaborati = new Dictionary<string, bool>();

            // ciclo flusso incassi

            foreach (var rFlussoIncassi in DS.flussoincassi) {
                decimal sumAmount = 0;
                if (!flussoIncassiAmounts.ContainsKey((int) rFlussoIncassi.idflusso)) {
                    flussoIncassiAmounts.Add((int) rFlussoIncassi.idflusso, 0);
                }

                var mov = DS.income;
                var impMov = DS.incomeyear;
                var impLast = DS.incomelast;
                var fasecontratto = CfgFn.GetNoNullInt32(_security.GetSys("estimatephase"));
                var fasemassima = CfgFn.GetNoNullInt32(_security.GetSys("maxincomephase"));

                var fasefine = fasemassima;

                MetaData.SetDefault(DS.incomeyear, "ayear", esercizio);

                var idflusso = rFlussoIncassi.idflusso;
                var nbill = rFlussoIncassi.nbillValue;

                // Verifica esistenza della bolletta su DB
 
                string errore;
                if (soloConSospesi || nbill != DBNull.Value) {
                    nbill = getSospesiAttivi(nbill, out errore);
                    if (nbill == DBNull.Value) {
                        // Non � stato creato ancora sul db mediante l'importazione del giornale di cassa
                        continue;
                    }
                }

                // ciclo flusso incassidetail
                //legge i dettagli flusso incassi se non sono presenti
                if (!info.dettFlussoIncassiPerIdFlusso.ContainsKey(idflusso.Value)) continue;

                foreach (var rFileDet in info.dettFlussoIncassiPerIdFlusso[idflusso.Value]) {

                    //Anche qui deve ciclare tra i crediti per ottenere un codiceBollettino

                    // Leggo i dettagli fattura da incassare facendo una ricerca per codice bollettino univoco 
                    var codiceBollettino = rFileDet.iduniqueformcode;
                    if (string.IsNullOrEmpty(codiceBollettino)) continue;

                    //var iuv = rFileDet.iuv;

                    //Elabora una volta sola ogni codice bollettino, incassando TUTTI i crediti con pari  iduniqueformcode
                    //Non fa niente se il ramo c.attivi ha gi� considerato questo bollettino, questo ramo lo elaborer� per la quota "fatture"
                    // che � disgiunta da quella dei c.attivi
                    var key = codiceBollettino;
                    if (bollettiniElaborati.ContainsKey(key)) continue;
                    //// bollettini non incassabili per mancata generazione scritture
                    //if (bollettiniNonIncassabili.Contains(codiceBollettino)) {
                    //    continue;
                    //}
                    bollettiniElaborati.Add(key, true);

                    // Dettagli non contabilizzati con iduniqueformcode=  codiceBollettino
                    if (!info.dettFatturaPerUniqueFormCode.ContainsKey(codiceBollettino)) continue;
                    var rowsInvoicedetPerBollettino = info.dettFatturaPerUniqueFormCode[codiceBollettino];
                    
                    q filterDetFattura = null;
                    switch (tipoElaborazione) {
                        case TipoElaborazioneIncassi.totali:
                            filterDetFattura = q.isNull("idinc_iva") & q.isNull("idinc_taxable");
                            break;
                        case TipoElaborazioneIncassi.imponibile:
                            filterDetFattura = q.isNull("idinc_taxable") ;
                            break;
                        case TipoElaborazioneIncassi.iva:
                            filterDetFattura = q.isNull("idinc_iva") ;
                            break;
                    }
                    
                    var rowsInvoicedet = rowsInvoicedetPerBollettino._Filter(filterDetFattura).ToArray();

                    // Si possono verificare i seguenti quattro casi:
                    // 1) Dettaglio fattura collegato a dettaglio contratto attivo contabilizzato ma non ancora salvato (accertamento in memoria),
                    //    sar� portato a incasso partendo dall'accertamento
                    // 2) Dettaglio fattura collegato a dettaglio contratto attivo contabilizzato e con accertamento salvato su DB, 
                    //    sar� portato a incasso partendo dall'accertamento
                    // 3) Dettaglio fattura collegato a dettaglio contratto attivo non contabilizzato con questa procedura perch� privo di IUV, 
                    //    sar� scartato e dovr� essere prima contabilizzato il dett. c.a. secondo una delle altre consuete modalit�
                    // 4) Dettaglio fattura non collegato a dettaglio, 
                    //    saranno generate tutte le fasi finanziarie  

                    // ciclo flusso invoicedetai
                    foreach (var rInvoiceDet in rowsInvoicedet) {
                        string idrelated = BudgetFunction.ComposeObjects(
                            new[] {
                                "inv",
                                rInvoiceDet["idinvkind"],
                                rInvoiceDet["yinv"],
                                rInvoiceDet["ninv"]
                            });
                        if (_conn.count("entry", q.eq("idrelated", idrelated))==0 ) {
                            continue;
                        }
                        var currUpb = rInvoiceDet.idupb;
                        var currUpbIva = rInvoiceDet.idupb_iva;

                        // Cerca la contabilizzazione del dettaglio contratto attivo collegato per agganciarsi ad essa                        
                        estimatedetailRow estimDet = null;
                        if (rInvoiceDet.idestimkind != null) {
                            var estimateDetails = DS.estimatedetail.get(_conn,
                                q.mCmp(rInvoiceDet, "idestimkind", "yestim", "nestim") &
                                q.eq("rownum", rInvoiceDet.estimrownum)
                            );
                            estimDet = estimateDetails[0];
                        }

                        if (estimDet == null) {
                            switch (tipoElaborazione) {
                                case TipoElaborazioneIncassi.totali:
                                    //Elaborazione pre modifica split fasi - esegue solo con upb_iva == null
                                    if (currUpb == null || currUpbIva != null) continue; //i totali devono avere un upb_iva NON impostato per essere elaborati
                                    break;
                                case TipoElaborazioneIncassi.imponibile:
                                    if (currUpb == null || currUpbIva == null) continue; // imponibile  o iva � ammesso solo se c'� currUPB
                                    break;
                                case TipoElaborazioneIncassi.iva:
                                    if (currUpb == null || currUpbIva == null) continue; // imponibile  o iva � ammesso solo se c'� currUPB
                                    break;
                            }
                        }
                        else {
                            //conta la cont. del  dett.contratto non gli upb
                            switch (tipoElaborazione) {
                                case TipoElaborazioneIncassi.totali:
                                    //Elaborazione pre modifica split fasi - esegue solo con upb_iva == null
                                    if (estimDet.idinc_iva != estimDet.idinc_taxable) continue; 
                                    if (currUpb == null || currUpbIva != null) continue; //i totali devono avere un upb_iva NON impostato per essere elaborati
                                    break;
                                case TipoElaborazioneIncassi.imponibile:
                                    if (estimDet.idinc_iva == estimDet.idinc_taxable) continue; 
                                    if (estimDet.idinc_iva == estimDet.idinc_taxable) continue; // imponibile  o iva � ammesso solo se c'� currUPB
                                    break;
                                case TipoElaborazioneIncassi.iva:
                                    if (estimDet.idinc_iva == estimDet.idinc_taxable) continue; 
                                    if (currUpb == null || currUpbIva == null) continue; // imponibile  o iva � ammesso solo se c'� currUPB
                                    break;
                            }
                        }

                        decimal imponibile = CfgFn.GetNoNullDecimal(rInvoiceDet.taxable);
                        decimal quantitaConfezioni = CfgFn.GetNoNullDecimal(rInvoiceDet.npackage);
                        decimal sconto = CfgFn.GetNoNullDecimal(rInvoiceDet.discount);
                        decimal imponibiletot = CfgFn.GetNoNullDecimal(CfgFn.RoundValuta((imponibile * quantitaConfezioni * (1 - sconto))));
                        //double imponibiletotEUR = CfgFn.RoundValuta(imponibiletot*tassocambio);
                        var iva = CfgFn.GetNoNullDecimal(rInvoiceDet.tax);
                        decimal amountBase = 0;
                        


                        switch (tipoElaborazione) {
                            case TipoElaborazioneIncassi.totali:
                                amountBase = imponibiletot + iva;
                                //Elaborazione pre modifica split fasi - esegue solo con upb_iva == null
                                break;
                            case TipoElaborazioneIncassi.imponibile:
                                amountBase = imponibiletot;
                                break;
                            case TipoElaborazioneIncassi.iva:
                                amountBase = iva ;
                                break;
                        }
                       
                        if (amountBase==0)continue;


                        // Cerco eventuale accertamento che contabilizza il dettaglio contratto attivo associato

                        incomeRow parentR = null;
                        incomeyearRow parentYearR = null;

                        int faseinizio;
                        if (rInvoiceDet.idestimkind == null) {
                            faseinizio = 1; // genera tutte le fasi
                        }
                        else {
                          

                            if (estimDet==null) continue; // C'� un errore

                           

                            var idincCa = estimDet.idinc_taxable;
                            if (tipoElaborazione == TipoElaborazioneIncassi.iva) {
                                idincCa = estimDet.idinc_iva;
                            }
                            // Se idinc_taxable � nullo, il dettaglio del contratto attivo deve essere contabilizzato per altra via, 
                            // si tratta di un dettaglio senza IUV e la presente procedura non lo elabora
                            if (idincCa == null) continue;

                            // Prima cerca l'accertamento in memoria perch� potrebbe non essere stato ancora salvato
                            var movs = DS.income.Filter(q.eq("idinc", idincCa));
                            var movYears = DS.incomeyear.Filter(q.eq("idinc", idincCa));
                            
                            // Se non lo trova in memoria legge l'accertamento precedentemente salvato su DB 
                            if (movs.Length == 0) {
                                movs = DS.income.getFromDb(_conn, q.eq("idinc", idincCa));
                                movYears = DS.incomeyear.getFromDb(_conn, q.eq("idinc", idincCa) & q.eq("ayear", esercizio));
                            }

                            if (movs.Length == 0) continue; // Non trova la contabilizzazione, si tratta di un errore
                            faseinizio = fasecontratto + 1; // deve generare le fasi finanziarie successive

                            parentR = movs[0];
                            parentYearR = movYears[0];
                        }


                        //string filterInvoice = QHS.AppAnd(QHS.CmpEq("idinvkind", rInvoiceDet["idinvkind"]),
                        //            QHS.CmpEq("yinv", rInvoiceDet["yinv"]), QHS.CmpEq("ninv", rInvoiceDet["ninv"]));
                        var filterInvoice = q.mCmp(rInvoiceDet, "idinvkind", "yinv", "ninv");

                        var invoice = DS.invoice.get(_conn, filterInvoice);
                        if (invoice.Length == 0) continue;
                        var invoiceRow = invoice[0];

                        object idacc = DBNull.Value;

                        var idaccmotive = invoiceRow.idaccmotivedebit_crg ?? invoiceRow.idaccmotivedebit;

                        // Anagrafica dalla Fattura
                        var idreg = invoiceRow.idreg;
                        // Incasso che contabilizza il dettaglio di importo pari a -importo
                        var idincTaxable = rInvoiceDet.idinc_taxable;
                        var idinciva = rInvoiceDet.idinc_iva;

                        if (idincTaxable != null && tipoElaborazione == TipoElaborazioneIncassi.imponibile) continue; // gi� contabilizzato
                        if (idinciva != null && tipoElaborazione == TipoElaborazioneIncassi.iva) continue; // gi� contabilizzato
                        if ((idincTaxable != null || idinciva != null) && tipoElaborazione == TipoElaborazioneIncassi.totali) continue; // gi� contabilizzato

                        MetaData.SetDefault(DS.incomeyear, "ayear", esercizio);
                        //DataRow IncomeToLink = null; 

                        // ciclo fasi
                        for (var faseCorrente = faseinizio; faseCorrente <= fasefine; faseCorrente++) {
                            mov.Columns["nphase"].DefaultValue = faseCorrente;

                            //var amount = //imponibiletot + iva;
                            //    CfgFn.GetNoNullDecimal(parentYearR == null ? imponibiletot+iva : parentYearR.amount); //moltiplicata per la quantit� rInvoiceDet.number al fine di ottenere l'imponibile
                            decimal amount = amountBase; //CfgFn.GetNoNullDecimal(parentYearR == null ? amountBase: parentYearR.amount); //moltiplicata per la quantit� rInvoiceDet.number al fine di ottenere l'imponibile
                            if (amount==0)break;
                            
                            var newEntrataRow = metaIncome.Get_New_Row(parentR, mov) as incomeRow;

                            var description = parentR?["description"].ToString() ?? invoiceDescription(rInvoiceDet);

                            // Selezione UPB e Voce di Bilancio in modo completamente automatico
                            var idUpbSelected = rInvoiceDet.idupb;
                            if (rInvoiceDet.idupb_iva != null && tipoElaborazione == TipoElaborazioneIncassi.iva) {
                                idUpbSelected = rInvoiceDet.idupb_iva;
                            }

                            var idmanagerSelected = _conn.readValue("upb", q.eq("idupb", idUpbSelected), "idman");
                            //_conn.DO_READ_VALUE("upb", QHS.CmpEq("idupb", idUpbSelected),"idman");

                            // Determinazione del capitolo di bilancio in base alla causale finanziaria impostata sul dettaglio
                            var idfinSelected = getBilancioFromCausaleFin(rInvoiceDet.idfinmotiveValue, out errore);
                            if (errore != "") {
                                MessageBox.Show(errore+" nel dettaglio "+rInvoiceDet.detaildescription+ " codice bollettino "+rInvoiceDet.iduniqueformcode,
                                    "Errore");
                                return false;
                            }

                            fillMovimento(newEntrataRow, idmanagerSelected, idreg, description);

                            newEntrataRow.doc = invoiceRow.doc ;//invoiceDescription(rInvoiceDet);
                            newEntrataRow.docdate = invoiceRow.docdate;//rFlussoIncassi.dataincasso;
                            newEntrataRow.nphaseValue = faseCorrente;

                            var newImpMov = impMov.NewRow();
                            fillImputazioneMovimento(newImpMov, amount, idfinSelected, idUpbSelected);

                            newImpMov["idinc"] = newEntrataRow["idinc"];
                            newImpMov["ayear"] = esercizio;

                            impMov.Rows.Add(newImpMov);

                            if (faseCorrente == _nphaseSiopeE) {
                                string errori;
                                var idsor = getSiopeForAccMotive(rInvoiceDet["idaccmotive"], out errori);
                                fillIncomeSorted(newEntrataRow, idsor, amount);
                            }

                            if (faseCorrente == fasemassima) {
                                var newLastMov = metaIncomeLast.Get_New_Row(newEntrataRow, impLast) as incomelastRow;
                                // aggiunge le informazioni sul numero bolletta se sono state specificate nel flusso e

                                if (nbill != DBNull.Value) {
                                    newLastMov.nbill = (int) nbill;
                                    var flag = CfgFn.GetNoNullInt32(newLastMov["flag"]);
                                    flag = flag | 1;
                                    newLastMov["flag"] = flag;
                                }

                                newLastMov["idinc"] = newEntrataRow["idinc"];
                                var ep = new EP_functions(_dispatcher as MetaDataDispatcher);

                                if (ep.attivo) {
                                    idacc = ep.GetCustomerAccountForRegistry(idaccmotive, newEntrataRow["idreg"]);
                                }

                                if (idacc != DBNull.Value) {
                                    newLastMov["idacccredit"] = idacc;
                                }

                                //Aggiunge la riga in IncomeInvoice e lo contabilizza
                                //const int currcausale = 1; // contabilizzazione totale

                                int currcausale = 1;
                                switch (tipoElaborazione) {
                                    case TipoElaborazioneIncassi.totali:
                                        currcausale = 1;
                                        break;
                                    case TipoElaborazioneIncassi.imponibile:
                                        currcausale = 3;
                                        break;
                                    case TipoElaborazioneIncassi.iva:
                                        currcausale = 2;
                                        break;
                                }

                                var incInvoiceRow = incInvoice.Get_New_Row(newEntrataRow, DS.incomeinvoice);
                                incInvoiceRow["movkind"] = currcausale;
                                incInvoiceRow["idinvkind"] = rInvoiceDet.idinvkind;
                                incInvoiceRow["yinv"] = rInvoiceDet.yinv;
                                incInvoiceRow["ninv"] = rInvoiceDet.ninv;

                                //Effettua i collegamenti con il dettaglio della fattura
                                if (tipoElaborazione == TipoElaborazioneIncassi.imponibile) {
                                    rInvoiceDet.idinc_taxable = newEntrataRow.idinc;
                                }

                                if (tipoElaborazione == TipoElaborazioneIncassi.iva) {
                                    rInvoiceDet.idinc_iva = newEntrataRow.idinc;
                                }

                                if (tipoElaborazione == TipoElaborazioneIncassi.totali) {
                                    rInvoiceDet.idinc_iva = newEntrataRow.idinc;
                                    rInvoiceDet.idinc_taxable = newEntrataRow.idinc;
                                }


                                sumAmount += amount; // incrementa l'importo incassato
                            }

                            parentR = newEntrataRow;
                        }

                        // fine ciclo fasi
                    }

                    // fine ciclo flusso invoicedetai

                    //va fatto al termine delle fasi imponibile,iva e totali
                    //if (rFlussoIncassi.importo == sumAmount) {
                    //      rFlussoIncassi.elaborato = "S";
                    //}
                }

                // fine ciclo flusso incassidetail

                flussoIncassiAmounts[(int) rFlussoIncassi.idflusso] += sumAmount;
            }

            //fine ciclo flusso incassi

            return true;
        }


        private static DataRow getGridCurrentRow(DataGrid g) {
            var dsv = (DataSet) g.DataSource;
            var tv = dsv?.Tables[g.DataMember];
            if (tv == null) return null;

            if (tv.Rows.Count == 0) return null;
            DataRowView dv;
            try {
                dv = (DataRowView) g.BindingContext[dsv, tv.TableName].Current;
            }
            catch {
                dv = null;
            }

            return dv?.Row;
        }


        /// <summary>
        /// Importa flussi incassi da foglio Excel (tracciato concordato con Roma Tor Vergata)
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        private void btnIncassi_Click(object sender, EventArgs e) {
            btnElaboraContabilizzazioni.Enabled = false;
            //btnelaboraFlussoCrediti.Enabled = false;
            //btnElaboraIncassi.Enabled = false;
            var t = leggiFile(false);
            if (t == null) {
                return;
            }

            importaTabellaFlussoIncassi(t);
 
        }


        private void elaboraFlussoCrediti() {
            //riempie estimate, estimate
            var res = fillEstimate();
            if (!res) {
                MessageBox.Show(this, @"Errore nella creazione dei contratti attivi");
                return;
            }
           
            var resA = fillAnnulment();
            if (!resA) {
                MessageBox.Show(this, @"Errore nell'elaborazione degli annullamenti");
                return;
            }

            if (!DS.HasChanges()) {
                MessageBox.Show("Nessun credito da elaborare");
                return;                
            }

            var myPostData = new Easy_PostData();
            myPostData.initClass(DS, _conn);
            var resSave = myPostData.DO_POST();

            if (!resSave) {
                MessageBox.Show(this, "Errore nel salvataggio");
                return;
            }

            if (generaScrittureContrattiAttivi()) {
                MessageBox.Show(this, "Elaborazione crediti completata");
            }
        }

        DataRow GetGridRow(DataGrid G, int index) {
            /*
             * LISTING TYPE DEFAULT
             *   DescribeAColumn(T, "idestimkind", ".idestimkind", nPos++);
                DescribeAColumn(T, "yestim", ".yestim", nPos++);
                DescribeAColumn(T, "nestim", ".nestim", nPos++);
                DescribeAColumn(T, "rownum", ".rownum", nPos++);
                D
             * */
            string TableName = G.DataMember.ToString();
            DataSet MyDS = (DataSet)G.DataSource;
            DataTable MyTable = MyDS.Tables[TableName];
            string filter = "";
            
            filter = _qhc.AppAnd(_qhc.CmpEq("idestimkind", G[index, 0]),_qhc.CmpEq("yestim", G[index, 1]), 
            _qhc.CmpEq("nestim", G[index, 2]), _qhc.CmpEq("rownum", G[index, 3]));
            DataRow[] selectresult = MyTable.Select(filter);
            return (selectresult.Length > 0) ? selectresult[0] : null;
        }

        private DataRow[] GetGridSelectedRows(DataGrid G) {
            if (G.DataMember == null) return null;
            if (G.DataSource == null) return null;
            string TableName = G.DataMember.ToString();
            DataSet MyDS = (DataSet)G.DataSource;
            DataTable MyTable = MyDS.Tables[TableName];
            int numrighetemp = MyTable.Rows.Count;
            int numrighe = 0;
            int i;
            for (i = 0; i < numrighetemp; i++) {
                if (G.IsSelected(i)) {
                    DataRow R = GetGridRow(G, i);
                    if (R == null) continue;
                    numrighe++;
                }
            }

            DataRow[] Res = new DataRow[numrighe];
            int count = 0;
            for (i = 0; i < numrighetemp; i++) {
                if (G.IsSelected(i)) {
                    DataRow R = GetGridRow(G, i);
                    if (R == null) continue;
                    Res[count++] = R;
                }
            }

            return Res;
        }

        private void datagrid_DoubleClick(object sender, EventArgs e) {
            // permette la selezione di una riga per visualizzarla richiamando edit type specifico per ciascun grid
            //
            //dgrCrediti
            //dgrIncassi
            //dgrDettContrattiAttivi
            //dgrFattureCreate
            DataGrid dataGrid = (DataGrid)sender;
            DataRow RigaSelezionata = getGridCurrentRow(dataGrid);
            string tableName = "";
            string viewName = "";
            string listType = "";
            string editType = "";
            if (dataGrid.Name == "dgrCrediti") { 
                tableName = "flussocreditidetail";
                 // listing type e d edit type da valorizzare, per ora metto default
                listType = "default";
                editType = "default";
            }
            if (dataGrid.Name == "dgrIncassi") {
                tableName = "flussoincassidetail";
                listType = "default";
                editType = "default";
            }
            if (dataGrid.Name == "dgrDettContrattiAttivi") {
                tableName = "estimatedetail";
                listType = "default";
                editType = "default";
            }
            if (dataGrid.Name == "dgrContratti") {
                tableName = "estimate";
                listType = null;
                editType = null;
            }
            if (dataGrid.Name == "dgrFattureCreate") {
                tableName = "invoice";
                listType = "default";
                editType = "default";
            }
            if (RigaSelezionata == null)
                return;
            VisualizzaRigaSelezionata(RigaSelezionata, tableName, viewName,   listType,   editType);
        }


     
     


        /// <summary>
        /// Elabora contratto da flusso studenti
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        private void btnElaboraFlussoCrediti_Click(object sender, EventArgs e) {
            btnelaboraFlussoCrediti.Visible = false;
            Application.DoEvents();
            elaboraFlussoCrediti();
            azzeraTutto();
            btnCercaContrattiDaContabilizzare_Click(sender, e);
            btnelaboraFlussoCrediti.Visible = true;
        }

        void azzeraTutto() {
            DS.income.Clear();
            DS.incomelast.Clear();
            DS.income.Clear();
            DS.incomeyear.Clear();
            DS.incomesorted.Clear();
            DS.flussoincassi.Clear();
            DS.flussoincassidetail.Clear();

            DS.invoice.Clear();
            DS.invoicedetail.Clear();

            DS.estimate.Clear();
            DS.estimatedetail.Clear();

            DS.ivaregister.Clear();

            DS.incomeinvoice.Clear();
            DS.incomeestimate.Clear();

            DS.flussocrediti.Clear();
            DS.flussocreditidetail.Clear();


        }
        /// <summary>
        /// Elabora contabilizzazioni
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        private void btnElaboraContabilizzazioni_Click(object sender, EventArgs e) {
            btnElaboraContabilizzazioni.Enabled = false;
            //necessita di DS.estimatedetail non vuoto
            DS.income.Clear();
            DS.incomelast.Clear();
            DS.income.Clear();
            DS.incomeyear.Clear();
            DS.incomesorted.Clear();
            DS.flussoincassi.Clear();
            DS.flussoincassidetail.Clear();

            DataRow[] SelectedRows = GetGridSelectedRows(dgrDettContrattiAttivi);
            var resFin = true;

            for (int i = 0; i < SelectedRows.Length; i++) {
                resFin = creaAccertamentiDettagliContratti(new estimatedetailRow[] {( estimatedetailRow)SelectedRows[i]});
                if (!resFin) break;
            }

            DataSet dSupdated;
            if (resFin) resFin = doSave(out dSupdated);

            azzeraTutto();

            if (resFin) btnCercaContrattiDaContabilizzare_Click(sender, e);
            //la doSave mostra gi� messaggi pi� specifici nel caso in cui fallisca. 
            // Questo messaggio pu� essere fuorviante perch� potrebbe non esserci nessun movimento e quindi NON essere un errore
            //if (!resFin) {
            //    MessageBox.Show(this, @"Errore nell'elaborazione della generazione dei movimenti finanziari");
            //}
        }

        /// <summary>
        /// Elabora flusso incassi, ossia crea gli incassi per tutte le righe di flussoincassi non ancora elaborate e che per� abbiano
        ///  il numero di sospeso attivo impostato ed il cui sospeso esista nel programma. Inoltre nulla � creato per quanto riguarda
        ///  i contratti attivi collegabili a fattura. Se il tipo contratto � a gestione differita, crea anche gli accertamenti.
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        private void btnElaboraFattureDaIncassi_Click(object sender, EventArgs e) {
            bool saved = btnElaboraIncassi.Visible;
            btnElaboraIncassi.Visible = false;
            Application.DoEvents();

            azzeraTutto();
            btnAssociaEventualiBollette_Click(sender, e);
            //btnElaboraIncassi.Enabled = false;
            creaFatture(!chkAncheSenzaSospesi.Checked); // creaIncassiContrattiAttivi(true);
            azzeraTutto();
            //btnElaboraIncassi.Enabled = true;
            btnElaboraIncassi.Visible = saved;
        }

     

        /// <summary>
        /// Per tutte le righe di flussoincassi associa il n. di sospeso attivo (nbill) se il sospeso ha la stessa causale della riga di 
        ///  flussoincassi. Una riga di flusso incassi pu� essere associata ad un solo sospeso attivo, mentre un sospeso attivo
        ///  pu� essere agganciato a pi� righe di flusso incassi
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        private void btnAssociaEventualiBollette_Click(object sender, EventArgs e) {
            DS.flussoincassi.Clear();
            var rows = DS.flussoincassi.getFromDb(_conn, q.eq("ayear", esercizio) & q.isNull("nbill"));

            var noChange = true;
            foreach (var r1 in rows) {
                // cerca di assegnare un sospeso attivo sulla base della causale
                var causale = r1.causale;
                if (string.IsNullOrEmpty(causale)) continue;
                var nbill = getSospesiAttiviFromCausali(causale);
                if (nbill == null) continue;
                noChange = false;
                r1.nbill = nbill;
            }

            //if (noChange) {
            //    MessageBox.Show("Nessuna bolletta da collegare trovata", "Avviso");
            //    return;
            //}

            var myPostData = new Easy_PostData();
            myPostData.initClass(DS, _conn);
            var res = myPostData.DO_POST();

            if (!res) {
                MessageBox.Show(this, "Errore nel salvataggio dell'associazione degli incassi alle bollette mediante causale bolletta");
                return;
            }

           // MessageBox.Show(this, "Le bollette presenti sono state collegate.");
        }

     
        

        void AddVoceCreditore(DataRow R) {
            if (R["idreg"] == DBNull.Value) return;
            R["!registry"] = GetTitleForIdReg(R["idreg"]);
        }

        void AddVoceUPB(DataRow R) {
            if (R["idupb"] == DBNull.Value) return;
            R["!codeupb"] = GetTitleForIdUPB(R["idupb"]);
        }
        void AddVoceUPBIva(DataRow R) {
            if (R["idupb_iva"] == DBNull.Value) return;
            R["!codeupb_iva"] = GetTitleForIdUPB(R["idupb_iva"]);
        }

        void preScanVociCollegateDettagliContrattoAttivo(q filter) {
            DataTable tDettView = _conn.CreateTableByName("estimatedetailview",
                "idestimkind,yestim,nestim,idupb,upb,idupb_iva,upb_iva,idreg,registry");
            _conn.readTableJoined(tDettView,"estimate", filter,                     
                    q.eq("active","S"),
                    (from k in DS.estimate.PrimaryKey select k.ColumnName).ToArray());
            foreach (DataRow r in tDettView.Rows) {
                if (r["idreg"] != DBNull.Value) {
                    __regTitles[CfgFn.GetNoNullInt32(r["idreg"])] = r["registry"].ToString();
                };
                if (r["idupb"] != DBNull.Value) {
                    __UpbTitles[r["idupb"].ToString()] = r["upb"].ToString();
                }
                if (r["idupb_iva"] != DBNull.Value) {
                    __UpbTitles[r["idupb_iva"].ToString()] = r["upb_iva"].ToString();
                }
            }

        }

        void AddVociCollegate(DataRow Row) {

           if (Row.Table.TableName == "estimatedetail") {
           AddVoceCreditore(Row);
           AddVoceUPB(Row );
           AddVoceUPBIva(Row);
        }
    }

        Dictionary<int, string> __regTitles = new Dictionary<int, string>();

        string GetTitleForIdReg(object idreg) {
            if (idreg == DBNull.Value) return "";
            int n = Convert.ToInt32(idreg);
            DataRow reg = getRegistry(n);

            //if (__regTitles.ContainsKey(n)) return __regTitles[n];

            object title = reg?["title"]; //_conn.DO_READ_VALUE("registry", _qhs.CmpEq("idreg", idreg), "title");
            if (title == null) {
                title = "[anagrafica di codice " + idreg + "]";
            }
            __regTitles[n] = title.ToString();
            return title.ToString();
        }

        Dictionary<string, string> __UpbTitles = new Dictionary<string, string>();

        string GetTitleForIdUPB(object idupb) {
          
            if (idupb == DBNull.Value)
                return "";
            string str_idupb = idupb.ToString();
            if (__UpbTitles.ContainsKey(str_idupb))
                return __UpbTitles[str_idupb];
            object title = _conn.DO_READ_VALUE("upb", _qhs.CmpEq("idupb", idupb), "title");
            if (title == null) {
                title = "[upb di codice " + idupb + "]";
            }
            __UpbTitles[str_idupb] = title.ToString();
            return title.ToString();
        }
         
        


        /// <summary>
        /// Legge in memoria i dettaglio contratti attivi con IUV ma senza contabilizzazione
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        private void btnCercaContrattiDaContabilizzare_Click(object sender, EventArgs e) {
            bool saved = btnCercaContrattiDaContabilizzare.Visible;
            btnCercaContrattiDaContabilizzare.Visible = false;
            Application.DoEvents();

            DS.estimatedetail.Clear();
            __UpbTitles.Clear();
            __regTitles.Clear();

            btnElaboraContabilizzazioni.Enabled = false;
            // filtra le righe contratti attivi associate a flusso crediti (iduniqueformcode non nullo) non ancora contabilizzate
            var filterDett = ((q.isNull("idinc_taxable")) | (q.isNull("idinc_iva") & q.gt("tax",0))) & q.isNotNull("iduniqueformcode") &
                             q.isNull("stop") ;
            var filterEstimate = q.eq("active", "S");
            var secEstimate = MetaExpressionParser.From(_conn.Security.SelectCondition("estimate", true));
            var enabledIdEstimkind = (from r in DS.estimatekind where ((r.flag??0) & 1)==0 select r.idestimkind ).ToArray();
            filterEstimate = filterEstimate & q.fieldIn("idestimkind", enabledIdEstimkind);
            if (secEstimate != null) filterEstimate = filterEstimate & secEstimate;
            _conn.readTableJoined(DS.estimatedetail,"estimate",
                filterDett,
                filterEstimate, (from k in DS.estimate.PrimaryKey select k.ColumnName).ToArray()
                );
            preScanVociCollegateDettagliContrattoAttivo(((q.isNull("idinc_taxable")) |( q.isNull("idinc_iva") & q.gt("tax",0)) ) & q.isNotNull("iduniqueformcode") &
                                                        q.isNull("stop"));
            //DS.estimatedetail.getFromDb(_conn,
            //    ((q.isNull("idinc_taxable")) | (q.isNull("idinc_iva"))) & q.isNotNull("iduniqueformcode")  & q.isNull("stop"));
            var mDettaglio = _dispatcher.Get("estimatedetail");
            if (DS.estimatedetail.Rows.Count > 0) {
                for (int i = 0; i < DS.estimatedetail.Rows.Count; i++) {
                    AddVociCollegate(DS.estimatedetail.Rows[i]);//si pu� ottimizzare passando il filtro originario usato per estimatedetail per fare un join
                    mDettaglio.CalculateFields(DS.estimatedetail.Rows[i], "contabilizza");
                }
            }
            HelpForm.SetAllowMultiSelection(DS.estimatedetail, true);
            HelpForm.SetDataGrid(dgrDettContrattiAttivi, DS.estimatedetail);

            if (DS.estimatedetail.Rows.Count > 0) {
                for (int i = 0; i < DS.estimatedetail.Rows.Count; i++) {
                  
                    dgrDettContrattiAttivi.Select(i); // seleziona tutto
                }
            }

            if (DS.estimatedetail.Rows.Count == 0) {
                MessageBox.Show("Nessun dettaglio contratto trovato","Avviso");
            }
            btnElaboraContabilizzazioni.Enabled = DS.estimatedetail.Rows.Count > 0;

            btnCercaContrattiDaContabilizzare.Visible=saved;
        }

        private void btnCreaFattureVendita_Click(object sender, EventArgs e) {

        }

        string hashActiveContract(DataRow r) {
            return $"{r["idestimkind"]}�{r["yestim"]}�{r["nestim"]}";
        }
        /// <summary>
        /// Genera le scritture sui contratti attivi di cui nel dataset in memoria � stata impostata la data inizio di qualche dettaglio
        /// </summary>
        public void generaScrittureContrattiAttiviEsterno() {
            DataSet ext = DS.Clone();
            foreach (string table in new [] {"estimate","estimatedetail"}) {
                ext.Tables[table].Merge(DS.Tables[table]);
            }
            Dictionary<string,bool> contractToGenerate=new Dictionary<string, bool>();
            foreach (var rEstim in DS.estimate) {
                contractToGenerate[hashActiveContract(rEstim)] = false;
            }

            foreach (DataRow r in ext.Tables["estimatedetail"].Select()) {
                if (r.RowState != DataRowState.Modified) {
                    ext.Tables["estimatedetail"].Rows.Remove(r);
                    continue;
                }
                if (r["start", DataRowVersion.Original] != DBNull.Value) {
                    ext.Tables["estimatedetail"].Rows.Remove(r);
                    continue;
                }

                if (r["start", DataRowVersion.Current] == DBNull.Value) {
                    ext.Tables["estimatedetail"].Rows.Remove(r);
                    continue;
                }

                //prende solo le righe di cui � stato ora impostato lo start
                object newStart = r["start"];
                r.RejectChanges();
                r["start"] = newStart;
                contractToGenerate[hashActiveContract(r)] = true;
            }
            ext.Tables["estimate"].RejectChanges();

            var metaEstimate = _dispatcher.Get("estimate");
            metaEstimate.DS = ext;

            foreach (DataRow rEstim in ext.Tables["estimate"].Rows) {
                if (!contractToGenerate[hashActiveContract(rEstim)]) continue;
                Easy_PostData_NoBL post = new Easy_PostData_NoBL();
                post.initClass(ext, _conn);
                if (!post.DO_POST()) continue;
                var epm = new EP_Manager(metaEstimate, null, null, null, null, null, null, null, null, "estimate");
                epm.disableIntegratedPosting();
                epm.silent = true;
                epm.setForcedCurrentRow(rEstim);
                epm.afterPost(true);
                epm.Dispose();

                //Sistema il valore della riga originale
                //non credo sia necessario 

            }

            


        }
        private void btnIncassiContrattiAttivi_Click(object sender, EventArgs e) {
            btnIncassiContrattiAttivi.Visible = false;
            Application.DoEvents();
            azzeraTutto();
            btnAssociaEventualiBollette_Click(sender, e);

            DataSet dSupdated;
            

            bool res = creaIncassiContrattiAttivi(!chkAncheSenzaSospesi.Checked);
            if (!DS.HasChanges()) {
                ricalcolaFlagElaborato();
                azzeraTutto();
                MessageBox.Show("Nessun incasso da creare", "Avviso");
                  btnIncassiContrattiAttivi.Visible = true;
                return;
            }
            if (res) {

                generaScrittureContrattiAttiviEsterno();

                //Il salvataggio azzera anche i movimenti finanziari
                if (doSave(out dSupdated)) {
                    MessageBox.Show("Gli incassi per i contratti attivi sono stati salvati.");
                }
                else {
                    MessageBox.Show("Errore nel salvataggio degli incassi per i contratti attivi","Errore");
                    btnIncassiContrattiAttivi.Visible = true;
                    return;
                }
                //genera le scritture contratti attivi di cui sono stati letti gli incassi ove ci sia una gestione differita
                //res = generaScrittureContrattiAttivi();
                if (!res) {
                    MessageBox.Show("Errore nel salvataggio delle scritture sui contratti attivi","Errore");
                }
                else {
                    MessageBox.Show("Le scritture per i contratti attivi sono stati salvate.","Avviso");
                }                              
            }
            azzeraTutto();
            btnIncassiContrattiAttivi.Visible = true;
        }

        private void btnCreaIncassiFatture_Click(object sender, EventArgs e) {
            string error;
            if (!generaIncassiFatture(!chkAncheSenzaSospesi.Checked, out error)) {
                MessageBox.Show("Errore nel salvataggio incassi per le fatture" + "\r\n" + error, "Errore");
            };
            azzeraTutto();
        }

        private void btnSospesiRFSRFB_Click(object sender, EventArgs e) {
            var t= _conn.SQLRunner(
                $@"select null as codice_fiscale_studente, nbill as numero_sospeso_attivo,           
                 bill.motive as causale,      
                 adate as data_incasso
                 (select min(iduniqueformcode) from flussocreditidetail fd where 
                          bill.motive like '/RFS/'+fd.iuv+'/%' or bill.motive like '/RFB/'+fd.iuv+'/%') as codice_bollettino_univoco,
                 total as importo 
                 from bill where (bill.motive like '/RFS/%' or bill.motive like '/RFB/%') and ybill = {esercizio} and billkind='C'  
                 and exists( select * from flussocredidetail fd where bill.motive like  '/RFS/'+fd.iuv+'/%' or bill.motive like '/RFB/'+fd.iuv+'/%')
                 and not exists(select * from flussoincassi f2 where f2.nbill=bill.nbill and f2.ayear={esercizio})");
            if (t==null)return;
            if (t.Rows.Count == 0) {
                MessageBox.Show("Nessun sospeso RFB o RFS trovato da collegare.", "Avviso");
                return;
            }
            importaTabellaFlussoIncassi(t);
        }
    }
}