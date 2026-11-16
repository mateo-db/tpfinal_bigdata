CREATE OR REPLACE TABLE raw_transacciones AS
SELECT *
FROM READ_CSV_AUTO('consultas/transacciones.csv');