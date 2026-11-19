import sys
from pathlib import Path

import pendulum
from airflow.sdk import dag, task

BASE_DIR = Path(__file__).resolve().parent.parent
sys.path.insert(0, str(BASE_DIR))

import pipeline


@dag(
    dag_id="pipeline_transacciones",
    schedule="0 2 * * *",
    start_date=pendulum.datetime(2026, 11, 1, tz="America/Argentina/Buenos_Aires"),
)
def pipeline_transacciones():

    @task
    def extraer():
        pipeline.extract()

    @task
    def validar():
        pipeline.validate()

    @task
    def limpiar():
        pipeline.clean()

    @task
    def unir():
        pipeline.unite()

    @task
    def preguntas():
        pipeline.question()

    extraccion = extraer()
    validacion = validar()
    limpieza = limpiar()
    union = unir()
    consultas = preguntas()

    extraccion >> validacion >> limpieza >> union >> consultas


pipeline_transacciones()
