﻿<%@ Page Language="C#" MasterPageFile="~/MetaMasterBootstrap.master" AutoEventWireup="true" CodeFile="accountenactment_default.aspx.cs" Inherits="accountenactment_default"  Title="Atto amministrativo di budget" %>

<%@ Register Assembly="HelpWeb" Namespace="HelpWeb" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="CHP_PC" Runat="Server" >

    <div class="row">
        <div class="col-md-4">
            <fieldset>
                <legend>Atto</legend>
                <div class="row">
                    <div class="col-md-6">
                        <label for="txtEsercizioDocumento">Esercizio:</label>
                    </div>
                    <div class="col-md-6">
                        <cc1:hwTextBox runat="server" ReadOnly="true"  CssClass="input-md form-control" style="text-align: right;" TabIndex="10" ID="txtEsercizioDocumento" Tag="accountenactment.yenactment"></cc1:hwTextBox>
                    </div>
                </div>
                <div class="row">
                    <div class="col-md-6">
                        <label for="txtNumeroDocumento">Numero:</label>
                    </div>
                    <div class="col-md-6">
                        <cc1:hwTextBox runat="server" TabIndex="20" CssClass="input-md form-control" style="text-align: right;" ID="txtNumeroDocumento" Tag="accountenactment.nenactment"></cc1:hwTextBox>
                    </div>
                </div>
                <div class="row">
                    <div class="col-md-6">
                       
                    </div>
                    <div class="col-md-6">
                       
                    </div>
                </div>
            </fieldset>
        </div>

    <div class="col-md-4">
        <fieldset id="gboxStato" runat="server">
            <legend>Stato</legend>
            <div class="row">
                <div class="col-md-12">
                    <cc1:hwRadioButton runat="server" TabIndex="40" Tag="accountenactment.idenactmentstatus:1" ID="rdbInAttesa" Text="In attesa di approvazione" />
                </div>
            </div>
            <div class="row">
                <div class="col-md-12">
                    <cc1:hwRadioButton runat="server" TabIndex="50" Tag="accountenactment.idenactmentstatus:2" ID="rdbApprovato" Text="Approvato" />
                </div>
            </div>
            <div class="row">
                <div class="col-md-12">
                    <cc1:hwRadioButton runat="server" TabIndex="60" Tag="accountenactment.idenactmentstatus:3" ID="rdbAnnullato" Text="Annullato" />
                </div>
            </div>
        </fieldset>
    </div>

        <div class="col-md-4">
            <div class="row">
                <div class="col-md-12">
                    <cc1:hwButton runat="server"  class="btn btn-block" TabIndex="70" ID="btnWait" Text="Rimetti in attesa" Tag="do_wait" />
                </div>
            </div>
            <div class="row">
                <div class="col-md-12">
                    <cc1:hwButton runat="server"  class="btn btn-block" TabIndex="80" ID="btnApprova" Text="Approva l'atto" Tag="do_approva" />
                </div>
            </div>
            <div class="row">
                <div class="col-md-12">
                    <cc1:hwButton runat="server"  class="btn btn-block" TabIndex="90" ID="btnAnnulla" Text="Annulla l'atto" Tag="do_annulla" />
                </div>
            </div>
        </div>
    </div>


    <div class="row">
        <div class="col-md-10">
            <label for="txtDescrizione">Descrizione:</label>
            <cc1:hwTextBox runat="server" TabIndex="100"  CssClass="form-control" Tag="accountenactment.description" ID="txtDescrizione" TextMode="multiLine" Rows="3"></cc1:hwTextBox>
        </div>
        <div class="col-md-2">
            <label for="txtDataContabile">Data Contabile:</label>
            <cc1:hwTextBox runat="server"  CssClass="form-control" TabIndex="110" ID="txtDataContabile" Tag="accountenactment.adate"></cc1:hwTextBox>
        </div>
    </div>

        
    <div class="row">
        <fieldset>
            <legend>Variazioni di Budget inserite nell'atto</legend>
            <div class="col-md-2">
                <cc1:hwButton runat="server" TabIndex="120" ID="btnCollega" Tag="collega" class="btn btn-block" Text="Inserisci" />
                <cc1:hwButton runat="server" TabIndex="130" ID="btnScollega" Tag="unlink.detail" class="btn  btn-block" Text="Rimuovi" />
                <cc1:hwButton runat="server" TabIndex="140" ID="btnModifica" Tag="modifica" class="btn btn-block" Text="Modifica" />
            </div>
            <div class="col-md-10">
                <div id="necessary" runat="server">
                    <cc1:hwDataGridWeb runat="server" TabIndex="150" ID="dgrVariazioni" Tag="accountvarview.documentocollegato" />
                </div>
            </div>
        </fieldset>
    </div>


</asp:Content>

