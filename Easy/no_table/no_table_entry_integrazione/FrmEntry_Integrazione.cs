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
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Text;
using System.Windows.Forms;
using metadatalibrary;
using ep_functions;
using funzioni_configurazione;
using metaeasylibrary;

namespace no_table_entry_integrazione {
    public partial class Frmno_table_entry_integrazione : Form {
        MetaData Meta;
        
        
        QueryHelper QHS;
        private DataAccess conn;

        public Frmno_table_entry_integrazione() {
            InitializeComponent();
        }
        Dictionary<string,string> plAccountLookup = new Dictionary<string, string>();
        Dictionary<string, string> accountLookup = new Dictionary<string, string>();
        public void MetaData_AfterLink() {
            Meta = MetaData.GetMetaData(this);
            conn = Meta.Conn;
            QHS = Meta.Conn.GetQueryHelper();
            //tAccountLookUp = DataAccess.CreateTableByName(Meta.Conn, "accountlookup", "oldidacc, newidacc");
            DataTable tAccountLookUp = conn.RUN_SELECT("accountlookupview","oldidacc,newidacc", null, QHS.CmpEq("newayear", conn.GetSys("esercizio")), null, false);
            foreach (DataRow r in tAccountLookUp.Rows) {
                lookupAccount[r["oldidacc"].ToString()] = r["newidacc"].ToString();
            }
            DataTable tPlAccount = conn.RUN_SELECT( "placcount", "idplaccount, placcpart",null,QHS.CmpEq("ayear",conn.GetEsercizio()),null,false);
            foreach (DataRow r in tPlAccount.Rows) {
                plAccountLookup[r["idplaccount"].ToString()] = r["placcpart"].ToString();
            }
            DataTable tAccount = conn.RUN_SELECT("account", "idacc, idplaccount", null, QHS.CmpEq("ayear", conn.GetEsercizio()), null, false);
            foreach (DataRow r in tAccount.Rows) {
                accountLookup[r["idacc"].ToString()] = r["idplaccount"].ToString();
            }
        }

        public void MetaData_AfterActivation() {
            this.Text = Meta.Name;           
        }

        public void MetaData_AfterClear() {
            this.Text = Meta.Name;
        }

        private void btnIntegrazione_Click(object sender, EventArgs e) {
            DataTable tEntryDetail = ottieniDettagliScrittura();
            if (tEntryDetail == null) return;

            if (!doIntegrazione(tEntryDetail)) {
                MessageBox.Show(this, "Errore nel processo di integrazione dei risconti", "Errore");
            }
        }
        private bool doVerify () {
            string filter = QHS.AppAnd(QHS.FieldIn("identrykind", new object [] {5,14,15} ), // Risconto integrazione
                                QHS.CmpEq("Year(adate)", Meta.GetSys("esercizio")));

            int nrows = Meta.Conn.RUN_SELECT_COUNT("entry", filter, false);
            
            if (nrows>0) {
                if (MessageBox.Show("Le scritture di Integrazione relative all''esercizio corrente risultano gi� generate. Si desidera proseguire comunque?", "Avviso",
                    MessageBoxButtons.YesNo, MessageBoxIcon.Question) != DialogResult.Yes)
                    return false;
            }
            return true;
        }

