page 50107 "TEC_CRMIntegrationSetup"
{
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "TEC_CRMIntegrationSetup";
    Caption = 'Configuración Integración CRM';
    InsertAllowed = false;
    DeleteAllowed = false;

    layout
    {
        area(Content)
        {
            group(Endpoints)
            {
                Caption = 'Endpoints Power Automate';
                field("Order Creation URL"; Rec."Order Creation URL") { ApplicationArea = All; }
                field("Status Update URL"; Rec."Status Update URL") { ApplicationArea = All; }
                field("Customer Stats URL"; Rec."Customer Stats URL") { ApplicationArea = All; }
            }
            group(Authentication)
            {
                Caption = 'Autenticación (OAuth2)';
                field("Tenant ID"; Rec."Tenant ID") { ApplicationArea = All; }
                field("Grant Type"; Rec."Grant Type") { ApplicationArea = All; }
                field("Client ID"; Rec."Client ID") { ApplicationArea = All; }
                field("Client Secret"; Rec."Client Secret") { ApplicationArea = All; }
                field("Scope"; Rec."Scope") { ApplicationArea = All; }
            }
        }
    }

    trigger OnOpenPage()
    begin
        if not Rec.Get() then begin
            Rec.Init();
            // Asignamos por defecto los valores que me indicaste si la tabla está vacía
            Rec."Tenant ID" := 'd6ce406d-71fe-4379-b0ff-0853f834545a';
            Rec."Client ID" := '0a6e5481-3726-406e-a128-a8d0ab970057';
            Rec."Client Secret" := 'TCI8Q~beIlpsy9j0tkgX7WnFDm6_g5E7YCvrbcVm';
            Rec.Insert();
        end;
    end;
}