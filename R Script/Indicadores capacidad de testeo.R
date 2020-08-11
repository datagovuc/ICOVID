
############################################################################################
########## Positividad examenes PCR y tasa por región, provincia y comuna ##################
########## Cuadrado C. Escuela de Salud Pública. Universidad de Chile     ##################
########## v1 Last Update: Agosto 4, 2020                                 ##################
############################################################################################

# Load packages
if (!require("pacman")) install.packages("pacman")
pacman::p_load(readr, dplyr, ggplot2, haven, tidyquant, ggsci, readxl, stringr, stringi)

###################################################################################
## Directorio de trabajo
###################################################################################
setwd()

###################################################################################
## Datos
###################################################################################

# Load data
datos.epi <- read_delim(file = '20200802_Epivigila.csv', delim = "|")
data <- read_delim(file = '~20200802_Laboratorio.csv', delim = "|")

summary(datos.epi)
summary(data)

matchgeo <- read_excel("Match comuna -provincia - region.xls")
matchgeo <- matchgeo %>% rename(comuna_residencia=`Nombre Comuna`,
                                provincia_residencia=`Nombre Provincia`,
                                codigo_comuna=`Código Comuna 2017`,
                                codigo_provincia=`Código Provincia`,
                                codigo_region=`Código Región`)

poblacion <- read_excel("poblacion.xlsx")
poblacion <- poblacion %>% rename(codigo_comuna=Comuna, codigo_provincia=Provincia, codigo_region=Codigo.region, pob=`2020`) %>% 
              dplyr::select(codigo_comuna,codigo_provincia,codigo_region,pob)

poblacion.comuna <- poblacion %>% group_by(codigo_comuna) %>% summarise(pob=sum(pob, na.rm=T))
poblacion.provincia <- poblacion %>% group_by(codigo_provincia) %>% summarise(pob=sum(pob, na.rm=T))
poblacion.region <- poblacion %>% group_by(codigo_region) %>% summarise(pob=sum(pob, na.rm=T))
  
# # Fix date data
## Fomarting dates
datos.epi <- datos.epi %>%
  mutate(fecha_primeros_sintomas = as.Date(fecha_primeros_sintomas, format = "%m/%d/%Y"),
         fecha_notificacion = as.Date(fecha_notificacion, format = "%m/%d/%Y"),
         fecha_fallecimiento = as.Date(fecha_fallecimiento, format = "%m/%d/%Y"),
         fecha_ingreso_hospital = as.Date(fecha_ingreso_hospital, format = "%m/%d/%Y"),
         fecha_egreso_hospital = as.Date(fecha_egreso_hospital, format = "%m/%d/%Y"))

data <- data %>%
  mutate(Fechatomademuestra = as.Date(Fechatomademuestra, format = "%m/%d/%Y"),
         FechadeResultado = as.Date(FechadeResultado, format = "%m/%d/%Y"),
         Fechadecorreo = as.Date(Fechadecorreo, format = "%m/%d/%Y"))

summary(data$Fechatomademuestra)
summary(data$FechadeResultado)
summary(data$Fechadecorreo)
summary(datos.epi$fecha_notificacion)
summary(datos.epi$fecha_primeros_sintomas)

# Round date data to day level
data$Fechatomademuestra <- round_date(data$Fechatomademuestra, "day")
data$FechadeResultado <- round_date(data$FechadeResultado, "day")
data$Fechadecorreo <- round_date(data$Fechadecorreo, "day")

# Fix string data
datos.epi$sintomas <- ifelse(datos.epi$sintomas=="", NA, datos.epi$sintomas)

# Fix id data
datos.epi$id <- as.integer(datos.epi$id)
data$id <- as.integer(data$id)

# Match comuna - provincia

## Estandarizar texto comuna
matchgeo$comuna_residencia <- tolower(str_replace_all(matchgeo$comuna_residencia, "[[:punct:]]", " "))
matchgeo$comuna_residencia <- stringi::stri_trans_general(matchgeo$comuna_residencia,"Latin-ASCII")
datos.epi$comuna_residencia <- tolower(str_replace_all(datos.epi$comuna_residencia, "[[:punct:]]", " "))
datos.epi$comuna_residencia <- stringi::stri_trans_general(datos.epi$comuna_residencia,"Latin-ASCII")

### Formato equivalente para comunas con variaciones
matchgeo$comuna_residencia <- ifelse(matchgeo$comuna_residencia=="coihaique","coyhaique",
                                     matchgeo$comuna_residencia)
matchgeo$comuna_residencia <- ifelse(matchgeo$comuna_residencia=="concon","con con",
                                     matchgeo$comuna_residencia)

### Formato equivalente para regiones

# Explorar categorias región
table(matchgeo$`Nombre Región`)
table(datos.epi$region_residencia)
table(data$region_toma_muestra)

# Cambiar desconocido por NA
datos.epi$region_residencia <- ifelse(datos.epi$region_residencia=="Desconocido", NA, datos.epi$region_residencia)

# Cambiar formato región con error ortográfico
data$region_toma_muestra <- ifelse(data$region_toma_muestra=="Región de Aysén del General Carlos Ibañes del Campo",
                                   "Región de Aysén del General Carlos Ibáñez del Campo",
                                   data$region_toma_muestra)

# Mismo formato
matchgeo$`Nombre Región` <- ifelse(matchgeo$`Nombre Región`=="Antofagasta","Región de Antofagasta",
                                     matchgeo$`Nombre Región`)
