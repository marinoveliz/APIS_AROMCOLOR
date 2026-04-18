page 50101 PurchaseLineAPI
{
    PageType = API;
    APIPublisher = 'TECNOAV';
    APIGroup = 'apiGroup';
    Caption = 'purchaseLineAPI';
    EntityName = 'purchaseLine';
    EntitySetName = 'purchaseLines';
    DelayedInsert = true;
    SourceTable = "Purchase Line";

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field(lineNo; Rec."Line No.") { }
                field(type; Rec."Type") { }
                field(no; Rec."No.") { }
                field(description; Rec.Description) { }
                field(quantity; Rec.Quantity) { }
                field(directUnitCost; Rec."Direct Unit Cost") { }
                field(locationCode; Rec."Location Code") { }
                field(taeAmountICE; Rec."tae_Amount ICE")
                {
                    Caption = 'Monto ICE';
                }
                field(taeAmountIncludingVATLast; Rec."tae_Amount Including VAT Last")
                {
                    Caption = 'tae_Amount Including VAT Last';
                }
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
                field(taeAnioUltDiv; Rec.tae_AnioUltDiv)
                {
                    Caption = 'tae_AnioUltDiv';
                }
                field(taeConceptoDeclaraIVA; Rec.tae_ConceptoDeclaraIVA)
                {
                    Caption = 'Concepto declaración IVA';
                }
                field(taeConceptoRetencion; Rec.tae_ConceptoRetencion)
                {
                    Caption = 'Concepto retención';
                }
                field(taeCostoUnitarioExclIVA; Rec."tae_Costo Unitario Excl. IVA")
                {
                    Caption = 'Direct Unit Cost';
                }
                field(taeDividendos; Rec.tae_Dividendos)
                {
                    Caption = 'tae_Dividendos';
                }
                field(taeFacturaReembolso; Rec."tae_Factura Reembolso")
                {
                    Caption = 'tae_Factura Reembolso';
                }
                field(taeFechaPagoDiv; Rec.tae_FechaPagoDiv)
                {
                    Caption = 'tae_FechaPagoDiv';
                }
                field(taeImRentaSoc; Rec.tae_ImRentaSoc)
                {
                    Caption = 'tae_ImRentaSoc';
                }
                field(taeIvaIncluido; Rec.tae_IvaIncluido)
                {
                    Caption = 'Iva Asumido';
                }
                field(taeNoImportacion; Rec."tae_No. Importacion")
                {
                    Caption = 'No. Importacion';
                }
                field(taeRETVATBaseAmount; Rec."tae_RETVAT Base Amount")
                {
                    Caption = 'tae_RETVAT Base Amount';
                }
                field(taeReembIdentifierIVA; Rec."tae_Reemb Identifier IVA")
                {
                    Caption = 'VAT Identifier';
                }
                field(taeReembIVA; Rec."tae_Reemb_% IVA")
                {
                    Caption = 'Reemb % Impto.';
                }
                field(taeReembAutorizacion; Rec.tae_Reemb_Autorizacion)
                {
                    Caption = 'No. Autorización';
                }
                field(taeReembBaseICE; Rec.tae_Reemb_BaseICE)
                {
                    Caption = 'Reemb Base ICE';
                }
                field(taeReembBaseIVA; Rec.tae_Reemb_BaseIVA)
                {
                    Caption = 'Reemb Base IVA';
                }
                field(taeReembBaseIVA0; Rec.tae_Reemb_BaseIVA0)
                {
                    Caption = 'Reemb Base IVA 0';
                }
                field(taeReembBaseNOIVA; Rec.tae_Reemb_BaseNOIVA)
                {
                    Caption = 'Reemb Base NO IVA';
                }
                field(taeReembElectronico; Rec.tae_Reemb_Electronico)
                {
                    Caption = 'Comprobante electrónico';
                }
                field(taeReembEsquemaOffline; Rec.tae_Reemb_EsquemaOffline)
                {
                    Caption = 'Esquema Offline';
                }
                field(taeReembEstablecimiento; Rec.tae_Reemb_Establecimiento)
                {
                    Caption = 'Establecimiento';
                }
                field(taeReembFechaEmision; Rec.tae_Reemb_FechaEmision)
                {
                    Caption = 'Fecha emision documento';
                }
                field(taeReembIdProveedor; Rec.tae_Reemb_IdProveedor)
                {
                    Caption = 'N° identificación proveedor';
                }
                field(taeReembMontoICE; Rec.tae_Reemb_MontoICE)
                {
                    Caption = 'Reemb Monto ICE';
                }
                field(taeReembPaisProveedor; Rec.tae_Reemb_PaisProveedor)
                {
                    Caption = 'Country/Region Code';
                }
                field(taeReembPeriodo; Rec.tae_Reemb_Periodo)
                {
                    Caption = 'Periodo';
                }
                field(taeReembPtoEmision; Rec.tae_Reemb_PtoEmision)
                {
                    Caption = 'Pto. Emisión';
                }
                field(taeReembSecuencial; Rec.tae_Reemb_Secuencial)
                {
                    Caption = 'No. Comprobante';
                }
                field(taeReembSecuencialProveedor; Rec.tae_Reemb_SecuencialProveedor)
                {
                    Caption = 'Secuencial proveedor';
                }
                field(taeReembTipoComprobante; Rec."tae_Reemb_Tipo Comprobante")
                {
                    Caption = 'Tipo comprobante';
                }
                field(taeReembTipoIVA; Rec.tae_Reemb_TipoIVA)
                {
                    Caption = 'Reemb Cod. Impto';
                }
                field(taeReembTipoIdProveedor; Rec.tae_Reemb_TipoIdProveedor)
                {
                    Caption = 'Tipo identificación proveedor';
                }
                field(taeReembTipoProveedor; Rec.tae_Reemb_TipoProveedor)
                {
                    Caption = 'Tipo proveedor';
                }
                field(taeRetAplicar; Rec.tae_Ret_Aplicar)
                {
                    Caption = 'Aplica retención';
                }
                field(taeTipoDoc; Rec.tae_TipoDoc)
                {
                    Caption = 'Tipo documento';
                }
                field(taeTipoImpuesto; Rec.tae_TipoImpuesto)
                {
                    Caption = 'Tipo impuesto';
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
                field(taeVATAmount1; Rec."tae_VAT Amount 1")
                {
                    Caption = 'Importe Impto. 1';
                }
                field(taeVATAmount2; Rec."tae_VAT Amount 2")
                {
                    Caption = 'Importe Impto. 2';
                }
                field(taeVATAmount3; Rec."tae_VAT Amount 3")
                {
                    Caption = 'Importe Impto. 3';
                }
                field(taeVATAmount4; Rec."tae_VAT Amount 4")
                {
                    Caption = 'Importe Impto. 4';
                }
                field(taeVATAmountAsumido; Rec."tae_VAT Amount Asumido")
                {
                    Caption = 'Importe Impto. asumido';
                }
                field(taeVATAmountTotalAsumido; Rec."tae_VAT Amount Total Asumido")
                {
                    Caption = 'Importe total Impto. asumido';
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
                field(taeValueAmountIVA; Rec."tae_Value Amount IVA")
                {
                    Caption = 'Monto IVA';
                }
                field(taeValueAmountRETFTE; Rec."tae_Value Amount RETFTE")
                {
                    Caption = 'Monto Ret Fte';
                }
                field(taeValueAmountRETIVA; Rec."tae_Value Amount RETIVA")
                {
                    Caption = 'Monto Ret IVA';
                }
            }
        }
    }
}