# Detalles de Positividad de examenes PCR para casos sintomáticos/asintomáticos y BAC, provistos por ICOVID Chile. 

Este producto surge del trabajo colaborativo entre el Ministerio de Salud, el Ministerio de Ciencias, e investigadores del grupo ICOVID Chile (https://www.icovidchile.cl). El producto contiene información sobre la media movil de los último 7 días de la positividad de los examenes de PCR a SARS-CoV-2 detallados según dos condiciones de la persona a la que se le tomó el examen: según si era un caso sintomático o asintomático, y según si el caso es producto de la búsqueda activa de casos (BAC). La positividad está definida como la proporción de los test que resultan positivos, sobre el total de test efectuados ese día para personas con las condiciones expuestas. Por ejemplo, para el caso de positividad para personas asintomáticas se calcula como la cantidad de exámenes realizados a personas asintomáticas que resultaron positivos dividio por la cantidad total de exámenes realizados a personas asintomáticas.  

# Columnas y valores
El archivo `nacional/positividad_sintomas.csv` contiene la columna `fecha` que corresponde a la fecha en que el resultado fue informado a la autoridad, y las columnas `positividad_sintomatico` y `positividad_asintomatico` que indican la media movil de los último 7 días de la proporción de examenes positivos para casos sintomáticos y asintomáticos, respectivamente. Todos estos valores están separados entre sí por comas (csv). Similarmente, el archivo `nacional/positividad_bac.csv` contiene las columnas `fecha`, `positivdad_bac` y `positividad_no_bac` para pacientes según búsqueda activa de casos.

El archivo `regional/positividad_sintomas.csv` contiene la columna `codigo_region` y `region` indicando el código de la región y el nombre de la región de residencia de la persona a quien se le practicó el examen, además de las columnas `fecha`, `positividad_sintomatico` y `positividad_asintomatico` con el mismo significado explicado en el párrafo anterior pero para la región correspondiente. Similarmente el archivo `regional/positividad_bac.csv` contiene las columnas `codigo_region`, `region`, `fecha`, `positivdad_bac` y `positividad_no_bac` para pacientes según búsqueda activa de casos.

Existen cuatro archivos adicionales `provincial/positividad_sintomas.csv`, `provincial/positividad_bac.csv`, `ss/positividad_sintomas.csv` y `ss/positividad_bac.csv` con información de positividades al detalle de provincias y servicios de salud, respectivamente. En el primer caso los archivos tienen las columnas `codigo_provincia` y `provincia` indicando la información de la provincia de residencia, y en el segundo caso las columnas `codigo_ss` y `ss` indicando la información del servicio de salud correspondiente a la residencia de la persona a la que se le practicó el examen. 

# Fuente
Datos publicados periódicamente por el grupo ICOVID Chile (https://www.icovidchile.cl). 

# Frecuencia de actualización
Asociado a los informes epidemiológicos publicados por el Ministerio de Salud de Chile.

# Notas aclaratorias
(1) La información detallada de síntomas y de búsqueda activa se asocia a una notificación en los sistemas oficiales (Epivigila) y no necesariamente a una toma de muestra para exámenes. Por lo mismo la postividad está calculada sobre los exámenes practicados a personas que efectivamente se encuentran notificadas como caso en el sistema oficial.

(2) ICOVID Chiles es grupo interdisciplinario compuesto por investigadores e investigadoras de la Pontificia Universidad Católica de Chile, la Universidad de Chile, y la Universidad de Concepción. El cálculo de estas series se enmarca en un proyecto de colaboración entre el Ministerio de Salud de Chile, el Ministerio de Ciencia, Tecnología, Conocimiento e Innovación de Chile, las universidades mencionadas.