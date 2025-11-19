USE CirculoBancario;
GO

-- ==========================================
-- 1. API CLIENT (Solo una)
-- ==========================================
-- API Key original: CB_live_9k7m2p4x8n6v5b3w1q0r
-- Hash SHA-256 de la clave
INSERT INTO api_clients (nombre_entidad, api_key, estatus)
VALUES (
    'Banco Nacional de Crédito',
    '8f4e9a2c1d7b6f3e5a9c8d1f0b2e4a6c7d9f1e3b5a7c9e1d3f5b7a9c1e3d5f7b',
    'ACTIVO'
);
GO

-- ==========================================
-- 2. PERSONAS FÍSICAS
-- ==========================================

-- Insertar personas base (tipo FÍSICA)
INSERT INTO personas (tipo_persona, rfc, email, telefono, direccion, estatus)
VALUES 
    ('FISICA', 'MERL850315HDF', 'luis.mendoza@email.com', '2281234567', 'Av. Xalapa 123, Col. Centro, Xalapa, Ver.', 'ACTIVO'),
    ('FISICA', 'GARS920628MDF', 'sofia.garcia@email.com', '2289876543', 'Calle Enríquez 45, Col. Revolución, Xalapa, Ver.', 'ACTIVO'),
    ('FISICA', 'ROMC881104HDF', 'carlos.rodriguez@email.com', '2285551234', 'Av. Lázaro Cárdenas 789, Col. Badillo, Xalapa, Ver.', 'ACTIVO'),
    ('FISICA', 'HECJ950812MDF', 'jessica.hernandez@email.com', '2287778899', 'Privada de las Flores 12, Col. Jardines, Xalapa, Ver.', 'BLOQUEADO'),
    ('FISICA', 'VAPM900520HDF', 'miguel.vazquez@email.com', '2283334455', 'Circuito Presidentes 234, Col. Tres de Mayo, Xalapa, Ver.', 'ACTIVO');
GO

INSERT INTO personas_fisicas (persona_id, nombre, apellido_paterno, apellido_materno, curp, fecha_nacimiento, ingreso_mensual, ocupacion, estado_civil)
VALUES 
    (1, 'Luis Alberto', 'Mendoza', 'Ramírez', 'MERL850315HDFNMS09', '1985-03-15', 18500.00, 'Ingeniero de Software', 'CASADO'),
    (2, 'Sofía', 'García', 'Sánchez', 'GARS920628MDFRNF04', '1992-06-28', 15200.00, 'Contadora Pública', 'SOLTERA'),
    (3, 'Carlos Eduardo', 'Rodríguez', 'Martínez', 'ROMC881104HDFRRL06', '1988-11-04', 22300.00, 'Gerente de Ventas', 'CASADO'),
    (4, 'Jessica', 'Hernández', 'Cruz', 'HECJ950812MDFRRS02', '1995-08-12', 12800.00, 'Diseñadora Gráfica', 'SOLTERA'),
    (5, 'Miguel Ángel', 'Vázquez', 'Pérez', 'VAPM900520HDFZRG08', '1990-05-20', 28500.00, 'Médico General', 'CASADO');
GO

-- ==========================================
-- 3. PERSONAS MORALES
-- ==========================================

INSERT INTO personas (tipo_persona, rfc, email, telefono, direccion, estatus)
VALUES 
    ('MORAL', 'TEC150823KL5', 'contacto@techsolutions.mx', '2281112233', 'Parque Tecnológico Lote 5, Xalapa, Ver.', 'ACTIVO'),
    ('MORAL', 'CAF180910MN2', 'ventas@cafeorganico.mx', '2284445566', 'Carretera Xalapa-Coatepec Km 8, Ver.', 'ACTIVO'),
    ('MORAL', 'CON190305QR8', 'info@construmax.mx', '2287890123', 'Zona Industrial Norte, Xalapa, Ver.', 'ACTIVO');
GO

