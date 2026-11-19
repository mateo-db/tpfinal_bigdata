--monto total de transacciones aprobadas por tipo de operación en moneda ARS
SELECT
    tipo,
    SUM(monto) AS monto_total
FROM tabla_final
WHERE estado = 'aprobada'
AND moneda = 'ARS'
GROUP BY tipo;
--total transacciones por canal
SELECT
    canal,
    COUNT(id_transaccion) as total_transacciones
FROM tabla_final
GROUP BY canal;
--cuenta con más movimientos
SELECT
    id_cuenta,
    COUNT(id_transaccion) AS cant_movimientos
FROM tabla_final
GROUP BY id_cuenta
ORDER BY cant_movimientos DESC;
--porcentaje de rechazos hechos por cada sucursal
SELECT
    sucursal,
    COUNT(CASE WHEN estado = 'rechazada' THEN 1 END) * 100.0 / COUNT(*) AS porcentaje_rechazados
FROM tabla_final
WHERE sucursal IN ('Belgrano', 'Caballito', 'Palermo', 'Centro', 'La Plata')
GROUP BY sucursal;
--total transacciones por mes (primeros 6 meses)
SELECT
    DATE_TRUNC('month', fecha_hora) AS mes,
    COUNT(id_transaccion) as tot_transaccion
FROM tabla_final
WHERE fecha_hora BETWEEN
    TIMESTAMP '2025-01-01 00:00:00'
    AND TIMESTAMP '2025-06-30 23:59:59'
GROUP BY mes
ORDER BY mes ASC;
