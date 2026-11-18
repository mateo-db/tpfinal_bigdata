-- La ruta del CSV se pasa como parámetro (?) desde pipeline.py,
-- así la lectura no depende de la carpeta desde donde se ejecuta el pipeline.
CREATE OR REPLACE TABLE raw_transacciones AS SELECT * FROM READ_CSV_AUTO(?);
