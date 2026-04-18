page 50105 SalesPerson
{
    APIGroup = 'apiGroup';
    APIPublisher = 'TECNOAV';
    APIVersion = 'v1.0';
    ApplicationArea = All;
    Caption = 'salesPerson';
    DelayedInsert = true;
    EntityName = 'salesPerson';
    EntitySetName = 'SalesPersons';
    PageType = API;
    SourceTable = "Salesperson/Purchaser";
    
    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field(eMail; Rec."E-Mail")
                {
                    Caption = 'Email';
                }
                field(name; Rec.Name)
                {
                    Caption = 'Name';
                }
                field("code"; Rec."Code")
                {
                    Caption = 'Code';
                }
                field(phoneNo; Rec."Phone No.")
                {
                    Caption = 'Phone No.';
                }
            }
        }
    }
}
