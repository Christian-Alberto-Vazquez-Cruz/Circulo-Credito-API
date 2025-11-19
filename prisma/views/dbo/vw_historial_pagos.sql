SELECT
  hp.id AS pago_id,
  hp.obligacion_id,
  oc.numero_contrato,
  oc.tipo_credito,
  oc.persona_id,
  p.rfc,
  hp.numero_pago,
  hp.fecha_programada,
  hp.fecha_pago_real,
  hp.monto_programado,
  hp.monto_pagado,
  hp.monto_interes,
  hp.monto_capital,
  hp.dias_atraso_registrado,
  hp.estatus_pago,
  hp.notas,
  oc.entidad_otorgante,
  CASE
    WHEN hp.fecha_programada <= GETDATE() THEN DATEDIFF(DAY, hp.fecha_programada, GETDATE())
    ELSE 0
  END AS dias_desde_fecha_programada,
  CASE
    WHEN hp.monto_programado > 0 THEN ROUND((hp.monto_pagado / hp.monto_programado) * 100, 2)
    ELSE 0
  END AS porcentaje_pagado,
  hp.monto_programado - hp.monto_pagado AS monto_pendiente,
  CASE
    WHEN hp.fecha_pago_real IS NOT NULL THEN 1
    ELSE 0
  END AS fue_pagado,
  CASE
    WHEN hp.fecha_pago_real > hp.fecha_programada THEN 1
    ELSE 0
  END AS fue_pago_tardio,
  hp.created_at
FROM
  historial_pagos AS hp
  JOIN obligaciones_crediticias AS oc ON hp.obligacion_id = oc.id
  JOIN personas AS p ON oc.persona_id = p.id;