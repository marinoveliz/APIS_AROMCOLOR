// query 50104 TecGLEntry
// {

//     elements
//     {
//         dataitem(QueryElement100000000; "G/L Entry")
//         {
//             //             DataItemTableFilter = G/L Account No.=FILTER(41110101..41110105|41110201..41110205|41110301..41110305),
//             // Posting Date=FILTER(01/01/16..01/01/26),
//             // Document No.=FILTER(<>REGUL*);
//             column(G_L_Account_No; "G/L Account No.")
//             {
//                 ColumnFilter = G_L_Account_No = filter('41110101..41110105|41110201..41110205|41110301..41110305');

//             }
//             column(Document_No_; "Document No.")
//             {
//                 ColumnFilter = Document_No_ = filter('<>REGUL*');
//             }
//             column(Description; Description)
//             {
//             }
//             column(Document_Type; "Document Type")
//             {
//             }
//             column(Posting_Date; "Posting Date")
//             {
//                 ColumnFilter = Posting_Date = filter('2016-01-01..2026-12-31');
//             }
//             column(Amount; Amount)
//             {
//             }
//             column(Source_Code; "Source Code")
//             {
//             }
//             column(Source_No; "Source No.")
//             {
//             }
//             column(Source_Type; "Source Type")
//             {
//             }
//             column(Global_Dimension_1_Code; "Global Dimension 1 Code")
//             {
//             }
//             column(Global_Dimension_2_Code; "Global Dimension 2 Code")
//             {
//             }
//             column(Dimension_Set_ID; "Dimension Set ID")
//             {
//             }
//         }
//     }
// }

