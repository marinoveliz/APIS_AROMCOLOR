page 50111 "CRM Integration Debugger"
{
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;
    Caption = 'Diagnóstico de Indicadores CRM';

    layout
    {
        area(Content)
        {
            group(Configuracion)
            {
                Caption = 'Selección de Cliente';
                field(SelectedCustomer; SelectedCustomerNo)
                {
                    ApplicationArea = All;
                    Caption = 'Cliente';
                    TableRelation = Customer where(Blocked = const(" "));
                }
            }
            group(Resultado)
            {
                Caption = 'JSON Generado';
                field(JsonOutput; JsonOutput)
                {
                    ApplicationArea = All;
                    Caption = 'Cuerpo del JSON';
                    MultiLine = true;
                    Editable = false;
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(GenerarJson)
            {
                Caption = 'Generar JSON';
                Image = XMLFile;
                ApplicationArea = All;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    if SelectedCustomerNo = '' then
                        Error('Por favor seleccione un cliente.');

                    // Llamada al proceso de cálculo
                    JsonOutput := CRMIntegrationMgt.GenerateCustomerJson(SelectedCustomerNo);
                end;
            }
        }
    }

    var
        SelectedCustomerNo: Code[20];
        JsonOutput: Text;
        CRMIntegrationMgt: Codeunit "CRMIntegration Management";
}