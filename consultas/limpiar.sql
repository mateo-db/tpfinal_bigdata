-- en la transformacion se limpian los registros rechazados y se guardan en rechazados_limpios
CREATE OR REPLACE TABLE rechazados_limpios AS
SELECT DISTINCT
    TRIM(id_transaccion) AS id_transaccion,
    CASE
        WHEN fecha_hora LIKE '%/%' THEN TRY_STRPTIME(fecha_hora, '%d/%m/%Y %H:%M:%S')
        ELSE TRY_CAST(fecha_hora AS TIMESTAMP)
    END AS fecha_hora,
    CAST(id_cuenta AS INTEGER) AS id_cuenta,
    LOWER(TRIM(tipo)) AS tipo,
    ABS(CAST(
        CASE
            WHEN monto LIKE '%,%' THEN REPLACE(REPLACE(monto, '.', ''), ',', '.')
            ELSE monto
        END AS DOUBLE)) AS monto,
    UPPER(TRIM(moneda)) AS moneda,
    LOWER(TRIM(canal)) AS canal,
    id_sucursal,
    CASE id_sucursal
        WHEN 'S01' THEN 'Centro'
        WHEN 'S02' THEN 'Palermo'
        WHEN 'S03' THEN 'Belgrano'
        WHEN 'S04' THEN 'Caballito'
        WHEN 'S05' THEN 'La Plata'
    END AS sucursal,
    LOWER(TRIM(estado)) AS estado
FROM rechazados
WHERE id_transaccion NOT IN (SELECT id_transaccion FROM validos);