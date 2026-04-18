codeunit 50100 "CRMIntegration Management"
//mveliz 18/04/2026
{
    procedure GenerateCustomerJson(CustomerNo: Code[20]): Text
    var
        Cust: Record Customer;
        JObject: JsonObject;
        ResultText: Text;
    begin
        if not Cust.Get(CustomerNo) then
            exit('Cliente no encontrado.');

        // Ejecutar Cálculos
        CalculateMetrics(Cust, JObject);

        JObject.WriteTo(ResultText);
        exit(ResultText);
    end;

    local procedure CalculateMetrics(var Cust: Record Customer; var JObject: JsonObject)
    var
        CustLedgerEntry: Record "Cust. Ledger Entry";
        CurrentYear: Integer;
        DateFilter: Text;
        OverdueDays: Integer;
        TotalPaymentDays: Integer;
        ClosedEntriesCount: Integer;
    begin
        JObject.Add('ruc', Cust."VAT Registration No.");
        //JObject.Add('company', Database.CompanyName());
        JObject.Add('company', GetCurrentCompanyId());
        CurrentYear := Date2DMY(WorkDate(), 3);
        DateFilter := '0101' + Format(CurrentYear) + '..' + Format(WorkDate());
        Cust.SetFilter("Date Filter", DateFilter);
        Cust.CalcFields("Sales (LCY)");
        JObject.Add('invoicedAmount', Cust."Sales (LCY)");

        Cust.SetRange("Date Filter");
        Cust.CalcFields("Balance (LCY)", "Balance Due (LCY)");
        JObject.Add('portfolioAmount', Cust."Balance (LCY)");
        JObject.Add('overduePortfolioAmount', Cust."Balance Due (LCY)");

        // Días de Mora (Factura más antigua abierta)
        OverdueDays := 0;
        CustLedgerEntry.Reset();
        CustLedgerEntry.SetCurrentKey("Customer No.", Open, Positive, "Due Date");
        CustLedgerEntry.SetRange("Customer No.", Cust."No.");
        CustLedgerEntry.SetRange(Open, true);
        CustLedgerEntry.SetFilter("Due Date", '<%1', WorkDate());
        if CustLedgerEntry.FindFirst() then
            OverdueDays := WorkDate() - CustLedgerEntry."Due Date";

        JObject.Add('overduePortfolioDays', OverdueDays);

        // --- CORRECCIÓN: Cálculo Manual de Promedio de Días de Pago ---
        TotalPaymentDays := 0;
        ClosedEntriesCount := 0;
        CustLedgerEntry.Reset();
        CustLedgerEntry.SetRange("Customer No.", Cust."No.");
        CustLedgerEntry.SetRange(Open, false); // Solo facturas ya pagadas/cerradas
        CustLedgerEntry.SetRange("Document Type", CustLedgerEntry."Document Type"::Invoice);
        if CustLedgerEntry.FindSet() then begin
            repeat
                if CustLedgerEntry."Closed at Date" <> 0D then begin
                    TotalPaymentDays += (CustLedgerEntry."Closed at Date" - CustLedgerEntry."Posting Date");
                    ClosedEntriesCount += 1;
                end;
            until CustLedgerEntry.Next() = 0;
        end;

        if ClosedEntriesCount > 0 then
            JObject.Add('averagePaymentDays', Round(TotalPaymentDays / ClosedEntriesCount, 1))
        else
            JObject.Add('averagePaymentDays', 0);
        // -------------------------------------------------------------

        JObject.Add('paymenttermscode', Cust."Payment Terms Code");
    end;

    local procedure GetCurrentCompanyId(): Text
    var
        Company: Record Company;
    begin
        if Company.Get(CompanyName()) then
            exit(LowerCase(Format(Company.Id).Replace('{', '').Replace('}', '')));
        exit('');
    end;
}