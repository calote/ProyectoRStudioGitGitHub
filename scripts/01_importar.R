# Script para importar y preparar datos
library(tidyverse)
library(here)

# Crear mensaje de inicio
cat("Iniciando importación de datos:", format(Sys.time(), "%Y-%m-%d %H:%M:%S"))
cat("")

# Importar datos
datos_crudos <- read.csv(here("datos", "crudos", "datos.csv"))

# Procesar datos
datos_limpios <- datos_crudos %>%
  # Añade aquí tu procesamiento de datos
  # Añadir columnas calculadas
  mutate(
    grupo = factor(grupo)
  ) %>%
  na.omit()

# Guardar datos procesados
write_csv(datos_limpios, here("datos", "procesados", "datos_limpios.csv"))
saveRDS(datos_limpios, here("datos", "procesados", "datos_limpios.rds"))

# Mensaje final
cat("Importación y procesamiento completados:", format(Sys.time(), "%Y-%m-%d %H:%M:%S"))
cat("")
cat("Datos guardados en: datos/procesados/")
cat("")