matchgeo$`Nombre Región` <- ifelse(matchgeo$`Nombre Región`=="Arica y Parinacota","Región de Arica y Parinacota",
                                     matchgeo$`Nombre Región`)
matchgeo$`Nombre Región` <- ifelse(matchgeo$`Nombre Región`=="Atacama","Región de Atacama",
                                   matchgeo$`Nombre Región`)
matchgeo$`Nombre Región` <- ifelse(matchgeo$`Nombre Región`=="Aysén del General Carlos Ibáñez del Campo","Región de Aysén del General Carlos Ibañez del Campo",
                                   matchgeo$`Nombre Región`)
matchgeo$`Nombre Región` <- ifelse(matchgeo$`Nombre Región`=="Biobío","Región del Biobío",
                                   matchgeo$`Nombre Región`)
matchgeo$`Nombre Región` <- ifelse(matchgeo$`Nombre Región`=="Coquimbo","Región de Coquimbo",
                                   matchgeo$`Nombre Región`)
matchgeo$`Nombre Región` <- ifelse(matchgeo$`Nombre Región`=="La Araucanía","Región de la Araucanía",
                                   matchgeo$`Nombre Región`)
matchgeo$`Nombre Región` <- ifelse(matchgeo$`Nombre Región`=="Libertador General Bernardo O'Higgins","Región del Libertador General Bernardo OHiggins",
                                   matchgeo$`Nombre Región`)
matchgeo$`Nombre Región` <- ifelse(matchgeo$`Nombre Región`=="Los Lagos","Región de Los Lagos",
                                   matchgeo$`Nombre Región`)
matchgeo$`Nombre Región` <- ifelse(matchgeo$`Nombre Región`=="Los Ríos","Región de Los Ríos",
                                   matchgeo$`Nombre Región`)
matchgeo$`Nombre Región` <- ifelse(matchgeo$`Nombre Región`=="Magallanes y de la Antártica Chilena","Región de Magallanes y la Antártica Chilena",
                                   matchgeo$`Nombre Región`)
matchgeo$`Nombre Región` <- ifelse(matchgeo$`Nombre Región`=="Maule","Región del Maule",
                                   matchgeo$`Nombre Región`)
matchgeo$`Nombre Región` <- ifelse(matchgeo$`Nombre Región`=="Metropolitana de Santiago","Región Metropolitana de Santiago",
                                   matchgeo$`Nombre Región`)
matchgeo$`Nombre Región` <- ifelse(matchgeo$`Nombre Región`=="Ñuble","Región del Ñuble",
                                   matchgeo$`Nombre Región`)
matchgeo$`Nombre Región` <- ifelse(matchgeo$`Nombre Región`=="Tarapacá","Región de Tarapacá",
                                   matchgeo$`Nombre Región`)
matchgeo$`Nombre Región` <- ifelse(matchgeo$`Nombre Región`=="Valparaíso","Región de Valparaíso",
                                   matchgeo$`Nombre Región`)

# Explorar categorias región
table(matchgeo$`Nombre Región`)
table(datos.epi$region_residencia)
table(data$region_toma_muestra)

### Transformar a NA los desconocidos o "" 
datos.epi$comuna_residencia <- ifelse(datos.epi$comuna_residencia=="desconocido", NA,
                                      datos.epi$comuna_residencia)
datos.epi$comuna_residencia <- ifelse(datos.epi$comuna_residencia=="", NA,
                                      datos.epi$comuna_residencia)

### Tratar codigos como numeric
matchgeo$codigo_comuna <- as.integer(matchgeo$codigo_comuna)
matchgeo$codigo_provincia <- as.integer(matchgeo$codigo_provincia)
matchgeo$codigo_region <- as.integer(matchgeo$codigo_region)

## Match
datos.epi <- left_join(datos.epi , matchgeo, by="comuna_residencia")

## Identificar casos por búsqueda activa
datos.ba <- datos.epi %>% filter(etapa_clinica=="BUSQUEDA A")

## Validar que NA de comuna y provincia sean los mismos
table(is.na(datos.epi$comuna_residencia))                                              
table(is.na(datos.epi$provincia_residencia))  # Misma cantidad de NA para provincia y comuna

###################################################################################
## Deduplicación examenes
###################################################################################

# Deduplicación de misma fecha de muestra y resultado para el mismo id. 
# Elegimos una sola observación para cada test repetido (mismo id, misma fecha de toma de muestra y resultado)
length(unique(data$id))
data <- data %>% group_by(id,  Fechadecorreo, resul) %>%
                  slice(which.min(Fechatomademuestra)) %>%
                  filter(row_number()==1)
length(unique(data$id))

# Deduplicar variables de residencia con una observación por id en la base de epi
# Seleccionamos la fecha de toma de muestra más reciente para cada id
# Dejamos los datos de residencia más repetidos en casos con múltiples entradas
length(unique(datos.epi$id))
datos.epi <- datos.epi %>%  group_by(id, region_residencia, provincia_residencia, comuna_residencia) %>%
                            slice(which.max(fecha_notificacion)) %>%
                            group_by(id) %>%
                            filter(row_number()==1) %>% 
                            dplyr::select(id, region_residencia, provincia_residencia, comuna_residencia, codigo_comuna, codigo_provincia, codigo_region)
length(unique(datos.epi$id))

