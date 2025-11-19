-- ==========================================
-- BASE DE DATOS: CirculoCredito
-- API simulada que almacena historiales crediticios
-- ==========================================

IF NOT EXISTS (SELECT * FROM sys.databases WHERE name = 'CirculoCredito')
BEGIN
    CREATE DATABASE CirculoCredito;
END
GO

USE CirculoCredito;
GO

CREATE TABLE personas (
    id INT IDENTITY(1,1) PRIMARY KEY, 
    tipo_persona VARCHAR(10) CHECK (tipo_persona IN ('FISICA','MORAL')) NOT NULL,
    rfc VARCHAR(13) UNIQUE NOT NULL,
    email VARCHAR(150),
    telefono VARCHAR(15),
    direccion VARCHAR(500),
    estatus VARCHAR(20) DEFAULT 'ACTIVO' CHECK (estatus IN ('ACTIVO', 'INACTIVO', 'BLOQUEADO')),
    created_at DATETIME DEFAULT GETDATE(),
    updated_at DATETIME DEFAULT GETDATE(),

    CONSTRAINT CHK_RFC_TipoPersona CHECK (
        (tipo_persona = 'FISICA' AND LEN(rfc) = 13)
        OR
        (tipo_persona = 'MORAL' AND LEN(rfc) = 12)
    )
);
GO

-- Índices-
CREATE INDEX idx_personas_rfc ON personas(rfc);
CREATE INDEX idx_personas_tipo ON personas(tipo_persona);
GO

-- Tabla de extensión: personas_fisicas
CREATE TABLE personas_fisicas (
    persona_id INT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    apellido_paterno VARCHAR(100) NOT NULL,
    apellido_materno VARCHAR(100),
    curp VARCHAR(18) UNIQUE NOT NULL,
    fecha_nacimiento DATE,
    ingreso_mensual DECIMAL(10,2),
    ocupacion VARCHAR(100),
    estado_civil VARCHAR(20),
    
    CONSTRAINT FK_PF_Personas FOREIGN KEY (persona_id) 
        REFERENCES personas(id) ON DELETE CASCADE
);
GO

-- Índices --
CREATE INDEX idx_pf_curp ON personas_fisicas(curp);
GO

-- Tabla de extensión: personas_morales --
CREATE TABLE personas_morales (
    persona_id INT PRIMARY KEY,
    razon_social VARCHAR(200) NOT NULL,
    nombre_comercial VARCHAR(200),
    fecha_constitucion DATE,
    sector_economico VARCHAR(100),
    ingreso_anual DECIMAL(12,2),
    numero_empleados INT,
    representante_legal VARCHAR(200),
    
    CONSTRAINT FK_PM_Personas FOREIGN KEY (persona_id) 
        REFERENCES personas(id) ON DELETE CASCADE
);
GO


-- Tabla de obligaciones crediticias --


