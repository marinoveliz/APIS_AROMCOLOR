page 50100 PurchaseOrderAPI
{
    APIGroup = 'apiGroup';
    APIPublisher = 'TECNOAV';
    APIVersion = 'v1.0';
    ApplicationArea = All;
    Caption = 'purchaseOrderAPI';
    DelayedInsert = true;
    EntityName = 'purchaseOrder';
    EntitySetName = 'purchaseOrders';
    PageType = API;
    SourceTable = "Purchase Header";
    SourceTableView = WHERE("Document Type" = FILTER(Order));

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field(systemId; Rec.SystemId) { Editable = false; }
                field(documentType; Rec."Document Type") { }
                field(no; Rec."No.") { }
                field(buyFromVendorNo; Rec."Buy-from Vendor No.") { }
                field(orderDate; Rec."Order Date") { }
                field(postingDate; Rec."Posting Date") { }
                field(currencyCode; Rec."Currency Code") { }
                field(taeAmountRETFTE; Rec."tae_Amount RETFTE")
                {
                    Caption = 'Monto Ret Fte';
                }
                field(taeAmountRETIVA; Rec."tae_Amount RETIVA")
                {
                    Caption = 'Monto Ret IVA';
                }
                field(taeAmountVAT; Rec."tae_Amount VAT")
                {
                    Caption = 'Monto IVA';
                }
                field(taeAplicaAnexos; Rec.tae_AplicaAnexos)
                {
                    Caption = 'Aplica Anexos';
                }
                field(taeBlanketOrderNo; Rec."tae_Blanket Order No.")
                {
                    Caption = 'No. Pedido abierto';
                }
                field(taeCompAutorizacion; Rec.tae_Comp_Autorizacion)
                {
                    Caption = 'Autorización comprobante';
                }
                field(taeCompCodigoSRI; Rec.tae_Comp_CodigoSRI)
                {
                    Caption = 'CódigoSRI comprobante';
                }
                field(taeCompElectronico; Rec.tae_Comp_Electronico)
                {
                    Caption = 'Comprobante electrónico';
                }
                field(taeCompEsquemaOffline; Rec.tae_Comp_EsquemaOffline)
                {
                    Caption = 'Esquema Offline';
                }
                field(taeCompEstablecimiento; Rec.tae_Comp_Establecimiento)
                {
                    Caption = 'Establecimiento comprobante';
                }
                field(taeCompEstado; Rec.tae_Comp_Estado)
                {
                    Caption = 'Estado comprobante';
                }
                field(taeCompPtoEmision; Rec.tae_Comp_PtoEmision)
                {
                    Caption = 'Pto Emisión comprobante';
                }
                field(taeCompSecuencial; Rec.tae_Comp_Secuencial)
                {
                    Caption = 'Secuencial comprobante';
                }
                field(taeFiscalInvoiceNumberPAC; Rec."tae_Fiscal Invoice Number PAC")
                {
                    Caption = 'Fiscal Invoice Number PAC';
                }
                field(taeImpCatalogIncotermName; Rec."tae_Imp_Catalog Incoterm Name")
                {
                    Caption = 'Catalogo Incoterm';
                }
                field(taeImpConRefrendo; Rec."tae_Imp_Con Refrendo")
                {
                    Caption = 'Con Refrendo';
                }
                field(taeImpExitPoint; Rec."tae_Imp_Exit Point")
                {
                    Caption = 'Puerto/Aerop. embarque';
                }
                field(taeImpExterior; Rec.tae_Imp_Exterior)
                {
                    Caption = 'Es Proveedor Exterior';
                }
                field(taeImpRefrendoCompleto; Rec.tae_Imp_RefrendoCompleto)
                {
                    Caption = 'N° Refrendo';
                }
                field(taeImpRefrendoCorrelativo; Rec.tae_Imp_RefrendoCorrelativo)
                {
                    Caption = 'Correlativo';
                }
                field(taeImpRefrendoDistAduanero; Rec.tae_Imp_RefrendoDistAduanero)
                {
                    Caption = 'Distrito Aduanero';
                }
                field(taeImpRefrendoRegimen; Rec.tae_Imp_RefrendoRegimen)
                {
                    Caption = 'Régimen';
                }
                field(taeImpSrCountryRegionCode; Rec."tae_Imp_Sr Country/Region Code")
                {
                    Caption = 'País/Procedencia';
                }
                field(taeImpTipoImportacion; Rec.tae_Imp_TipoImportacion)
                {
                    Caption = 'Tipo de importación';
                }
                field(taeIncoterms; Rec.tae_Incoterms)
                {
                    Caption = 'Incoterm';
                }
                field(taeModAnularComp; Rec."tae_Mod_Anular Comp")
                {
                    Caption = 'Anular comprobante';
                }
                field(taeModAnularRet; Rec."tae_Mod_Anular Ret")
                {
                    Caption = 'Anular retención';
                }
                field(taeModAutorizacion; Rec.tae_Mod_Autorizacion)
                {
                    Caption = 'Autorización modificar';
                }
                field(taeModCodigoSRI; Rec.tae_Mod_CodigoSRI)
                {
                    Caption = 'CódigoSRI modificar';
                }
                field(taeModElectronico; Rec.tae_Mod_Electronico)
                {
                    Caption = 'Comprobante electronico';
                }
                field(taeModEstablecimiento; Rec.tae_Mod_Establecimiento)
                {
                    Caption = 'Establecimiento modificar';
                }
                field(taeModMotivo; Rec.tae_Mod_Motivo)
                {
                    Caption = 'Motivo modificar';
                }
                field(taeModNoDocumento; Rec."tae_Mod_No. Documento")
                {
                    Caption = 'N° documento modificar';
                }
                field(taeModPtoEmision; Rec.tae_Mod_PtoEmision)
                {
                    Caption = 'Pto Emisión modificar';
                }
                field(taeModSecuencial; Rec.tae_Mod_Secuencial)
                {
                    Caption = 'Secuencial modificar';
                }
                field(taeModTipoComprobante; Rec."tae_Mod_Tipo Comprobante")
                {
                    Caption = 'Tipo comprobante modificar';
                }
                field(taeModTipoDocumento; Rec."tae_Mod_Tipo Documento")
                {
                    Caption = 'Tipo documento modificar';
                }
                field(taeNoImportacion; Rec."tae_No. Importacion")
                {
                    Caption = 'No. Importacion';
                }
                field(taeNoValidarCampos; Rec.tae_NoValidarCampos)
                {
                    Caption = 'tae_NoValidarCampos';
                }
                field(taePeriodo; Rec.tae_Periodo)
                {
                    Caption = 'Periodo';
                }
                field(taeRetAplicar; Rec.tae_Ret_Aplicar)
                {
                    Caption = 'Factura aplica retención';
                }
                field(taeRetAutorizacion; Rec.tae_Ret_Autorizacion)
                {
                    Caption = 'Autorización retención';
                }
                field(taeRetCodigoSRI; Rec.tae_Ret_CodigoSRI)
                {
                    Caption = 'CódigoSRI retención';
                }
                field(taeRetElectronica; Rec.tae_Ret_Electronica)
                {
                    Caption = 'Retención electronica';
                }
                field(taeRetEstablecimiento; Rec.tae_Ret_Establecimiento)
                {
                    Caption = 'Establecimiento retención';
                }
                field(taeRetEstado; Rec.tae_Ret_Estado)
                {
                    Caption = 'Estado retención';
                }
                field(taeRetFechaEmision; Rec.tae_Ret_FechaEmision)
                {
                    Caption = 'Fecha emisión retención';
                }
                field(taeRetPeriodo; Rec.tae_Ret_Periodo)
                {
                    Caption = 'Periodo retención';
                }
                field(taeRetPtoEmision; Rec.tae_Ret_PtoEmision)
                {
                    Caption = 'Pto Emisión retención';
                }
                field(taeRetSecuencial; Rec.tae_Ret_Secuencial)
                {
                    Caption = 'Secuencial retención';
                }
                field(taeSecuencial; Rec.tae_Secuencial)
                {
                    Caption = 'Secuencial';
                }
                field(taeSustentoTributario; Rec."tae_Sustento Tributario")
                {
                    Caption = 'Sustento tributario';
                }
                field(taeTipoComprobante; Rec."tae_Tipo Comprobante")
                {
                    Caption = 'Tipo comprobante';
                }
                field(taeTipoDoc; Rec.tae_TipoDoc)
                {
                    Caption = 'Tipo Doc';
                }
                field(taeVAT1; Rec."tae_VAT % 1")
                {
                    Caption = 'VAT % 1';
                }
                field(taeVAT2; Rec."tae_VAT % 2")
                {
                    Caption = 'VAT % 2';
                }
                field(taeVAT3; Rec."tae_VAT % 3")
                {
                    Caption = 'VAT % 3';
                }
                field(taeVAT4; Rec."tae_VAT % 4")
                {
                    Caption = 'VAT % 4';
                }
                field(taeVATA; Rec."tae_VAT % A")
                {
                    Caption = 'VAT % 1';
                }
                field(taeVATAsumido; Rec."tae_VAT Asumido")
                {
                    Caption = 'Impuesto asumido';
                }
                field(taeVATIdentifier1; Rec."tae_VAT Identifier 1")
                {
                    Caption = 'VAT Identifier';
                }
                field(taeVATIdentifier2; Rec."tae_VAT Identifier 2")
                {
                    Caption = 'VAT Identifier';
                }
                field(taeVATIdentifier3; Rec."tae_VAT Identifier 3")
                {
                    Caption = 'VAT Identifier';
                }
                field(taeVATIdentifier4; Rec."tae_VAT Identifier 4")
                {
                    Caption = 'VAT Identifier';
                }
                field(taeVATIdentifierA; Rec."tae_VAT Identifier A")
                {
                    Caption = 'VAT Identifier';
                }
                field(taeVATProdPostingGroup1; Rec."tae_VAT Prod. Posting Group 1")
                {
                    Caption = 'Cód. Impto. 1';
                }
                field(taeVATProdPostingGroup2; Rec."tae_VAT Prod. Posting Group 2")
                {
                    Caption = 'Cód. Impto. 2';
                }
                field(taeVATProdPostingGroup3; Rec."tae_VAT Prod. Posting Group 3")
                {
                    Caption = 'Cód. Impto. 3';
                }
                field(taeVATProdPostingGroup4; Rec."tae_VAT Prod. Posting Group 4")
                {
                    Caption = 'Cód. Impto. 4';
                }
                field(taeVATProdPostingGroupA; Rec."tae_VAT Prod. Posting Group A")
                {
                    Caption = 'Tax Prod. Posting Group 1';
                }

            }
            // Este PART permite el Deep Insert
            part(purchaseLines; PurchaseLineAPI)
            {
                Caption = 'Lines';
                EntityName = 'purchaseLine';
                EntitySetName = 'purchaseLines';
                SubPageLink = "Document No." = FIELD("No."), "Document Type" = FIELD("Document Type");
            }
        }
    }
}