INSERT INTO personas_morales (persona_id, razon_social, nombre_comercial, fecha_constitucion, sector_economico, ingreso_anual, numero_empleados, representante_legal)
VALUES 
    (6, 'Tech Solutions de México S.A. de C.V.', 'TechSolutions MX', '2015-08-23', 'Tecnologías de Información', 3500000.00, 45, 'Roberto Jiménez Olvera'),
    (7, 'Café Orgánico de Veracruz S. de R.L. de C.V.', 'Café Veracruzano', '2018-09-10', 'Industria Alimentaria', 1200000.00, 18, 'María Elena Torres Guzmán'),
    (8, 'Construcciones Máximas del Golfo S.A. de C.V.', 'ConstruMax', '2019-03-05', 'Construcción', 8900000.00, 120, 'Ing. Jorge Alberto Domínguez');
GO

-- ==========================================
-- 4. OBLIGACIONES CREDITICIAS
-- ==========================================

-- Obligaciones de Luis Alberto (persona_id = 1) - Buen historial
INSERT INTO obligaciones_crediticias 
    (numero_contrato, persona_id, entidad_otorgante, clave_entidad, tipo_entidad, tipo_credito, 
     monto_original, saldo_actual, limite_credito, tasa_interes, plazo_meses, pago_mensual_estimado,
     fecha_solicitud, fecha_apertura, fecha_vencimiento, estatus_credito, dias_atraso)
VALUES 
    ('TC-BAZ-2023-001547', 1, 'Banco Azteca', 'BAZ001', 'BANCO', 'TARJETA_CREDITO', 
     30000.00, 8500.00, 30000.00, 42.50, NULL, 850.00,
     '2023-01-10', '2023-01-15', NULL, 'VIGENTE', 0),
    
    ('AUTO-SANT-2022-098765', 1, 'Banco Santander', 'SANT001', 'BANCO', 'CREDITO_AUTOMOTRIZ',
     285000.00, 145000.00, NULL, 13.50, 60, 5980.00,
     '2022-03-15', '2022-03-20', '2027-03-20', 'VIGENTE', 0);
GO

-- Obligaciones de Sofía (persona_id = 2) - Historial mixto
INSERT INTO obligaciones_crediticias 
    (numero_contrato, persona_id, entidad_otorgante, clave_entidad, tipo_entidad, tipo_credito, 
     monto_original, saldo_actual, limite_credito, tasa_interes, plazo_meses, pago_mensual_estimado,
     fecha_solicitud, fecha_apertura, fecha_vencimiento, estatus_credito, dias_atraso, monto_vencido)
VALUES 
    ('PERS-BBVA-2023-456789', 2, 'BBVA México', 'BBVA001', 'BANCO', 'CREDITO_PERSONAL',
     80000.00, 52000.00, NULL, 24.90, 36, 2850.00,
     '2023-06-01', '2023-06-05', '2026-06-05', 'VIGENTE', 15, 2850.00),
    
    ('TC-HSBC-2024-112233', 2, 'HSBC México', 'HSBC001', 'BANCO', 'TARJETA_CREDITO',
     15000.00, 14200.00, 15000.00, 48.90, NULL, 1420.00,
     '2024-01-12', '2024-01-15', NULL, 'VIGENTE', 0);
GO

-- Obligaciones de Carlos (persona_id = 3) - Excelente historial
INSERT INTO obligaciones_crediticias 
    (numero_contrato, persona_id, entidad_otorgante, clave_entidad, tipo_entidad, tipo_credito, 
     monto_original, saldo_actual, limite_credito, tasa_interes, plazo_meses, pago_mensual_estimado,
     fecha_solicitud, fecha_apertura, fecha_vencimiento, fecha_cierre, estatus_credito)
VALUES 
    ('HIP-BANORT-2019-789012', 3, 'Banco del Noreste', 'BNOR001', 'BANCO', 'CREDITO_HIPOTECARIO',
     1500000.00, 1120000.00, NULL, 10.50, 240, 16250.00,
     '2019-08-10', '2019-09-01', '2039-09-01', NULL, 'VIGENTE'),
    
    ('TC-BANAM-2021-334455', 3, 'Citibanamex', 'BANAM001', 'BANCO', 'TARJETA_CREDITO',
     50000.00, 0.00, 50000.00, 38.90, NULL, 0.00,
     '2021-05-20', '2021-05-25', NULL, '2024-10-15', 'CERRADO');
GO

