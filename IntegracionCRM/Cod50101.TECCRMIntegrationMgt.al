// // // // codeunit 50101 "TEC_CRMIntegrationMgt"
// // // // {
// // // //     // --- PASO 1: CREACIÓN DEL PEDIDO (Desde Pedido Abierto) ---
// // // //     [EventSubscriber(ObjectType::Codeunit, Codeunit::"Blanket Sales Order to Order", 'OnAfterRun', '', false, false)]
// // // //     local procedure OnAfterRun_BlanketOrderToOrder(var SalesHeader: Record "Sales Header"; var SalesOrderHeader: Record "Sales Header")
// // // //     var
// // // //         OpportunityGuid: Guid;
// // // //         CRMOrderId: Text;
// // // //         JsonPayload: Text;
// // // //     begin
// // // //         // Validamos el GUID de oportunidad en el pedido abierto
// // // //         if SalesHeader."Posting Description" = '' then exit;

// // // //         if not Evaluate(OpportunityGuid, SalesHeader."Posting Description") then exit;

// // // //         // Generamos JSON de creación
// // // //         JsonPayload := GenerateCRMJson(SalesOrderHeader, SalesHeader."Posting Description");

// // // //         // --- PREVISUALIZACIÓN 1: CREACIÓN ---
// // // //         if GuiAllowed then
// // // //             if not Confirm('PASO 1: Se ha generado el JSON de CREACIÓN para el CRM. ¿Desea enviarlo?\ %1', true, JsonPayload) then
// // // //                 exit;

// // // //         // Enviamos a crear al CRM
// // // //         CRMOrderId := SendOrderToCRM(JsonPayload);

// // // //         // Guardamos el ID de respuesta del CRM en BC
// // // //         if CRMOrderId <> '' then begin
// // // //             SalesOrderHeader."External Document No." := CopyStr(CRMOrderId, 1, MaxStrLen(SalesOrderHeader."External Document No."));
// // // //             SalesOrderHeader.Modify(true);

// // // //             // LLAMADA EXPLÍCITA: Para ver el JSON pequeño inmediatamente después de la creación
// // // //             UpdateCRMOrderStatus(CRMOrderId, SalesOrderHeader.Status);
// // // //         end;
// // // //     end;

// // // //     // --- PASO 2: OBSERVADOR DE ESTADOS (Para cambios manuales posteriores) ---
// // // //     [EventSubscriber(ObjectType::Table, Database::"Sales Header", 'OnAfterModifyEvent', '', false, false)]
// // // //     local procedure OnAfterModifySalesHeader_UpdateCRMStatus(var Rec: Record "Sales Header"; var xRec: Record "Sales Header"; RunTrigger: Boolean)
// // // //     begin
// // // //         if Rec.IsTemporary then exit;
// // // //         if Rec."Document Type" <> Rec."Document Type"::Order then exit;
// // // //         if Rec."External Document No." = '' then exit;

// // // //         // Solo dispara si el estado realmente cambia (ej. de Abierto a Lanzado o Convertido)
// // // //         if Rec.Status = xRec.Status then exit;

// // // //         UpdateCRMOrderStatus(Rec."External Document No.", Rec.Status);
// // // //     end;

// // // //     // --- PASO 3: ENVÍO DE ESTADO AL ENDPOINT ---
// // // //     local procedure UpdateCRMOrderStatus(CRMOrderId: Text; BCStatus: Enum "Sales Document Status")
// // // //     var
// // // //         HttpClient: HttpClient;
// // // //         Content: HttpContent;
// // // //         Headers: HttpHeaders;
// // // //         Response: HttpResponseMessage;
// // // //         JObject: JsonObject;
// // // //         PayloadText: Text;
// // // //         StatusUrl: Label 'https://dc7b0224e22ce677a83f5a6dcfe70f.0b.environment.api.powerplatform.com:443/powerautomate/automations/direct/workflows/854115c902c34857bf49ea62cdb0c3ba/triggers/manual/paths/invoke?api-version=1';
// // // //         CRMState: Text;
// // // //     begin
// // // //         // Mapeo de los 5 estados
// // // //         case Format(BCStatus) of
// // // //             'Open', 'Abierto':
// // // //                 CRMState := 'Open';
// // // //             'Released', 'Lanzado':
// // // //                 CRMState := 'Released';
// // // //             'Pending Approval', 'Pendiente aprobación', 'Pendiente aprob.':
// // // //                 CRMState := 'Pending Approval';
// // // //             'Pending Prepayment', 'Pdte. pago anticipado', 'Pendiente prepago':
// // // //                 CRMState := 'Pending Prepayment';
// // // //             'Converted', 'Convertido':
// // // //                 CRMState := 'Converted';
// // // //             else
// // // //                 CRMState := Format(BCStatus);
// // // //         end;

// // // //         JObject.Add('orderId', CRMOrderId);
// // // //         JObject.Add('state', CRMState);
// // // //         JObject.WriteTo(PayloadText);

// // // //         // --- PREVISUALIZACIÓN 2: ESTADO (El JSON pequeñito) ---
// // // //         if GuiAllowed then
// // // //             if not Confirm('PASO 2: Se ha generado el JSON de ACTUALIZACIÓN DE ESTADO para el CRM. ¿Desea enviarlo?\ %1', true, PayloadText) then
// // // //                 exit;

// // // //         Content.WriteFrom(PayloadText);
// // // //         Content.GetHeaders(Headers);
// // // //         if Headers.Contains('Content-Type') then Headers.Remove('Content-Type');
// // // //         Headers.Add('Content-Type', 'application/json');

// // // //         HttpClient.DefaultRequestHeaders.Add('Authorization', 'Bearer ' + GetAccessToken());

// // // //         if HttpClient.Post(StatusUrl, Content, Response) then begin
// // // //             if not Response.IsSuccessStatusCode() then begin
// // // //                 Response.Content.ReadAs(PayloadText);
// // // //                 Error('Error al actualizar el estado. Código: %1. Detalle: %2', Response.HttpStatusCode, PayloadText);
// // // //             end else begin
// // // //                 if GuiAllowed then
// // // //                     Message('El estado %1 fue actualizado exitosamente en el CRM.', CRMState);
// // // //             end;
// // // //         end else
// // // //             Error('No se pudo establecer conexión para actualizar el estado en el CRM.');
// // // //     end;

// // // //     local procedure GetAccessToken(): Text
// // // //     var
// // // //         HttpClient: HttpClient;
// // // //         Content: HttpContent;
// // // //         Headers: HttpHeaders;
// // // //         Response: HttpResponseMessage;
// // // //         ResponseText: Text;
// // // //         JObject: JsonObject;
// // // //         JToken: JsonToken;
// // // //         PostData: Text;
// // // //         TenantId: Label 'd6ce406d-71fe-4379-b0ff-0853f834545a';
// // // //         ClientId: Label '0a6e5481-3726-406e-a128-a8d0ab970057';
// // // //         ClientSecret: Label 'TCI8Q~beIlpsy9j0tkgX7WnFDm6_g5E7YCvrbcVm';
// // // //         Scope: Label 'https://service.flow.microsoft.com//.default';
// // // //     begin
// // // //         PostData := 'grant_type=client_credentials' +
// // // //                     '&client_id=' + ClientId +
// // // //                     '&client_secret=' + ClientSecret +
// // // //                     '&scope=' + Scope;

// // // //         Content.WriteFrom(PostData);
// // // //         Content.GetHeaders(Headers);
// // // //         Headers.Remove('Content-Type');
// // // //         Headers.Add('Content-Type', 'application/x-www-form-urlencoded');

// // // //         if HttpClient.Post('https://login.microsoftonline.com/' + TenantId + '/oauth2/v2.0/token', Content, Response) then begin
// // // //             Response.Content.ReadAs(ResponseText);
// // // //             if Response.IsSuccessStatusCode() then begin
// // // //                 if JObject.ReadFrom(ResponseText) then
// // // //                     if JObject.Get('access_token', JToken) then
// // // //                         exit(JToken.AsValue().AsText());
// // // //             end;
// // // //         end;
// // // //         exit('');
// // // //     end;

