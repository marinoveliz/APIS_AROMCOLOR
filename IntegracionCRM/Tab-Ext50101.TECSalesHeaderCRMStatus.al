tableextension 50101 "TEC_SalesHeaderCRMStatus" extends "Sales Header"
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