-- Obligaciones de Jessica (persona_id = 4) - Mal historial
INSERT INTO obligaciones_crediticias 
    (numero_contrato, persona_id, entidad_otorgante, clave_entidad, tipo_entidad, tipo_credito, 
     monto_original, saldo_actual, tasa_interes, plazo_meses, pago_mensual_estimado,
     fecha_solicitud, fecha_apertura, fecha_vencimiento, estatus_credito, dias_atraso, monto_vencido, pagos_atrasados_totales)
VALUES 
    ('PERS-COPPEL-2022-667788', 4, 'BanCoppel', 'COPP001', 'BANCO', 'CREDITO_PERSONAL',
     45000.00, 38500.00, 34.90, 24, 2450.00,
     '2022-11-05', '2022-11-10', '2024-11-10', 'CARTERA_VENCIDA', 125, 12250.00, 5),
    
    ('TC-FAMSA-2023-889900', 4, 'Banco Famsa', 'FAMS001', 'BANCO', 'TARJETA_CREDITO',
     10000.00, 9850.00, 10000.00, 55.90, NULL, 985.00,
     '2023-03-15', '2023-03-20', NULL, 'VENCIDO', 92, 2955.00, 3);
GO

-- Obligaciones de Miguel (persona_id = 5) - Buen historial profesional
INSERT INTO obligaciones_crediticias 
    (numero_contrato, persona_id, entidad_otorgante, clave_entidad, tipo_entidad, tipo_credito, 
     monto_original, saldo_actual, limite_credito, tasa_interes, plazo_meses, pago_mensual_estimado,
     fecha_solicitud, fecha_apertura, fecha_vencimiento, estatus_credito)
VALUES 
    ('NOM-BANORT-2023-445566', 5, 'Banorte', 'BNORT001', 'BANCO', 'CREDITO_NOMINA',
     120000.00, 78000.00, NULL, 18.50, 48, 3250.00,
     '2023-02-01', '2023-02-05', '2027-02-05', 'VIGENTE'),
    
    ('TC-INVERLAT-2022-778899', 5, 'Scotiabank Inverlat', 'INVER001', 'BANCO', 'TARJETA_CREDITO',
     40000.00, 12500.00, 40000.00, 36.90, NULL, 1250.00,
     '2022-07-10', '2022-07-15', NULL, 'VIGENTE');
GO

-- Obligaciones empresariales - Tech Solutions (persona_id = 6)
INSERT INTO obligaciones_crediticias 
    (numero_contrato, persona_id, entidad_otorgante, clave_entidad, tipo_entidad, tipo_credito, 
     monto_original, saldo_actual, tasa_interes, plazo_meses, pago_mensual_estimado,
     fecha_solicitud, fecha_apertura, fecha_vencimiento, estatus_credito)
VALUES 
    ('PYME-NAFIN-2023-112234', 6, 'Nacional Financiera', 'NAFIN001', 'BANCO', 'CREDITO_PYME',
     500000.00, 325000.00, 12.90, 36, 16850.00,
     '2023-04-15', '2023-05-01', '2026-05-01', 'VIGENTE'),
    
    ('EMP-BBVA-2024-334456', 6, 'BBVA México', 'BBVA001', 'BANCO', 'CREDITO_EMPRESARIAL',
     800000.00, 720000.00, 14.50, 60, 18200.00,
     '2024-01-10', '2024-01-20', '2029-01-20', 'VIGENTE');
GO

-- Obligaciones empresariales - Café Orgánico (persona_id = 7)
INSERT INTO obligaciones_crediticias 
    (numero_contrato, persona_id, entidad_otorgante, clave_entidad, tipo_entidad, tipo_credito, 
     monto_original, saldo_actual, tasa_interes, plazo_meses, pago_mensual_estimado,
     fecha_solicitud, fecha_apertura, fecha_vencimiento, estatus_credito, dias_atraso, monto_vencido)
VALUES 
    ('PYME-BANORT-2023-556677', 7, 'Banorte', 'BNORT001', 'BANCO', 'CREDITO_PYME',
     250000.00, 185000.00, 15.90, 24, 12450.00,
     '2023-09-01', '2023-09-10', '2025-09-10', 'VIGENTE', 22, 12450.00);
GO