CREATE TABLE obligaciones_crediticias (
    id INT IDENTITY(1,1) PRIMARY KEY,
    numero_contrato VARCHAR(50) UNIQUE NOT NULL,
    persona_id INT NOT NULL,
    
    -- Información de la entidad otorgante
    entidad_otorgante VARCHAR(200) NOT NULL,
    clave_entidad VARCHAR(20),
    tipo_entidad VARCHAR(50), -- 'BANCO', 'FINTECH', 'SOFOM', etc.
    
    tipo_credito VARCHAR(50) NOT NULL CHECK (tipo_credito IN (
        'TARJETA_CREDITO',
        'CREDITO_PERSONAL',
        'CREDITO_AUTOMOTRIZ',
        'CREDITO_HIPOTECARIO',
        'CREDITO_EMPRESARIAL',
        'CREDITO_NOMINA',
        'PRESTAMO_QUIROGRAFARIO',
        'CREDITO_PYME'
    )),
    
    -- Montos y condiciones
    monto_original DECIMAL(15,2) NOT NULL,
    saldo_actual DECIMAL(15,2) NOT NULL DEFAULT 0,
    limite_credito DECIMAL(15,2), -- Solo para tarjetas/líneas de crédito
    tasa_interes DECIMAL(5,2),
    plazo_meses INT,
    pago_mensual_estimado DECIMAL(10,2),
    
    -- Fechas importantes
    fecha_solicitud DATE,
    fecha_apertura DATE NOT NULL,
    fecha_vencimiento DATE,
    fecha_cierre DATE,
    fecha_ultimo_pago DATE,
    
    -- Estado del crédito
    estatus_credito VARCHAR(20) DEFAULT 'VIGENTE' CHECK (estatus_credito IN (
        'VIGENTE',
        'VENCIDO',
        'CERRADO',
        'CANCELADO',
        'CARTERA_VENCIDA',
        'REESTRUCTURADO',
        'CASTIGADO'
    )),
    
    -- Métricas de riesgo
    dias_atraso INT DEFAULT 0,
    monto_vencido DECIMAL(15,2) DEFAULT 0,
    pagos_atrasados_totales INT DEFAULT 0,
    
    -- Auditoría
    created_at DATETIME DEFAULT GETDATE(),
    updated_at DATETIME DEFAULT GETDATE(),

    CONSTRAINT CHK_Saldo_Valido CHECK (saldo_actual <= monto_original),
    CONSTRAINT CHK_Fechas_Coherentes CHECK (
        fecha_vencimiento IS NULL OR fecha_vencimiento >= fecha_apertura
    ),
    
    CONSTRAINT FK_Obligaciones_Personas FOREIGN KEY (persona_id) 
        REFERENCES personas(id) ON DELETE CASCADE
);
GO

-- Índices importantes
CREATE INDEX idx_obligaciones_persona ON obligaciones_crediticias(persona_id);
CREATE INDEX idx_obligaciones_estatus ON obligaciones_crediticias(estatus_credito);
CREATE INDEX idx_obligaciones_fecha ON obligaciones_crediticias(fecha_apertura);
GO

-- ==========================================
-- HISTORIAL DE PAGOS
-- ==========================================

CREATE TABLE historial_pagos (
    id INT IDENTITY(1,1) PRIMARY KEY,
    obligacion_id INT NOT NULL,
    
    numero_pago INT NOT NULL, -- 1, 2, 3... del total de pagos
    fecha_programada DATE NOT NULL,
    fecha_pago_real DATE,
    
    monto_programado DECIMAL(10,2) NOT NULL,
    monto_pagado DECIMAL(10,2) DEFAULT 0,
    monto_interes DECIMAL(10,2) DEFAULT 0,
    monto_capital DECIMAL(10,2) DEFAULT 0,
    
    dias_atraso_registrado INT DEFAULT 0,
    estatus_pago VARCHAR(20) DEFAULT 'PENDIENTE' CHECK (estatus_pago IN (
        'AL_CORRIENTE',
        'PENDIENTE',
        'ATRASADO_1_29',
        'ATRASADO_30_59',
        'ATRASADO_60_89',
        'ATRASADO_90_PLUS',
        'PAGADO',
        'PAGADO_TARDE',
        'NO_PAGADO'
    )),
    
    notas VARCHAR(500),
    created_at DATETIME DEFAULT GETDATE(),
    
    CONSTRAINT FK_Pagos_Obligaciones FOREIGN KEY (obligacion_id) 
        REFERENCES obligaciones_crediticias(id) ON DELETE CASCADE
);
GO

CREATE INDEX idx_pagos_obligacion ON historial_pagos(obligacion_id);
CREATE INDEX idx_pagos_estatus ON historial_pagos(estatus_pago);
GO

-- ==========================================
-- CONSULTAS EXTERNAS (Tracking)
-- ==========================================

