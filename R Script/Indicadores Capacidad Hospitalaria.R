###Cargar librerias
library(dplyr)
library(tidyr)
library(lubridate)
library(stringr)
library(data.table)
library(tidyquant)
library(ggplot2)
library(reshape)
library(zoo)
library(plyr)

rm(list=ls())       # clear the list of objects
graphics.off()			# clear the list of graphs

#####-------------------------
###Carga de datos 

#Para Indicador 1, 2 y 4
#Producto 48 - Encuesta SOCHIMI
SOCHIMI<- read.csv("https://raw.githubusercontent.com/MinCiencia/Datos-COVID19/master/output/producto48/SOCHIMI_std.csv", header = TRUE, sep = ",", dec = ".",stringsAsFactors = TRUE, encoding="UTF-8")
#Producto 8 - Pacientes UCI COVID -19
UCI<-read.csv("https://raw.githubusercontent.com/MinCiencia/Datos-COVID19/master/output/producto8/UCI_std.csv", header = TRUE, sep = ",", dec = ".",stringsAsFactors = TRUE, encoding="UTF-8")
#Producto 24 - Hospitalización de pacientes COVID-19 en sistema integrado
HOSP<-read.csv("https://raw.githubusercontent.com/MinCiencia/Datos-COVID19/master/output/producto24/CamasHospital_Diario_T.csv", header = TRUE, sep = ",", dec = ".",stringsAsFactors = TRUE, encoding="UTF-8")

#Para Indicador 3
#Para número de Pacientes VM fuera de UCI
VM_RM<-read.csv("https://raw.githubusercontent.com/jorgeperezrojas/covid19-data/master/csv/long_encuesta_sochimi.csv", header = TRUE, sep = ",", dec = ".",stringsAsFactors = TRUE, encoding="UTF-8")



#####-------------------------
#Fill NA
SOCHIMI[is.na(SOCHIMI)] <- 0

#Datos UCI
UCI_s<-UCI%>%
  dplyr::select(-Poblacion,-Region)%>%
  dplyr::rename(UCI.covid19 = numero,
                Fecha = fecha)%>%
  dplyr::mutate(Fecha = as.Date(Fecha))

###Crear Dataset SOCHIMI + UCI por Región - Diaria
SOCHIMI_R1<-SOCHIMI%>%
  dplyr::select(-Servicio.salud)%>% 
  group_by(Fecha,Codigo.region,Region)%>% 
  summarise_at(vars(-group_cols()),sum)%>%
  mutate(
    Fecha = as.Date(Fecha)
  )

##**Añadir valores anteriores
F_R <- SOCHIMI_R1%>%
  group_by(Codigo.region,Region) %>% 
  dplyr::select(Codigo.region,Region)%>%
  distinct(Codigo.region,Region) %>% 
  do( data.frame(., Fecha= seq(min(as.Date(UCI_s$Fecha)),
                               max(as.Date(UCI_s$Fecha)), by = '1 day')))

###Unir Fechas - Regiones y Codigo Region
na.locf2 <- function(x) na.locf(x, na.rm = FALSE)

SOCHIMI_R2<-F_R%>%
  left_join(SOCHIMI_R1, by = c("Fecha"="Fecha", "Codigo.region", "Region"))%>%
  group_by(Codigo.region, Region)%>% 
  do(na.locf2(.)) %>% 
  ungroup

SOCHIMI_R<-SOCHIMI_R2%>%
  left_join(UCI_s, by = c("Fecha", "Codigo.region"))

###Crear Dataset SOCHIMI + UCI Nacional - Diaria

SOCHIMI_N<-SOCHIMI_R%>%
  dplyr::select(-Codigo.region,-Region)%>%
  group_by(Fecha)%>% 
  summarise_at(vars(-group_cols()),sum)%>%
  as.data.frame()


#####-------------------------
### Indicador 1: 
###     Uso de camas UCI