// // // //     local procedure SendOrderToCRM(JsonPayload: Text): Text
// // // //     var
// // // //         HttpClient: HttpClient;
// // // //         Content: HttpContent;
// // // //         Headers: HttpHeaders;
// // // //         Response: HttpResponseMessage;
// // // //         CRMUrl: Label 'https://dc7b0224e22ce677a83f5a6dcfe70f.0b.environment.api.powerplatform.com:443/powerautomate/automations/direct/workflows/7567894f5d7f4fb5b3ad6c9e532b63ec/triggers/manual/paths/invoke?api-version=1';
// // // //         AccessToken: Text;
// // // //         ResponseText: Text;
// // // //         JObject: JsonObject;
// // // //         JToken: JsonToken;
// // // //     begin
// // // //         AccessToken := GetAccessToken();
// // // //         Content.WriteFrom(JsonPayload);
// // // //         Content.GetHeaders(Headers);
// // // //         if Headers.Contains('Content-Type') then Headers.Remove('Content-Type');
// // // //         Headers.Add('Content-Type', 'application/json');

// // // //         if AccessToken <> '' then
// // // //             HttpClient.DefaultRequestHeaders.Add('Authorization', 'Bearer ' + AccessToken);

// // // //         if HttpClient.Post(CRMUrl, Content, Response) then begin
// // // //             Response.Content.ReadAs(ResponseText);
// // // //             if Response.IsSuccessStatusCode() then begin
// // // //                 if JObject.ReadFrom(ResponseText) then
// // // //                     if JObject.Get('dynamicsOrderId', JToken) then
// // // //                         exit(JToken.AsValue().AsText());
// // // //             end else
// // // //                 Error('Error en el envío al CRM. Detalle: %1', ResponseText);
// // // //         end;
// // // //         exit('');
// // // //     end;

// // // //     local procedure GenerateCRMJson(SalesHeader: Record "Sales Header"; OpportunityNo: Text): Text
// // // //     var
// // // //         JObject: JsonObject;
// // // //         JLinesArray: JsonArray;
// // // //         SalesLine: Record "Sales Line";
// // // //         JLine: JsonObject;
// // // //     begin
// // // //         JObject.Add('documentType', 'Order');
// // // //         JObject.Add('sellToCustomerNo', SalesHeader."Sell-to Customer No.");
// // // //         JObject.Add('orderDate', SalesHeader."Order Date");
// // // //         JObject.Add('postingDate', SalesHeader."Posting Date");
// // // //         JObject.Add('externalDocumentNo', SalesHeader."No.");
// // // //         JObject.Add('SalespersonCode', SalesHeader."Salesperson Code");
// // // //         JObject.Add('ShortcutDimension1Code', SalesHeader."Shortcut Dimension 1 Code");
// // // //         JObject.Add('ShortcutDimension2Code', SalesHeader."Shortcut Dimension 2 Code");
// // // //         JObject.Add('DueDate', SalesHeader."Due Date");
// // // //         JObject.Add('Company', GetCurrentCompanyId());
// // // //         JObject.Add('opportunityNumber', OpportunityNo);
// // // //         JObject.Add('PaymentTermsCode', SalesHeader."Payment Terms Code");

// // // //         SalesLine.SetRange("Document Type", SalesHeader."Document Type");
// // // //         SalesLine.SetRange("Document No.", SalesHeader."No.");
// // // //         if SalesLine.FindSet() then
// // // //             repeat
// // // //                 Clear(JLine);
// // // //                 case SalesLine.Type of
// // // //                     SalesLine.Type::Item:
// // // //                         JLine.Add('type', 'Item');
// // // //                     else
// // // //                         JLine.Add('type', format(SalesLine.Type, 0, 0));
// // // //                 end;
// // // //                 JLine.Add('lineNo', format(SalesLine."Line No."));
// // // //                 JLine.Add('no', SalesLine."No.");
// // // //                 JLine.Add('quantity', SalesLine.Quantity);
// // // //                 JLine.Add('UnitofMeasureCode', SalesLine."Unit of Measure Code");
// // // //                 JLine.Add('locationCode', SalesLine."Location Code");
// // // //                 JLine.Add('unitPrice', SalesLine."Unit Price");
// // // //                 JLinesArray.Add(JLine);
// // // //             until SalesLine.Next() = 0;

// // // //         JObject.Add('salesLines', JLinesArray);
// // // //         exit(FormatJson(JObject));
// // // //     end;

// // // //     local procedure GetCurrentCompanyId(): Text
// // // //     var
// // // //         Company: Record Company;
// // // //     begin
// // // //         if Company.Get(CompanyName()) then
// // // //             exit(LowerCase(Format(Company.Id).Replace('{', '').Replace('}', '')));
// // // //         exit('');
// // // //     end;

// // // //     local procedure FormatJson(JObj: JsonObject): Text
// // // //     var
// // // //         Result: Text;
// // // //     begin
// // // //         JObj.WriteTo(Result);
// // // //         exit(Result);
// // // //     end;
// // // // }

// // // codeunit 50101 "TEC_CRMIntegrationMgt"
// // // {
// // //     // --- PASO 1: CREACIÓN DEL PEDIDO (Desde Pedido Abierto) ---
// // //     [EventSubscriber(ObjectType::Codeunit, Codeunit::"Blanket Sales Order to Order", 'OnAfterRun', '', false, false)]
// // //     local procedure OnAfterRun_BlanketOrderToOrder(var SalesHeader: Record "Sales Header"; var SalesOrderHeader: Record "Sales Header")
// // //     var
// // //         OpportunityGuid: Guid;
// // //         CRMOrderIdText: Text;
// // //         CRMOrderGuid: Guid;
// // //         JsonPayload: Text;
// // //     begin
// // //         if SalesHeader."Posting Description" = '' then exit;
// // //         if not Evaluate(OpportunityGuid, SalesHeader."Posting Description") then exit;

// // //         JsonPayload := GenerateCRMJson(SalesOrderHeader, SalesHeader."Posting Description");

// // //         if GuiAllowed then
// // //             if not Confirm('PASO 1: Se ha generado el JSON de CREACIÓN para el CRM. ¿Desea enviarlo?\ %1', true, JsonPayload) then
// // //                 exit;

// // //         // Enviamos a crear al CRM
// // //         CRMOrderIdText := SendOrderToCRM(JsonPayload);

// // //         // Guardamos el ID del CRM en nuestro campo personalizado
// // //         if CRMOrderIdText <> '' then begin
// // //             if Evaluate(CRMOrderGuid, CRMOrderIdText) then begin
// // //                 SalesOrderHeader."TEC_CRMOrderId" := CRMOrderGuid;
// // //                 SalesOrderHeader.Modify(true);

// // //                 // Llamada inicial para el estado "Abierto"
// // //                 UpdateCRMOrderStatus(SalesOrderHeader."TEC_CRMOrderId", 'Abierto');
// // //             end;
// // //         end;
// // //     end;

// // //     // --- PASO 2: OBSERVADOR DE ESTADOS (Pedidos Abiertos y Lanzados) ---
// // //     [EventSubscriber(ObjectType::Table, Database::"Sales Header", 'OnAfterModifyEvent', '', false, false)]
// // //     local procedure OnAfterModifySalesHeader_UpdateCRMStatus(var Rec: Record "Sales Header"; var xRec: Record "Sales Header"; RunTrigger: Boolean)
// // //     begin
// // //         if Rec.IsTemporary then exit;
// // //         if Rec."Document Type" <> Rec."Document Type"::Order then exit;
// // //         if IsNullGuid(Rec."TEC_CRMOrderId") then exit;

// // //         // Solo dispara si el estado cambia (Abierto <-> Lanzado)
// // //         if Rec.Status = xRec.Status then exit;