# Merge de base de labs con datos de residencia (región y provincia)
data <- left_join(data, datos.epi, by="id")

###################################################################################
## Fix región de residencia y variable resultado
###################################################################################

# Reemplazar región de residencia por región de toma de muestra en casos sin región conocida
table(is.na(data$region_residencia))
table(is.na(data$region_toma_muestra))
data$region_residencia <- ifelse(is.na(data$region_residencia), data$region_toma_muestra, data$region_residencia)
table(is.na(data$region_residencia))

# Imputar código de región en los faltantes
table(is.na(data$codigo_region))
table(is.na(data$region_toma_muestra))

match.reg <- unique(matchgeo %>% dplyr::select(`Nombre Región`, codigo_region) %>% 
                      rename(codigo_region2=codigo_region, region_residencia=`Nombre Región`))

data <- left_join(data,match.reg)
data$codigo_region <- ifelse(is.na(data$codigo_region), data$codigo_region2, data$codigo_region) 
data$codigo_region2 <- NULL
data$codigo_region <- ifelse(is.na(data$codigo_region) & data$region_residencia=="Región de Aysén del General Carlos Ibáñez del Campo", 
                                   11, data$codigo_region) 
data$codigo_region <- ifelse(data$region_residencia=="Región de Los Ríos", 
                             14, data$codigo_region) 
table(is.na(data$codigo_region))
table(is.na(data$region_residencia))

# Pasar de 3 categorías a 2 categorías resultado (1==positivo)
table(data$resul)
data$resul <- ifelse(data$resul=="POSITIVO",1,0)
table(data$resul)

###################################################################################
## Cálculo de series de positividad
###################################################################################

# Serie Nacional
pos.data.toma <- data %>% group_by(Fechatomademuestra, resul) %>% 
                  dplyr::select(Fechatomademuestra, resul) %>%
                  count(Fechatomademuestra, resul) %>%
                  group_by(Fechatomademuestra) %>%
                  mutate(freq = n / sum(n)) %>%
                  mutate(fecha=Fechatomademuestra) %>%
                  ungroup() %>%
                  dplyr::select(-Fechatomademuestra) 

# Save
pos.data.icovid <- pos.data.toma %>% filter(resul==1 & fecha>as.Date("2020-03-01") & fecha<as.Date(max(data$Fechadecorreo, na.rm = T))) %>% arrange(fecha) %>%
  mutate(positividad=zoo::rollapply(freq,7,mean,align='right',fill=NA)) %>% dplyr::select(fecha, positividad) 
write_csv(pos.data.icovid, "~/Documents/GitHub/ICOVID/dimension2/positividad/nacional/Positividad nacional.csv")

# Serie data regional 
pos.data.reg <- data %>% group_by(Fechatomademuestra, codigo_region, region_residencia, resul) %>% 
                      dplyr::select(id, Fechatomademuestra, codigo_region, region_residencia, resul) %>%
                      filter(!is.na(region_residencia)) %>%
                      summarise (n = n()) %>%
                      mutate(freq = n / sum(n)) %>% 
                      group_by(codigo_region, region_residencia, resul) %>% 
                      complete(Fechatomademuestra = seq.Date(min(Fechatomademuestra, na.rm = T), max(Fechatomademuestra, na.rm = T), by="day")) %>%
                      mutate(fecha=Fechatomademuestra) %>%
                      ungroup() %>%
                      group_by(fecha, codigo_region) %>% 
                      mutate(na_num = ifelse(is.na(sum(n)),sum(is.na(n)),0), # Identificamos verdaderos NA (na_num==2)
                             freq=ifelse(is.na(freq) & na_num==1, 0, freq), # Reemplazar NAs por 0 cuando correspon (na_num==1)
                             n=ifelse(is.na(n) & na_num==1, 0, n)) %>% # Reemplazar NAs por 0 cuando correspon (na_num==1)
                      dplyr::select(-Fechatomademuestra, -na_num)  %>%
                      ungroup() %>%
                      arrange(region_residencia, fecha, resul)

# Save
pos.data.reg.icovid <- pos.data.reg %>% filter(resul==1 & fecha>as.Date("2020-03-01") & fecha<as.Date(max(data$Fechadecorreo, na.rm = T))) %>% 
                                        group_by(region_residencia) %>% arrange(region_residencia,fecha) %>%
                                        mutate(positividad=zoo::rollapply(freq,7,mean,align='right',fill=NA)) %>% 
                                        dplyr::select(codigo_region, region_residencia, fecha, positividad) 
write_csv(pos.data.reg.icovid, "~/Documents/GitHub/ICOVID/dimension2/positividad/regional/Positividad por region.csv")

# Serie data provincial

pos.data.prov <- data %>% group_by(Fechatomademuestra, codigo_provincia, provincia_residencia, resul) %>% 
                               dplyr::select(id, Fechatomademuestra, codigo_provincia, provincia_residencia, resul) %>%
                               filter(!is.na(provincia_residencia)) %>%
                               summarise (n = n()) %>%
                               mutate(freq = n / sum(n)) %>% 
                               group_by(codigo_provincia, provincia_residencia, resul) %>% 
                               complete(Fechatomademuestra = seq.Date(min(Fechatomademuestra, na.rm = T), max(Fechatomademuestra, na.rm = T), by="day")) %>%
                               mutate(fecha=Fechatomademuestra) %>%
                               ungroup() %>%
                               group_by(fecha, codigo_provincia) %>% 
                               mutate(na_num = ifelse(is.na(sum(n)),sum(is.na(n)),0), # Identificamos verdaderos NA (na_num==2)
                                      freq=ifelse(is.na(freq) & na_num==1, 0, freq), # Reemplazar NAs por 0 cuando correspon (na_num==1)
                                      n=ifelse(is.na(n) & na_num==1, 0, n)) %>% # Reemplazar NAs por 0 cuando correspon (na_num==1)
                               dplyr::select(-Fechatomademuestra, -na_num)  %>%
                               ungroup() %>%
                               arrange(codigo_provincia, fecha, resul)

