page 50110 "CustomerMetricsAPI"
{
    PageType = API;
    Caption = 'Customer Metrics CRM';
    APIPublisher = 'custom';
    APIGroup = 'integrations';
    APIVersion = 'v1.0';
    EntityName = 'customerMetric';
    EntitySetName = 'customerMetrics';
    SourceTable = Customer;
    DelayedInsert = true;
    InsertAllowed = false;
    ModifyAllowed = false;
    DeleteAllowed = false;

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field(ruc; Rec."VAT Registration No.") { Caption = 'RUC'; }

                field(company; CompanyID) { Caption = 'Company ID'; }

                field(invoicedAmount; InvoicedAmount) { Caption = 'Invoiced Amount'; }

                field(portfolioAmount; PortfolioAmount) { Caption = 'Portfolio Amount'; }

                field(overduePortfolioAmount; OverdueAmount) { Caption = 'Overdue Portfolio Amount'; }

                field(overduePortfolioDays; OverdueDays) { Caption = 'Overdue Portfolio Days'; }

                field(averagePaymentDays; AvgPaymentDays) { Caption = 'Average Payment Days'; }

                field(paymenttermscode; IntPaymentTerms) { Caption = 'Payment Terms Code'; }
            }
        }
    }

    var
        CompanyID: Guid;
        InvoicedAmount: Decimal;
        PortfolioAmount: Decimal;
        OverdueAmount: Decimal;
        OverdueDays: Integer;
        AvgPaymentDays: Integer;
        IntPaymentTerms: Integer;

    trigger OnAfterGetRecord()
    begin
        // Aquí insertaremos la lógica de cálculo en el siguiente paso
    end;
}