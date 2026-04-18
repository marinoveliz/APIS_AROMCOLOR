codeunit 50102 "TEC_CRMSubscriberMgt"
//mveliz 18/04/2026 
//codeunit de subscripcion a los eventos que pueden desencadenar una actualizacion en uno o muchos indicadores del
//cliente, es uno de los dos metodos que usamos para simular el rastreo de los clientes que deben actualizarse.
{
    // 1. Registro de Documentos (Facturas/NC)
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", 'OnAfterPostSalesDoc', '', false, false)]
    local procedure OnAfterPostSalesDoc_MarkCustomer(var SalesHeader: Record "Sales Header")
    begin
        MarkCustomerForCRMUpdate(SalesHeader."Sell-to Customer No.");
    end;

    // 2. Inserción de movimientos (Pagos nuevos)
    [EventSubscriber(ObjectType::Table, Database::"Cust. Ledger Entry", 'OnAfterInsertEvent', '', false, false)]
    local procedure OnAfterInsertCustLedgerEntry_MarkCustomer(var Rec: Record "Cust. Ledger Entry")
    begin
        MarkCustomerForCRMUpdate(Rec."Customer No.");
    end;

    // 3. Modificación de movimientos (Aplicaciones/Liquidaciones de facturas)
    [EventSubscriber(ObjectType::Table, Database::"Cust. Ledger Entry", 'OnAfterModifyEvent', '', false, false)]
    local procedure OnAfterModifyCustLedgerEntry_MarkCustomer(var Rec: Record "Cust. Ledger Entry")
    begin
        // Cuando se aplica un pago a una factura, el registro de la factura se modifica
        MarkCustomerForCRMUpdate(Rec."Customer No.");
    end;

    local procedure MarkCustomerForCRMUpdate(CustomerNo: Code[20])
    var
        Customer: Record Customer;
    begin
        if CustomerNo = '' then
            exit;

        // Usamos Get para obtener el registro y validamos la bandera
        if Customer.Get(CustomerNo) then begin
            if not Customer.TEC_RequiresCRMUpdate then begin
                Customer.TEC_RequiresCRMUpdate := true;
                Customer.Modify();
            end;
        end;
    end;
}