CREATE TABLE consultas_externas (
    id INT IDENTITY(1,1) PRIMARY KEY,
    persona_id INT NOT NULL,
    entidad_consultante VARCHAR(200) NOT NULL,
    tipo_consulta VARCHAR(50) CHECK (tipo_consulta IN (
        'CREDITO_NUEVO',
        'REVISION',
        'COBRANZA',
        'ACTUALIZACION'
    )),
    fecha_consulta DATETIME DEFAULT GETDATE(),
    
    CONSTRAINT FK_Consultas_Personas FOREIGN KEY (persona_id) 
        REFERENCES personas(id)
);
GO

CREATE INDEX idx_consultas_persona ON consultas_externas(persona_id);
CREATE INDEX idx_consultas_fecha ON consultas_externas(fecha_consulta);
GO

CREATE TABLE api_clients (
    id INT IDENTITY(1,1) PRIMARY KEY,
    nombre_entidad VARCHAR(200) NOT NULL,   
    api_key VARCHAR(100) UNIQUE NOT NULL,
    estatus VARCHAR(20) DEFAULT 'ACTIVO' 
        CHECK (estatus IN ('ACTIVO', 'INACTIVO', 'REVOCADO')),
    created_at DATETIME DEFAULT GETDATE()
);
GO

-- ==========================================
-- Vistas 
-- ==========================================
-- ==========================================
-- Vista 1: Resumen crediticio por RFC
-- Agregaciones básicas de obligaciones
-- ==========================================
CREATE OR ALTER VIEW vw_resumen_crediticio AS
SELECT 
    p.id AS persona_id,
    p.rfc,
    p.tipo_persona,
    p.estatus AS estatus_persona,
    p.email,
    p.telefono,
    p.created_at AS fecha_registro,

    COUNT(oc.id) AS total_obligaciones,
    SUM(CASE WHEN oc.estatus_credito = 'VIGENTE' THEN 1 ELSE 0 END) AS obligaciones_vigentes,
    SUM(CASE WHEN oc.estatus_credito = 'VENCIDO' THEN 1 ELSE 0 END) AS obligaciones_vencidas,
    SUM(CASE WHEN oc.estatus_credito = 'CERRADO' THEN 1 ELSE 0 END) AS obligaciones_cerradas,
    SUM(CASE WHEN oc.estatus_credito = 'CANCELADO' THEN 1 ELSE 0 END) AS obligaciones_canceladas,
    SUM(CASE WHEN oc.estatus_credito = 'CARTERA_VENCIDA' THEN 1 ELSE 0 END) AS obligaciones_cartera_vencida,
    SUM(CASE WHEN oc.estatus_credito = 'REESTRUCTURADO' THEN 1 ELSE 0 END) AS obligaciones_reestructuradas,

    ISNULL(SUM(oc.monto_original), 0) AS monto_total_original,
    ISNULL(SUM(oc.saldo_actual), 0) AS saldo_total_actual,
    ISNULL(SUM(oc.monto_vencido), 0) AS monto_total_vencido,
    ISNULL(SUM(oc.limite_credito), 0) AS limite_credito_total,

    ISNULL(MAX(oc.dias_atraso), 0) AS max_dias_atraso,
    ISNULL(SUM(oc.pagos_atrasados_totales), 0) AS total_pagos_atrasados,

    MIN(oc.fecha_apertura) AS fecha_credito_mas_antiguo,
    MAX(oc.fecha_apertura) AS fecha_credito_mas_reciente,
    
    CASE 
        WHEN MIN(oc.fecha_apertura) IS NOT NULL 
        THEN DATEDIFF(MONTH, MIN(oc.fecha_apertura), GETDATE())
        ELSE 0
    END AS meses_historial_crediticio

FROM personas p
LEFT JOIN obligaciones_crediticias oc ON oc.persona_id = p.id
GROUP BY 
    p.id, p.rfc, p.tipo_persona, p.estatus, p.email, p.telefono, p.created_at;
GO

