SELECT
  p.id AS persona_id,
  p.rfc,
  p.tipo_persona,
  p.estatus AS estatus_persona,
  p.email,
  p.telefono,
  p.created_at AS fecha_registro,
  COUNT(oc.id) AS total_obligaciones,
  SUM(
    CASE
      WHEN oc.estatus_credito = 'VIGENTE' THEN 1
      ELSE 0
    END
  ) AS obligaciones_vigentes,
  SUM(
    CASE
      WHEN oc.estatus_credito = 'VENCIDO' THEN 1
      ELSE 0
    END
  ) AS obligaciones_vencidas,
  SUM(
    CASE
      WHEN oc.estatus_credito = 'CERRADO' THEN 1
      ELSE 0
    END
  ) AS obligaciones_cerradas,
  SUM(
    CASE
      WHEN oc.estatus_credito = 'CANCELADO' THEN 1
      ELSE 0
    END
  ) AS obligaciones_canceladas,
  SUM(
    CASE
      WHEN oc.estatus_credito = 'CARTERA_VENCIDA' THEN 1
      ELSE 0
    END
  ) AS obligaciones_cartera_vencida,
  SUM(
    CASE
      WHEN oc.estatus_credito = 'REESTRUCTURADO' THEN 1
      ELSE 0
    END
  ) AS obligaciones_reestructuradas,
  ISNULL(SUM(oc.monto_original), 0) AS monto_total_original,
  ISNULL(SUM(oc.saldo_actual), 0) AS saldo_total_actual,
  ISNULL(SUM(oc.monto_vencido), 0) AS monto_total_vencido,
  ISNULL(SUM(oc.limite_credito), 0) AS limite_credito_total,
  ISNULL(MAX(oc.dias_atraso), 0) AS max_dias_atraso,
  ISNULL(SUM(oc.pagos_atrasados_totales), 0) AS total_pagos_atrasados,
  MIN(oc.fecha_apertura) AS fecha_credito_mas_antiguo,
  MAX(oc.fecha_apertura) AS fecha_credito_mas_reciente,
  CASE
    WHEN MIN(oc.fecha_apertura) IS NOT NULL THEN DATEDIFF(MONTH, MIN(oc.fecha_apertura), GETDATE())
    ELSE 0
  END AS meses_historial_crediticio
FROM
  personas AS p
  LEFT JOIN obligaciones_crediticias AS oc ON oc.persona_id = p.id
GROUP BY
  p.id,
  p.rfc,
  p.tipo_persona,
  p.estatus,
  p.email,
  p.telefono,
  p.created_at;