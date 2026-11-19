# Problemas Encontrados en Fuente (`transacciones.csv`) con Pandas y Reglas Establecidas por Caso

## _Tipos de datos_

- El campo `monto` es de tipo `str`, debería ser de tipo númerico.
- El campo `fecha_hora` es de tipo `str`, debería ser de tipo fecha válida (TIMESTAMP).

`Regla N°1: Cada campo debe ser del tipo correcto, respectivamente.`

## _Formato de Texto_

- `moneda`:
  - Formatos distintos para mismos valores (en mayúsculas y minúsculas).
  - Ejemplo: `ars` y `ARS`.
- `tipo`:
  - Formatos distintos para mismos valores (en mayúsculas y minúsculas).
  - Espacios en blanco, al principio y al final de los valores.
  - Ejemplo: ` EXTRACCION` y `extraccion`

`Regla N°2: Los valores del campo 'moneda' deben estar estandarizados (solo mayúsculas, o solo minúsculas).`

`Regla N°3: Los valores del campo 'tipo' deben estar estandarizados (solo mayúsculas, o solo minúsculas) y sin espacios en blanco al principio o al final.`

## _Duplicados_

- `id_transacción`: Se detectaron _75_ valores duplicados. Por lo analizado del CSV, esto se debe a registros de transacciones, que poseen cada uno un duplicado idéntico.

`Regla N°4: El campo 'id_transaccion' no puede contener valores duplicados.`

## _Valores nulos_

- `sucursal`: Se detectaron _132_ valores nulos.

`Regla N°5: No deben existir valores nulos en ningun campo o registro.`

## _Formato Fechas_

- `fecha_hora`: Se detectaron valores con formatos que difieren entre sí:
  - Existen _2316_ valores que utilizan un tipo de formato de fecha _YYYY-mm-dd_.
  - Existen _259_ valores que utilizan un tipo de formato de fecha _dd/mm/YYYY_.

`Regla N°6: El campo 'fecha_hora' debe estar estandarizado con un único formato de fecha válido (YYYY-mm-dd)`

## _Rangos y Formatos Númericos_

- `monto`: Se detectaron valores númericos menores a cero. También diferencias en los separadores que usan para identificar los decimales y miles. Ejemplo:

| Formato | Valores |
|---|---|
| 99.999,99 | 87.484,74 · 29.007,34 · 67.900,91 · 63.394,74 ... |
| 99999.99 | 80867.05 · 91300.96 · 19368.67 · 60477.26 ... |

`Regla N°7: El campo 'monto' no puede contener valores númericos menores o iguales a cero`

`Regla N°8: El campo 'monto' debe estar estandarizado en un formato numérico ('.' como separador para decimales, sin separador para los miles).`

## _Rechazos por Regla_

- Regla N°1: _0_
- Regla N°2: _121_
- Regla N°3: _197_
- Regla N°4: _150_
- Regla N°5: _118_
- Regla N°6: _241_
- Regla N°7: _94_
- Regla N°8: _145_

En total hay _1066_ registros rechazados y _1509_ válidos (total _2575_). 

## _Limpieza y Tabla Final_

- Duplicados: se deja una sola copia.
- Fechas: se pasan al formato YYYY-mm-dd.
- `tipo` y `moneda`: se quitan los espacios y se unifican mayúsculas y minúsculas.
- `monto`: se usa el punto como decimal y los negativos se pasan a positivo.
- `sucursal` vacía: se completa según el `id_sucursal`.

La `tabla_final` queda con _2500_ registros (_1509_ válidos y _991_ limpios), sin ids repetidos.

## _Preguntas de Negocio_

### ¿Cual es el monto total aprobado por tipo de operacion en ARS?
- depósito _$244.315.991,27_, pago de servicio _$215.817.670,08_, extracción _$214.557.718,96_, transferencia _$199.063.880,75_.
### ¿Cuantas transacciones hay por canal?
- web _646_, app _642_, cajero _620_, sucursal _592_.
### ¿Cual es la cuenta con mas movimientos?
- la _10092_, con _15_.
### ¿Que porcentaje de las transacciones fue rechazado por sucursal?
- Palermo _9,02%_, La Plata _8,87%_, Centro _8,60%_, Caballito _8,01%_, Belgrano _7,71%_.
### ¿Cuantas transacciones hubo por mes (primeros 6 meses)?
- enero _102_, febrero _99_, marzo _103_, abril _107_, mayo _113_, junio _101_ (2024, primeros 6 meses de los datos).

## _Ejecución_

Desde la carpeta del proyecto, con el entorno activado (`pip install -r requirements.txt`):

```bash
export AIRFLOW__CORE__DAGS_FOLDER=$(pwd)/dags
export AIRFLOW__DATABASE__SQL_ALCHEMY_CONN=sqlite:////tmp/airflow.db
airflow standalone
```
La segunda línea es solo en caso de que se ejecute la base de Airflow en un disco lento como el mío, evitando que las tareas fallen con error 409.
