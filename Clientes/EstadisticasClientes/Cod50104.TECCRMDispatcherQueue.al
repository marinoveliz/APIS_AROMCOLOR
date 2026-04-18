codeunit 50104 "TEC_CRMDispatcherQueue"
{
    TableNo = "Job Queue Entry";

    trigger OnRun()
    var
        Customer: Record Customer;
        CRMIntegration: Codeunit "CRMIntegration Management"; // Tu codeunit 50100
        JsonPayload: Text;
        Success: Boolean;
    begin
        // 1. Buscamos solo a los clientes que requieren actualización
        Customer.Reset();
        Customer.SetRange(TEC_RequiresCRMUpdate, true);

        if Customer.FindSet() then begin
            repeat
                // 2. Generamos el JSON usando tu Codeunit existente
                JsonPayload := CRMIntegration.GenerateCustomerJson(Customer."No.");

                // Validamos que el JSON no esté vacío (ej. si no se encontró el cliente)
                if (JsonPayload <> '') and (JsonPayload <> 'Cliente no encontrado.') then begin

                    // 3. Enviamos al endpoint del CRM
                    Success := SendToPowerAutomate(JsonPayload);

                    // 4. Si el envío fue exitoso (Status 200 OK), apagamos la bandera
                    if Success then begin
                        Customer.TEC_RequiresCRMUpdate := false;
                        Customer.Modify(false); // false para no disparar triggers
                    end;
                end;
            until Customer.Next() = 0;
        end;
    end;

    local procedure SendToPowerAutomate(JsonPayload: Text): Boolean
    var
        HttpClient: HttpClient;
        HttpContent: HttpContent;
        HttpHeaders: HttpHeaders;
        HttpResponse: HttpResponseMessage;
        AccessToken: Text;
        CRMUrl: Label 'https://dc7b0224e22ce677a83f5a6dcfe70f.0b.environment.api.powerplatform.com:443/powerautomate/automations/direct/workflows/99eaa05d81944654af1e53ae0ab4e45e/triggers/manual/paths/invoke?api-version=1';
    begin
        // Obtenemos el token usando las credenciales
        AccessToken := GetAccessToken();

        // Preparamos el cuerpo de la petición
        HttpContent.WriteFrom(JsonPayload);
        HttpContent.GetHeaders(HttpHeaders);

        if HttpHeaders.Contains('Content-Type') then
            HttpHeaders.Remove('Content-Type');
        HttpHeaders.Add('Content-Type', 'application/json');

        // Añadimos el token de autorización al encabezado
        if AccessToken <> '' then
            HttpClient.DefaultRequestHeaders.Add('Authorization', 'Bearer ' + AccessToken);

        // Realizamos el POST
        if HttpClient.Post(CRMUrl, HttpContent, HttpResponse) then begin
            // Si Power Automate responde con 200 OK, la actualización fue exitosa
            exit(HttpResponse.IsSuccessStatusCode());
        end;

        exit(false);
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
}