-- Obligaciones empresariales - ConstruMax (persona_id = 8)
INSERT INTO obligaciones_crediticias 
    (numero_contrato, persona_id, entidad_otorgante, clave_entidad, tipo_entidad, tipo_credito, 
     monto_original, saldo_actual, tasa_interes, plazo_meses, pago_mensual_estimado,
     fecha_solicitud, fecha_apertura, fecha_vencimiento, estatus_credito)
VALUES 
    ('EMP-SANT-2022-998877', 8, 'Banco Santander', 'SANT001', 'BANCO', 'CREDITO_EMPRESARIAL',
     2500000.00, 1850000.00, 11.50, 84, 42500.00,
     '2022-06-15', '2022-07-01', '2029-07-01', 'VIGENTE'),
    
    ('EMP-HSBC-2023-665544', 8, 'HSBC México', 'HSBC001', 'BANCO', 'CREDITO_EMPRESARIAL',
     1200000.00, 980000.00, 13.20, 60, 25800.00,
     '2023-03-20', '2023-04-01', '2028-04-01', 'VIGENTE');
GO

-- ==========================================
-- 5. HISTORIAL DE PAGOS
-- ==========================================

-- Historial de pagos para tarjeta de Luis (obligacion_id = 1) - Pagos puntuales
INSERT INTO historial_pagos 
    (obligacion_id, numero_pago, fecha_programada, fecha_pago_real, monto_programado, monto_pagado, 
     monto_interes, monto_capital, dias_atraso_registrado, estatus_pago)
VALUES 
    (1, 1, '2023-02-15', '2023-02-14', 850.00, 850.00, 300.00, 550.00, 0, 'PAGADO'),
    (1, 2, '2023-03-15', '2023-03-15', 850.00, 850.00, 280.00, 570.00, 0, 'PAGADO'),
    (1, 3, '2023-04-15', '2023-04-13', 850.00, 850.00, 265.00, 585.00, 0, 'PAGADO'),
    (1, 4, '2023-05-15', '2023-05-15', 850.00, 850.00, 248.00, 602.00, 0, 'PAGADO'),
    (1, 5, '2023-06-15', '2023-06-14', 850.00, 850.00, 230.00, 620.00, 0, 'PAGADO');
GO

-- Historial para crédito automotriz de Luis (obligacion_id = 2) - Excelente
INSERT INTO historial_pagos 
    (obligacion_id, numero_pago, fecha_programada, fecha_pago_real, monto_programado, monto_pagado, 
     monto_interes, monto_capital, dias_atraso_registrado, estatus_pago)
VALUES 
    (2, 1, '2022-04-20', '2022-04-19', 5980.00, 5980.00, 3200.00, 2780.00, 0, 'PAGADO'),
    (2, 2, '2022-05-20', '2022-05-18', 5980.00, 5980.00, 3170.00, 2810.00, 0, 'PAGADO'),
    (2, 3, '2022-06-20', '2022-06-20', 5980.00, 5980.00, 3140.00, 2840.00, 0, 'PAGADO'),
    (2, 4, '2022-07-20', '2022-07-19', 5980.00, 5980.00, 3110.00, 2870.00, 0, 'PAGADO');
GO

-- Historial para crédito personal de Sofía (obligacion_id = 3) - Con retrasos menores
INSERT INTO historial_pagos 
    (obligacion_id, numero_pago, fecha_programada, fecha_pago_real, monto_programado, monto_pagado, 
     monto_interes, monto_capital, dias_atraso_registrado, estatus_pago)
VALUES 
    (3, 1, '2023-07-05', '2023-07-05', 2850.00, 2850.00, 1660.00, 1190.00, 0, 'PAGADO'),
    (3, 2, '2023-08-05', '2023-08-12', 2850.00, 2850.00, 1640.00, 1210.00, 7, 'PAGADO_TARDE'),
    (3, 3, '2023-09-05', '2023-09-05', 2850.00, 2850.00, 1620.00, 1230.00, 0, 'PAGADO'),
    (3, 4, '2023-10-05', '2023-10-18', 2850.00, 2850.00, 1600.00, 1250.00, 13, 'PAGADO_TARDE'),
    (3, 5, '2023-11-05', NULL, 2850.00, 0.00, 0.00, 0.00, 15, 'ATRASADO_1_29');
