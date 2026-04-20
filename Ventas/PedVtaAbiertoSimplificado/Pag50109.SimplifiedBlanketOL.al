// page 50109 "Simplified Blanket Order List"
// {
//     PageType = List;
//     SourceTable = "Sales Header";
//     SourceTableView = WHERE("Document Type" = CONST("Blanket Order"));
//     Caption = 'Lista Pedidos Abiertos CRM';
//     ApplicationArea = All;
//     UsageCategory = Lists;
//     CardPageId = "Simplified Blanket Order Card"; // Vincula con la ficha que ya publicaste
//     Editable = false;
//     InsertAllowed = false;

//     layout
//     {
//         area(Content)
//         {
//             repeater(Control1)
//             {
//                 field("No."; Rec."No.")
//                 {
//                     ApplicationArea = All;
//                 }
//                 field("External Document No."; Rec."External Document No.")
//                 {
//                     ApplicationArea = All;
//                     Caption = 'Referencia CRM';
//                 }
//                 field("Sell-to Customer No."; Rec."Sell-to Customer No.")
//                 {
//                     ApplicationArea = All;
//                 }
//                 field("Sell-to Customer Name"; Rec."Sell-to Customer Name")
//                 {
//                     ApplicationArea = All;
//                 }
//                 field("Order Date"; Rec."Order Date")
//                 {
//                     ApplicationArea = All;
//                 }
//                 field("Shortcut Dimension 1 Code"; Rec."Shortcut Dimension 1 Code")
//                 {
//                     ApplicationArea = All;
//                 }
//                 field(Status; Rec.Status)
//                 {
//                     ApplicationArea = All;
//                 }
//                 field("Amount Including VAT"; Rec."Amount Including VAT")
//                 {
//                     ApplicationArea = All;
//                 }
//             }
//         }
//     }
// }