tableextension 50120 TEC_CustomerCRMUpdate extends Customer
{
    fields
    {
        field(50100; TEC_RequiresCRMUpdate; Boolean)
        {
            Caption = 'Requiere actualización CRM';
            DataClassification = CustomerContent;
            ToolTip = 'Indica si hubo movimientos o vencimientos que requieran enviar el nuevo estado financiero al CRM.';
        }

    }
}
