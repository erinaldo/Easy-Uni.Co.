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

´╗┐namespace assetacquire_default {
    partial class FrmAskDescr {
        /// <summary>
        /// Required designer variable.
        /// </summary>
        private System.ComponentModel.IContainer components = null;

        /// <summary>
        /// Clean up any resources being used.
        /// </summary>
        /// <param name="disposing">true if managed resources should be disposed; otherwise, false.</param>
        protected override void Dispose(bool disposing) {
            if (disposing && (components != null)) {
                components.Dispose();
            }
            base.Dispose(disposing);
        }

        #region Windows Form Designer generated code

        /// <summary>
        /// Required method for Designer support - do not modify
        /// the contents of this method with the code editor.
        /// </summary>
        private void InitializeComponent() {
            this.groupBox1 = new System.Windows.Forms.GroupBox();
            this.txtDescrizione = new System.Windows.Forms.TextBox();
            this.lblIndicazioni = new System.Windows.Forms.Label();
            this.grpClassMerc = new System.Windows.Forms.GroupBox();
            this.txtDescClassMerc = new System.Windows.Forms.TextBox();
            this.txtCodClassMerc = new System.Windows.Forms.TextBox();
            this.btnClassMerc = new System.Windows.Forms.Button();
            this.btnCancel = new System.Windows.Forms.Button();
            this.btnOk = new System.Windows.Forms.Button();
            this.groupBox1.SuspendLayout();
            this.grpClassMerc.SuspendLayout();
            this.SuspendLayout();
            // 
            // groupBox1
            // 
            this.groupBox1.Controls.Add(this.txtDescrizione);
            this.groupBox1.Controls.Add(this.lblIndicazioni);
            this.groupBox1.Location = new System.Drawing.Point(12, 12);
            this.groupBox1.Name = "groupBox1";
            this.groupBox1.Size = new System.Drawing.Size(365, 74);
            this.groupBox1.TabIndex = 16;
            this.groupBox1.TabStop = false;
            this.groupBox1.Text = "Descrizione";
            // 
            // txtDescrizione
            // 
            this.txtDescrizione.Anchor = ((System.Windows.Forms.AnchorStyles)(((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Left) 
            | System.Windows.Forms.AnchorStyles.Right)));
            this.txtDescrizione.Location = new System.Drawing.Point(6, 47);
            this.txtDescrizione.Name = "txtDescrizione";
            this.txtDescrizione.Size = new System.Drawing.Size(353, 20);
            this.txtDescrizione.TabIndex = 2;
            // 
            // lblIndicazioni
            // 
            this.lblIndicazioni.Location = new System.Drawing.Point(8, 30);
            this.lblIndicazioni.Name = "lblIndicazioni";
            this.lblIndicazioni.Size = new System.Drawing.Size(296, 25);
            this.lblIndicazioni.TabIndex = 14;
            this.lblIndicazioni.Text = "Inserire parte della descrizione del listino desiderato";
            // 
            // grpClassMerc
            // 
            this.grpClassMerc.Controls.Add(this.txtDescClassMerc);
            this.grpClassMerc.Controls.Add(this.txtCodClassMerc);
            this.grpClassMerc.Controls.Add(this.btnClassMerc);
            this.grpClassMerc.Location = new System.Drawing.Point(12, 102);
            this.grpClassMerc.Name = "grpClassMerc";
            this.grpClassMerc.Size = new System.Drawing.Size(365, 121);
            this.grpClassMerc.TabIndex = 17;
            this.grpClassMerc.TabStop = false;
            this.grpClassMerc.Tag = "";
            this.grpClassMerc.Text = "Class.Merceologica";
            // 
            // txtDescClassMerc
            // 
            this.txtDescClassMerc.Anchor = ((System.Windows.Forms.AnchorStyles)(((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Left) 
            | System.Windows.Forms.AnchorStyles.Right)));
            this.txtDescClassMerc.Location = new System.Drawing.Point(127, 15);
            this.txtDescClassMerc.Multiline = true;
            this.txtDescClassMerc.Name = "txtDescClassMerc";
            this.txtDescClassMerc.ReadOnly = true;
            this.txtDescClassMerc.Size = new System.Drawing.Size(228, 57);
            this.txtDescClassMerc.TabIndex = 5;
            this.txtDescClassMerc.TabStop = false;
            this.txtDescClassMerc.Tag = "";
            // 
            // txtCodClassMerc
            // 
            this.txtCodClassMerc.Anchor = ((System.Windows.Forms.AnchorStyles)(((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Left) 
            | System.Windows.Forms.AnchorStyles.Right)));
            this.txtCodClassMerc.Location = new System.Drawing.Point(6, 83);
            this.txtCodClassMerc.Name = "txtCodClassMerc";
            this.txtCodClassMerc.Size = new System.Drawing.Size(349, 20);
            this.txtCodClassMerc.TabIndex = 4;
            this.txtCodClassMerc.Tag = "";
            this.txtCodClassMerc.Leave += new System.EventHandler(this.txtCodClassMerc_Leave);
            // 
            // btnClassMerc
            // 
            this.btnClassMerc.Location = new System.Drawing.Point(11, 54);
            this.btnClassMerc.Name = "btnClassMerc";
            this.btnClassMerc.Size = new System.Drawing.Size(88, 23);
            this.btnClassMerc.TabIndex = 3;
            this.btnClassMerc.TabStop = false;
            this.btnClassMerc.Tag = "";
            this.btnClassMerc.Text = "Classificazione";
            this.btnClassMerc.Click += new System.EventHandler(this.btnClassMerc_Click);
            // 
            // btnCancel
            // 
            this.btnCancel.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Bottom | System.Windows.Forms.AnchorStyles.Left)));
            this.btnCancel.DialogResult = System.Windows.Forms.DialogResult.Cancel;
            this.btnCancel.Location = new System.Drawing.Point(231, 236);
            this.btnCancel.Name = "btnCancel";
            this.btnCancel.Size = new System.Drawing.Size(75, 23);
            this.btnCancel.TabIndex = 19;
            this.btnCancel.Text = "Cancel";
            // 
            // btnOk
            // 
            this.btnOk.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Bottom | System.Windows.Forms.AnchorStyles.Left)));
            this.btnOk.DialogResult = System.Windows.Forms.DialogResult.OK;
            this.btnOk.Location = new System.Drawing.Point(97, 236);
            this.btnOk.Name = "btnOk";
            this.btnOk.Size = new System.Drawing.Size(75, 23);
            this.btnOk.TabIndex = 18;
            this.btnOk.Text = "Ok";
            // 
            // FrmAskDescr
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(395, 271);
            this.Controls.Add(this.groupBox1);
            this.Controls.Add(this.grpClassMerc);
            this.Controls.Add(this.btnCancel);
            this.Controls.Add(this.btnOk);
            this.Name = "FrmAskDescr";
            this.StartPosition = System.Windows.Forms.FormStartPosition.CenterScreen;
            this.Text = "FrmAskDescr";
            this.FormClosing += new System.Windows.Forms.FormClosingEventHandler(this.FrmAskDescr_FormClosing);
            this.groupBox1.ResumeLayout(false);
            this.groupBox1.PerformLayout();
            this.grpClassMerc.ResumeLayout(false);
            this.grpClassMerc.PerformLayout();
            this.ResumeLayout(false);

        }

        #endregion

        private System.Windows.Forms.GroupBox groupBox1;
        public System.Windows.Forms.TextBox txtDescrizione;
        private System.Windows.Forms.Label lblIndicazioni;
        private System.Windows.Forms.GroupBox grpClassMerc;
        private System.Windows.Forms.TextBox txtDescClassMerc;
        private System.Windows.Forms.TextBox txtCodClassMerc;
        private System.Windows.Forms.Button btnClassMerc;
        private System.Windows.Forms.Button btnCancel;
        private System.Windows.Forms.Button btnOk;
    }
}