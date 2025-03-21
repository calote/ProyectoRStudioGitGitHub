# Script para importar y preparar datos

# Cargar paquetes
library(tidyverse)
library(here)

# Crear mensaje de inicio
cat("Iniciando importación de datos:", format(Sys.time(), "%Y-%m-%d %H:%M:%S"), "\n")

# Importar datos de ejemplo (si no existen, crear datos simulados)
if (!file.exists(here("datos", "crudos", "datos.csv"))) {
  # Crear datos simulados
  cat("No se encontraron datos. Creando datos simulados...\n")
  
  set.seed(123)
  datos_crudos <- data.frame(
    id = 1:100,
    variable_numerica = rnorm(100, mean = 50, sd = 10),
    variable_categorica = sample(c("Grupo A", "Grupo B", "Grupo C"), 100, replace = TRUE)
  )
  
  # Guardar datos simulados
  write.csv(datos_crudos, here("datos", "crudos", "datos.csv"), row.names = FALSE)
} else {
  # Leer datos existentes
  datos_crudos <- read.csv(here("datos", "crudos", "datos.csv"))
}

# Procesar datos
datos_limpios <- datos_crudos %>%
  # Añadir columnas calculadas
  mutate(
    variable_normalizada = scale(variable_numerica),
    grupo = factor(variable_categorica)
  ) %>%
  # Eliminar filas con valores NA (si hubiera)
  na.omit()

# Guardar datos procesados
write_csv(datos_limpios, here("datos", "procesados", "datos_limpios.csv"))
saveRDS(datos_limpios, here("datos", "procesados", "datos_limpios.rds"))

# Mensaje final
cat("Importación y procesamiento completados:", format(Sys.time(), "%Y-%m-%d %H:%M:%S"), "\n")
cat("Datos guardados en: datos/procesados/\n")