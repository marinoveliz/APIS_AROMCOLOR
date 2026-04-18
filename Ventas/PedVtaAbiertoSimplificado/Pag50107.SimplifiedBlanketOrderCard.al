
page 50107 "Simplified Blanket Order Card"
{
    PageType = Card;
    SourceTable = "Sales Header";
    SourceTableView = WHERE("Document Type" = CONST("Blanket Order"));
    Caption = 'Ficha Pedido Abierto CRM';
    InsertAllowed = false;// Normalmente se crean vía API, desactivamos inserción manual para control

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'Información General';
                field("No."; Rec."No.") { ApplicationArea = All; Editable = false; }
                field("Sell-to Customer No."; Rec."Sell-to Customer No.") { ApplicationArea = All; Editable = false; }
                field("Order Date"; Rec."Order Date") { ApplicationArea = All; }
                field("Posting Date"; Rec."Posting Date") { ApplicationArea = All; }
                field("External Document No."; Rec."External Document No.") { ApplicationArea = All; Caption = 'Ref. CRM (Ext. Doc)'; }
                field(Status; Rec.Status) { ApplicationArea = All; Editable = false; }
            }

            part(Lines; "Simplified Blanket Order Subp")
            {
                ApplicationArea = All;
                SubPageLink = "Document Type" = FIELD("Document Type"), "Document No." = FIELD("No.");
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(MakeOrder)
            {
                Caption = 'Crear Pedido de Venta';
                Image = MakeOrder;
                ApplicationArea = All;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    BlanketToOrder: Codeunit "Blanket Sales Order to Order";
                    SalesLine: Record "Sales Line";
                begin
                    Rec.TestStatusOpen();

                    // Limpieza de fechas caducadas
                    if Rec."Order Date" < WorkDate() then begin
                        Rec.Validate("Order Date", WorkDate());
                        Rec.Validate("Posting Date", WorkDate());
                        Rec.Modify();
                    end;

                    SalesLine.SetRange("Document Type", Rec."Document Type");
                    SalesLine.SetRange("Document No.", Rec."No.");
                    if SalesLine.FindSet() then
                        repeat
                            if SalesLine."Shipment Date" < WorkDate() then begin
                                SalesLine.Validate("Shipment Date", WorkDate());
                                SalesLine.Modify();
                            end;
                        until SalesLine.Next() = 0;

                    // Ejecución de la conversión
                    if Confirm('¿Desea convertir este Pedido Abierto en un Pedido de Venta normal?', false) then begin
                        BlanketToOrder.Run(Rec);
                        Message('Proceso de conversión finalizado con éxito.');
                    end;
                end;
            }
        }
    }
}