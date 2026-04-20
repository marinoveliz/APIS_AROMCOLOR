page 50102 BlanketSalesOrderAPI
{
    APIGroup = 'apiGroup';
    APIPublisher = 'TECNOAV';
    APIVersion = 'v1.0';
    ApplicationArea = All;
    Caption = 'BlanketSalesOrderAPI';
    DelayedInsert = true;
    EntityName = 'salesOrder';
    EntitySetName = 'salesOrders';
    PageType = API;
    SourceTable = "Sales Header";
    SourceTableView = WHERE("Document Type" = FILTER("Blanket Order"));

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field(systemId; Rec.SystemId) { Editable = false; }
                field(documentType; Rec."Document Type") { }
                field(no; Rec."No.") { }
                field(sellToCustomerNo; Rec."Sell-to Customer No.") { }
                field(orderDate; Rec."Order Date") { }
                field(postingDate; Rec."Posting Date") { }
                field(externalDocumentNo; Rec."External Document No.") { }
                field("SalespersonCode"; Rec."Salesperson Code") { }
                field("ShortcutDimension1Code"; Rec."Shortcut Dimension 1 Code") { }
                field("ShortcutDimension2Code"; Rec."Shortcut Dimension 2 Code") { }
                field("DueDate"; Rec."Due Date") { }
                field("GenBusPostingGroup"; Rec."Gen. Bus. Posting Group") { }
                field("VATBusPostingGroup"; Rec."VAT Bus. Posting Group") { }
                field("PaymentMethodCode"; Rec."Payment Method Code") { }
                field("PaymentTermsCode"; Rec."Payment Terms Code") { }
                field(taeAnulNoDocumento; Rec."tae_Anul_No. Documento")
                {
                    Caption = 'N° Referencia';
                }
                field("QuoteNo"; Rec."Quote No.")
                {
                    Caption = 'Quote No';
                }

                field("PostingDescription"; Rec."Posting Description")
                {
                    Caption = 'Posting Description';

                    trigger OnValidate()
                    begin
                        // Capturamos el valor del JSON en la variable global
                        TempPostingDescription := Rec."Posting Description";
                    end;
                }
                field("ShpfyOrderNo"; Rec."Shpfy Order No.")
                {
                    Caption = 'Shpfy Order No';
                }
                field(taeAnulTipoDocumento; Rec."tae_Anul_Tipo Documento")
                {
                    Caption = 'Tipo doc. Referencia';
                }

                field(taeAplicaAnexos; Rec.tae_AplicaAnexos)
                {
                    Caption = 'Aplica Anexos';
                }

                field(taeBlanketOrderNo; Rec."tae_Blanket Order No.")
                {
                    Caption = 'No. Pedido abierto';
                }
                field(taeCompEstablecimiento; Rec.tae_Comp_Establecimiento)
                {
                    Caption = 'Establecimiento';
                }
                field(taeCompEstado; Rec.tae_Comp_Estado)
                {
                    Caption = 'State';
                }
                field(taeCompEstadoElectronico; Rec.tae_Comp_EstadoElectronico)
                {
                    Caption = 'tae_Comp_EstadoElectronico';
                }
                field(taeCompPtoEmision; Rec.tae_Comp_PtoEmision)
                {
                    Caption = 'Punto de Emisión';
                }
                field(taeCompSecuencial; Rec.tae_Comp_Secuencial)
                {
                    Caption = 'No. Comprobante';
                }
                field(taeIdAprobador; Rec."tae_Id Aprobador")
                {
                    Caption = 'tae_Id Aprobador';
                }
                field(taeIncoterms; Rec.tae_Incoterms)
                {
                    Caption = 'Incoterms';
                }
                field(taeIsPosting; Rec.tae_IsPosting)
                {
                    Caption = 'Registrando';
                }
                field(taeLegend; Rec.tae_Legend)
                {
                    Caption = 'Leyenda';
                }
                field(taeObservaciones; Rec.tae_Observaciones)
                {
                    Caption = 'Observaciones';
                }
                field(taeSecuencial; Rec.tae_Secuencial)
                {
                    Caption = 'Secuencial';
                }
                field(taeTipoDoc; Rec.tae_TipoDoc)
                {
                    Caption = 'Tipo Doc';
                }
                field(taeTipoIdent; Rec.tae_Tipo_Ident)
                {
                    Caption = 'Tipo de Identificación';
                }
                field(createdOrderNo; CreatedOrderNoVar)
                {
                    Caption = 'Created Order No.';
                    Editable = false;
                }
                field(Status; Rec.Status)
                {
                    Caption = 'Estado del pedido';
                }
            }
            // Part para el Deep Insert de líneas de venta
            part(salesLines; SalesOrderLineAPI)
            {
                Caption = 'Lines';
                EntityName = 'salesLine';
                EntitySetName = 'salesLines';
                SubPageLink = "Document No." = FIELD("No."), "Document Type" = FIELD("Document Type");
            }
        }
    }

    var
        TempPostingDescription: Text[100];
        CreatedOrderNoVar: Code[20];

    trigger OnAfterGetRecord()
    var
        SalesHeaderOrder: Record "Sales Header";
    begin
        // Lógica para encontrar el pedido vinculado
        Clear(CreatedOrderNoVar);
        SalesHeaderOrder.SetRange("Document Type", SalesHeaderOrder."Document Type"::Order);
        SalesHeaderOrder.SetRange("Sell-to Customer No.", Rec."Sell-to Customer No.");

        // Filtramos por el número del Pedido Abierto actual
        // En los Pedidos de Venta normales, el origen se guarda en las líneas, 
        // pero podemos buscar el encabezado que coincida con el cliente y la referencia
        SalesHeaderOrder.SetRange("External Document No.", Rec."External Document No.");

        if SalesHeaderOrder.FindLast() then
            CreatedOrderNoVar := SalesHeaderOrder."No.";
    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        // Insertamos el registro ejecutando los triggers de tabla (donde BC hace su copia del Blanket Order)
        Rec.Insert(true);

        // Si capturamos algo en el JSON, lo forzamos ahora para sobreescribir el valor por defecto
        if TempPostingDescription <> '' then begin
            Rec."Posting Description" := TempPostingDescription;
            Rec.Modify(true);
        end;

        exit(false); // Retornamos false porque ya hicimos el Insert manual
    end;

    // --- FUNCIONES (BOUND ACTIONS) ---

    [ServiceEnabled]
    procedure Release(var ActionContext: WebServiceActionContext)
    var
        ReleaseSalesDoc: Codeunit "Release Sales Document";
    begin
        ReleaseSalesDoc.Run(Rec);
        ActionContext.SetResultCode(WebServiceActionResultCode::Deleted);
    end;

    [ServiceEnabled]
    procedure Post(var ActionContext: WebServiceActionContext)
    var
        SalesPost: Codeunit "Sales-Post";
    begin
        // Configura para Enviar y Facturar por defecto
        Rec.Ship := true;
        Rec.Invoice := true;
        SalesPost.Run(Rec);
        ActionContext.SetResultCode(WebServiceActionResultCode::Deleted);
    end;

    [ServiceEnabled]
    procedure Reopen(var ActionContext: WebServiceActionContext)
    var
        ReleaseSalesDoc: Codeunit "Release Sales Document";
    begin
        ReleaseSalesDoc.Reopen(Rec);
        ActionContext.SetResultCode(WebServiceActionResultCode::Deleted);
    end;
}