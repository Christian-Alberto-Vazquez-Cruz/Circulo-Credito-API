SELECT
  p.id,
  p.rfc,
  p.tipo_persona,
  p.email,
  p.telefono,
  p.direccion,
  p.estatus,
  p.created_at,
  p.updated_at,
  pf.curp,
  pf.nombre,
  pf.apellido_paterno,
  pf.apellido_materno,
  pf.fecha_nacimiento,
  pf.ingreso_mensual,
  pf.ocupacion,
  pf.estado_civil,
  pm.razon_social,
  pm.nombre_comercial,
  pm.fecha_constitucion,
  pm.sector_economico,
  pm.ingreso_anual,
  pm.numero_empleados,
  pm.representante_legal,
  CASE
    WHEN p.tipo_persona = 'FISICA' THEN pf.nombre + ' ' + pf.apellido_paterno + ' ' + ISNULL(pf.apellido_materno, '')
    ELSE pm.razon_social
  END AS nombre_identificacion
FROM
  personas AS p
  LEFT JOIN personas_fisicas AS pf ON pf.persona_id = p.id
  LEFT JOIN personas_morales AS pm ON pm.persona_id = p.id;