#### Regional
Ind_1_R<-SOCHIMI_R%>% 
  mutate(
    Porc_Uso_UCI= ifelse(Camas.totales.intensivo==0,0,ifelse(Camas.totales.intensivo<Camas.ocupadas.intensivo,Camas.ocupadas.intensivo/Camas.ocupadas.intensivo,Camas.ocupadas.intensivo/Camas.totales.intensivo))*100
  )%>% dplyr::rename(
    fecha = Fecha,
    region_residencia = Region,
    codigo_region = Codigo.region
  )%>%
  dplyr::select(fecha,codigo_region, region_residencia, Porc_Uso_UCI )%>%
  drop_na(Porc_Uso_UCI)


write.csv(Ind_1_R,"C:/Users/maida/Dropbox/COVID-19-Panel/Indicadores COVID/Uso de camas UCI por region.csv", row.names = FALSE)

#### Nacional
Ind_1_N<-SOCHIMI_N%>% 
  mutate(
    Porc_Uso_UCI= ifelse(Camas.totales.intensivo==0,0,ifelse(Camas.totales.intensivo<Camas.ocupadas.intensivo,Camas.ocupadas.intensivo/Camas.ocupadas.intensivo,Camas.ocupadas.intensivo/Camas.totales.intensivo))*100
  )%>% dplyr::rename(
    fecha = Fecha
  )%>%
  dplyr::select(fecha, Porc_Uso_UCI )%>%
  drop_na(Porc_Uso_UCI)


write.csv(Ind_1_N,"C:/Users/maida/Dropbox/COVID-19-Panel/Indicadores COVID/Uso de camas UCI Nacional.csv", row.names = FALSE)


#####-------------------------
### Indicador 2: 
###     Uso Covid-19 de camas UCI

#factor
f<-1-(0.791-0.56)

####Regional
Ind_2_R<-SOCHIMI_R%>% 
  mutate(
    Porc_Uso_Covid = ifelse(Camas.totales.intensivo==0,0,ifelse(Camas.totales.intensivo<UCI.covid19,UCI.covid19/(UCI.covid19*f),UCI.covid19/(Camas.totales.intensivo*f)))*100
  )%>%
  dplyr::rename(
    fecha = Fecha,
    region_residencia = Region,
    codigo_region = Codigo.region
  )%>%
  dplyr::select(fecha,codigo_region, region_residencia, Porc_Uso_Covid )%>%
  drop_na(Porc_Uso_Covid)

write.csv(Ind_2_R,"C:/Users/maida/Dropbox/COVID-19-Panel/Indicadores COVID/Uso de camas UCI Covid-19 por region.csv", row.names = FALSE)

####Nacional
Ind_2_N<-SOCHIMI_N%>% 
  mutate(
    Porc_Uso_Covid = ifelse(Camas.totales.intensivo==0,0,ifelse(Camas.totales.intensivo<UCI.covid19,UCI.covid19/(UCI.covid19*f),UCI.covid19/(Camas.totales.intensivo*f)))*100
  )%>%
  dplyr::rename(
    fecha = Fecha
  )%>%
  dplyr::select(fecha,Porc_Uso_Covid )%>%
  drop_na(Porc_Uso_Covid)

write.csv(Ind_2_N,"C:/Users/maida/Dropbox/COVID-19-Panel/Indicadores COVID/Uso de camas UCI Covid-19 Nacional.csv", row.names = FALSE)


#####-------------------------
###Indicador 3:
###  Calculo Número de Pacientes VM fuera de UCI

#Región Metropolitana- Diaria
Ind_3<-VM_RM%>% 
  dplyr::select(fecha,rm_covid_en_vmi_fuera_upca)%>%
  drop_na(rm_covid_en_vmi_fuera_upca)

write.csv(Ind_3,"C:/Users/maida/Dropbox/COVID-19-Panel/Indicadores COVID/Pacientes VM fuera UPCA en RM.csv", row.names = FALSE)


