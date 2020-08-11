# Indicadores Capacidad Hospitalaria

El desconfinamiento de una región o país pasa por las posibilidades que el sistema de salud tenga para administrar una mayor cantidad de nuevos casos. Además, el seguimiento de la capacidad hospitalaria permite a los funcionarios de salud pública evaluar la capacidad de nuestro sistema de atención médica para tratar casos severos de COVID-19. Un indicador que usualmente se usa para monitorear la carga del sistema de salud es el porcentaje de camas UCI disponibles en la zona geográfica analizada. Complementariamente recomendamos monitorear la cantidad de pacientes en ventilación mecánica que no se encuentran en camas UCI, como una manera de seguir la pista a pacientes de mayor gravedad que el sistema de salud está teniendo dificultades en tratar.

 Dimensiones que se abordan:

- Preparación de la red asistencial para tratar nuevos casos.
- Renormalización de las actividades del sistema de salud.

Indicadores:

1. [Uso de camas UCI](https://github.com/ccuadradon/ICOVID/tree/master/dimension4/uci)
2. [Uso Covid-19 de camas UCI](https://github.com/ccuadradon/ICOVID/tree/master/dimension4/ucicovid)
3. [Pacientes en ventilación mecánica fuera de UCI](https://github.com/ccuadradon/ICOVID/tree/master/dimension4/varhosp)
4. [Tasa de variación semanal de hospitalizaciones totales Covid-19](https://github.com/ccuadradon/ICOVID/tree/master/dimension4/vmnouci)

## Descripción de los indicadores

### Uso de camas UCI

![equation](https://latex.codecogs.com/svg.latex?%5Ctext%7B%25%20Uso%20de%20camas%20UCI%20%28d%5C%27ia%20n%29%7D%20%3D%20100%20%5Ctimes%20%5Cfrac%7B%5Ctext%7BCantidad%20de%20camas%20UCI%20utilizadas%20en%20el%20d%5C%27ia%20n%7D%7D%7B%5Ctext%7BCantidad%20de%20camas%20disponibles%20en%20el%20d%5C%27ia%20n%7D%7D)

Un indicador que usualmente se usa para monitorear la sobrecarga de un sistema de salud es el del porcentaje de camas UCI disponibles en la zona geográfica analizada.  Este indicador se calcula a nivel nacional y regional. En el caso chileno, el modelo de gestión hospitalaria adoptado es a nivel nacional. Por esta razón, aunque el indicador considera información de camas disponibles a nivel regional, las cifras no necesariamente reflejan la realidad de dicha región dada la movilidad de pacientes entre hospitales y entre regiones. Los valores altos de este indicador sugieren una mayor carga de la pandemia y un sistema de salud menos preparado para que el servicio de salud, la región o país analizado retome sus actividades.

Para el cálculo de este indicador se usan los datos del [producto 48 del Github del MinCiencia](https://github.com/MinCiencia/Datos-COVID19/tree/master/output/producto48), el cual recoge la información recabada diariamente por la SOCHIMI. En el producto 48 se actualizan de manera diaria la cantidad de camas UCI utilizadas y la cantidad total de camas UCI disponibles en el sistema de salud, a nivel nacional, regional y de servicio de salud.

### Uso Covid-19 de camas UCI

![equation](https://latex.codecogs.com/svg.latex?%5Ctext%7B%25%20Uso%20Covid%2019%20de%20camas%20UCI%20d%5C%27ia%20n%7D%20%3D%20%5Cfrac%7B%5Ctext%7BCantidad%20de%20pacientes%20Covid19%20en%20UCI%20utilizadas%20en%20el%20d%5C%27ia%20n%7D%7D%7B%5Ctext%7BCantidad%20de%20camas%20UCI%7D%20%5Ctimes%20%281%20-%20max%28%5Ctext%7BTasa%20de%20ocupaci%5C%27on%20hist%5C%27orica%20de%20camas%20UCI%20%7D%20-%20%5Ctext%7Bfactor%20de%20descompensaci%5C%27on%7D%2C0%29%29%7D)

A diferencia del indicador precedente, este indicador sólo considera el uso de camas UCI por parte de pacientes Covid-19. Por esto, su objetivo es monitorear la sobrecarga del sistema de salud que puede atribuirse directamente a la pandemia. Además, dado que se considera la tasa historica nacional de utilización de camas UCI y las posibles postergaciones debidas al Covid-19 (factor de descompensación) en su cálculo, este indicador también da cuenta de la sobreexigencia excepcional debido a la pandemia. Los valores altos de este indicador sugieren una mayor carga de la pandemia y un sistema de salud menos preparado para que el servicio de salud, la región o país analizado retome sus actividades. Por otro lado, valores bajos dan indicios de un sistema de salud que está más cerca de retomar actividades no relacionadas con el Covid-19 y que actualmente están siendo relegadas.

Para el cálculo de este indicador se usan los datos de los productos [8](https://github.com/MinCiencia/Datos-COVID19/tree/master/output/producto8) y  [48](https://github.com/MinCiencia/Datos-COVID19/tree/master/output/producto48) del Github del MinCiencia. En el producto 48, el cual recoge la información recabada diariamente por la SOCHIMI, se actualizan de manera diaria la cantidad total de camas UCI disponibles. En el producto 8 se informan los pacientes Covid-19 hospitalizados en camas UCI. Dado que el producto 8 se informa sólo a nivel regional y no a nivel de servicio de salud, este indicador se calcula a nivel nacional y regional.

### Pacientes en ventilación mecánica invasiva (VMI) fuera de UCI

Este indicador es complementario a los relacionados con el uso de camas UCI y que ayuda a monitorear la saturación del sistema. Informa sobre la situación sólo a nivel de la Región Metropolitana. Los valores altos de este indicador sugieren un nivel de saturación alto y una situación de gran estrés del sistema hospitalario.

Los datos se obtienen de los resultados de la [encuesta SOCHIMI](https://github.com/jorgeperezrojas/covid19-data/blob/master/csv/encuesta_sochimi.csv)

### Tasa de variacón semanal de hospitalizaciones  totales COVID - 19

Su cálculo es como sigue:

![equation](https://latex.codecogs.com/svg.latex?%5Ctext%7BTasa%20de%20variaci%5C%27on%20semanal%20hospitalizaciones%20totales%20Covid%2019%20%28d%5C%27ia%20n%29%7D%20%3D%20%5Cfrac%7B%5Ctext%7Bmedia%20m%5C%27ovil%28d%5C%27ia%20n%29%7D%20-%20%5Ctext%7Bmedia%20m%5C%27ovil%28d%5C%27ia%20n%20-%207%29%7D%20%7D%7B%5Ctext%7Bmedia%20m%5C%27ovil%28d%5C%27ia%20n%20-%207%29%7D%7D)

En donde la media móvil es:

![equation](https://latex.codecogs.com/svg.latex?%5Ctext%7Bmedia%20m%5C%27ovil%28d%5C%27ia%20n%29%7D%20%3D%20%5Cdfrac%7B%5Csum_%7Bi%20%3D%20n%20-%202%7D%5E%7Bn%7D%20%5Ctext%7BCantidad%20de%20hospitalizaciones%20totales%20Covid%2019%20%28d%5C%27ia%20i%29%7D%7D%7B3%7D)

Este indicador mide la variación semanal en la carga hospitalaria de pacientes Covid-19 en todos los tipos de cama: básica, media, UTI y UCI. Se entiende por paciente en hospitalización la persona que cumple con los criterios de definición de caso sospechoso con una muestra positiva de SARS-CoV-2 que ha sido ingresado en el sistema integrado y reportado por la Unidad de Gestión Centralizada de Camas (UGCC). Los valores bajos y decrecientes indican que el sistema de salud está bajando su carga.

Para el cálculo de este indicador se utilizan los datos del [producto 24 del Github de MinCiencia](https://github.com/MinCiencia/Datos-COVID19/tree/master/output/producto24).

[Graficos](https://github.com/ccuadradon/ICOVID/tree/master/dimension4/Gr%C3%A1ficos)

Se recomienda descargar los gráficos en interactivos en el repositorio de Gráficos. A continuación se muestran los gráficos estáticos.

![Indicador 1](https://github.com/ccuadradon/ICOVID/blob/master/dimension4/Gr%C3%A1ficos/Indicador1Nacional.svg)

![Indicador 3](https://github.com/ccuadradon/ICOVID/blob/master/dimension4/Gr%C3%A1ficos/Indicador3.svg)

![Indicador 4](https://github.com/ccuadradon/ICOVID/blob/master/dimension4/Gr%C3%A1ficos/Indicador4.svg)

![Indicador 1](https://github.com/ccuadradon/ICOVID/blob/master/dimension4/Gr%C3%A1ficos/Indicador1.svg)

![Indicador 2](https://github.com/ccuadradon/ICOVID/blob/master/dimension4/Gr%C3%A1ficos/Indicador2.svg)