# Save
pos.data.prov.icovid <- pos.data.prov %>% filter(resul==1 & fecha>as.Date("2020-03-01") & fecha<as.Date(max(data$Fechadecorreo, na.rm = T))) %>% group_by(provincia_residencia) %>% arrange(provincia_residencia,fecha) %>%
  mutate(positividad=zoo::rollapply(freq,7,mean,align='right',fill=NA)) %>% dplyr::select(codigo_provincia, provincia_residencia, fecha, positividad) 
write_csv(pos.data.prov.icovid, "~/Documents/GitHub/ICOVID/dimension2/positividad/provincial/Positividad por provincia.csv")

# Serie data comunal
pos.data.comuna <- data %>% group_by(Fechatomademuestra, codigo_comuna, comuna_residencia, resul) %>% 
                        dplyr::select(id, Fechatomademuestra, codigo_comuna, comuna_residencia, resul) %>%
                        filter(!is.na(comuna_residencia)) %>%
                        summarise (n = n()) %>%
                        mutate(freq = n / sum(n)) %>% 
                        group_by(codigo_comuna, comuna_residencia, resul) %>% 
                        complete(Fechatomademuestra = seq.Date(min(Fechatomademuestra, na.rm = T), max(Fechatomademuestra, na.rm = T), by="day")) %>%
                        mutate(fecha=Fechatomademuestra, serie="Fecha toma muestra") %>%
                        ungroup() %>%
                        group_by(fecha, comuna_residencia) %>% 
                        mutate(na_num = ifelse(is.na(sum(n)),sum(is.na(n)),0), # Identificamos verdaderos NA (na_num==2)
                               freq=ifelse(is.na(freq) & na_num==1, 0, freq), # Reemplazar NAs por 0 cuando correspon (na_num==1)
                               n=ifelse(is.na(n) & na_num==1, 0, n)) %>% # Reemplazar NAs por 0 cuando correspon (na_num==1)
                        dplyr::select(-Fechatomademuestra, -na_num)  %>%
                        ungroup() %>%
                        arrange(comuna_residencia, fecha, resul)

# Save
pos.data.comuna.icovid <- pos.data.comuna %>% filter(resul==1 & serie=="Fecha toma muestra" & fecha>as.Date("2020-03-01") & fecha<as.Date(max(data$Fechadecorreo, na.rm = T))) %>% group_by(comuna_residencia) %>% arrange(fecha) %>%
                          mutate(positividad=zoo::rollapply(freq,7,mean,align='right',fill=NA)) %>% dplyr::select(codigo_comuna, comuna_residencia, fecha, positividad) 
write_csv(pos.data.comuna.icovid, "~/Documents/GitHub/ICOVID/dimension2/positividad/comunal/Positividad por comuna.csv")

###################################################################################
## Visualizaciones
###################################################################################

# Serie nacional para ICOVID
pos.nac <- ggplot(pos.data.icovid, 
        aes(x=fecha, y=positividad)) + 
        # geom_point(alpha=0.2) +  
        geom_line(color = "steelblue", size=1.1,) +    
        geom_hline(yintercept= 0.1, colour="red4") +
        labs(x="Fecha", y="Proporción examenes PCR positivos (positividad)") +
        ylim(0,1) + theme_minimal() 
pos.nac
ggsave(pos.nac, filename="~/Documents/GitHub/ICOVID/dimension2/positividad/nacional/positividad nacional.pdf", 
       width = 14.6*2, height = 9.6*2, units = "cm")


# Serie regional para ICOVID
pos.reg <- ggplot(pos.data.reg.icovid, 
       aes(x=fecha, y=positividad)) + 
  # geom_point(alpha=0.2) +  
  geom_line(color = "steelblue", size=1.1,) +    
  geom_hline(yintercept= 0.1, colour="red4") +
  labs(x="Fecha", y="Proporción examenes PCR positivos (positividad)") +
  ylim(0,1) + theme_minimal() + facet_wrap(region_residencia~.) 
pos.reg
ggsave(pos.reg, filename="~/Documents/GitHub/ICOVID/dimension2/positividad/regional/positividad regional.pdf", 
       width = 14.6*2, height = 9.6*2, units = "cm")

# Serie provincial para ICOVID
pos.prov <-ggplot(pos.data.prov.icovid, 
       aes(x=fecha, y=positividad)) + 
  # geom_point(alpha=0.2) +  
  geom_line(color = "steelblue", size=1.1,) +    
  geom_hline(yintercept= 0.1, colour="red4") +
  labs(x="Fecha", y="Proporción examenes PCR positivos (positividad)") +
  ylim(0,1) + theme_minimal() + facet_wrap(provincia_residencia~.) 
