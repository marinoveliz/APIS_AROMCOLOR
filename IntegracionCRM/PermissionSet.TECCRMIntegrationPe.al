permissionset 50100 TEC_CRMIntegrationPe
{
    Assignable = true;
    Caption = 'TEC_CRMIntegrationPe', MaxLength = 30;
    Permissions =
        table TEC_CRMIntegrationSetup = X,
        tabledata TEC_CRMIntegrationSetup = RMID,
        page EditarValoresDimensiones = X,
        page "CRM Integration Debugger" = X,
        page CustomerAPI = X,
        page CustomerMetricsAPI = X,
        page PurchaseOrderAPI = X,
        page PurchaseLineAPI = X,
        page CustomNoSeriesAPI = X,
        page SalesPerson = X,
        page TEC_CRMIntegrationSetup = X,
        page SalesOrderLineAPI = X,
        page BlanketSalesOrderAPI = X,
        codeunit TEC_CRMSubscriberMgt = X,
        codeunit TEC_CRMNightlySweeper = X,
        codeunit TEC_CRMDispatcherQueue = X,
        codeunit "CRMIntegration Management" = X,
        codeunit TEC_CRMIntegrationMgt = X;
}