// // //         if Rec.Status = Rec.Status::Open then
// // //             UpdateCRMOrderStatus(Rec."TEC_CRMOrderId", 'Abierto')
// // //         else if Rec.Status = Rec.Status::Released then
// // //             UpdateCRMOrderStatus(Rec."TEC_CRMOrderId", 'Lanzado');
// // //     end;

// // //     // --- PASO 3: OBSERVADOR DE ARCHIVO (Entregado y Facturado) ---
// // //     [EventSubscriber(ObjectType::Table, Database::"Sales Header Archive", 'OnAfterInsertEvent', '', false, false)]
// // //     local procedure OnAfterInsertSalesHeaderArchive(var Rec: Record "Sales Header Archive"; RunTrigger: Boolean)
// // //     begin
// // //         // Solo actuamos si es un Pedido y tiene nuestro GUID del CRM
// // //         if Rec."Document Type" <> Rec."Document Type"::Order then exit;
// // //         if IsNullGuid(Rec."TEC_CRMOrderId") then exit;

// // //         // Evaluamos las banderas de registro del usuario
// // //         if Rec.Invoice then
// // //             UpdateCRMOrderStatus(Rec."TEC_CRMOrderId", 'Facturado')
// // //         else if Rec.Ship then
// // //             UpdateCRMOrderStatus(Rec."TEC_CRMOrderId", 'Entregado');
// // //     end;

// // //     // --- PROCEDIMIENTO DE ACTUALIZACIÓN AL ENDPOINT ---
// // //     local procedure UpdateCRMOrderStatus(CRMOrderId: Guid; EstadoAEnviar: Text)
// // //     var
// // //         HttpClient: HttpClient;
// // //         Content: HttpContent;
// // //         Headers: HttpHeaders;
// // //         Response: HttpResponseMessage;
// // //         JObject: JsonObject;
// // //         PayloadText: Text;
// // //         StatusUrl: Label 'https://dc7b0224e22ce677a83f5a6dcfe70f.0b.environment.api.powerplatform.com:443/powerautomate/automations/direct/workflows/854115c902c34857bf49ea62cdb0c3ba/triggers/manual/paths/invoke?api-version=1';
// // //     begin
// // //         // Formateamos el Guid sin las llaves {} para el JSON
// // //         JObject.Add('orderId', Format(CRMOrderId, 0, 4));
// // //         JObject.Add('state', EstadoAEnviar);
// // //         JObject.WriteTo(PayloadText);

// // //         if GuiAllowed then
// // //             if not Confirm('Se enviará el estado "%1" al CRM. ¿Desea enviarlo?\ %2', true, EstadoAEnviar, PayloadText) then
// // //                 exit;

// // //         Content.WriteFrom(PayloadText);
// // //         Content.GetHeaders(Headers);
// // //         if Headers.Contains('Content-Type') then Headers.Remove('Content-Type');
// // //         Headers.Add('Content-Type', 'application/json');

// // //         HttpClient.DefaultRequestHeaders.Add('Authorization', 'Bearer ' + GetAccessToken());

// // //         if HttpClient.Post(StatusUrl, Content, Response) then begin
// // //             if not Response.IsSuccessStatusCode() then begin
// // //                 Response.Content.ReadAs(PayloadText);
// // //                 Error('Error al actualizar el estado. Código: %1. Detalle: %2', Response.HttpStatusCode, PayloadText);
// // //             end else begin
// // //                 if GuiAllowed then
// // //                     Message('El estado %1 fue actualizado exitosamente en el CRM.', EstadoAEnviar);
// // //             end;
// // //         end else
// // //             Error('No se pudo establecer conexión para actualizar el estado en el CRM.');
// // //     end;

// // //     // --- FUNCIONES AUXILIARES (Sin Cambios) ---

// // //     local procedure GetAccessToken(): Text
// // //     var
// // //         HttpClient: HttpClient;
// // //         Content: HttpContent;
// // //         Headers: HttpHeaders;
// // //         Response: HttpResponseMessage;
// // //         ResponseText: Text;
// // //         JObject: JsonObject;
// // //         JToken: JsonToken;
// // //         PostData: Text;
// // //         TenantId: Label 'd6ce406d-71fe-4379-b0ff-0853f834545a';
// // //         ClientId: Label '0a6e5481-3726-406e-a128-a8d0ab970057';
// // //         ClientSecret: Label 'TCI8Q~beIlpsy9j0tkgX7WnFDm6_g5E7YCvrbcVm';
// // //         Scope: Label 'https://service.flow.microsoft.com//.default';
// // //     begin
// // //         PostData := 'grant_type=client_credentials' +
// // //                     '&client_id=' + ClientId +
// // //                     '&client_secret=' + ClientSecret +
// // //                     '&scope=' + Scope;

// // //         Content.WriteFrom(PostData);
// // //         Content.GetHeaders(Headers);
// // //         Headers.Remove('Content-Type');
// // //         Headers.Add('Content-Type', 'application/x-www-form-urlencoded');

// // //         if HttpClient.Post('https://login.microsoftonline.com/' + TenantId + '/oauth2/v2.0/token', Content, Response) then begin
// // //             Response.Content.ReadAs(ResponseText);
// // //             if Response.IsSuccessStatusCode() then begin
// // //                 if JObject.ReadFrom(ResponseText) then
// // //                     if JObject.Get('access_token', JToken) then
// // //                         exit(JToken.AsValue().AsText());
// // //             end;
// // //         end;
// // //         exit('');
// // //     end;

// // //     local procedure SendOrderToCRM(JsonPayload: Text): Text
// // //     var
// // //         HttpClient: HttpClient;
// // //         Content: HttpContent;
// // //         Headers: HttpHeaders;
// // //         Response: HttpResponseMessage;
// // //         CRMUrl: Label 'https://dc7b0224e22ce677a83f5a6dcfe70f.0b.environment.api.powerplatform.com:443/powerautomate/automations/direct/workflows/7567894f5d7f4fb5b3ad6c9e532b63ec/triggers/manual/paths/invoke?api-version=1';
// // //         AccessToken: Text;
// // //         ResponseText: Text;
// // //         JObject: JsonObject;
// // //         JToken: JsonToken;
// // //     begin
// // //         AccessToken := GetAccessToken();
// // //         Content.WriteFrom(JsonPayload);
// // //         Content.GetHeaders(Headers);
// // //         if Headers.Contains('Content-Type') then Headers.Remove('Content-Type');
// // //         Headers.Add('Content-Type', 'application/json');

// // //         if AccessToken <> '' then
// // //             HttpClient.DefaultRequestHeaders.Add('Authorization', 'Bearer ' + AccessToken);

// // //         if HttpClient.Post(CRMUrl, Content, Response) then begin
// // //             Response.Content.ReadAs(ResponseText);
// // //             if Response.IsSuccessStatusCode() then begin
// // //                 if JObject.ReadFrom(ResponseText) then
// // //                     if JObject.Get('dynamicsOrderId', JToken) then
// // //                         exit(JToken.AsValue().AsText());
// // //             end else
// // //                 Error('Error en el envío al CRM. Detalle: %1', ResponseText);
// // //         end;
// // //         exit('');
// // //     end;

// // //     local procedure GenerateCRMJson(SalesHeader: Record "Sales Header"; OpportunityNo: Text): Text
// // //     var
// // //         JObject: JsonObject;
// // //         JLinesArray: JsonArray;
// // //         SalesLine: Record "Sales Line";
// // //         JLine: JsonObject;
// // //     begin
// // //         JObject.Add('documentType', 'Order');
// // //         JObject.Add('sellToCustomerNo', SalesHeader."Sell-to Customer No.");
// // //         JObject.Add('orderDate', SalesHeader."Order Date");
// // //         JObject.Add('postingDate', SalesHeader."Posting Date");
// // //         JObject.Add('externalDocumentNo', SalesHeader."No.");
// // //         JObject.Add('SalespersonCode', SalesHeader."Salesperson Code");
// // //         JObject.Add('ShortcutDimension1Code', SalesHeader."Shortcut Dimension 1 Code");
// // //         JObject.Add('ShortcutDimension2Code', SalesHeader."Shortcut Dimension 2 Code");
// // //         JObject.Add('DueDate', SalesHeader."Due Date");
// // //         JObject.Add('Company', GetCurrentCompanyId());
// // //         JObject.Add('opportunityNumber', OpportunityNo);
// // //         JObject.Add('PaymentTermsCode', SalesHeader."Payment Terms Code");

