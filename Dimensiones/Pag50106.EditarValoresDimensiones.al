page 50106 EditarValoresDimensiones
{
    ApplicationArea = All;
    Caption = 'EditarValoresDimensiones';
    PageType = List;
    SourceTable = "Dimension Value";
    UsageCategory = Administration;
    
    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Dimension Value ID"; Rec."Dimension Value ID")
                {
                    ToolTip = 'Specifies the value of the Dimension Value ID field.', Comment = '%';
                }
                field("Consolidation Code"; Rec."Consolidation Code")
                {
                    ToolTip = 'Specifies the code that is used for consolidation.';
                }
                field("Code"; Rec."Code")
                {
                    ToolTip = 'Specifies the code for the dimension value.';
                }
                field("Dimension Code"; Rec."Dimension Code")
                {
                    ToolTip = 'Specifies the code for the dimension.';
                }
                field("Dimension Id"; Rec."Dimension Id")
                {
                    ToolTip = 'Specifies the value of the Dimension Id field.', Comment = '%';
                }
            }
        }
    }
}