#####-------------------------
### Indicador 4: 
###     Tasa de variación semanal de hospitalizaciones totales Covid-19

####Region

#Calcular Media Móvil: 3 días
SOCHIMI_R$Rm_UCI.covid19 <- ave(SOCHIMI_R$UCI.covid19, SOCHIMI_R[c("Codigo.region", "Region")], FUN =
                                  function(x) rollapplyr(zoo(x), 3, mean,  partial = FALSE, fill = NA))

#Calcular tasa de variación semanal

Ind_4_Lag_R<- expand.grid(
  Codigo.region = sort(unique(SOCHIMI_R$Codigo.region)),
  Fecha   = seq(from = min(SOCHIMI_R$Fecha), to = max(SOCHIMI_R$Fecha)+7, by = '1 day')
) %>% 
  left_join(SOCHIMI_R, by = c("Codigo.region","Fecha"))%>% 
  arrange(Codigo.region,Fecha)%>%
  group_by(Codigo.region)%>%
  mutate(
    Lag7_UCI.covid19 = dplyr::lag(Rm_UCI.covid19, n=7)
  )%>% 
  ungroup()


Ind_4_R<-Ind_4_Lag_R%>%
  mutate(
    Tasa7_UCI.covid19 = ifelse(is.na(Lag7_UCI.covid19)==TRUE | Lag7_UCI.covid19==0, 0,(Rm_UCI.covid19 - Lag7_UCI.covid19)/Lag7_UCI.covid19)*100,
    Fecha = as.Date(Fecha)
  ) %>%
  filter(!is.na(Region)) %>%
  dplyr::rename(
    fecha = Fecha,
    region_residencia = Region,
    codigo_region = Codigo.region,
    Tasa_var_hosp = Tasa7_UCI.covid19 
  )%>%
  dplyr::select(fecha, codigo_region, region_residencia,Tasa_var_hosp )

write.csv(Ind_4_R,"C:/Users/maida/Dropbox/COVID-19-Panel/Indicadores COVID/tasa de variación semanal hospitalizaciones Covid-19 por region.csv", row.names = FALSE)


####Nacional

#Calcular Media Móvil: 3 días
HOSP_N<- HOSP%>% 
  mutate(
    Hosp_Total=UCI+UTI+Media+Basica
  )%>% dplyr::rename(
   fecha = Tipo.de.cama
  )%>% 
  mutate(
    fecha = as.Date(fecha))

HOSP_N$Rm_HOSP.covid19 <- ave(HOSP_N$Hosp_Total, FUN =
                                  function(x) rollapplyr(zoo(x), 3, mean,  partial = FALSE, fill = NA))

#Calcular tasa de variación semanal

Ind_4_Lag_N<- expand.grid(
  fecha   = seq(from = min(HOSP_N$fecha), to = max(HOSP_N$fecha)+7, by = '1 day')
) %>% 
  left_join(HOSP_N, by = c("fecha"))%>% 
  arrange(fecha)%>%
  mutate(
    Lag7_HOSP.covid19 = dplyr::lag(Rm_HOSP.covid19, n=7)
  )


Ind_4_N<-Ind_4_Lag_N%>%
  mutate(
    Tasa7_HOSP.covid19 = ifelse(is.na(Lag7_HOSP.covid19)==TRUE | Lag7_HOSP.covid19==0, 0,(Rm_HOSP.covid19 - Lag7_HOSP.covid19)/Lag7_HOSP.covid19)*100
  ) %>%
  filter(!is.na(Hosp_Total)) %>%
  dplyr::rename(
    Tasa_var_hosp = Tasa7_HOSP.covid19 
  )%>%
  dplyr::select(fecha,Tasa_var_hosp )

write.csv(Ind_4_N,"C:/Users/maida/Dropbox/COVID-19-Panel/Indicadores COVID/tasa de variación semanal hospitalizaciones Covid-19 Nacional.csv", row.names = FALSE)