GO

-- Historial para crédito hipotecario de Carlos (obligacion_id = 5) - Perfecto
INSERT INTO historial_pagos 
    (obligacion_id, numero_pago, fecha_programada, fecha_pago_real, monto_programado, monto_pagado, 
     monto_interes, monto_capital, dias_atraso_registrado, estatus_pago)
VALUES 
    (5, 1, '2019-10-01', '2019-09-30', 16250.00, 16250.00, 13125.00, 3125.00, 0, 'PAGADO'),
    (5, 2, '2019-11-01', '2019-10-31', 16250.00, 16250.00, 13100.00, 3150.00, 0, 'PAGADO'),
    (5, 3, '2019-12-01', '2019-11-29', 16250.00, 16250.00, 13075.00, 3175.00, 0, 'PAGADO');
GO

-- Historial para crédito de Jessica (obligacion_id = 7) - Múltiples atrasos severos
INSERT INTO historial_pagos 
    (obligacion_id, numero_pago, fecha_programada, fecha_pago_real, monto_programado, monto_pagado, 
     monto_interes, monto_capital, dias_atraso_registrado, estatus_pago)
VALUES 
    (7, 1, '2022-12-10', '2023-01-18', 2450.00, 2450.00, 1310.00, 1140.00, 39, 'PAGADO_TARDE'),
    (7, 2, '2023-01-10', '2023-02-25', 2450.00, 2450.00, 1295.00, 1155.00, 46, 'PAGADO_TARDE'),
    (7, 3, '2023-02-10', '2023-04-08', 2450.00, 2450.00, 1280.00, 1170.00, 57, 'PAGADO_TARDE'),
    (7, 4, '2023-03-10', NULL, 2450.00, 0.00, 0.00, 0.00, 125, 'ATRASADO_90_PLUS'),
    (7, 5, '2023-04-10', NULL, 2450.00, 0.00, 0.00, 0.00, 125, 'ATRASADO_90_PLUS');
GO

-- Historial para crédito PYME de Tech Solutions (obligacion_id = 9) - Pagos puntuales
INSERT INTO historial_pagos 
    (obligacion_id, numero_pago, fecha_programada, fecha_pago_real, monto_programado, monto_pagado, 
     monto_interes, monto_capital, dias_atraso_registrado, estatus_pago)
VALUES 
    (9, 1, '2023-06-01', '2023-05-31', 16850.00, 16850.00, 5375.00, 11475.00, 0, 'PAGADO'),
    (9, 2, '2023-07-01', '2023-06-30', 16850.00, 16850.00, 5250.00, 11600.00, 0, 'PAGADO'),
    (9, 3, '2023-08-01', '2023-07-31', 16850.00, 16850.00, 5125.00, 11725.00, 0, 'PAGADO');
GO

-- Historial para crédito de Café Orgánico (obligacion_id = 11) - Con atraso reciente
INSERT INTO historial_pagos 
    (obligacion_id, numero_pago, fecha_programada, fecha_pago_real, monto_programado, monto_pagado, 
     monto_interes, monto_capital, dias_atraso_registrado, estatus_pago)
VALUES 
    (11, 1, '2023-10-10', '2023-10-10', 12450.00, 12450.00, 3312.50, 9137.50, 0, 'PAGADO'),
    (11, 2, '2023-11-10', '2023-11-15', 12450.00, 12450.00, 3280.00, 9170.00, 5, 'PAGADO_TARDE'),
    (11, 3, '2023-12-10', NULL, 12450.00, 0.00, 0.00, 0.00, 22, 'ATRASADO_1_29');
GO

PRINT 'Inserciones completadas exitosamente';
PRINT 'Total personas físicas: 5';
PRINT 'Total personas morales: 3';
PRINT 'Total obligaciones crediticias: 15';
PRINT 'Total registros de pagos: 28';
PRINT '';
PRINT 'API Key generada (guardar en lugar seguro):';
PRINT 'CB_live_9k7m2p4x8n6v5b3w1q0r';
PRINT 'Hash almacenado: 8f4e9a2c1d7b6f3e5a9c8d1f0b2e4a6c7d9f1e3b5a7c9e1d3f5b7a9c1e3d5f7b';
GO