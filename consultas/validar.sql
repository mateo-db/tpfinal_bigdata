CREATE OR REPLACE TABLE rechazados AS
SELECT *,
    CASE
        WHEN id_transaccion IN (
            SELECT id_transaccion
            FROM raw_transacciones
            GROUP BY id_transaccion
            HAVING COUNT(*) > 1
        )
        THEN 'id_transaccion duplicado'
        WHEN id_transaccion IS NULL OR fecha_hora IS NULL OR id_cuenta IS NULL
            OR tipo IS NULL OR monto IS NULL OR moneda IS NULL OR canal IS NULL
            OR id_sucursal IS NULL OR sucursal IS NULL OR estado IS NULL
        THEN 'campo con valor nulo'
        WHEN TRY_STRPTIME(fecha_hora, '%Y-%m-%d %H:%M:%S') IS NULL
        THEN 'fecha_hora no cumple el formato YYYY-mm-dd HH:MM:SS'
        WHEN monto LIKE '%,%'
        THEN 'monto con formato numérico no estandarizado'
        WHEN TRY_CAST(monto AS DOUBLE) IS NULL
        THEN 'monto no es numérico'
        WHEN TRY_CAST(monto AS DOUBLE) <= 0
        THEN 'monto menor o igual a cero'
        WHEN moneda NOT IN ('ARS', 'USD')
        THEN 'moneda no estandarizada'
        WHEN tipo NOT IN ('deposito', 'extraccion', 'transferencia', 'pago_servicio')
        THEN 'tipo no estandarizado'
    END AS motivo_rechazo
FROM raw_transacciones
WHERE
    id_transaccion IN (
        SELECT id_transaccion
        FROM raw_transacciones
        GROUP BY id_transaccion
        HAVING COUNT(*) > 1
    )
    OR id_transaccion IS NULL OR fecha_hora IS NULL OR id_cuenta IS NULL
    OR tipo IS NULL OR monto IS NULL OR moneda IS NULL OR canal IS NULL
    OR id_sucursal IS NULL OR sucursal IS NULL OR estado IS NULL
    OR TRY_STRPTIME(fecha_hora, '%Y-%m-%d %H:%M:%S') IS NULL
    OR monto LIKE '%,%'
    OR TRY_CAST(monto AS DOUBLE) IS NULL
    OR TRY_CAST(monto AS DOUBLE) <= 0
    OR moneda NOT IN ('ARS', 'USD')
    OR tipo NOT IN ('deposito', 'extraccion', 'transferencia', 'pago_servicio');

CREATE OR REPLACE TABLE validos AS
SELECT *
FROM raw_transacciones
WHERE id_transaccion NOT IN (SELECT id_transaccion FROM rechazados);