-- ==========================================
-- Vista 2: Información completa de personas
-- Unifica persona física y moral
-- ==========================================
CREATE OR ALTER VIEW vw_persona_completa AS
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
        WHEN p.tipo_persona = 'FISICA' 
        THEN pf.nombre + ' ' + pf.apellido_paterno + ' ' + ISNULL(pf.apellido_materno, '')
        ELSE pm.razon_social
    END AS nombre_identificacion

FROM personas p
LEFT JOIN personas_fisicas pf ON pf.persona_id = p.id
LEFT JOIN personas_morales pm ON pm.persona_id = p.id;
GO

-- ==========================================
-- Vista 3: Detalle de obligaciones activas
-- Sin calificaciones ni interpretaciones
-- ==========================================
CREATE OR ALTER VIEW vw_detalle_obligaciones AS
SELECT 
    oc.id AS obligacion_id,
    oc.numero_contrato,
    oc.persona_id,
    p.rfc,
    p.tipo_persona,
    
    CASE 
        WHEN p.tipo_persona = 'FISICA' 
        THEN pf.nombre + ' ' + pf.apellido_paterno + ' ' + ISNULL(pf.apellido_materno, '')
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
    oc.tasa_interes,
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
        WHEN oc.monto_original > 0 
        THEN ROUND((oc.saldo_actual / oc.monto_original) * 100, 2)
        ELSE 0
    END AS porcentaje_deuda_original,
    
    CASE 
        WHEN oc.limite_credito IS NOT NULL AND oc.limite_credito > 0 
        THEN ROUND((oc.saldo_actual / oc.limite_credito) * 100, 2)
        ELSE NULL
    END AS porcentaje_utilizacion_limite,
    
    DATEDIFF(MONTH, oc.fecha_apertura, GETDATE()) AS meses_desde_apertura,
    
    CASE 
        WHEN oc.fecha_vencimiento IS NOT NULL 
        THEN DATEDIFF(MONTH, GETDATE(), oc.fecha_vencimiento)
        ELSE NULL
    END AS meses_hasta_vencimiento,
    
    oc.created_at,
    oc.updated_at

FROM obligaciones_crediticias oc
INNER JOIN personas p ON oc.persona_id = p.id
LEFT JOIN personas_fisicas pf ON pf.persona_id = p.id
LEFT JOIN personas_morales pm ON pm.persona_id = p.id;
GO

-- ==========================================
-- Vista 4: Historial detallado de pagos
-- Solo datos objetivos de comportamiento
-- ==========================================
CREATE OR ALTER VIEW vw_historial_pagos AS
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
        WHEN hp.fecha_programada <= GETDATE() 
        THEN DATEDIFF(DAY, hp.fecha_programada, GETDATE())
        ELSE 0
    END AS dias_desde_fecha_programada,
    
    CASE 
        WHEN hp.monto_programado > 0 
        THEN ROUND((hp.monto_pagado / hp.monto_programado) * 100, 2)
        ELSE 0
    END AS porcentaje_pagado,
    
    hp.monto_programado - hp.monto_pagado AS monto_pendiente,
    
    CASE WHEN hp.fecha_pago_real IS NOT NULL THEN 1 ELSE 0 END AS fue_pagado,
    CASE WHEN hp.fecha_pago_real > hp.fecha_programada THEN 1 ELSE 0 END AS fue_pago_tardio,
    
    hp.created_at

FROM historial_pagos hp
INNER JOIN obligaciones_crediticias oc ON hp.obligacion_id = oc.id
INNER JOIN personas p ON oc.persona_id = p.id;
GO

