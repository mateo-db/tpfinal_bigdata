CREATE OR REPLACE TABLE rechazados AS
SELECT *,
    CASE
        WHEN 
            TRY_CAST(REPLACE(monto, ',', '.') AS DOUBLE) IS NULL 
        THEN 
            'No se pudo convertir a númerico con punto como separador de decimal'
        WHEN 
            try_strptime(fecha_hora, '%Y-%m-%d %H:%M:%S') IS NULL
        THEN 
            'No se pudo interpretar cadena de texto con formato %Y-%m-%d %H:%M:%S'
        WHEN 
            try_strptime(fecha_hora, '%d-%m-%Y %H:%M:%S') IS NULL
        THEN 
            'No se pudo interpretar cadena de texto con formato %d-%m-%Y %H:%M:%S'
        WHEN 
            sucursal IS NULL
        THEN 
            'El valor fue detectado como NULL'
        WHEN 
            UPPER(moneda) NOT IN ('ARS', 'USD')
        THEN 
            'No se pudo convertir a mayúsculas'
        WHEN 
            LOWER(tipo) NOT IN ('deposito', 'extraccion', 'transferencia', 'pago_servicio')
        THEN 
            'No se pudo convertir a minúsculas'
        WHEN 
            TRIM(tipo) NOT IN ('deposito', 'extraccion', 'transferencia', 'pago_servicio')
        THEN 
            'No se pudo eliminar espacios en blanco'
        WHEN 
            id_transaccion IN (SELECT id_transaccion FROM transacciones_raw GROUP BY id_transaccion HAVING COUNT(*) > 1)
        THEN 
            'Registro duplicado'
        WHEN 
            TRY_CAST(monto AS DOUBLE) <= 0
        THEN 
            'Valor númerico menor o igual a cero'
        ELSE 'Motivo desconocido'
    END AS motivo_rechazo
FROM transacciones_raw WHERE
TRY_CAST(REPLACE(monto, ',', '.') AS DOUBLE) IS NULL
OR sucursal IS NULL 
OR try_strptime(fecha_hora, '%Y-%m-%d %H:%M:%S') IS NULL
OR try_strptime(fecha_hora, '%d-%m-%Y %H:%M:%S') IS NULL
OR UPPER(moneda) NOT IN ('ARS', 'USD')
OR LOWER(tipo) NOT IN ('deposito', 'extraccion', 'transferencia', 'pago_servicio')
OR TRIM(tipo) NOT IN ('deposito', 'extraccion', 'transferencia', 'pago_servicio')
OR id_transaccion IN (
    SELECT id_transaccion
    FROM transacciones_raw
    GROUP BY id_transaccion
    HAVING COUNT(*) > 1
)
OR TRY_CAST(monto AS DOUBLE) <= 0

CREATE AND REPLACE TABLE validos AS
SELECT * FROM transacciones_raw WHERE
TRY_CAST(REPLACE(monto, ',', '.') AS DOUBLE) IS NOT NULL
AND sucursal IS NOT NULL 
AND try_strptime(fecha_hANDa, '%Y-%m-%d %H:%M:%S') IS NOT NULL
AND try_strptime(fecha_hANDa, '%d-%m-%Y %H:%M:%S') IS NOT NULL
AND UPPER(moneda) IN ('ARS', 'USD')
AND LOWER(tipo) IN ('deposito', 'extraccion', 'transferencia', 'pago_servicio')
AND TRIM(tipo) IN ('deposito', 'extraccion', 'transferencia', 'pago_servicio')
AND id_transaccion NOT IN (
    SELECT id_transaccion
    FROM transacciones_raw
    GROUP BY id_transaccion
    HAVING COUNT(*) > 1
)
AND TRY_CAST(monto AS DOUBLE) > 0
