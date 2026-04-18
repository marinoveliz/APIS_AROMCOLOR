codeunit 50103 "TEC_CRMNightlySweeper"
{
    //mveliz 18/04/2026
    //codeunit que rastrea la cartera vencida


    // Al poner esta propiedad, le decimos a BC que esta codeunit 
    // se puede programar en una Cola de Proyecto (Job Queue)
    TableNo = "Job Queue Entry";

    trigger OnRun()
    var
        CustLedgerEntry: Record "Cust. Ledger Entry";
        Customer: Record Customer;
        TargetDate: Date;
    begin
        // 1. Calculamos la fecha objetivo: Ayer
        // Usamos Today (fecha del servidor) y le restamos 1 día
        TargetDate := CalcDate('<-1D>', Today());

        // 2. Filtramos los movimientos de cliente
        CustLedgerEntry.Reset();
        CustLedgerEntry.SetRange(Open, true); // Solo facturas que aún no se pagan
        CustLedgerEntry.SetRange("Document Type", CustLedgerEntry."Document Type"::Invoice); // Solo facturas
        CustLedgerEntry.SetRange("Due Date", TargetDate); // Que hayan vencido exactamente ayer

        // 3. Recorremos los resultados y marcamos a los clientes
        if CustLedgerEntry.FindSet() then begin
            repeat
                if Customer.Get(CustLedgerEntry."Customer No.") then begin
                    // Solo actualizamos si la bandera está apagada para ahorrar recursos
                    if not Customer.TEC_RequiresCRMUpdate then begin
                        Customer.TEC_RequiresCRMUpdate := true;
                        // Usamos Modify(false) porque no necesitamos disparar los triggers estándar 
                        // de la tabla de clientes para este simple check técnico.
                        Customer.Modify(false);
                    end;
                end;
            until CustLedgerEntry.Next() = 0;
        end;
    end;
}