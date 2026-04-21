sequenceDiagram
    participant CRM as CRM Aromcolor
    participant BC_Blanket as BC: Pedido Abierto
    participant BC_Order as BC: Pedido de Venta
    participant BC_Arch as BC: Histórico / Registros
    
    %% Fase 1: Inyección
    CRM->>BC_Blanket: POST API (Crea Pedido Abierto)
    Note over CRM,BC_Blanket: Posting Description = Oportunidad GUID
    
    %% Fase 2: Conversión y Sincronización (Handshake)
    BC_Blanket->>BC_Order: Make Order (Conversión)
    BC_Order->>CRM: POST a PA (JSON con datos de Venta + Oportunidad)
    CRM-->>BC_Order: Devuelve 'dynamicsOrderId'
    Note over BC_Order: Guarda Guid en 'TEC_CRMOrderId'
    
    %% Fase 3: Ciclo de Vida y Estados
    BC_Order->>CRM: POST a PA (orderId, state: "Abierto")
    
    %% Usuario lanza el pedido
    BC_Order->>BC_Order: Acción: Lanzar
    BC_Order->>CRM: POST a PA (orderId, state: "Lanzado")
    
    %% Fase 4: Registro y Cumplimiento
    BC_Order->>BC_Arch: Acción: Registrar (Envío / Factura)
    Note over BC_Arch: TEC_CRMOrderId viaja al histórico
    BC_Arch->>CRM: POST a PA (orderId, state: "Entregado" / "Facturado")