pos.prov
ggsave(pos.prov, filename="~/Documents/GitHub/ICOVID/dimension2/positividad/provincial/positividad provincial.pdf", 
       width = 14.6*2, height = 9.6*2, units = "cm")

# Serie comunal para ICOVID
ggplot(pos.data.comuna.icovid, 
       aes(x=fecha, y=positividad)) + 
  # geom_point(alpha=0.2) +  
  geom_line(color = "steelblue", size=1.1,) +    
  geom_hline(yintercept= 0.1, colour="red4") + 
  labs(x="Fecha", y="Proporción examenes PCR positivos (positividad)") +
  ylim(0,1) + theme_minimal() + facet_wrap(comuna_residencia~.) 

###################################################################################
## Cálculo de series de tasa de test (media móvil diaria y suma semanal)
###################################################################################

# Serie Nacional
tasa.data.correo <- data %>% group_by(Fechatomademuestra) %>% 
                    dplyr::select(id, Fechatomademuestra) %>%
                    summarise (n = n()) %>%
                    complete(Fechatomademuestra = seq.Date(min(Fechatomademuestra, na.rm = T), max(Fechatomademuestra, na.rm = T), by="day")) %>%
                    mutate(fecha=Fechatomademuestra) %>%
                    ungroup() %>%
                    group_by(fecha) %>% 
                    mutate(n=ifelse(is.na(n), 0, n)) %>% # Reemplazar NAs por 0 cuando correspon 
                    dplyr::select(-Fechatomademuestra)  %>%
                    ungroup() %>%
                    arrange(fecha)

tasa.data.correo <- tasa.data.correo %>% mutate(tasatest=n/sum(poblacion.region$pob)*1000) 

# Save
tasa.test.data.icovid <- tasa.data.correo %>% filter(fecha>as.Date("2020-03-01") & fecha<as.Date(max(data$Fechadecorreo, na.rm = T))) %>% arrange(fecha) %>% 
                         mutate(tasatest=zoo::rollapply(tasatest,7,mean,align='right',fill=NA)) %>% 
                         dplyr::select(fecha, tasatest) 
write_csv(tasa.test.data.icovid, "~/Documents/GitHub/ICOVID/dimension2/tasatest/nacional/tasa test nacional.csv")

tasasem.test.data.icovid <- tasa.data.correo %>% filter(fecha>as.Date("2020-03-01") & fecha<as.Date(max(data$Fechadecorreo, na.rm = T))) %>% arrange(fecha) %>% 
                          mutate(tasatest=zoo::rollapply(tasatest,7,sum,align='right',fill=NA)) %>% 
                          dplyr::select(fecha, tasatest) 
write_csv(tasasem.test.data.icovid, "~/Documents/GitHub/ICOVID/dimension2/tasatest/nacional/tasa test semanal nacional.csv")

# Serie data regional
tasa.data.correo.reg <- data %>% group_by(Fechatomademuestra, codigo_region, region_residencia) %>% 
                          dplyr::select(id, Fechatomademuestra, codigo_region, region_residencia) %>%
                          filter(!is.na(region_residencia)) %>%
                          summarise (n = n()) %>%
                          group_by(codigo_region, region_residencia) %>% 
                          complete(Fechatomademuestra = seq.Date(min(Fechatomademuestra, na.rm = T), max(Fechatomademuestra, na.rm = T), by="day")) %>%
                          mutate(fecha=Fechatomademuestra) %>%
                          ungroup() %>%
                          group_by(fecha, region_residencia) %>% 
                          mutate(n=ifelse(is.na(n), 0, n)) %>% # Reemplazar NAs por 0 cuando correspon 
                          dplyr::select(-Fechatomademuestra)  %>%
                          ungroup() %>%
                          arrange(region_residencia, fecha)

tasa.data.correo.reg <- left_join(tasa.data.correo.reg,poblacion.region)
tasa.data.correo.reg <- tasa.data.correo.reg %>% mutate(tasatest=n/pob*1000) 

# Save
tasa.test.data.reg.icovid <- tasa.data.correo.reg %>% filter(fecha>as.Date("2020-03-01") & fecha<as.Date(max(data$Fechadecorreo, na.rm = T)) & !is.na(codigo_region)) %>% 
                             arrange(fecha) %>% group_by(codigo_region, region_residencia) %>% 
                             mutate(tasatest=zoo::rollapply(tasatest,7,mean,align='right',fill=NA)) %>% 
                             dplyr::select(fecha, tasatest, codigo_region, region_residencia) 
write_csv(tasa.test.data.reg.icovid, "~/Documents/GitHub/ICOVID/dimension2/tasatest/regional/tasa test regional.csv")

tasasem.test.data.reg.icovid <- tasa.data.correo.reg %>% filter(fecha>as.Date("2020-03-01") & fecha<as.Date(max(data$Fechadecorreo, na.rm = T)) & !is.na(codigo_region)) %>% 
                                arrange(fecha) %>% group_by(codigo_region, region_residencia) %>% 
                                mutate(tasatest=zoo::rollapply(tasatest,7,sum,align='right',fill=NA)) %>% 
                                dplyr::select(fecha, tasatest, codigo_region, region_residencia) 
write_csv(tasasem.test.data.reg.icovid, "~/Documents/GitHub/ICOVID/dimension2/tasatest/regional/tasa test semanal regional.csv")

