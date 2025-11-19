SELECT
  oc.id AS obligacion_id,
  oc.numero_contrato,
  oc.persona_id,
  p.rfc,
  p.tipo_persona,
  CASE
    WHEN p.tipo_persona = 'FISICA' THEN pf.nombre + ' ' + pf.apellido_paterno + ' ' + ISNULL(pf.apellido_materno, '')
    ELSE pm.razon_social
  END AS nombre_completo,
  p.telefono,
  p.email,
  oc.entidad_otorgante,
  oc.clave_entidad,
  oc.tipo_entidad,
  oc.tipo_credito,
  oc.monto_original,
  oc.saldo_actual,
  oc.limite_credito,
  oc.plazo_meses,
  oc.pago_mensual_estimado,
  oc.fecha_solicitud,
  oc.fecha_apertura,
  oc.fecha_vencimiento,
  oc.fecha_cierre,
  oc.fecha_ultimo_pago,
  oc.estatus_credito,
  oc.dias_atraso,
  oc.monto_vencido,
  oc.pagos_atrasados_totales,
  CASE
    WHEN oc.monto_original > 0 THEN ROUND((oc.saldo_actual / oc.monto_original) * 100, 2)
    ELSE 0
  END AS porcentaje_deuda_original,
  CASE
    WHEN oc.limite_credito IS NOT NULL
    AND oc.limite_credito > 0 THEN ROUND((oc.saldo_actual / oc.limite_credito) * 100, 2)
    ELSE NULL
  END AS porcentaje_utilizacion_limite,
  DATEDIFF(MONTH, oc.fecha_apertura, GETDATE()) AS meses_desde_apertura,
  CASE
    WHEN oc.fecha_vencimiento IS NOT NULL THEN DATEDIFF(MONTH, GETDATE(), oc.fecha_vencimiento)
    ELSE NULL
  END AS meses_hasta_vencimiento,
  oc.created_at,
  oc.updated_at
FROM
  obligaciones_crediticias AS oc
  JOIN personas AS p ON oc.persona_id = p.id
  LEFT JOIN personas_fisicas AS pf ON pf.persona_id = p.id
  LEFT JOIN personas_morales AS pm ON pm.persona_id = p.id;