// // //         SalesLine.SetRange("Document Type", SalesHeader."Document Type");
// // //         SalesLine.SetRange("Document No.", SalesHeader."No.");
// // //         if SalesLine.FindSet() then
// // //             repeat
// // //                 Clear(JLine);
// // //                 case SalesLine.Type of
// // //                     SalesLine.Type::Item:
// // //                         JLine.Add('type', 'Item');
// // //                     else
// // //                         JLine.Add('type', format(SalesLine.Type, 0, 0));
// // //                 end;
// // //                 JLine.Add('lineNo', format(SalesLine."Line No."));
// // //                 JLine.Add('no', SalesLine."No.");
// // //                 JLine.Add('quantity', SalesLine.Quantity);
// // //                 JLine.Add('UnitofMeasureCode', SalesLine."Unit of Measure Code");
// // //                 JLine.Add('locationCode', SalesLine."Location Code");
// // //                 JLine.Add('unitPrice', SalesLine."Unit Price");
// // //                 JLinesArray.Add(JLine);
// // //             until SalesLine.Next() = 0;

// // //         JObject.Add('salesLines', JLinesArray);
// // //         exit(FormatJson(JObject));
// // //     end;

// // //     local procedure GetCurrentCompanyId(): Text
// // //     var
// // //         Company: Record Company;
// // //     begin
// // //         if Company.Get(CompanyName()) then
// // //             exit(LowerCase(Format(Company.Id).Replace('{', '').Replace('}', '')));
// // //         exit('');
// // //     end;

// // //     local procedure FormatJson(JObj: JsonObject): Text
// // //     var
// // //         Result: Text;
// // //     begin
// // //         JObj.WriteTo(Result);
// // //         exit(Result);
// // //     end;
// // // }
// // codeunit 50101 "TEC_CRMIntegrationMgt"
// // {
// //     // =========================================================================
// //     // PASO 1: CREACIÓN DEL PEDIDO (Desde Pedido Abierto)
// //     // =========================================================================
// //     [EventSubscriber(ObjectType::Codeunit, Codeunit::"Blanket Sales Order to Order", 'OnAfterRun', '', false, false)]
// //     local procedure OnAfterRun_BlanketOrderToOrder(var SalesHeader: Record "Sales Header"; var SalesOrderHeader: Record "Sales Header")
// //     var
// //         OpportunityGuid: Guid;
// //         CRMOrderIdText: Text;
// //         CRMOrderGuid: Guid;
// //         JsonPayload: Text;
// //     begin
// //         if SalesHeader."Posting Description" = '' then exit;
// //         if not Evaluate(OpportunityGuid, SalesHeader."Posting Description") then exit;

// //         JsonPayload := GenerateCRMJson(SalesOrderHeader, SalesHeader."Posting Description");

// //         if GuiAllowed then
// //             if not Confirm('PASO 1: Se ha generado el JSON de CREACIÓN para el CRM. ¿Desea enviarlo?\ %1', true, JsonPayload) then
// //                 exit;

// //         // Enviamos a crear al CRM
// //         CRMOrderIdText := SendOrderToCRM(JsonPayload);

// //         // Guardamos el ID del CRM en nuestro campo personalizado
// //         if CRMOrderIdText <> '' then begin
// //             if Evaluate(CRMOrderGuid, CRMOrderIdText) then begin
// //                 SalesOrderHeader."TEC_CRMOrderId" := CRMOrderGuid;
// //                 SalesOrderHeader.Modify(true);

// //                 // Llamada inicial para el estado "Abierto"
// //                 UpdateCRMOrderStatus(SalesOrderHeader."TEC_CRMOrderId", 'Abierto');
// //             end;
// //         end;
// //     end;

// //     // =========================================================================
// //     // PASO 2: EVENTOS DE ESTADO (Lanzar y Reabrir)
// //     // Escuchamos a la Codeunit 414 que controla el botón "Lanzar"
// //     // =========================================================================

// //     // Cuando el usuario presiona "Lanzar"
// //     [EventSubscriber(ObjectType::Codeunit, Codeunit::"Release Sales Document", 'OnAfterReleaseSalesDoc', '', false, false)]
// //     local procedure OnAfterReleaseSalesDoc(var SalesHeader: Record "Sales Header"; PreviewMode: Boolean; var LinesWereModified: Boolean)
// //     begin
// //         if PreviewMode then exit; // Evita dispararse si el usuario solo está "previsualizando"
// //         if SalesHeader."Document Type" <> SalesHeader."Document Type"::Order then exit;
// //         if IsNullGuid(SalesHeader."TEC_CRMOrderId") then exit;

// //         UpdateCRMOrderStatus(SalesHeader."TEC_CRMOrderId", 'Lanzado');
// //     end;

// //     // Cuando el usuario presiona "Reabrir" (Por si se equivocó y necesita corregir algo)
// //     [EventSubscriber(ObjectType::Codeunit, Codeunit::"Release Sales Document", 'OnAfterReopenSalesDoc', '', false, false)]
// //     local procedure OnAfterReopenSalesDoc(var SalesHeader: Record "Sales Header"; PreviewMode: Boolean)
// //     begin
// //         if PreviewMode then exit;
// //         if SalesHeader."Document Type" <> SalesHeader."Document Type"::Order then exit;
// //         if IsNullGuid(SalesHeader."TEC_CRMOrderId") then exit;

// //         UpdateCRMOrderStatus(SalesHeader."TEC_CRMOrderId", 'Abierto');
// //     end;

// //     // =========================================================================
// //     // PASO 3: EVENTO DE REGISTRO (Entregado / Facturado)
// //     // Escuchamos a la Codeunit 80 que hace el registro real
// //     // =========================================================================
// //     [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", 'OnAfterPostSalesDoc', '', false, false)]
// //     local procedure OnAfterPostSalesDoc(var SalesHeader: Record "Sales Header"; var GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line"; SalesShptHdrNo: Code[20]; RetRcpHdrNo: Code[20]; SalesInvHdrNo: Code[20]; SalesCrMemoHdrNo: Code[20]; CommitIsSuppressed: Boolean; InvtPickPutaway: Boolean; var CustLedgerEntry: Record "Cust. Ledger Entry")
// //     begin
// //         if SalesHeader."Document Type" <> SalesHeader."Document Type"::Order then exit;
// //         if IsNullGuid(SalesHeader."TEC_CRMOrderId") then exit;

// //         // Si BC generó un número de Factura de Venta Registrada, enviamos "Facturado"
// //         if SalesInvHdrNo <> '' then begin
// //             UpdateCRMOrderStatus(SalesHeader."TEC_CRMOrderId", 'Facturado');
// //         end
// //         // Si no hay factura, pero generó un Envío de Venta, enviamos "Entregado"
// //         else if SalesShptHdrNo <> '' then begin
// //             UpdateCRMOrderStatus(SalesHeader."TEC_CRMOrderId", 'Entregado');
// //         end;
// //     end;

// //     // =========================================================================
// //     // PROCEDIMIENTOS DE COMUNICACIÓN AL ENDPOINT Y JSON
// //     // =========================================================================
// //     local procedure UpdateCRMOrderStatus(CRMOrderId: Guid; EstadoAEnviar: Text)
// //     var
// //         HttpClient: HttpClient;
// //         Content: HttpContent;
// //         Headers: HttpHeaders;
// //         Response: HttpResponseMessage;
// //         JObject: JsonObject;
// //         PayloadText: Text;
// //         StatusUrl: Label 'https://dc7b0224e22ce677a83f5a6dcfe70f.0b.environment.api.powerplatform.com:443/powerautomate/automations/direct/workflows/854115c902c34857bf49ea62cdb0c3ba/triggers/manual/paths/invoke?api-version=1';
// //     begin
// //         // Format con (0,4) saca el Guid limpio sin llaves para que el JSON lo acepte bien
// //         JObject.Add('orderId', Format(CRMOrderId, 0, 4));
// //         JObject.Add('state', EstadoAEnviar);
// //         JObject.WriteTo(PayloadText);