# Serie data provincial
tasa.data.correo.prov <-  data %>% group_by(Fechatomademuestra, codigo_provincia, provincia_residencia) %>% 
                          dplyr::select(id, Fechatomademuestra, codigo_provincia, provincia_residencia) %>%
                          filter(!is.na(provincia_residencia)) %>%
                          summarise (n = n()) %>%
                          group_by(codigo_provincia, provincia_residencia) %>% 
                          complete(Fechatomademuestra = seq.Date(min(Fechatomademuestra, na.rm = T), max(Fechatomademuestra, na.rm = T), by="day")) %>%
                          mutate(fecha=Fechatomademuestra) %>%
                          ungroup() %>%
                          group_by(fecha, provincia_residencia) %>% 
                          mutate(n=ifelse(is.na(n), 0, n)) %>% # Reemplazar NAs por 0 cuando correspon 
                          dplyr::select(-Fechatomademuestra)  %>%
                          ungroup() %>%
                          arrange(provincia_residencia, fecha)

tasa.data.correo.prov <- left_join(tasa.data.correo.prov,poblacion.provincia)
tasa.data.correo.prov <- tasa.data.correo.prov %>% mutate(tasatest=n/pob*1000) 

# Save
tasa.test.data.prov.icovid <- tasa.data.correo.prov %>% filter(fecha>as.Date("2020-03-01") & fecha<as.Date(max(data$Fechadecorreo, na.rm = T)) & !is.na(codigo_provincia)) %>% 
                                                        arrange(fecha) %>% group_by(codigo_provincia, provincia_residencia) %>% 
                                                        mutate(tasatest=zoo::rollapply(tasatest,7,mean,align='right',fill=NA)) %>%  
                                                        dplyr::select(fecha, tasatest, codigo_provincia, provincia_residencia) 
write_csv(tasa.test.data.prov.icovid, "~/Documents/GitHub/ICOVID/dimension2/tasatest/provincial/tasa test provincial.csv")

tasasem.test.data.prov.icovid <- tasa.data.correo.prov %>% filter(fecha>as.Date("2020-03-01") & fecha<as.Date(max(data$Fechadecorreo, na.rm = T)) & !is.na(codigo_provincia)) %>% 
                              arrange(fecha) %>% group_by(codigo_provincia, provincia_residencia) %>% 
                              mutate(tasatest=zoo::rollapply(tasatest,7,sum,align='right',fill=NA)) %>%  
                              dplyr::select(fecha, tasatest, codigo_provincia, provincia_residencia) 
write_csv(tasasem.test.data.prov.icovid, "~/Documents/GitHub/ICOVID/dimension2/tasatest/provincial/tasa test semanal provincial.csv")


# Serie data comunal
tasa.data.correo.comuna <- data %>% group_by(Fechatomademuestra, codigo_comuna, comuna_residencia) %>% 
                            dplyr::select(id, Fechatomademuestra, codigo_comuna, comuna_residencia) %>%
                            filter(!is.na(comuna_residencia)) %>%
                            summarise (n = n()) %>%
                            group_by(codigo_comuna, comuna_residencia) %>% 
                            complete(Fechatomademuestra = seq.Date(min(Fechatomademuestra, na.rm = T), max(Fechatomademuestra, na.rm = T), by="day")) %>%
                            mutate(fecha=Fechatomademuestra) %>%
                            ungroup() %>%
                            group_by(fecha, comuna_residencia) %>% 
                            mutate(n=ifelse(is.na(n), 0, n)) %>% # Reemplazar NAs por 0 cuando correspon 
                            dplyr::select(-Fechatomademuestra)  %>%
                            ungroup() %>%
                            arrange(comuna_residencia, fecha)

tasa.data.correo.comuna <- left_join(tasa.data.correo.comuna,poblacion.comuna)
tasa.data.correo.comuna <- tasa.data.correo.comuna %>% mutate(tasatest=n/pob*1000) 

# Save
tasa.test.data.comuna.icovid <- tasa.data.correo.comuna %>% filter(fecha>as.Date("2020-03-01") & fecha<as.Date(max(data$Fechadecorreo, na.rm = T))  & !is.na(codigo_comuna)) %>% 
                                arrange(fecha) %>% group_by( codigo_comuna, comuna_residencia) %>% 
                                mutate(tasatest=zoo::rollapply(tasatest,7,mean,align='right',fill=NA)) %>%
                                dplyr::select(fecha, tasatest, codigo_comuna, comuna_residencia) 
write_csv(tasa.test.data.comuna.icovid, "~/Documents/GitHub/ICOVID/dimension2/tasatest/comunal/tasa test comunal.csv")

tasasem.test.data.comuna.icovid <- tasa.data.correo.comuna %>% filter(fecha>as.Date("2020-03-01") & fecha<as.Date(max(data$Fechadecorreo, na.rm = T))  & !is.na(codigo_comuna)) %>% 
                                arrange(fecha) %>% group_by( codigo_comuna, comuna_residencia) %>% 
                                mutate(tasatest=zoo::rollapply(tasatest,7,sum,align='right',fill=NA)) %>%
                                dplyr::select(fecha, tasatest, codigo_comuna, comuna_residencia) 
write_csv(tasa.test.data.comuna.icovid, "~/Documents/GitHub/ICOVID/dimension2/tasatest/comunal/tasa test semanal comunal.csv")

###################################################################################
## Visualizaciones por dia
###################################################################################

