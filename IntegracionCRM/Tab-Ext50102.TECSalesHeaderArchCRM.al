tableextension 50102 TEC_SalesHeaderArchCRM extends "Sales Header Archive"
{
    fields
    {
        field(50118; "TEC_CRMOrderId"; Guid)
        {
            Caption = 'CRM Order ID';
            DataClassification = CustomerContent;
        }
    }
}
