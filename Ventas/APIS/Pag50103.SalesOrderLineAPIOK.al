page 50103 SalesOrderLineAPI
{
    PageType = API;
    APIGroup = 'apiGroup';
    APIPublisher = 'TECNOAV';
    Caption = 'salesLineAPI';
    EntityName = 'salesLine';
    EntitySetName = 'salesLines';
    DelayedInsert = true;
    SourceTable = "Sales Line";

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                // Campos de vinculación necesarios para la lógica de inserción
                field(documentId; Rec.SystemId) { Caption = 'SystemId'; }
                field(documentType; Rec."Document Type") { }
                field(documentNo; Rec."Document No.") { }

                field(lineNo; Rec."Line No.") { }
                field(type; Rec."Type") { }
                field(no; Rec."No.") { }
                field(description; Rec.Description) { }
                field(quantity; Rec.Quantity) { }
                field(unitPrice; Rec."Unit Price") { }
                field(unitOfMeasureCode; Rec."Unit of Measure Code") { }
                field(locationCode; Rec."Location Code") { }
                field(shipmentDate; Rec."Shipment Date") { }
                field(shortcutDimension1Code; Rec."Shortcut Dimension 1 Code") { }
            }
        }
    }

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    var
        SalesHeader: Record "Sales Header";
        SalesLine: Record "Sales Line";
    begin
        // 1. Validar existencia de la cabecera
        if not SalesHeader.Get(Rec."Document Type", Rec."Document No.") then
            Error('La cabecera %1 de tipo %2 no existe o no se ha persistido aún.', Rec."Document No.", Rec."Document Type");

        // 2. Cálculo automático del Line No. si viene en 0
        if Rec."Line No." = 0 then begin
            SalesLine.SetRange("Document Type", Rec."Document Type");
            SalesLine.SetRange("Document No.", Rec."Document No.");
            if SalesLine.FindLast() then
                Rec."Line No." := SalesLine."Line No." + 10000
            else
                Rec."Line No." := 10000;
        end;

        // 3. Heredar dimensiones de la cabecera
        Rec."Dimension Set ID" := SalesHeader."Dimension Set ID";
        Rec."Shortcut Dimension 1 Code" := SalesHeader."Shortcut Dimension 1 Code";
        Rec."Shortcut Dimension 2 Code" := SalesHeader."Shortcut Dimension 2 Code";

        // 4. Lógica original: Asignación para Blanket Orders
        if Rec.Quantity <> 0 then
            Rec.Validate("Qty. to Ship", Rec.Quantity);

        // 5. Inserción manual con triggers de tabla activos
        Rec.Insert(true);

        // Retornamos false para evitar que el framework intente insertar de nuevo
        exit(false);
    end;

    trigger OnModifyRecord(): Boolean
    begin
        // Validamos en caso de que se actualice la cantidad de una línea existente
        if Rec.Quantity <> xRec.Quantity then
            Rec.Validate("Qty. to Ship", Rec.Quantity);

        exit(true);
    end;
}