# Serie nacional para ICOVID
graph.nacional <- ggplot(tasa.test.data.icovid, 
       aes(x=fecha, y=tasatest)) + 
  geom_line(color = "steelblue", size=1.1,) +    
  geom_hline(yintercept=1, colour="red4") +  
  labs(x="Fecha toma de muestra", y="Tasa de test diarios por 1000 habitantes") +
  ylim(0,5) + theme_minimal() 
graph.nacional
ggsave(graph.nacional, filename="~/Documents/GitHub/ICOVID/dimension2/tasatest/nacional/tasa test nacional.pdf", 
       width = 14.6*2, height = 9.6*2, units = "cm")

# Serie regional para ICOVID
graph.reg <- ggplot(tasa.test.data.reg.icovid, 
       aes(x=fecha, y=tasatest)) + 
  geom_line(color = "steelblue", size=1.1,) +    
  geom_hline(yintercept= 1, colour="red4") + 
  labs(x="Fecha toma de muestra", y="Tasa de test diarios por 1000 habitantes") +
  ylim(0,5) + theme_minimal() + facet_wrap(region_residencia~.) 
graph.reg
ggsave(graph.reg, filename="~/Documents/GitHub/ICOVID/dimension2/tasatest/regional/tasa test regional.pdf", 
       width = 14.6*2, height = 9.6*2, units = "cm")

# Serie provincial para ICOVID
graph.prov <- ggplot(tasa.test.data.prov.icovid, 
       aes(x=fecha, y=tasatest)) + 
  geom_line(color = "steelblue", size=1.1,) +    
  geom_hline(yintercept= 1, colour="red4") + 
  labs(x="Fecha toma de muestra", y="Tasa de test diarios por 1000 habitantes") +
  ylim(0,5) + theme_minimal() + facet_wrap(provincia_residencia~.) 
graph.prov
ggsave(graph.prov, filename="~/Documents/GitHub/ICOVID/dimension2/tasatest/provincial/tasa test provincial.pdf", 
       width = 14.6*2, height = 9.6*2, units = "cm")

# Serie comunal para ICOVID
ggplot(tasa.test.data.comuna.icovid, 
       aes(x=fecha, y=tasatest)) + 
  geom_line(color = "steelblue", size=1.1,) +    
  geom_hline(yintercept= 1, colour="red4") + 
  labs(x="Fecha toma de muestra", y="Tasa de test diarios por 1000 habitantes") +
  ylim(0,5) + theme_minimal() + facet_wrap(comuna_residencia~.) 

###################################################################################
## Visualizaciones por semana
###################################################################################

# Serie nacional para ICOVID
graph.nacional.sem <- ggplot(tasasem.test.data.icovid, 
                         aes(x=fecha, y=tasatest)) + 
  geom_line(color = "steelblue", size=1.1,) +    
  geom_hline(yintercept=1, colour="red4") +  
  labs(x="Fecha toma de muestra", y="Tasa de test semanal por 1000 habitantes") +
  theme_minimal() 
graph.nacional.sem
ggsave(graph.nacional.sem, filename="~/Documents/GitHub/ICOVID/dimension2/tasatest/nacional/tasa test semanal nacional.pdf", 
       width = 14.6*2, height = 9.6*2, units = "cm")

# Serie regional para ICOVID
graph.reg.sem <- ggplot(tasasem.test.data.reg.icovid, 
                    aes(x=fecha, y=tasatest)) + 
  geom_line(color = "steelblue", size=1.1,) +    
  geom_hline(yintercept= 1, colour="red4") + 
  labs(x="Fecha toma de muestra", y="Tasa de test semanal por 1000 habitantes") +
  theme_minimal() + facet_wrap(region_residencia~.) 
graph.reg.sem
ggsave(graph.reg.sem, filename="~/Documents/GitHub/ICOVID/dimension2/tasatest/regional/tasa test semanal regional.pdf", 
       width = 14.6*2, height = 9.6*2, units = "cm")

# Serie provincial para ICOVID
graph.prov.sem <- ggplot(tasasem.test.data.prov.icovid, 
                     aes(x=fecha, y=tasatest)) + 
  geom_line(color = "steelblue", size=1.1,) +    
  geom_hline(yintercept= 1, colour="red4") + 
  labs(x="Fecha toma de muestra", y="Tasa de test semanal por 1000 habitantes") +
  theme_minimal() + facet_wrap(provincia_residencia~.) 
graph.prov.sem
ggsave(graph.prov.sem, filename="~/Documents/GitHub/ICOVID/dimension2/tasatest/provincial/tasa test semanal provincial.pdf", 
       width = 14.6*2, height = 9.6*2, units = "cm")

###################################################################################
## Cálculo de series de numero de test por caso confirmado
###################################################################################

# Serie Nacional
ntest <- data %>% group_by(Fechatomademuestra) %>% 
          dplyr::select(id, Fechatomademuestra) %>%
          summarise (n = n()) %>%
          complete(Fechatomademuestra = seq.Date(min(Fechatomademuestra, na.rm = T), max(Fechatomademuestra, na.rm = T), by="day")) %>%
          mutate(fecha=Fechatomademuestra) %>%
          ungroup() %>%
          group_by(fecha) %>% 
          mutate(n=ifelse(is.na(n), 0, n)) %>% # Reemplazar NAs por 0 cuando correspon 
          dplyr::select(-Fechatomademuestra)  %>%
          ungroup() %>%
          arrange(fecha)