        private bool doIntegrazione(DataTable tEntryDetailSource) {
            if (tEntryDetailSource == null) {
                MessageBox.Show(this, "La tabella dei dettagli scritture non � definita", "Errore");
                return false;
            }

            if (tEntryDetailSource.Rows.Count == 0) {
                MessageBox.Show(this, "La tabella dei dettagli scritture risulta vuota", "Avvertimento");
                return true;
            }

            DataTable tEntry = DataAccess.CreateTableByName(Meta.Conn, "entry", "*");
            DataTable tEntryDetail = DataAccess.CreateTableByName(Meta.Conn, "entrydetail", "*");

            DataSet ds = new DataSet();
            ds.Tables.Add(tEntry);
            ds.Tables.Add(tEntryDetail);

            RowChange.SetOptimized(ds.Tables["entry"], true);
            RowChange.ClearMaxCache(ds.Tables["entry"]);
            RowChange.SetOptimized(ds.Tables["entrydetail"], true);
            RowChange.ClearMaxCache(ds.Tables["entrydetail"]);

            ds.Relations.Add("entryentrydetail",
                    new DataColumn[] { tEntry.Columns["yentry"], tEntry.Columns["nentry"] },
                    new DataColumn[] { tEntryDetail.Columns["yentry"], tEntryDetail.Columns["nentry"] }, false);

            int currYear = (int)Meta.GetSys("esercizio");

            MetaData MEntry = MetaData.GetMetaData(this, "entry");
            MEntry.SetDefaults(ds.Tables["entry"]);
            MetaData.SetDefault(ds.Tables["entry"], "yentry", currYear);

            
            DateTime jan01 = new DateTime(currYear, 1, 1);
            object descr = "Integrazione dei risconti";
            if (!doVerify()) return false;
         
            DataRow rEntry3 = MEntry.Get_New_Row(null, ds.Tables["entry"]);  //3-->5    rettifica
            DataRow rEntry8 = MEntry.Get_New_Row(null, ds.Tables["entry"]);  //8-->15   commessa completata
            DataRow rEntry13 = MEntry.Get_New_Row(null, ds.Tables["entry"]); //13-->14  percentuale completamento

            rEntry3["identrykind"] = 5;
            rEntry3["adate"] = jan01;
            rEntry3["description"] = descr;

            rEntry8["identrykind"] = 15;
            rEntry8["adate"] = jan01;
            rEntry8["description"] = "Integrazione risconti Commessa completata";   //task 8769

            rEntry13["identrykind"] = 14;
            rEntry13["adate"] = jan01;
            rEntry13["description"] = "Chiusura ratei percentuale completamento"; //task 8769

            Dictionary<int, DataRow> parentRow = new Dictionary<int, DataRow>();
            parentRow[3] = rEntry3;
            parentRow[8] = rEntry8;
            parentRow[13] = rEntry13;

            Dictionary<int, int> nChild = new Dictionary<int, int>();
            nChild[3] = 0;
            nChild[8] = 0;
            nChild[13] = 0;


            string campoRiscontoAttivo = "idacc_deferredrevenue";
            string campoRiscontoPassivo = "idacc_deferredcost";
            //string campoRateoAttivo = "idacc_accruals";

            object idacc_riscontoA = Meta.Conn.DO_READ_VALUE("config", QHS.CmpEq("ayear", currYear), campoRiscontoAttivo);
            if ((idacc_riscontoA == null) || (idacc_riscontoA == DBNull.Value)) {
                MessageBox.Show(this, "Attenzione non � stato specificato il conto del risconto attivo", "Errore");
                return false;
            }

            object idacc_riscontoP = Meta.Conn.DO_READ_VALUE("config", QHS.CmpEq("ayear", currYear), campoRiscontoPassivo);
            if ((idacc_riscontoP == null) || (idacc_riscontoP == DBNull.Value)) {
                MessageBox.Show(this, "Attenzione non � stato specificato il conto del risconto passivo", "Errore");
                return false;
            }

            MetaData MEntryDetail = MetaData.GetMetaData(this, "entrydetail");
            MEntryDetail.SetDefaults(ds.Tables["entrydetail"]);
            MetaData.SetDefault(ds.Tables["entrydetail"], "yentry", currYear);

            //Emilia mi ha confermato che al momento lasciamo questa esclusione su tutta la upb   7/9/2018
            Dictionary<string, bool> upbRateoAttivo = new Dictionary<string, bool>();
            foreach (DataRow curr in tEntryDetailSource.Rows) {
                //fa un prescan di tutte le upb movimentate con un conto di rateo attivo
                int identrykind = CfgFn.GetNoNullInt32(curr["identrykind"]);
                object idAcc = curr["idacc"];
                object newIdAcc = attualizzaAccount(idAcc);
                if (newIdAcc == DBNull.Value || newIdAcc == null) {
                    MessageBox.Show("Non sono riuscito ad attualizzare il conto di codice " +
                                    conn.DO_READ_VALUE("account", QHS.CmpEq("idacc", idAcc), "codeacc"), "Errore");
                    continue;
                }
                object idRateoAttivo = attualizzaAccount(curr["idacc_accruals"]); // getRateoAttivo(Curr["idupb"].ToString());
                if (identrykind == 8 && newIdAcc.Equals(idRateoAttivo)) {
                    upbRateoAttivo[curr["idupb"].ToString()] = true;
                }
            }

            foreach (DataRow curr in tEntryDetailSource.Rows) {
                int identrykind = CfgFn.GetNoNullInt32( curr["identrykind"]);
                decimal importoDettaglio = CfgFn.GetNoNullDecimal(curr["amount"]);
                if (importoDettaglio == 0) continue;
                string idupb = curr["idupb"].ToString();

                //solo per le tipo 8 saltiamo le upb movimentate con una scrittura tipo 8 come rateo attivo
                if ((identrykind ==8) && upbRateoAttivo.ContainsKey(idupb)) continue;

                object idAcc = curr["idacc"];
                object newIdAcc = attualizzaAccount(idAcc);
                if (newIdAcc == DBNull.Value||newIdAcc==null) {
                    MessageBox.Show("Non sono riuscito ad attualizzare il conto di codice " +
                                    conn.DO_READ_VALUE("account", QHS.CmpEq("idacc", idAcc), "codeacc"), "Errore");
                    continue;
                }

                string placcpart = valutaIdAcc(newIdAcc);

                if ((placcpart != "C") && (placcpart != "R")) continue;
              

                object idRiscontoPassivo = DBNull.Value;
                if (placcpart == "R" ) {
                    idRiscontoPassivo = attualizzaAccount(curr["idacc_deferredcost"]); //getRiscontoPassivo(Curr["idupb"].ToString());
                    if (idRiscontoPassivo == DBNull.Value ||idRiscontoPassivo==null) {
                        idRiscontoPassivo = idacc_riscontoP;
                    }
                }

                if (placcpart == "R" && identrykind == 3) {
                    idRiscontoPassivo = idacc_riscontoP;
                }

                object idRateoAttivo = DBNull.Value;
                idRateoAttivo = attualizzaAccount(curr["idacc_accruals"]); // getRateoAttivo(Curr["idupb"].ToString());

                //if (idRateoAttivo == DBNull.Value || idRateoAttivo == null) {
                //    //string codiceUpb =
                //    //    conn.DO_READ_VALUE("upb", "codeupb", QHS.CmpEq("idupb", Curr["idupb"])).ToString();
                //    //MessageBox.Show("Conto di rateo attivo non configurato per l'UPB di codice " + codiceUpb,
                //    //    "Errore");
                //    continue;
                //}

                int flagaccountusage = CfgFn.GetNoNullInt32(curr["flagaccountusage"]);
                //per le tipo 8 (Assestamento Commessa Completata) prende solo i risconti
                //if ((identrykind == 8) && ((flagaccountusage & 12)==0)) continue; 

                //per le tipo 3  (Risconto Rettifica)  salta i conti di risconto
                if ((identrykind==3) && (newIdAcc.Equals(idacc_riscontoA)) || (newIdAcc.Equals(idRiscontoPassivo))) continue;

                //per le tipo 8 (Assestamento Commessa Completata) salta i conti di rateo attivo
                //if (identrykind == 8 && newIdAcc.Equals(idRateoAttivo)) continue;

                //per le tipo 8 (Assestamento Commessa Completata) salta quelle che non sono di ricavo in dare
                if ((identrykind == 8) && ((placcpart != "R"))) continue; //||(importoDettaglio>0) task  11249 non filtro pi� dare o avere


                //per le tipo 13 (Assestamento Percentuale di Completamento) salta quelle che non sono di ricavo in avere
                if ((identrykind == 13) && ((placcpart != "R") || (importoDettaglio < 0))) continue;

                
                if ((identrykind == 13) && (placcpart == "C")) {
                    string codeacc = conn.DO_READ_VALUE("account", QHS.CmpEq("idacc", idAcc), "codeacc").ToString();
                    MessageBox.Show("Il conto di codice " +codeacc +
                                    " non � un conto di ricavo ma � presente in una scrittura di tipo:\n\r"+
                                    "Assestamento Percentuale di Completamento"
                                   , "Errore");
                    continue;
                }

                object idaccountDare = DBNull.Value;
                object idaccountAvere = DBNull.Value;

                object riscontoChoosen = "";
                if (placcpart == "C") {
                    riscontoChoosen = idacc_riscontoA;
                }
                else {
                    riscontoChoosen = idRiscontoPassivo;
                }

                if (identrykind == 3 || identrykind == 8) {
                    idaccountDare = newIdAcc;
                    idaccountAvere = riscontoChoosen;
                }
                else {
                    idaccountDare = newIdAcc;
                    idaccountAvere =  idRateoAttivo;
                }

                DataRow rEntry = parentRow[identrykind];
                nChild[identrykind] = nChild[identrykind] + 1;
                

                // Dettaglio COSTO - RICAVO (Non ho il problema di controllare l'esistenza di una riga pregressa
                // perch� per come � costruita la tabella le righe sono tutte diverse tra di loro
                DataRow rEntryDetailCR = MEntryDetail.Get_New_Row(rEntry, ds.Tables["entrydetail"]);
                rEntryDetailCR["amount"] = -importoDettaglio;
                rEntryDetailCR["idacc"] = idaccountDare;
                foreach (string field in new string[] {"idreg", "idupb", "idepexp", "idepacc", "idsor1", "idsor2", "idsor3",
                    "idaccmotive", "competencystart", "competencystop","idrelated"}) {
                    rEntryDetailCR[field] = curr[field];
                }

                //EP.EffettuaScrittura(idepcontext, importoRisconto, idAcc, Curr["idreg"], Curr["idupb"],
                //    jan01, Curr["competencystop"], null, Curr["idaccmotive"]);
               
                //// Dettaglio RISCONTO               
                //string filter = costruisciFiltro(riscontoChoosen, Curr);
                //if (tEntryDetail.Select(filter).Length > 0) {
                //    DataRow rFound = tEntryDetail.Select(filter)[0];
                //    rFound["amount"] = CfgFn.GetNoNullDecimal(rFound["amount"]) + importoDettaglio;
                //}
                //else {
                //    DataRow rEntryDetailRis = MEntryDetail.Get_New_Row(rEntry, ds.Tables["entrydetail"]);
                //    rEntryDetailRis["amount"] = importoDettaglio;
                //    rEntryDetailRis["idacc"] = idaccountAvere;
                //    foreach (string field in new string[] {"idreg", "idupb", "idepexp", "idepacc", "idsor1", "idsor2", "idsor3",
                //    "idaccmotive", "competencystart", "competencystop"}) {
                //        rEntryDetailRis[field] = Curr[field];
                //    }
                //}

                DataRow rEntryDetailRis = MEntryDetail.Get_New_Row(rEntry, ds.Tables["entrydetail"]);
                rEntryDetailRis["amount"] = importoDettaglio;
                rEntryDetailRis["idacc"] = idaccountAvere;
                foreach (string field in new string[] {"idreg", "idupb", "idepexp", "idepacc", "idsor1", "idsor2", "idsor3",
                    "idaccmotive", "competencystart", "competencystop","idrelated"}) {
                    rEntryDetailRis[field] = curr[field];
                }


            }
            foreach (int kind in new int[] {3, 8, 13}) {
                if (nChild[kind] == 0) {
                    parentRow[kind].Delete();
                }
            }
            if (ds.Tables["entry"].Rows.Count == 0) {
                MessageBox.Show(this, "Nessuna operazione da integrare.", "Avviso");
                return true;
            }
            FrmEntryPreSave frm = new FrmEntryPreSave(ds.Tables["entrydetail"], Meta.Conn,tEntryDetailSource);
            DialogResult dr = frm.ShowDialog();
            if (dr != DialogResult.OK) {
                MessageBox.Show(this, "Operazione Annullata!","Avviso");
                return true;
            }

            PostData Post = new Easy_PostData_NoBL();

            Post.InitClass(ds, Meta.Conn);
            if (Post.DO_POST()) {
                DataRow rEntryPosted = ds.Tables["entry"].Rows[0];
                EditRelatedEntryByKey(rEntryPosted);
                MessageBox.Show(this, "Integrazione dei residui completata con successo!");
            }
            else {
                MessageBox.Show(this, "Errore nel salvataggio della scrittura di integrazione!", "Errore");
            }
            return true;
        }