// //         if GuiAllowed then
// //             if not Confirm('Se enviará el estado "%1" al CRM. ¿Desea enviarlo?\ %2', true, EstadoAEnviar, PayloadText) then
// //                 exit;

// //         Content.WriteFrom(PayloadText);
// //         Content.GetHeaders(Headers);
// //         if Headers.Contains('Content-Type') then Headers.Remove('Content-Type');
// //         Headers.Add('Content-Type', 'application/json');

// //         HttpClient.DefaultRequestHeaders.Add('Authorization', 'Bearer ' + GetAccessToken());

// //         if HttpClient.Post(StatusUrl, Content, Response) then begin
// //             if not Response.IsSuccessStatusCode() then begin
// //                 Response.Content.ReadAs(PayloadText);
// //                 Error('Error al actualizar el estado. Código: %1. Detalle: %2', Response.HttpStatusCode, PayloadText);
// //             end else begin
// //                 if GuiAllowed then
// //                     Message('El estado %1 fue actualizado exitosamente en el CRM.', EstadoAEnviar);
// //             end;
// //         end else
// //             Error('No se pudo establecer conexión para actualizar el estado en el CRM.');
// //     end;

// //     local procedure GetAccessToken(): Text
// //     var
// //         HttpClient: HttpClient;
// //         Content: HttpContent;
// //         Headers: HttpHeaders;
// //         Response: HttpResponseMessage;
// //         ResponseText: Text;
// //         JObject: JsonObject;
// //         JToken: JsonToken;
// //         PostData: Text;
// //         TenantId: Label 'd6ce406d-71fe-4379-b0ff-0853f834545a';
// //         ClientId: Label '0a6e5481-3726-406e-a128-a8d0ab970057';
// //         ClientSecret: Label 'TCI8Q~beIlpsy9j0tkgX7WnFDm6_g5E7YCvrbcVm';
// //         Scope: Label 'https://service.flow.microsoft.com//.default';
// //     begin
// //         PostData := 'grant_type=client_credentials' +
// //                     '&client_id=' + ClientId +
// //                     '&client_secret=' + ClientSecret +
// //                     '&scope=' + Scope;

// //         Content.WriteFrom(PostData);
// //         Content.GetHeaders(Headers);
// //         Headers.Remove('Content-Type');
// //         Headers.Add('Content-Type', 'application/x-www-form-urlencoded');

// //         if HttpClient.Post('https://login.microsoftonline.com/' + TenantId + '/oauth2/v2.0/token', Content, Response) then begin
// //             Response.Content.ReadAs(ResponseText);
// //             if Response.IsSuccessStatusCode() then begin
// //                 if JObject.ReadFrom(ResponseText) then
// //                     if JObject.Get('access_token', JToken) then
// //                         exit(JToken.AsValue().AsText());
// //             end;
// //         end;
// //         exit('');
// //     end;

// //     local procedure SendOrderToCRM(JsonPayload: Text): Text
// //     var
// //         HttpClient: HttpClient;
// //         Content: HttpContent;
// //         Headers: HttpHeaders;
// //         Response: HttpResponseMessage;
// //         CRMUrl: Label 'https://dc7b0224e22ce677a83f5a6dcfe70f.0b.environment.api.powerplatform.com:443/powerautomate/automations/direct/workflows/7567894f5d7f4fb5b3ad6c9e532b63ec/triggers/manual/paths/invoke?api-version=1';
// //         AccessToken: Text;
// //         ResponseText: Text;
// //         JObject: JsonObject;
// //         JToken: JsonToken;
// //     begin
// //         AccessToken := GetAccessToken();
// //         Content.WriteFrom(JsonPayload);
// //         Content.GetHeaders(Headers);
// //         if Headers.Contains('Content-Type') then Headers.Remove('Content-Type');
// //         Headers.Add('Content-Type', 'application/json');

// //         if AccessToken <> '' then
// //             HttpClient.DefaultRequestHeaders.Add('Authorization', 'Bearer ' + AccessToken);

// //         if HttpClient.Post(CRMUrl, Content, Response) then begin
// //             Response.Content.ReadAs(ResponseText);
// //             if Response.IsSuccessStatusCode() then begin
// //                 if JObject.ReadFrom(ResponseText) then
// //                     if JObject.Get('dynamicsOrderId', JToken) then
// //                         exit(JToken.AsValue().AsText());
// //             end else
// //                 Error('Error en el envío al CRM. Detalle: %1', ResponseText);
// //         end;
// //         exit('');
// //     end;

// //     local procedure GenerateCRMJson(SalesHeader: Record "Sales Header"; OpportunityNo: Text): Text
// //     var
// //         JObject: JsonObject;
// //         JLinesArray: JsonArray;
// //         SalesLine: Record "Sales Line";
// //         JLine: JsonObject;
// //     begin
// //         JObject.Add('documentType', 'Order');
// //         JObject.Add('sellToCustomerNo', SalesHeader."Sell-to Customer No.");
// //         JObject.Add('orderDate', SalesHeader."Order Date");
// //         JObject.Add('postingDate', SalesHeader."Posting Date");
// //         JObject.Add('externalDocumentNo', SalesHeader."No.");
// //         JObject.Add('SalespersonCode', SalesHeader."Salesperson Code");
// //         JObject.Add('ShortcutDimension1Code', SalesHeader."Shortcut Dimension 1 Code");
// //         JObject.Add('ShortcutDimension2Code', SalesHeader."Shortcut Dimension 2 Code");
// //         JObject.Add('DueDate', SalesHeader."Due Date");
// //         JObject.Add('Company', GetCurrentCompanyId());
// //         JObject.Add('opportunityNumber', OpportunityNo);
// //         JObject.Add('PaymentTermsCode', SalesHeader."Payment Terms Code");

// //         SalesLine.SetRange("Document Type", SalesHeader."Document Type");
// //         SalesLine.SetRange("Document No.", SalesHeader."No.");
// //         if SalesLine.FindSet() then
// //             repeat
// //                 Clear(JLine);
// //                 case SalesLine.Type of
// //                     SalesLine.Type::Item:
// //                         JLine.Add('type', 'Item');
// //                     else
// //                         JLine.Add('type', format(SalesLine.Type, 0, 0));
// //                 end;
// //                 JLine.Add('lineNo', format(SalesLine."Line No."));
// //                 JLine.Add('no', SalesLine."No.");
// //                 JLine.Add('quantity', SalesLine.Quantity);
// //                 JLine.Add('UnitofMeasureCode', SalesLine."Unit of Measure Code");
// //                 JLine.Add('locationCode', SalesLine."Location Code");
// //                 JLine.Add('unitPrice', SalesLine."Unit Price");
// //                 JLinesArray.Add(JLine);
// //             until SalesLine.Next() = 0;

// //         JObject.Add('salesLines', JLinesArray);
// //         exit(FormatJson(JObject));
// //     end;

// //     local procedure GetCurrentCompanyId(): Text
// //     var
// //         Company: Record Company;
// //     begin
// //         if Company.Get(CompanyName()) then
// //             exit(LowerCase(Format(Company.Id).Replace('{', '').Replace('}', '')));
// //         exit('');
// //     end;

