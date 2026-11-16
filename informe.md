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

-`sucursal`: Se detectaron _132_ valores nulos.

`Regla N°5: No deben existir valores nulos en ningun campo o registro.`

## _Formato Fechas_

-`fecha_hora`: Se detectaron valores con formatos que difieren entre sí. - Existen _2316_ valores que utilizan un tipo de formato de fecha _YYYY-mm-dd_. - Existen _259_ valores que utilizan un tipo de formato de fecha _dd/mm/YYYY_.

`Regla N°6: El campo 'fecha_hora' debe estar estandarizado con un único formato de fecha válido (YYYY-mm-dd)`

## _Rangos y Formatos Númericos_

- `monto`: Se detectaron valores númericos menores a cero. También diferencias en los separadores que usan para identificar los decimales y miles.
  Ejemplo:
- Formato Valores
- 99.999,99 [87.484,74, 29.007,34, 67.900,91, 63.394,74, 8...]
- 99999.99 [80867.05, 91300.96, 19368.67, 60477.26, 26142...]

`Regla N°7: El campo 'monto' no puede contener valores númericos menores o iguales a cero`
`Regla N°8: El campo 'monto' debe estar estandarizado en un formato numérico ('.' como separador para decimales, sin separador para los miles).`
