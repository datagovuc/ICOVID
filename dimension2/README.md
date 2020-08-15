# Capacidad de testeo

La capacidad de testeo permite identificar nuevos casos de personas con COVID-19 en Chile. Los indicadores que a continuación se presentan deben ser interpretados considerando el grupo de indicadores completo. La interpretación correcta dependerá de las condiciones de aplicación de los test (por ejemplo: tasa por habitante, testeo sólo a sintomáticos y coberturas homogéneas en una zona determinada) y de las condiciones globales en el desarrollo de la epidemia.

1. [Positividad de los test PCR](https://github.com/datagovuc/ICOVID/tree/master/dimension2/positividad)
2. [Número de test diarios por mil de habitantes](https://github.com/datagovuc/ICOVID/tree/master/dimension2/tasatest)

## Descripción de los indicadores

### [Positividad de los test PCR](https://github.com/datagovuc/ICOVID/tree/master/dimension2/positividad)

La positividad de los casos está definida como la proporción de los test que resultan positivos para COVID-19 en un día con respecto al total de test para COVID-19 efectuados ese día (test positivos / test totales) en una localidad determinada. El ideal es alcanzar una proporción igual o menor a 3 por ciento de test positivos sobre el total de test efectuados. Se recomienda mantener una proporción de 3 por ciento o menos de casos positivos al menos durante 14 días, asumiendo una vigilancia epidemiológica adecuada. Este es el indicador principal de la dimensión.

Los archivos de datos de positividad (.csv) para este indicador cuentan con la variable fecha (en días), dos variables identificadora de la unidad de análisis (region_residencia, provincia_residencia o comuna_residencia según corresponda), una en formato string y otra en formato numérico utilizando códigos estándar para Chile. La variable positividad indica la proporción de test tomados en ese día que resultaron positivos sobre el total de test realizados. 

### [Número de test semanales por mil habitantes](https://github.com/datagovuc/ICOVID/tree/master/dimension2/tasatest)

El número de test informados corresponde a la media móvil semanal de test realizados en el área geográfica de residencia de la persona a la que se le solicita el examen. Se propone que se realice al menos un test cada mil habitantes por semana en cada localidad determinada (país, región, provincia, servicio de salud y comuna). Este umbral está definido considerando una vigilancia epidemiológica integral, enfocada en testeo a casos sospechosos y a sus contactos directos (por lo tanto, no a testeo aleatorio). Los resultados de cada test debiesen ser informados en menos de 24 horas. Se utiliza como indicador secundario para esta dimensión.

Los archivos de datos de tasa de test semanal (.csv) para este indicador cuentan con la variable fecha (en días), dos variables identificadora de la unidad de análisis (region_residencia, provincia_residencia o comuna_residencia según corresponda), una en formato string y otra en formato numérico utilizando códigos estándar para Chile. La variable tasatest indica la proporción de test tomados en ese día que resultaron positivos sobre el total de test realizados. 

Se encuentran disponibles además archivos en que a tasa de test se entrega de manera diaria, sin realizar una sumatoria de los últimos 7 días (tasa test nacional.csv, tasa test regional.csv, tasa test provincial.csv. tasa test comunal. csv).

## Metodología
Más detalles sobre el cálculo de los indicadores puede encontrarse en [ICOVID-Chile](https://www.icovidchile.cl/metodologia-1)