        private Dictionary<string, object> riscPassivo = new Dictionary<string, object>();

        private Dictionary<string, object> rateoAttivo = new Dictionary<string, object>();
   

        public void EditRelatedEntryByKey(DataRow rEntry) {
            if (rEntry == null) return;
            if ((rEntry["yentry"] == DBNull.Value) || (rEntry["nentry"] == DBNull.Value)) return;
            MetaData ToMeta = Meta.Dispatcher.Get("entry");
            if (ToMeta == null) return;
            string checkfilter = QHS.MCmp(rEntry, new string[] { "yentry", "nentry" });
            ToMeta.ContextFilter = checkfilter;
            Form F = null;
            if (Meta.LinkedForm != null) F = Meta.LinkedForm.ParentForm;
            bool result = ToMeta.Edit(F, "default", false);
            string listtype = ToMeta.DefaultListType;
            DataRow R = ToMeta.SelectOne(listtype, checkfilter, null, null);
            if (R != null) ToMeta.SelectRow(R, listtype);
        }

        private Dictionary<string, string> lookupAccount = new Dictionary<string, string>();
        private object attualizzaAccount(object oldidacc) {
            if (oldidacc == DBNull.Value) return DBNull.Value;
            if (lookupAccount.ContainsKey(oldidacc.ToString())) return lookupAccount[oldidacc.ToString()];
            return DBNull.Value;
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="CoR">Flag che vale C: Costi; R: Ricavi</param>
        /// <returns></returns>
        private DataTable ottieniDettagliScrittura() {
            int lastAyear = (int)Meta.GetSys("esercizio") - 1;
            DateTime dec31 = new DateTime(lastAyear, 12, 31);

            string queryED = "SELECT d.*,e.identrykind,"+
                             "A.codeacc, A.title as account, ACCM.codemotive, ACCM.title as accmotive,reg.title as registry,U.codeupb, " +
                             "A.flagaccountusage,"+
                             "UY.idacc_accruals,UY.idacc_deferredcost FROM entrydetail d "
            + " JOIN entry e ON " + QHS.AppAnd(QHS.CmpEq("e.yentry", QHS.Field("d.yentry")),
            QHS.CmpEq("e.nentry", QHS.Field("d.nentry")))+
                             " join upb U on U.idupb = D.idupb "+
                             " left outer JOIN epupbkindyear UY on "+ QHS.AppAnd(
                                        QHS.CmpEq("UY.idepupbkind", QHS.Field("U.idepupbkind")),
                                        QHS.CmpEq("UY.ayear",lastAyear))
                             + "LEFT OUTER JOIN accmotive ACCM on ACCM.idaccmotive = d.idaccmotive "
                             + " JOIN ACCOUNT A ON " + QHS.CmpEq("A.idacc", QHS.Field("d.idacc"))
                             + "LEFT OUTER JOIN registry REG on REG.idreg = d.idreg "
            + " WHERE " + QHS.AppAnd(QHS.FieldInList("e.identrykind", QHS.List(3,8,13)), QHS.CmpEq("e.yentry", lastAyear));

            DataTable tEntryDetail = DataAccess.SQLRunner(Meta.Conn, queryED);
            if (tEntryDetail == null) {
                MessageBox.Show(this, "Errore nell'estrazione dei dati da ENTRYDETAIL", "Errore");
                return null;
            }

            tEntryDetail.TableName = "entrydetail";

            return tEntryDetail;
        }

       

        
        private string valutaIdAcc(object idAcc) {
            if (idAcc == DBNull.Value|| idAcc==null) return "";
            if (!accountLookup.ContainsKey(idAcc.ToString())) return "";
            string idplaccount = accountLookup[idAcc.ToString()];
            if (!plAccountLookup.ContainsKey(idplaccount)) return "";
            return plAccountLookup[idplaccount];          

        }
    }
}