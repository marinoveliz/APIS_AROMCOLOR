page 50104 CustomerAPI
{
    PageType = API;
    APIGroup = 'apiGroup';
    APIPublisher = 'TECNOAV';
    APIVersion = 'v1.0';
    ApplicationArea = All;
    Caption = 'customerAPI';
    DelayedInsert = true;
    EntityName = 'customerAPI';
    EntitySetName = 'customersAPI';
    SourceTable = Customer;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field(no; Rec."No.") { }
                field(name; Rec.Name) { }

                // Variables para Identificación
                field(taeCodIdent; GlobalIdentTipo) { }
                field(vatRegistrationNo; GlobalIdentNum) { }

                // Variables para Geografía (Ecuador)
                field(taeCodPais; GlobalPais) { }
                field(taeCodProvincia; GlobalProvincia) { }
                field(taeCodCanton; GlobalCanton) { }
                field(taeCodParroquia; GlobalParroquia) { }

                field(address; Rec.Address) { }
                field(city; Rec.City) { }
                field(eMail; Rec."E-Mail") { }
                field(genBusPostingGroup; Rec."Gen. Bus. Posting Group") { }
                field(customerPostingGroup; Rec."Customer Posting Group") { }
                field(vatBusPostingGroup; Rec."VAT Bus. Posting Group") { }
                field(taeFormaPago; Rec.tae_FormaPago) { }
                field(taeCodSexo; Rec.tae_Cod_Sexo) { }
                field(taeExterior; Rec.tae_Exterior) { }
                field(taeParteRelacionada; Rec.tae_ParteRelacionada) { }
                field(countryRegionCode; Rec."Country/Region Code") { }
            }
        }
    }

    // --- TRIGGERS DE LÓGICA ---

    trigger OnAfterGetRecord()
    begin
        // Sincroniza variables para que el GET no devuelva valores vacíos
        GlobalIdentTipo := Rec.tae_Cod_Ident;
        GlobalIdentNum := Rec."VAT Registration No.";
        GlobalPais := Rec.tae_Cod_Pais;
        GlobalProvincia := Rec.tae_Cod_Provincia;
        GlobalCanton := Rec.tae_Cod_Canton;
        GlobalParroquia := Rec.tae_Cod_Parroquia;
    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        ProcessLocalFields();
    end;

    trigger OnModifyRecord(): Boolean
    begin
        ProcessLocalFields();
    end;

    local procedure ProcessLocalFields()
    begin
        // 1. JERARQUÍA DE IDENTIFICACIÓN
        // Validamos solo si el valor en la variable es distinto al de la tabla o si es inserción
        if GlobalIdentTipo <> '' then
            Rec.Validate(tae_Cod_Ident, GlobalIdentTipo);

        if GlobalIdentNum <> '' then
            Rec.Validate("VAT Registration No.", GlobalIdentNum);

        // 2. JERARQUÍA GEOGRÁFICA
        if GlobalPais <> '' then
            Rec.Validate(tae_Cod_Pais, GlobalPais);

        if GlobalProvincia <> '' then
            Rec.Validate(tae_Cod_Provincia, GlobalProvincia);

        if GlobalCanton <> '' then
            Rec.Validate(tae_Cod_Canton, GlobalCanton);

        if GlobalParroquia <> '' then
            Rec.Validate(tae_Cod_Parroquia, GlobalParroquia);
    end;

    var
        GlobalIdentTipo: Text[2];
        GlobalIdentNum: Code[20];
        GlobalPais: Code[10];
        GlobalProvincia: Code[10];
        GlobalCanton: Code[10];
        GlobalParroquia: Code[10];
}