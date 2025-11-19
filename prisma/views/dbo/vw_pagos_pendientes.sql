SELECT
  hp.id AS pago_id,
  hp.obligacion_id,
  oc.numero_contrato,
  oc.tipo_credito,
  p.id AS persona_id,
  p.rfc,
  p.tipo_persona,
  CASE
    WHEN p.tipo_persona = 'FISICA' THEN pf.nombre + ' ' + pf.apellido_paterno + ' ' + ISNULL(pf.apellido_materno, '')
    ELSE pm.razon_social
  END AS nombre_completo,
  hp.numero_pago,
  hp.fecha_programada,
  hp.monto_programado,
  hp.monto_pagado,
  hp.dias_atraso_registrado,
  hp.estatus_pago,
  oc.entidad_otorgante,
  CASE
    WHEN hp.fecha_programada <= GETDATE() THEN DATEDIFF(DAY, hp.fecha_programada, GETDATE())
    ELSE 0
  END AS dias_atraso_calculado
FROM
  historial_pagos AS hp
  JOIN obligaciones_crediticias AS oc ON hp.obligacion_id = oc.id
  JOIN personas AS p ON oc.persona_id = p.id
  LEFT JOIN personas_fisicas AS pf ON pf.persona_id = p.id
  LEFT JOIN personas_morales AS pm ON pm.persona_id = p.id
WHERE
  hp.estatus_pago IN (
    'PENDIENTE',
    'ATRASADO_1_29',
    'ATRASADO_30_59',
    'ATRASADO_60_89',
    'ATRASADO_90_PLUS'
  )
  AND oc.estatus_credito IN ('VIGENTE', 'VENCIDO');