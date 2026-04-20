// pageextension 50103 "TEC_SalesOrderPeriodExt" extends "Sales Order"
// {
//     layout
//     {
//         // Puedes ubicar el campo donde prefieras. 
//         // Aquí lo estamos agregando en la pestaña "General", justo después de la Fecha de Registro.
//         addafter("Posting Date")
//         {
//             field("tae_periodo"; Rec.tae_Periodo) // Cambia "TEC_Periodo" por el nombre real de tu campo en la tabla
//             {
//                 ApplicationArea = All;
//                 ToolTip = 'Especifica el periodo correspondiente para este pedido de venta.';
//                 Editable = true; // Permite que el usuario lo modifique
//                 Importance = Promoted; // Lo hace visible incluso si la pestaña está colapsada
//             }
//         }
//     }
// }