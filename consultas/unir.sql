-- en la exportacion se unen validos y rechazados_limpios en tabla_final con los tipos correctos
CREATE OR REPLACE TABLE tabla_final AS
SELECT
    id_transaccion,
    CAST(fecha_hora AS TIMESTAMP) AS fecha_hora,
    CAST(fecha_hora AS DATE) AS fecha,
    CAST(id_cuenta AS INTEGER) AS id_cuenta,
    tipo,
    CAST(monto AS DOUBLE) AS monto,
    moneda,
    canal,
    id_sucursal,
    sucursal,
    estado
FROM validos
UNION
SELECT
    id_transaccion,
    fecha_hora,
    CAST(fecha_hora AS DATE) AS fecha,
    id_cuenta,
    tipo,
    monto,
    moneda,
    canal,
    id_sucursal,
    sucursal,
    estado
FROM rechazados_limpios
ORDER BY id_transaccion;