-- ==========================================
-- Vista 6: Pagos pendientes
-- ==========================================
CREATE OR ALTER VIEW vw_pagos_pendientes AS
SELECT 
    hp.id AS pago_id,
    hp.obligacion_id,
    oc.numero_contrato,
    oc.tipo_credito,
    
    p.id AS persona_id,
    p.rfc,
    p.tipo_persona,
    CASE 
        WHEN p.tipo_persona = 'FISICA' 
        THEN pf.nombre + ' ' + pf.apellido_paterno + ' ' + ISNULL(pf.apellido_materno, '')
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
        WHEN hp.fecha_programada <= GETDATE() 
        THEN DATEDIFF(DAY, hp.fecha_programada, GETDATE())
        ELSE 0
    END AS dias_atraso_calculado

FROM historial_pagos hp
INNER JOIN obligaciones_crediticias oc ON hp.obligacion_id = oc.id
INNER JOIN personas p ON oc.persona_id = p.id
LEFT JOIN personas_fisicas pf ON pf.persona_id = p.id
LEFT JOIN personas_morales pm ON pm.persona_id = p.id

WHERE hp.estatus_pago IN ('PENDIENTE', 'ATRASADO_1_29', 'ATRASADO_30_59', 
                          'ATRASADO_60_89', 'ATRASADO_90_PLUS')
  AND oc.estatus_credito IN ('VIGENTE', 'VENCIDO');
GO

-- ==========================================
-- Vista 7: Estadísticas de comportamiento de pago
-- Datos para análisis de patrones
-- ==========================================
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
    
    -- Porcentaje de cumplimiento
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

-- ==========================================
-- Roles 
-- ==========================================
CREATE ROLE rol_consulta_readonly;
CREATE ROLE rol_admin_escritura;
CREATE ROLE rol_auditor;
GO
-- ==========================================
-- Permisos por rol
-- ==========================================

-- Permisos readonly --
GRANT SELECT ON SCHEMA::dbo TO rol_consulta_readonly;
GRANT INSERT ON consultas_externas TO rol_consulta_readonly;
REVOKE SELECT ON api_clients FROM rol_consulta_readonly; 
GO

-- Permisos Admin --
GRANT SELECT, INSERT, UPDATE ON SCHEMA::dbo TO rol_admin_escritura;
REVOKE DELETE ON SCHEMA::dbo FROM rol_admin_escritura; 
REVOKE UPDATE ON api_clients FROM rol_admin_escritura; 
GRANT SELECT ON SCHEMA::dbo TO rol_auditor;
GO

-- Permisos Auditor
GRANT SELECT ON SCHEMA::dbo TO rol_auditor;
GO

-- ==========================================
-- Usuarios y asignación de roles
-- ==========================================

-- App api - - 
IF NOT EXISTS (SELECT * FROM sys.server_principals WHERE name = 'app_api')
    CREATE LOGIN app_api WITH PASSWORD = 'app_api';
GO

IF NOT EXISTS (SELECT * FROM sys.database_principals WHERE name = 'app_api')
    CREATE USER app_api FOR LOGIN app_api;
GO

EXEC sp_addrolemember 'rol_consulta_readonly', 'app_api';
GO

-- Admin --
IF NOT EXISTS (SELECT * FROM sys.server_principals WHERE name = 'app_admin')
    CREATE LOGIN app_admin WITH PASSWORD = 'app_admin_P@ssw0rd!';
GO

IF NOT EXISTS (SELECT * FROM sys.database_principals WHERE name = 'app_admin')
    CREATE USER app_admin FOR LOGIN app_admin;
GO

EXEC sp_addrolemember 'rol_admin_escritura', 'app_admin';
GO

-- Auditor --

IF NOT EXISTS (SELECT * FROM sys.server_principals WHERE name = 'app_auditor')
    CREATE LOGIN app_auditor WITH PASSWORD = 'app_auditor_P@ssw0rd!';
GO

IF NOT EXISTS (SELECT * FROM sys.database_principals WHERE name = 'app_auditor')
    CREATE USER app_auditor FOR LOGIN app_auditor;
GO

EXEC sp_addrolemember 'rol_auditor', 'app_auditor';
GO

PRINT 'Base de datos CirculoCredito creada exitosamente';
GO