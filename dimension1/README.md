# Dinámica de contagios

En el seguimiento de una epidemia existen dos aspectos muy importantes a considerar: La cantidad de personas enfermas o infectadas, que se denomina carga, y la transmisión. Ambos aspectos determinan la evolución en el tiempo de la epidemia y son fundamentales para establecer las medidas a seguir cuando no existen vacunas disponibles.

1. [Indicador de carga](https://github.com/datagovuc/ICOVID/tree/master/dimension1/carga)
2. [Indicador de transmisión](https://github.com/datagovuc/ICOVID/tree/master/dimension1/R)

## Descripción de los indicadores

### [Indicador de carga](https://github.com/datagovuc/ICOVID/tree/master/dimension1/carga)

Indicador de carga de personas infectadas es el promedio de incidencia diaria de los últimos siete días, calculado diariamente por 100 mil habitantes. El objetivo es que los casos nuevos disminuyan a menos de un caso por 100.000 habitantes.

Los archivos de datos carga ajustada (.csv) para este indicador cuentan con la variable fecha (en días), una variable identificadora de la unidad de análisis (region, provincia o servicio.salud según corresponda), una variable de carga.estimada que corresponde a la estimación del número de casos nuevos estimados por cada 100.000 habitantes, carga.liminf que corresponde al valor del intervalo de credibilidad en el percentil 2,75 para la estimación del número de casos nuevos estimados por cada 100.000 habitantes y  carga.lisup que corresponde al valor del intervalo de credibilidad en el percentil 97,5 de la estimación del del número de casos nuevos estimados por cada 100.000 habitantes. Este último valor es el utilizado para asignar un color en base a los umbrales definidos por ICOVID-Chile.

Se encuentran disponibles además los archivos de datos de carga sin ajustar por población para cada nivel que corresponde al número absoluto de nuevos casos por día (carga.nacional.csv, carga.regional.csv, carga.ss.csv, carga.provincial.csv)

### [Indicador de transmisión](https://github.com/datagovuc/ICOVID/tree/master/dimension1/R)

Número reproductivo efectivo diario (R(t)) calculado sobre la base de los últimos siete días con método desarrollado por Cori et al. (2013). El objetivo es que la transmisión representada por el promedio de los últimos siete días del número reproductivo efectivo sea menor a 0.8.

Los archivos de datos (.csv) para este indicador cuentan con la variable fecha (en días), una variable identificadora de la unidad de análisis (region, provincia o servicio.salud según corresponda), una variable de r.estimado que corresponde a la estimación puntual del R(t), r.liming que corresponde al valor del intervalo de credibilidad en el percentil 2,75 para la estimación del R(t) y  r.lisup que corresponde al valor del intervalo de credibilidad en el percentil 97,5 de la estimación del R(t). Este último valor es el utilizado para asignar un color en base a los umbrales definidos por ICOVID-Chile.

## Metodología
Más detalles sobre el cálculo de los indicadores puede encontrarse en [ICOVID-Chile](https://www.icovidchile.cl/metodologia-1)
