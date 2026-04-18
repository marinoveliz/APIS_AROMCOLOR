pageextension 50100 "TEC_BlanketOrderExt" extends "Blanket Sales Order"
{
    actions
    {
        addlast("F&unctions")
        {
            action(TEC_ShowCRMJson)
            {
                ApplicationArea = All;
                Caption = 'Previsualizar JSON CRM';
                Image = XMLFile;
                ToolTip = 'Genera y muestra el JSON que se enviaría al CRM basado en la oportunidad.';

                trigger OnAction()
                var
                    SalesHeader: Record "Sales Header";
                    OpportunityGuid: Guid;
                begin
                    SalesHeader.Get(Rec."Document Type", Rec."No.");
                    if Rec."Posting Description" = '' then
                        Error('El campo "Posting Description" está vacío.');

                    // Validación 2: ¿Tiene formato de GUID (Oportunidad del CRM)?
                    if not Evaluate(OpportunityGuid, Rec."Posting Description") then
                        Error('El campo "Posting Description" (%1) no es una oportunidad válida del CRM.', Rec."Posting Description");

                    // Llamada a la función que armará el JSON (la definiremos en el siguiente paso)
                    Message(GenerateCRMJson(SalesHeader));
                end;
            }
        }
    }
    procedure GetCurrentCompanyId(): Text
    var
        Company: Record Company;
    begin
        // Filtramos la tabla Company por el nombre de la empresa actual
        if Company.Get(CompanyName()) then
            // El campo Id es de tipo GUID, lo convertimos a texto
            // El formato estándar de BC para este campo ya coincide con el que necesitas
            exit(LowerCase(Format(Company.Id).Replace('{', '').Replace('}', '')));

        Error('No se pudo encontrar el identificador de la compañía actual.');
    end;

    local procedure GenerateCRMJson(SalesHeader: Record "Sales Header"): Text
    var
        JObject: JsonObject;
        JLinesArray: JsonArray;
        SalesLine: Record "Sales Line";
        JLine: JsonObject;
    begin
        // Cabecera básica según tu ejemplo
        JObject.Add('documentType', 'Order');
        JObject.Add('sellToCustomerNo', SalesHeader."Sell-to Customer No.");
        JObject.Add('orderDate', SalesHeader."Order Date");
        JObject.Add('postingDate', SalesHeader."Posting Date");
        JObject.Add('externalDocumentNo', SalesHeader."External Document No.");
        JObject.Add('SalespersonCode', SalesHeader."Salesperson Code");
        JObject.Add('ShortcutDimension1Code', SalesHeader."Shortcut Dimension 1 Code");
        JObject.Add('ShortcutDimension2Code', SalesHeader."Shortcut Dimension 2 Code");
        JObject.Add('DueDate', SalesHeader."Due Date");
        // CAMBIO AQUÍ: Usamos la función dinámica en lugar del ID fijo
        JObject.Add('Company', GetCurrentCompanyId());
        JObject.Add('opportunityNumber', SalesHeader."Posting Description");

        // Líneas
        SalesLine.SetRange("Document Type", SalesHeader."Document Type");
        SalesLine.SetRange("Document No.", SalesHeader."No.");
        if SalesLine.FindSet() then
            repeat
                Clear(JLine);
                JLine.Add('type', format(SalesLine.Type));
                JLine.Add('lineNo', format(SalesLine."Line No."));
                JLine.Add('no', SalesLine."No.");
                JLine.Add('quantity', SalesLine.Quantity);
                JLine.Add('UnitofMeasureCode', SalesLine."Unit of Measure Code");
                JLine.Add('locationCode', SalesLine."Location Code");
                JLine.Add('unitPrice', SalesLine."Unit Price");
                JLinesArray.Add(JLine);
            until SalesLine.Next() = 0;

        JObject.Add('salesLines', JLinesArray);

        exit(FormatJson(JObject));
    end;

    local procedure FormatJson(JObj: JsonObject): Text
    var
        Result: Text;
    begin
        JObj.WriteTo(Result);
        exit(Result);
    end;
}