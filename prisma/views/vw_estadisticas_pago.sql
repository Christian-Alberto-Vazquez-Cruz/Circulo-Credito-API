CREATE OR ALTER VIEW vw_estadisticas_pago AS
SELECT 
    p.id AS persona_id,
    p.rfc,
    oc.id AS obligacion_id,
    oc.numero_contrato,
    
    -- Conteos de pagos
    COUNT(hp.id) AS total_pagos_programados,
    SUM(CASE WHEN hp.estatus_pago IN ('PAGADO', 'AL_CORRIENTE') THEN 1 ELSE 0 END) AS pagos_realizados,
    SUM(CASE WHEN hp.estatus_pago = 'PAGADO_TARDE' THEN 1 ELSE 0 END) AS pagos_tardios,
    SUM(CASE WHEN hp.estatus_pago = 'NO_PAGADO' THEN 1 ELSE 0 END) AS pagos_no_realizados,
    
    -- Montos
    SUM(hp.monto_programado) AS monto_total_programado,
    SUM(hp.monto_pagado) AS monto_total_pagado,
    SUM(hp.monto_programado - hp.monto_pagado) AS monto_total_pendiente,
    
    -- Atrasos
    AVG(CAST(hp.dias_atraso_registrado AS FLOAT)) AS promedio_dias_atraso,
    MAX(hp.dias_atraso_registrado) AS max_dias_atraso_registrado,
    
    CASE 
        WHEN COUNT(hp.id) > 0 
        THEN ROUND(
            (CAST(SUM(CASE WHEN hp.estatus_pago IN ('PAGADO', 'AL_CORRIENTE') THEN 1 ELSE 0 END) AS FLOAT) 
             / COUNT(hp.id)) * 100, 2)
        ELSE 0
    END AS porcentaje_cumplimiento

FROM personas p
INNER JOIN obligaciones_crediticias oc ON oc.persona_id = p.id
LEFT JOIN historial_pagos hp ON hp.obligacion_id = oc.id
GROUP BY p.id, p.rfc, oc.id, oc.numero_contrato;
GO
