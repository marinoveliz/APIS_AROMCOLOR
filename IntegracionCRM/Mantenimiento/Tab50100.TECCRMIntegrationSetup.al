table 50100 "TEC_CRMIntegrationSetup"
{
    Caption = 'CRM Integration Setup';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Primary Key"; Code[10])
        {
            Caption = 'Primary Key';
        }
        field(2; "Order Creation URL"; Text[2048])
        {
            Caption = 'URL Creación de Pedido';
            ExtendedDatatype = URL;
        }
        field(3; "Status Update URL"; Text[2048])
        {
            Caption = 'URL Actualización de Estado';
            ExtendedDatatype = URL;
        }
        field(4; "Customer Stats URL"; Text[2048])
        {
            Caption = 'URL Estadísticas de Clientes';
            ExtendedDatatype = URL;
        }

        // --- Credenciales Directas ---
        field(5; "Tenant ID"; Text[50])
        {
            Caption = 'Tenant ID';
        }
        field(6; "Grant Type"; Text[50])
        {
            Caption = 'Grant Type';
            InitValue = 'client_credentials';
        }
        field(7; "Client ID"; Text[100])
        {
            Caption = 'Client ID';
        }
        field(8; "Client Secret"; Text[250])
        {
            Caption = 'Client Secret';
            ExtendedDatatype = Masked; // Mantiene el secreto oculto con asteriscos en pantalla
        }
        field(9; "Scope"; Text[250])
        {
            Caption = 'Scope';
            InitValue = 'https://service.flow.microsoft.com//.default';
        }
    }

    keys
    {
        key(PK; "Primary Key")
        {
            Clustered = true;
        }
    }
}