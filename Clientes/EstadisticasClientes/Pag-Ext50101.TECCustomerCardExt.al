pageextension 50101 TEC_CustomerCardExt extends "Customer Card"
{
    layout
    {
        addlast(General)
        {
            field(TEC_RequiresCRMUpdate; Rec.TEC_RequiresCRMUpdate)
            {
                ApplicationArea = all;
                Editable = true;
            }
        }
    }
}