// //     local procedure FormatJson(JObj: JsonObject): Text
// //     var
// //         Result: Text;
// //     begin
// //         JObj.WriteTo(Result);
// //         exit(Result);
// //     end;
// // }
// codeunit 50101 "TEC_CRMIntegrationMgt"
// {
//     // =========================================================================
//     // PASO 1: CREACIÓN Y GUARDADO DEL GUID CORRECTAMENTE
//     // =========================================================================
//     [EventSubscriber(ObjectType::Codeunit, Codeunit::"Blanket Sales Order to Order", 'OnAfterRun', '', false, false)]
//     local procedure OnAfterRun_BlanketOrderToOrder(var SalesHeader: Record "Sales Header"; var SalesOrderHeader: Record "Sales Header")
//     var
//         OpportunityGuid: Guid;
//         CRMOrderIdText: Text;
//         CRMOrderGuid: Guid;
//         JsonPayload: Text;
//     begin
//         if SalesHeader."Posting Description" = '' then exit;
//         if not Evaluate(OpportunityGuid, SalesHeader."Posting Description") then exit;

//         JsonPayload := GenerateCRMJson(SalesOrderHeader, SalesHeader."Posting Description");

//         if GuiAllowed then
//             if not Confirm('PASO 1: Se ha generado el JSON de CREACIÓN para el CRM. ¿Desea enviarlo?\ %1', true, JsonPayload) then
//                 exit;

//         CRMOrderIdText := SendOrderToCRM(JsonPayload);

//         if CRMOrderIdText <> '' then begin
//             // TRUCO: Asegurarnos de que el texto tenga llaves para que BC lo acepte como GUID
//             if not CRMOrderIdText.StartsWith('{') then
//                 CRMOrderIdText := '{' + CRMOrderIdText + '}';

//             // Convertimos y guardamos
//             if Evaluate(CRMOrderGuid, CRMOrderIdText) then begin
//                 SalesOrderHeader."TEC_CRMOrderId" := CRMOrderGuid;
//                 SalesOrderHeader.Modify(true);

//                 Commit(); // Forzamos el guardado en BD antes de hacer el envío HTTP
//                 UpdateCRMOrderStatus(SalesOrderHeader."TEC_CRMOrderId", 'Abierto');
//             end else
//                 Message('Aviso: El CRM devolvió un ID, pero BC no pudo convertirlo a formato GUID: %1', CRMOrderIdText);
//         end;
//     end;

//     // =========================================================================
//     // PASO 2: OBSERVADOR DE ESTADO (Abierto / Lanzado)
//     // =========================================================================
//     [EventSubscriber(ObjectType::Table, Database::"Sales Header", 'OnAfterModifyEvent', '', false, false)]
//     local procedure OnAfterModifySalesHeader_UpdateCRMStatus(var Rec: Record "Sales Header"; var xRec: Record "Sales Header"; RunTrigger: Boolean)
//     begin
//         if Rec.IsTemporary then exit;
//         if Rec."Document Type" <> Rec."Document Type"::Order then exit;
//         if IsNullGuid(Rec."TEC_CRMOrderId") then exit;

//         if Rec.Status = xRec.Status then exit;

//         Commit(); // Liberamos la transacción de BD

//         if Rec.Status = Rec.Status::Released then
//             UpdateCRMOrderStatus(Rec."TEC_CRMOrderId", 'Lanzado')
//         else if Rec.Status = Rec.Status::Open then
//             UpdateCRMOrderStatus(Rec."TEC_CRMOrderId", 'Abierto');
//     end;

//     // =========================================================================
//     // PASO 3: OBSERVADOR DE REGISTRO (Entregado / Facturado)
//     // Cortamos los parámetros finales para evitar errores de versión
//     // =========================================================================
//     [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", 'OnAfterPostSalesDoc', '', false, false)]
//     local procedure OnAfterPostSalesDoc(var SalesHeader: Record "Sales Header"; var GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line"; SalesShptHdrNo: Code[20]; RetRcpHdrNo: Code[20]; SalesInvHdrNo: Code[20]; SalesCrMemoHdrNo: Code[20])
//     begin
//         if SalesHeader."Document Type" <> SalesHeader."Document Type"::Order then exit;
//         if IsNullGuid(SalesHeader."TEC_CRMOrderId") then exit;

//         Commit(); // Liberamos la transacción de BD

//         // Evaluamos qué documento se generó realmente
//         if SalesInvHdrNo <> '' then
//             UpdateCRMOrderStatus(SalesHeader."TEC_CRMOrderId", 'Facturado')
//         else if SalesShptHdrNo <> '' then
//             UpdateCRMOrderStatus(SalesHeader."TEC_CRMOrderId", 'Entregado');
//     end;

//     // =========================================================================
//     // PROCEDIMIENTOS HTTP Y JSON
//     // =========================================================================
//     local procedure UpdateCRMOrderStatus(CRMOrderId: Guid; EstadoAEnviar: Text)
//     var
//         HttpClient: HttpClient;
//         Content: HttpContent;
//         Headers: HttpHeaders;
//         Response: HttpResponseMessage;
//         JObject: JsonObject;
//         PayloadText: Text;
//         StatusUrl: Label 'https://dc7b0224e22ce677a83f5a6dcfe70f.0b.environment.api.powerplatform.com:443/powerautomate/automations/direct/workflows/854115c902c34857bf49ea62cdb0c3ba/triggers/manual/paths/invoke?api-version=1';
//     begin
//         // Format 0,4 quita las llaves para enviar el ID limpio al JSON de PA
//         JObject.Add('orderId', Format(CRMOrderId, 0, 4));
//         JObject.Add('state', EstadoAEnviar);
//         JObject.WriteTo(PayloadText);

//         if GuiAllowed then
//             if not Confirm('Se enviará el estado "%1" al CRM. ¿Desea enviarlo?\ %2', true, EstadoAEnviar, PayloadText) then
//                 exit;

//         Content.WriteFrom(PayloadText);
//         Content.GetHeaders(Headers);
//         if Headers.Contains('Content-Type') then Headers.Remove('Content-Type');
//         Headers.Add('Content-Type', 'application/json');

//         HttpClient.DefaultRequestHeaders.Add('Authorization', 'Bearer ' + GetAccessToken());

//         if HttpClient.Post(StatusUrl, Content, Response) then begin
//             if not Response.IsSuccessStatusCode() then begin
//                 Response.Content.ReadAs(PayloadText);
//                 Error('Error al actualizar el estado. Código: %1. Detalle: %2', Response.HttpStatusCode, PayloadText);
//             end else begin
//                 if GuiAllowed then
//                     Message('El estado %1 fue actualizado exitosamente.', EstadoAEnviar);
//             end;
//         end else
//             Error('No se pudo establecer conexión para actualizar el estado.');
//     end;

//     local procedure GetAccessToken(): Text
//     var
//         HttpClient: HttpClient;
//         Content: HttpContent;
//         Headers: HttpHeaders;
//         Response: HttpResponseMessage;
//         ResponseText: Text;
//         JObject: JsonObject;
//         JToken: JsonToken;
//         PostData: Text;
//         TenantId: Label 'd6ce406d-71fe-4379-b0ff-0853f834545a';
//         ClientId: Label '0a6e5481-3726-406e-a128-a8d0ab970057';
//         ClientSecret: Label 'TCI8Q~beIlpsy9j0tkgX7WnFDm6_g5E7YCvrbcVm';
//         Scope: Label 'https://service.flow.microsoft.com//.default';
//     begin
//         PostData := 'grant_type=client_credentials' +
//                     '&client_id=' + ClientId +
//                     '&client_secret=' + ClientSecret +
//                     '&scope=' + Scope;

//         Content.WriteFrom(PostData);
//         Content.GetHeaders(Headers);
//         Headers.Remove('Content-Type');
//         Headers.Add('Content-Type', 'application/x-www-form-urlencoded');

//         if HttpClient.Post('https://login.microsoftonline.com/' + TenantId + '/oauth2/v2.0/token', Content, Response) then begin
//             Response.Content.ReadAs(ResponseText);
//             if Response.IsSuccessStatusCode() then begin
//                 if JObject.ReadFrom(ResponseText) then
//                     if JObject.Get('access_token', JToken) then
//                         exit(JToken.AsValue().AsText());
//             end;
//         end;
//         exit('');
//     end;

