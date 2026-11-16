import duckdb
from pathlib import Path

# RUTAS
BASE_DIR = Path(__file__).resolve().parent
SQL_DIR = BASE_DIR / "consultas"
DATA_DIR = BASE_DIR / "consultas"
DB_PATH = BASE_DIR / "pipeline.duckdb"


def read_sql(filename: str):
    try:
        path = SQL_DIR / filename
        # Acá le damos la dirección de la carpeta y el archivo dentro de esa carpeta
        return path.read_text(encoding="UTF-8")
        # Retornamos el contenido del archivo SQL con codificación

    except Exception as e:
        print("Ocurrió un error al intentar leer el archivo SQL:", e)
        raise


def count(con, table):
    try:
        return con.execute(f'''
            SELECT COUNT(*) FROM {table}
        ''').fetchone()[0]
    except Exception as e:
        print("Ocurrió un error al contar:", e)
        raise


def extract():
    con = duckdb.connect(str(DB_PATH))
    try:
        print("###### EXTRACCIÓN ######")
        con.execute(read_sql(filename="extract.sql"))
        print("Valores extraídos:", count(con, "raw_transacciones"))
    except Exception as e:
        print("Ocurrió un error durante la extracción:", e)
        raise
    finally:
        con.close()


def validate():
    con = duckdb.connect(str(DB_PATH))
    try:
        print("###### VALIDACIÓN ######")
        con.execute(read_sql(filename="validar.sql"))
        print("Valores rechazados:", count(con, "rechazados"))
        print("Valores válidos:", count(con, "validos"))
    except Exception as e:
        print("Ocurrió un error durante la validación:", e)
        raise
    finally:
        con.close()


def clean():
    con = duckdb.connect(str(DB_PATH))
    try:
        print("###### LIMPIEZA ######")
        con.execute(read_sql(filename="limpiar.sql"))
        print("Valores rechazados limpiados:", count(con, "rechazados_limpios"))
    except Exception as e:
        print("Ocurrió un error durante la limpieza:", e)
        raise
    finally:
        con.close()


def unite():
    con = duckdb.connect(str(DB_PATH))
    try:
        print("###### UNIÓN DE VÁLIDOS Y RECHAZADOS LIMPIOS ######")
        con.execute(read_sql(filename="unir.sql"))
        print("Valores fusionados de válidos y rechazados limpios:", count(con, "tabla_final"))
    except Exception as e:
        print("Ocurrió un error durante la unión:", e)
        raise
    finally:
        con.close()


def question():
    con = duckdb.connect(str(DB_PATH))
    try:
        print("###### PREGUNTAS SOBRE TABLA FINAL ######")
        con.execute(read_sql(filename="preguntas.sql"))
    except Exception as e:
        print("Ocurrió un error al ejecutar las consultas:", e)
        raise
    finally:
        con.close()


import duckdb
import pandas as pd
from pathlib import Path

# RUTAS
BASE_DIR = Path(__file__).resolve().parent
SQL_DIR = BASE_DIR / "consultas"
DATA_DIR = BASE_DIR / "consultas"
DB_PATH = BASE_DIR / "pipeline.duckdb"


def read_sql(filename: str):
    try:
        path = SQL_DIR / filename
        # Acá le damos la dirección de la carpeta y el archivo dentro de esa carpeta
        return path.read_text(encoding="UTF-8")
        # Retornamos el contenido del archivo SQL con codificación

    except Exception as e:
        print("Ocurrió un error al intentar leer el archivo SQL:", e)
        raise


def count(con, table):
    try:
        return con.execute(f'''
            SELECT COUNT(*) FROM {table}
        ''').fetchone()[0]

    except Exception as e:
        print("Ocurrió un error al contar:", e)
        raise


def extract():
    con = duckdb.connect(str(DB_PATH))

    try:
        print("\n###### EXTRACCIÓN ######")
        con.execute(read_sql(filename="extract.sql"))
        print("Valores extraídos:", count(con, "transacciones_raw"))

    except Exception as e:
        print("Ocurrió un error durante la extracción:", e)
        raise

    finally:
        con.close()


def validate():
    con = duckdb.connect(str(DB_PATH))

    try:
        print("\n###### VALIDACIÓN ######")
        con.execute(read_sql(filename="validar.sql"))
        print("Valores rechazados:", count(con, "rechazados"))
        print("Valores válidos:", count(con, "validos"))

    except Exception as e:
        print("Ocurrió un error durante la validación:", e)
        raise

    finally:
        con.close()


def clean():
    con = duckdb.connect(str(DB_PATH))

    try:
        print("\n###### LIMPIEZA ######")
        con.execute(read_sql(filename="limpiar.sql"))
        print("Valores rechazados limpiados:", count(con, "rechazados_limpios"))

    except Exception as e:
        print("Ocurrió un error durante la limpieza:", e)
        raise

    finally:
        con.close()


def unite():
    con = duckdb.connect(str(DB_PATH))

    try:
        print("\n###### UNIÓN DE VÁLIDOS Y RECHAZADOS LIMPIOS ######")
        con.execute(read_sql(filename="unir.sql"))
        print("Valores fusionados de válidos y rechazados limpios:", count(con, "tabla_final"))

    except Exception as e:
        print("Ocurrió un error durante la unión:", e)
        raise

    finally:
        con.close()


def question():
    con = duckdb.connect(str(DB_PATH))

    try:
        print("\n###### PREGUNTAS SOBRE TABLA FINAL ######")
        con.execute(read_sql(filename="preguntas.sql"))

    except Exception as e:
        print("Ocurrió un error al ejecutar las consultas:", e)
        raise

    finally:
        con.close()


# EJECUCIÓN MANUAL DEL PIPELINE
def main():
    try:
        extract()
        validate()
        clean()
        unite()
        question()
    except Exception as e:
        print("Error:", e)
        raise


if __name__ == "__main__":
    main()