# Save
ntest.acumulados.icovid <- ntest %>% filter(fecha>as.Date("2020-03-01") & fecha<as.Date(max(data$Fechadecorreo, na.rm = T))) %>% arrange(fecha) %>% 
  mutate(ntestcum=cumsum(n)) %>% 
  dplyr::select(fecha, ntestcum) 
write_csv(ntest.acumulados.icovid, "~/Documents/GitHub/ICOVID/dimension2/ntest/nacional/n test acumulados nacional.csv")

# Serie data regional
ntest.reg <- data %>% group_by(Fechatomademuestra, codigo_region, region_residencia) %>% 
              dplyr::select(id, Fechatomademuestra, codigo_region, region_residencia) %>%
              filter(!is.na(region_residencia)) %>%
              summarise (n = n()) %>%
              group_by(codigo_region, region_residencia) %>% 
              complete(Fechatomademuestra = seq.Date(min(Fechatomademuestra, na.rm = T), max(Fechatomademuestra, na.rm = T), by="day")) %>%
              mutate(fecha=Fechatomademuestra) %>%
              ungroup() %>%
              group_by(fecha, region_residencia) %>% 
              mutate(n=ifelse(is.na(n), 0, n)) %>% # Reemplazar NAs por 0 cuando correspon 
              dplyr::select(-Fechatomademuestra)  %>%
              ungroup() %>%
              arrange(region_residencia, fecha)

# Save
ntest.reg.icovid <- ntest.reg %>% filter(fecha>as.Date("2020-03-01") & fecha<as.Date(max(data$Fechadecorreo, na.rm = T)) & !is.na(codigo_region)) %>% 
  arrange(codigo_region, fecha) %>% group_by(codigo_region, region_residencia) %>% 
  mutate(ntestcum=cumsum(n)) %>% 
  dplyr::select(fecha, ntestcum, codigo_region, region_residencia) 
write_csv(ntest.reg.icovid, "~/Documents/GitHub/ICOVID/dimension2/ntest/regional/n test acumulados regional.csv")

# Serie data provincial
ntest.prov <-  data %>% group_by(Fechatomademuestra, codigo_provincia, provincia_residencia) %>% 
                    dplyr::select(id, Fechatomademuestra, codigo_provincia, provincia_residencia) %>%
                    filter(!is.na(provincia_residencia)) %>%
                    summarise (n = n()) %>%
                    group_by(codigo_provincia, provincia_residencia) %>% 
                    complete(Fechatomademuestra = seq.Date(min(Fechatomademuestra, na.rm = T), max(Fechatomademuestra, na.rm = T), by="day")) %>%
                    mutate(fecha=Fechatomademuestra) %>%
                    ungroup() %>%
                    group_by(fecha, provincia_residencia) %>% 
                    mutate(n=ifelse(is.na(n), 0, n)) %>% # Reemplazar NAs por 0 cuando correspon 
                    dplyr::select(-Fechatomademuestra)  %>%
                    ungroup() %>%
                    arrange(provincia_residencia, fecha)

# Save
ntest.prov.icovid <- ntest.prov %>% filter(fecha>as.Date("2020-03-01") & fecha<as.Date(max(data$Fechadecorreo, na.rm = T)) & !is.na(codigo_provincia)) %>% 
  arrange(codigo_provincia, fecha) %>% group_by(codigo_provincia, provincia_residencia) %>% 
  mutate(ntestcum=cumsum(n)) %>% 
  dplyr::select(fecha, ntestcum, codigo_provincia, provincia_residencia) 
write_csv(ntest.prov.icovid, "~/Documents/GitHub/ICOVID/dimension2/ntest/provincial/n test acumulados provincial.csv")

# Serie data comunal
ntest.comuna <- data %>% group_by(Fechatomademuestra, codigo_comuna, comuna_residencia) %>% 
                        dplyr::select(id, Fechatomademuestra, codigo_comuna, comuna_residencia) %>%
                        filter(!is.na(comuna_residencia)) %>%
                        summarise (n = n()) %>%
                        group_by(codigo_comuna, comuna_residencia) %>% 
                        complete(Fechatomademuestra = seq.Date(min(Fechatomademuestra, na.rm = T), max(Fechatomademuestra, na.rm = T), by="day")) %>%
                        mutate(fecha=Fechatomademuestra) %>%
                        ungroup() %>%
                        group_by(fecha, comuna_residencia) %>% 
                        mutate(n=ifelse(is.na(n), 0, n)) %>% # Reemplazar NAs por 0 cuando correspon 
                        dplyr::select(-Fechatomademuestra)  %>%
                        ungroup() %>%
                        arrange(comuna_residencia, fecha)

# Save
ntest.comuna.icovid <- ntest.comuna %>% filter(fecha>as.Date("2020-03-01") & fecha<as.Date(max(data$Fechadecorreo, na.rm = T))  & !is.na(codigo_comuna)) %>% 
  arrange(codigo_comuna, fecha) %>% group_by(codigo_comuna, comuna_residencia) %>% 
  mutate(ntestcum=cumsum(n)) %>% 
  dplyr::select(fecha, ntestcum, codigo_comuna, comuna_residencia) 
write_csv(ntest.comuna.icovid, "~/Documents/GitHub/ICOVID/dimension2/ntest/comunal/n test acumulados comunal.csv")