//     local procedure SendOrderToCRM(JsonPayload: Text): Text
//     var
//         HttpClient: HttpClient;
//         Content: HttpContent;
//         Headers: HttpHeaders;
//         Response: HttpResponseMessage;
//         CRMUrl: Label 'https://dc7b0224e22ce677a83f5a6dcfe70f.0b.environment.api.powerplatform.com:443/powerautomate/automations/direct/workflows/7567894f5d7f4fb5b3ad6c9e532b63ec/triggers/manual/paths/invoke?api-version=1';
//         AccessToken: Text;
//         ResponseText: Text;
//         JObject: JsonObject;
//         JToken: JsonToken;
//     begin
//         AccessToken := GetAccessToken();
//         Content.WriteFrom(JsonPayload);
//         Content.GetHeaders(Headers);
//         if Headers.Contains('Content-Type') then Headers.Remove('Content-Type');
//         Headers.Add('Content-Type', 'application/json');

//         if AccessToken <> '' then
//             HttpClient.DefaultRequestHeaders.Add('Authorization', 'Bearer ' + AccessToken);

//         if HttpClient.Post(CRMUrl, Content, Response) then begin
//             Response.Content.ReadAs(ResponseText);
//             if Response.IsSuccessStatusCode() then begin
//                 if JObject.ReadFrom(ResponseText) then
//                     if JObject.Get('dynamicsOrderId', JToken) then
//                         exit(JToken.AsValue().AsText());
//             end else
//                 Error('Error en el envío al CRM. Detalle: %1', ResponseText);
//         end;
//         exit('');
//     end;

//     local procedure GenerateCRMJson(SalesHeader: Record "Sales Header"; OpportunityNo: Text): Text
//     var
//         JObject: JsonObject;
//         JLinesArray: JsonArray;
//         SalesLine: Record "Sales Line";
//         JLine: JsonObject;
//     begin
//         JObject.Add('documentType', 'Order');
//         JObject.Add('sellToCustomerNo', SalesHeader."Sell-to Customer No.");
//         JObject.Add('orderDate', SalesHeader."Order Date");
//         JObject.Add('postingDate', SalesHeader."Posting Date");
//         JObject.Add('externalDocumentNo', SalesHeader."No.");
//         JObject.Add('SalespersonCode', SalesHeader."Salesperson Code");
//         JObject.Add('ShortcutDimension1Code', SalesHeader."Shortcut Dimension 1 Code");
//         JObject.Add('ShortcutDimension2Code', SalesHeader."Shortcut Dimension 2 Code");
//         JObject.Add('DueDate', SalesHeader."Due Date");
//         JObject.Add('Company', GetCurrentCompanyId());
//         JObject.Add('opportunityNumber', OpportunityNo);
//         JObject.Add('PaymentTermsCode', SalesHeader."Payment Terms Code");

//         SalesLine.SetRange("Document Type", SalesHeader."Document Type");
//         SalesLine.SetRange("Document No.", SalesHeader."No.");
//         if SalesLine.FindSet() then
//             repeat
//                 Clear(JLine);
//                 case SalesLine.Type of
//                     SalesLine.Type::Item:
//                         JLine.Add('type', 'Item');
//                     else
//                         JLine.Add('type', format(SalesLine.Type, 0, 0));
//                 end;
//                 JLine.Add('lineNo', format(SalesLine."Line No."));
//                 JLine.Add('no', SalesLine."No.");
//                 JLine.Add('quantity', SalesLine.Quantity);
//                 JLine.Add('UnitofMeasureCode', SalesLine."Unit of Measure Code");
//                 JLine.Add('locationCode', SalesLine."Location Code");
//                 JLine.Add('unitPrice', SalesLine."Unit Price");
//                 JLinesArray.Add(JLine);
//             until SalesLine.Next() = 0;

//         JObject.Add('salesLines', JLinesArray);
//         exit(FormatJson(JObject));
//     end;

//     local procedure GetCurrentCompanyId(): Text
//     var
//         Company: Record Company;
//     begin
//         if Company.Get(CompanyName()) then
//             exit(LowerCase(Format(Company.Id).Replace('{', '').Replace('}', '')));
//         exit('');
//     end;

