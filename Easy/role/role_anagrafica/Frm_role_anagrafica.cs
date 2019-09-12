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
using System.Drawing;
using System.Collections;
using System.ComponentModel;
using System.Windows.Forms;
using metadatalibrary;

namespace role_anagrafica//cdruololista_Anagrafica//
{
	/// <summary>
	/// Summary description for frmcdruololista_Anagrafica.
	/// </summary>
	public class Frm_role_anagrafica : System.Windows.Forms.Form
	{
		public vistaForm DS;
		private System.Windows.Forms.ImageList images;
		private System.Windows.Forms.DataGrid dataGrid1;
		public System.Windows.Forms.ToolBar MetaDataToolBar;
		private System.Windows.Forms.ToolBarButton seleziona;
		private System.Windows.Forms.ToolBarButton impostaricerca;
		private System.Windows.Forms.ToolBarButton effettuaricerca;
		private System.Windows.Forms.ToolBarButton modifica;
		private System.Windows.Forms.ToolBarButton inserisci;
		private System.Windows.Forms.ToolBarButton inseriscicopia;
		private System.Windows.Forms.ToolBarButton elimina;
		private System.Windows.Forms.ToolBarButton Salva;
		private System.Windows.Forms.ToolBarButton aggiorna;
		public System.Windows.Forms.Panel MetaDataDetail;
		private System.Windows.Forms.TextBox textBox1;
		private System.Windows.Forms.Label label2;
		private System.Windows.Forms.TextBox textBox2;
		private System.Windows.Forms.Label label1;
		private System.Windows.Forms.ComboBox comboBox1;
		private System.Windows.Forms.CheckBox checkBox2;
		private System.Windows.Forms.Button button1;
		private System.ComponentModel.IContainer components;

		public Frm_role_anagrafica()
		{
			InitializeComponent();
		}

		/// <summary>
		/// Clean up any resources being used.
		/// </summary>
		protected override void Dispose( bool disposing )
		{
			if( disposing )
			{
				if(components != null)
				{
					components.Dispose();
				}
			}
			base.Dispose( disposing );
		}

		public void MetaData_AfterLink(){

			bool IsAdmin=false;
			MetaData Meta= MetaData.GetMetaData(this);

			if (Meta.GetSys("FlagMenuAdmin")!=null) 
				IsAdmin=(Meta.GetSys("FlagMenuAdmin").ToString()=="S");
			Meta.CanSave=IsAdmin;
			Meta.CanInsert=IsAdmin;
			Meta.CanInsertCopy=IsAdmin;
			Meta.CanCancel=IsAdmin;			
		}

