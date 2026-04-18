pageextension 50102 "TEC_SalesOrderCRMExt" extends "Sales Order"
{
    layout
    {
        addlast(General)
        {
            field("TEC_CRMOrderId"; Rec."TEC_CRMOrderId")
            {
                ApplicationArea = All;
                ToolTip = 'ID interno del CRM para sincronización de estados.';
                Editable = false; // Protegemos el campo para que no se edite a mano
                Importance = Promoted;
            }
        }
    }
}