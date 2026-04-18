
page 50108 "Simplified Blanket Order Subp"
{
    PageType = ListPart;
    SourceTable = "Sales Line";
    Caption = 'Líneas del Pedido';
    //AutoSplitKey = true;
    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("No."; Rec."No.") { ApplicationArea = All; Editable = false; }
                field(Description; Rec.Description) { ApplicationArea = All; }

                // Cantidad total original
                field(Quantity; Rec.Quantity)
                {
                    ApplicationArea = All;
                    Caption = 'Cant. Total CRM';
                }

                // Cantidad que se va a enviar al pedido normal en la próxima conversión
                field("Qty. to Ship"; Rec."Qty. to Ship")
                {
                    ApplicationArea = All;
                    Caption = 'Cant. a Convertir';
                    Style = Strong;
                }

                // Cantidad que ya ha sido convertida en pedidos de venta (pero no necesariamente facturada)
                field("Quantity Shipped"; Rec."Quantity Shipped")
                {
                    ApplicationArea = All;
                    Caption = 'Ya Convertido (Enviado)';
                    Editable = false;
                    Style = Subordinate;
                }


                field("Unit of Measure Code"; Rec."Unit of Measure Code") { ApplicationArea = All; }
                field("Unit Price"; Rec."Unit Price") { ApplicationArea = All; }
                field("Location Code"; Rec."Location Code") { ApplicationArea = All; }
            }
        }
    }
}