//     local procedure FormatJson(JObj: JsonObject): Text
//     var
//         Result: Text;
//     begin
//         JObj.WriteTo(Result);
//         exit(Result);
//     end;
// }
codeunit 50101 "TEC_CRMIntegrationMgt"
{
    // =========================================================================
    // PASO 1: CREACIÓN Y GUARDADO DEL GUID CORRECTAMENTE
    // =========================================================================
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Blanket Sales Order to Order", 'OnAfterRun', '', false, false)]
    local procedure OnAfterRun_BlanketOrderToOrder(var SalesHeader: Record "Sales Header"; var SalesOrderHeader: Record "Sales Header")
    var
        OpportunityGuid: Guid;
        CRMOrderIdText: Text;
        CRMOrderGuid: Guid;
        JsonPayload: Text;
        SalesOrderDB: Record "Sales Header";
    begin
        if SalesHeader."Posting Description" = '' then exit;
        if not Evaluate(OpportunityGuid, SalesHeader."Posting Description") then exit;

        Commit(); // Forzamos escritura previa

        JsonPayload := GenerateCRMJson(SalesOrderHeader, SalesHeader."Posting Description");

        if GuiAllowed then
            if not Confirm('PASO 1: Se ha generado el JSON de CREACIÓN para el CRM. ¿Desea enviarlo?\ %1', true, JsonPayload) then
                exit;

        // Llamamos a la función de envío (Aquí saltarán las trampas 1 y 2)
        CRMOrderIdText := SendOrderToCRM(JsonPayload);

        // --- TRAMPA 3: Valor que llegó a la función principal ---
        //    Message('TRAMPA 3 - Texto final devuelto a la función principal:\ "%1"', CRMOrderIdText);

        if CRMOrderIdText <> '' then begin
            if not CRMOrderIdText.StartsWith('{') then
                CRMOrderIdText := '{' + CRMOrderIdText + '}';

            // Convertimos y guardamos
            if Evaluate(CRMOrderGuid, CRMOrderIdText) then begin

                if SalesOrderDB.Get(SalesOrderHeader."Document Type", SalesOrderHeader."No.") then begin
                    SalesOrderDB."TEC_CRMOrderId" := CRMOrderGuid;
                    SalesOrderDB.Modify(true);

                    Commit();
                    UpdateCRMOrderStatus(SalesOrderDB."TEC_CRMOrderId", 'Abierto');
                end;

            end else
                Message('ERROR TRAMPA 3: BC no pudo convertir el texto "%1" a formato GUID.', CRMOrderIdText);
        end;
    end;

    // =========================================================================
    // PASO 2: OBSERVADOR DE ESTADO (Abierto / Lanzado)
    // =========================================================================
    [EventSubscriber(ObjectType::Table, Database::"Sales Header", 'OnAfterModifyEvent', '', false, false)]
    local procedure OnAfterModifySalesHeader_UpdateCRMStatus(var Rec: Record "Sales Header"; var xRec: Record "Sales Header"; RunTrigger: Boolean)
    begin
        if Rec.IsTemporary then exit;
        if Rec."Document Type" <> Rec."Document Type"::Order then exit;
        if IsNullGuid(Rec."TEC_CRMOrderId") then exit;

        if Rec.Status = xRec.Status then exit;

        Commit();

        if Rec.Status = Rec.Status::Released then
            UpdateCRMOrderStatus(Rec."TEC_CRMOrderId", 'Lanzado')
        else if Rec.Status = Rec.Status::Open then
            UpdateCRMOrderStatus(Rec."TEC_CRMOrderId", 'Abierto');
    end;

    // =========================================================================
    // PASO 3: OBSERVADOR DE REGISTRO (Entregado / Facturado)
    // =========================================================================
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", 'OnAfterPostSalesDoc', '', false, false)]
    local procedure OnAfterPostSalesDoc(var SalesHeader: Record "Sales Header"; var GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line"; SalesShptHdrNo: Code[20]; RetRcpHdrNo: Code[20]; SalesInvHdrNo: Code[20]; SalesCrMemoHdrNo: Code[20])
    begin
        if SalesHeader."Document Type" <> SalesHeader."Document Type"::Order then exit;
        if IsNullGuid(SalesHeader."TEC_CRMOrderId") then exit;

        Commit();

        if SalesInvHdrNo <> '' then
            UpdateCRMOrderStatus(SalesHeader."TEC_CRMOrderId", 'Facturado')
        else if SalesShptHdrNo <> '' then
            UpdateCRMOrderStatus(SalesHeader."TEC_CRMOrderId", 'Entregado');
    end;

    // =========================================================================
    // PROCEDIMIENTOS HTTP Y JSON
    // =========================================================================
    local procedure UpdateCRMOrderStatus(CRMOrderId: Guid; EstadoAEnviar: Text)
    var
        HttpClient: HttpClient;
        Content: HttpContent;
        Headers: HttpHeaders;
        Response: HttpResponseMessage;
        JObject: JsonObject;
        PayloadText: Text;
        StatusUrl: Label 'https://dc7b0224e22ce677a83f5a6dcfe70f.0b.environment.api.powerplatform.com:443/powerautomate/automations/direct/workflows/854115c902c34857bf49ea62cdb0c3ba/triggers/manual/paths/invoke?api-version=1';
    begin
        JObject.Add('orderId', Format(CRMOrderId, 0, 4));
        JObject.Add('state', EstadoAEnviar);
        JObject.WriteTo(PayloadText);

        if GuiAllowed then
            if not Confirm('Se enviará el estado "%1" al CRM. ¿Desea enviarlo?\ %2', true, EstadoAEnviar, PayloadText) then
                exit;

        Content.WriteFrom(PayloadText);
        Content.GetHeaders(Headers);
        if Headers.Contains('Content-Type') then Headers.Remove('Content-Type');
        Headers.Add('Content-Type', 'application/json');

        HttpClient.DefaultRequestHeaders.Add('Authorization', 'Bearer ' + GetAccessToken());

        if HttpClient.Post(StatusUrl, Content, Response) then begin
            if not Response.IsSuccessStatusCode() then begin
                Response.Content.ReadAs(PayloadText);
                Error('Error al actualizar el estado. Código: %1. Detalle: %2', Response.HttpStatusCode, PayloadText);
            end else begin
                if GuiAllowed then
                    Message('El estado %1 fue actualizado exitosamente.', EstadoAEnviar);
            end;
        end else
            Error('No se pudo establecer conexión para actualizar el estado.');
    end;

    local procedure GetAccessToken(): Text
    var
        HttpClient: HttpClient;
        Content: HttpContent;
        Headers: HttpHeaders;
        Response: HttpResponseMessage;
        ResponseText: Text;
        JObject: JsonObject;
        JToken: JsonToken;
        PostData: Text;
        TenantId: Label 'd6ce406d-71fe-4379-b0ff-0853f834545a';
        ClientId: Label '0a6e5481-3726-406e-a128-a8d0ab970057';
        ClientSecret: Label 'TCI8Q~beIlpsy9j0tkgX7WnFDm6_g5E7YCvrbcVm';
        Scope: Label 'https://service.flow.microsoft.com//.default';
    begin
        PostData := 'grant_type=client_credentials' +
                    '&client_id=' + ClientId +
                    '&client_secret=' + ClientSecret +
                    '&scope=' + Scope;

        Content.WriteFrom(PostData);
        Content.GetHeaders(Headers);
        Headers.Remove('Content-Type');
        Headers.Add('Content-Type', 'application/x-www-form-urlencoded');

        if HttpClient.Post('https://login.microsoftonline.com/' + TenantId + '/oauth2/v2.0/token', Content, Response) then begin
            Response.Content.ReadAs(ResponseText);
            if Response.IsSuccessStatusCode() then begin
                if JObject.ReadFrom(ResponseText) then
                    if JObject.Get('access_token', JToken) then
                        exit(JToken.AsValue().AsText());
            end;
        end;
        exit('');
    end;

    local procedure SendOrderToCRM(JsonPayload: Text): Text
    var
        HttpClient: HttpClient;
        Content: HttpContent;
        Headers: HttpHeaders;
        Response: HttpResponseMessage;
        CRMUrl: Label 'https://dc7b0224e22ce677a83f5a6dcfe70f.0b.environment.api.powerplatform.com:443/powerautomate/automations/direct/workflows/7567894f5d7f4fb5b3ad6c9e532b63ec/triggers/manual/paths/invoke?api-version=1';
        AccessToken: Text;
        ResponseText: Text;
        JObject: JsonObject;
        JToken: JsonToken;
    begin
        AccessToken := GetAccessToken();
        Content.WriteFrom(JsonPayload);
        Content.GetHeaders(Headers);
        if Headers.Contains('Content-Type') then Headers.Remove('Content-Type');
        Headers.Add('Content-Type', 'application/json');

        if AccessToken <> '' then
            HttpClient.DefaultRequestHeaders.Add('Authorization', 'Bearer ' + AccessToken);

        if HttpClient.Post(CRMUrl, Content, Response) then begin
            Response.Content.ReadAs(ResponseText);

            // --- TRAMPA 1: Respuesta cruda ---
            //  Message('TRAMPA 1 - Respuesta cruda del CRM:\ %1', ResponseText);

            if Response.IsSuccessStatusCode() then begin
                if JObject.ReadFrom(ResponseText) then begin
                    if JObject.Get('dynamicsOrderId', JToken) then begin
                        // --- TRAMPA 2: Valor extraído ---
                        Message('TRAMPA 2 - Valor extraído del JSON:\ "%1"', JToken.AsValue().AsText());
                        exit(JToken.AsValue().AsText());
                    end;
                end;
            end else
                Error('Error en el envío al CRM. Detalle: %1', ResponseText);
        end;
        exit('');
    end;

    local procedure GenerateCRMJson(SalesHeader: Record "Sales Header"; OpportunityNo: Text): Text
    var
        JObject: JsonObject;
        JLinesArray: JsonArray;
        SalesLine: Record "Sales Line";
        JLine: JsonObject;
    begin
        JObject.Add('documentType', 'Order');
        JObject.Add('sellToCustomerNo', SalesHeader."Sell-to Customer No.");
        JObject.Add('orderDate', SalesHeader."Order Date");
        JObject.Add('postingDate', SalesHeader."Posting Date");
        JObject.Add('externalDocumentNo', SalesHeader."No.");
        JObject.Add('SalespersonCode', SalesHeader."Salesperson Code");
        JObject.Add('ShortcutDimension1Code', SalesHeader."Shortcut Dimension 1 Code");
        JObject.Add('ShortcutDimension2Code', SalesHeader."Shortcut Dimension 2 Code");
        JObject.Add('DueDate', SalesHeader."Due Date");
        JObject.Add('Company', GetCurrentCompanyId());
        JObject.Add('opportunityNumber', OpportunityNo);
        JObject.Add('PaymentTermsCode', SalesHeader."Payment Terms Code");

        SalesLine.SetRange("Document Type", SalesHeader."Document Type");
        SalesLine.SetRange("Document No.", SalesHeader."No.");
        if SalesLine.FindSet() then
            repeat
                Clear(JLine);
                case SalesLine.Type of
                    SalesLine.Type::Item:
                        JLine.Add('type', 'Item');
                    else
                        JLine.Add('type', format(SalesLine.Type, 0, 0));
                end;
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

    local procedure GetCurrentCompanyId(): Text
    var
        Company: Record Company;
    begin
        if Company.Get(CompanyName()) then
            exit(LowerCase(Format(Company.Id).Replace('{', '').Replace('}', '')));
        exit('');
    end;

    local procedure FormatJson(JObj: JsonObject): Text
    var
        Result: Text;
    begin
        JObj.WriteTo(Result);
        exit(Result);
    end;
}