		#region Windows Form Designer generated code
		/// <summary>
		/// Required method for Designer support - do not modify
		/// the contents of this method with the code editor.
		/// </summary>
		private void InitializeComponent()
		{
			this.components = new System.ComponentModel.Container();
			System.Resources.ResourceManager resources = new System.Resources.ResourceManager(typeof(Frm_role_anagrafica));
			this.DS = new role_anagrafica.vistaForm();
			this.images = new System.Windows.Forms.ImageList(this.components);
			this.dataGrid1 = new System.Windows.Forms.DataGrid();
			this.MetaDataToolBar = new System.Windows.Forms.ToolBar();
			this.seleziona = new System.Windows.Forms.ToolBarButton();
			this.impostaricerca = new System.Windows.Forms.ToolBarButton();
			this.effettuaricerca = new System.Windows.Forms.ToolBarButton();
			this.modifica = new System.Windows.Forms.ToolBarButton();
			this.inserisci = new System.Windows.Forms.ToolBarButton();
			this.inseriscicopia = new System.Windows.Forms.ToolBarButton();
			this.elimina = new System.Windows.Forms.ToolBarButton();
			this.Salva = new System.Windows.Forms.ToolBarButton();
			this.aggiorna = new System.Windows.Forms.ToolBarButton();
			this.MetaDataDetail = new System.Windows.Forms.Panel();
			this.button1 = new System.Windows.Forms.Button();
			this.checkBox2 = new System.Windows.Forms.CheckBox();
			this.comboBox1 = new System.Windows.Forms.ComboBox();
			this.textBox1 = new System.Windows.Forms.TextBox();
			this.label2 = new System.Windows.Forms.Label();
			this.textBox2 = new System.Windows.Forms.TextBox();
			this.label1 = new System.Windows.Forms.Label();
			((System.ComponentModel.ISupportInitialize)(this.DS)).BeginInit();
			((System.ComponentModel.ISupportInitialize)(this.dataGrid1)).BeginInit();
			this.MetaDataDetail.SuspendLayout();
			this.SuspendLayout();
			// 
			// DS
			// 
			this.DS.DataSetName = "vistaForm";
			this.DS.Locale = new System.Globalization.CultureInfo("en-US");
			// 
			// images
			// 
			this.images.ImageSize = new System.Drawing.Size(30, 30);
			this.images.ImageStream = ((System.Windows.Forms.ImageListStreamer)(resources.GetObject("images.ImageStream")));
			this.images.TransparentColor = System.Drawing.Color.Transparent;
			// 
			// dataGrid1
			// 
			this.dataGrid1.Anchor = ((System.Windows.Forms.AnchorStyles)((((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Bottom) 
				| System.Windows.Forms.AnchorStyles.Left) 
				| System.Windows.Forms.AnchorStyles.Right)));
			this.dataGrid1.DataMember = "";
			this.dataGrid1.HeaderForeColor = System.Drawing.SystemColors.ControlText;
			this.dataGrid1.Location = new System.Drawing.Point(16, 64);
			this.dataGrid1.Name = "dataGrid1";
			this.dataGrid1.Size = new System.Drawing.Size(498, 160);
			this.dataGrid1.TabIndex = 73;
			this.dataGrid1.Tag = "role.default";
			// 
			// MetaDataToolBar
			// 
			this.MetaDataToolBar.Appearance = System.Windows.Forms.ToolBarAppearance.Flat;
			this.MetaDataToolBar.Buttons.AddRange(new System.Windows.Forms.ToolBarButton[] {
																							   this.seleziona,
																							   this.impostaricerca,
																							   this.effettuaricerca,
																							   this.modifica,
																							   this.inserisci,
																							   this.inseriscicopia,
																							   this.elimina,
																							   this.Salva,
																							   this.aggiorna});
			this.MetaDataToolBar.ButtonSize = new System.Drawing.Size(56, 56);
			this.MetaDataToolBar.DropDownArrows = true;
			this.MetaDataToolBar.ImageList = this.images;
			this.MetaDataToolBar.Location = new System.Drawing.Point(0, 0);
			this.MetaDataToolBar.Name = "MetaDataToolBar";
			this.MetaDataToolBar.ShowToolTips = true;
			this.MetaDataToolBar.Size = new System.Drawing.Size(530, 106);
			this.MetaDataToolBar.TabIndex = 76;
			this.MetaDataToolBar.Tag = "";
			// 
			// seleziona
			// 
			this.seleziona.ImageIndex = 1;
			this.seleziona.Tag = "mainselect";
			this.seleziona.Text = "Seleziona";
			this.seleziona.ToolTipText = "Seleziona l\'elemento desiderato";
			// 
			// impostaricerca
			// 
			this.impostaricerca.ImageIndex = 10;
			this.impostaricerca.Tag = "mainsetsearch";
			this.impostaricerca.Text = "Imposta Ricerca";
			this.impostaricerca.ToolTipText = "Imposta una nuova ricerca";
			// 
			// effettuaricerca
			// 
			this.effettuaricerca.ImageIndex = 12;
			this.effettuaricerca.Tag = "maindosearch";
			this.effettuaricerca.Text = "Effettua Ricerca";
			this.effettuaricerca.ToolTipText = "Cerca in base ai dati immessi";
			// 
			// modifica
			// 
			this.modifica.ImageIndex = 6;
			this.modifica.Tag = "mainedit";
			this.modifica.Text = "Modifica";
			this.modifica.ToolTipText = "Modifica l\'elemento selezionato";
			// 
			// inserisci
			// 
			this.inserisci.ImageIndex = 0;
			this.inserisci.Tag = "maininsert";
			this.inserisci.Text = "Inserisci";
			this.inserisci.ToolTipText = "Inserisci un nuovo elemento";
			// 
			// inseriscicopia
			// 
			this.inseriscicopia.ImageIndex = 9;
			this.inseriscicopia.Tag = "maininsertcopy";
			this.inseriscicopia.Text = "Inserisci copia";
			this.inseriscicopia.ToolTipText = "Inserisci un nuovo elemento copiando i dati da quello attuale";
			// 
			// elimina
			// 
			this.elimina.ImageIndex = 3;
			this.elimina.Tag = "maindelete";
			this.elimina.Text = "Elimina";
			this.elimina.ToolTipText = "Elimina l\'elemento selezionato";
			// 
			// Salva
			// 
			this.Salva.ImageIndex = 2;
			this.Salva.Tag = "mainsave";
			this.Salva.Text = "Salva";
			this.Salva.ToolTipText = "Salva le modifiche effettuate";
			// 
			// aggiorna
			// 
			this.aggiorna.ImageIndex = 13;
			this.aggiorna.Tag = "mainrefresh";
			this.aggiorna.Text = "Aggiorna";
			// 
			// MetaDataDetail
			// 
			this.MetaDataDetail.Anchor = ((System.Windows.Forms.AnchorStyles)(((System.Windows.Forms.AnchorStyles.Bottom | System.Windows.Forms.AnchorStyles.Left) 
				| System.Windows.Forms.AnchorStyles.Right)));
			this.MetaDataDetail.Controls.Add(this.button1);
			this.MetaDataDetail.Controls.Add(this.checkBox2);
			this.MetaDataDetail.Controls.Add(this.comboBox1);
			this.MetaDataDetail.Controls.Add(this.textBox1);
			this.MetaDataDetail.Controls.Add(this.label2);
			this.MetaDataDetail.Controls.Add(this.textBox2);
			this.MetaDataDetail.Controls.Add(this.label1);
			this.MetaDataDetail.Location = new System.Drawing.Point(16, 232);
			this.MetaDataDetail.Name = "MetaDataDetail";
			this.MetaDataDetail.Size = new System.Drawing.Size(498, 136);
			this.MetaDataDetail.TabIndex = 75;
			// 
			// button1
			// 
			this.button1.Location = new System.Drawing.Point(8, 8);
			this.button1.Name = "button1";
			this.button1.Size = new System.Drawing.Size(88, 23);
			this.button1.TabIndex = 67;
			this.button1.Tag = "manage.registryclass.anagrafica";
			this.button1.Text = "Tipologia";
			// 
			// checkBox2
			// 
			this.checkBox2.Location = new System.Drawing.Point(104, 56);
			this.checkBox2.Name = "checkBox2";
			this.checkBox2.Size = new System.Drawing.Size(96, 24);
			this.checkBox2.TabIndex = 66;
			this.checkBox2.Tag = "role.active:S:N";
			this.checkBox2.Text = "Attivo";
			// 
			// comboBox1
			// 
			this.comboBox1.Anchor = ((System.Windows.Forms.AnchorStyles)(((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Left) 
				| System.Windows.Forms.AnchorStyles.Right)));
			this.comboBox1.DataSource = this.DS.registryclass;
			this.comboBox1.DisplayMember = "description";
			this.comboBox1.Location = new System.Drawing.Point(104, 8);
			this.comboBox1.Name = "comboBox1";
			this.comboBox1.Size = new System.Drawing.Size(378, 21);
			this.comboBox1.TabIndex = 64;
			this.comboBox1.Tag = "role.idregistryclass";
			this.comboBox1.ValueMember = "idregistryclass";
			// 
			// textBox1
			// 
			this.textBox1.Location = new System.Drawing.Point(8, 56);
			this.textBox1.MaxLength = 1;
			this.textBox1.Name = "textBox1";
			this.textBox1.Size = new System.Drawing.Size(88, 20);
			this.textBox1.TabIndex = 50;
			this.textBox1.Tag = "role.idrole";
			this.textBox1.Text = "";
			// 
			// label2
			// 
			this.label2.Location = new System.Drawing.Point(8, 88);
			this.label2.Name = "label2";
			this.label2.Size = new System.Drawing.Size(100, 16);
			this.label2.TabIndex = 49;
			this.label2.Text = "Descrizione";
			// 
			// textBox2
			// 
			this.textBox2.Anchor = ((System.Windows.Forms.AnchorStyles)(((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Left) 
				| System.Windows.Forms.AnchorStyles.Right)));
			this.textBox2.Location = new System.Drawing.Point(8, 104);
			this.textBox2.Name = "textBox2";
			this.textBox2.Size = new System.Drawing.Size(474, 20);
			this.textBox2.TabIndex = 51;
			this.textBox2.Tag = "role.description";
			this.textBox2.Text = "";
			// 
			// label1
			// 
			this.label1.Location = new System.Drawing.Point(8, 40);
			this.label1.Name = "label1";
			this.label1.Size = new System.Drawing.Size(72, 16);
			this.label1.TabIndex = 48;
			this.label1.Text = "Codice";
			// 
			// Frm_role_anagrafica
			// 
			this.AutoScaleBaseSize = new System.Drawing.Size(5, 13);
			this.ClientSize = new System.Drawing.Size(530, 374);
			this.Controls.Add(this.dataGrid1);
			this.Controls.Add(this.MetaDataToolBar);
			this.Controls.Add(this.MetaDataDetail);
			this.Name = "Frm_role_anagrafica";
			this.Text = "frmcdruololista_Anagrafica";
			((System.ComponentModel.ISupportInitialize)(this.DS)).EndInit();
			((System.ComponentModel.ISupportInitialize)(this.dataGrid1)).EndInit();
			this.MetaDataDetail.ResumeLayout(false);
			this.ResumeLayout(false);

		}
		#endregion
	}
}
