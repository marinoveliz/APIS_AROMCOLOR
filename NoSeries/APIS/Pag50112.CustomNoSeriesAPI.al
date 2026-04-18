// page 50112 "CustomNoSeriesAPI"
// {
//     APIGroup = 'custom';
//     APIPublisher = 'tecnoav';
//     APIVersion = 'v1.0';
//     EntityName = 'noSeriesLine';
//     EntitySetName = 'noSeriesLines';
//     PageType = API;
//     SourceTable = "No. Series Line";
//     // Filtramos directamente por el código de serie AJNON
//     SourceTableView = sorting("Series Code", "Starting Date") order(descending) where("Series Code" = const('AJ-NOM'));
//     InsertAllowed = false;
//     ModifyAllowed = false;
//     DeleteAllowed = false;
//     Caption = 'No. Series Line API';

//     layout
//     {
//         area(Content)
//         {
//             repeater(GroupName)
//             {
//                 // field(seriesCode; Rec."Series Code")
//                 // {
//                 //     Caption = 'Series Code';
//                 //     Visible = false;
//                 // }
//                 // field(startingDate; Rec."Starting Date")
//                 // {
//                 //     Caption = 'Starting Date';
//                 //     Visible = false;
//                 // }
//                 // field(startingNo; Rec."Starting No.")
//                 // {
//                 //     Caption = 'Starting No.';
//                 //     Visible = false;
//                 // }
//                 field(lastNoUsed; Rec."Last No. Used")
//                 {
//                     Caption = 'Last No. Used';
//                     Visible = true;
//                 }
//                 // field(endingNo; Rec."Ending No.")
//                 // {
//                 //     Caption = 'Ending No.';
//                 //     Visible = false;
//                 // }
//             }
//         }
//     }
// }
page 50112 "CustomNoSeriesAPI"
{
    APIGroup = 'custom';
    APIPublisher = 'tecnoav';
    APIVersion = 'v1.0';
    EntityName = 'noSeriesLine';
    EntitySetName = 'noSeriesLines';
    PageType = API;
    SourceTable = "No. Series Line";
    InsertAllowed = false;
    ModifyAllowed = false;
    DeleteAllowed = false;
    Caption = 'No. Series Line API';

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field(lastNoUsed; Rec."Last No. Used")
                {
                    Caption = 'Last No. Used';
                }
            }
        }
    }

    trigger OnOpenPage()
    var
        NoSeriesLine: Record "No. Series Line";
    begin
        // Limpiamos cualquier filtro previo del dataset de la página
        Rec.Reset();

        // Buscamos en una variable temporal para no ensuciar el Rec principal aún
        NoSeriesLine.Reset();
        NoSeriesLine.SetRange("Series Code", 'AJ-NOM');

        // Intentamos encontrar el último registro basado en la clave primaria (Line No.)
        if NoSeriesLine.FindLast() then begin
            // Si lo encuentra, aplicamos el filtro exacto al Rec de la página
            Rec.SetRange("Series Code", NoSeriesLine."Series Code");
            Rec.SetRange("Line No.", NoSeriesLine."Line No.");
        end else begin
            // Si sigue vacío, es vital verificar si el código AJNON existe en la tabla 309
            // Forzamos un filtro que devuelva vacío para evitar errores de set, 
            // pero le sugiero revisar los datos en BC.
            Rec.SetRange("Series Code", 'N/A');
        end;
    end;
}