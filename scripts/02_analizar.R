# Script para realizar análisis estadísticos
# Cargar paquetes
library(tidyverse)
library(here)
library(broom)

# Crear carpeta para resultados si no existe
if (!dir.exists(here("salida", "resultados"))) {
  dir.create(here("salida", "resultados"), recursive = TRUE)
}

# Mensaje de inicio
cat("Iniciando análisis estadístico:", format(Sys.time(), "%Y-%m-%d %H:%M:%S"))
cat("")

# Cargar datos procesados
datos_limpios <- readRDS(here("datos", "procesados", "datos_limpios.rds"))

# Realizar análisis descriptivo
resumen_estadistico <- datos_limpios %>%
  group_by(grupo) %>%
  summarize(
    n = n(),
    media = mean(variable1, na.rm = TRUE),
    mediana = median(variable1, na.rm = TRUE),
    desv_est = sd(variable1, na.rm = TRUE),
    min = min(variable1, na.rm = TRUE),
    max = max(variable1, na.rm = TRUE)
  )

# Realizar análisis inferencial
# ANOVA para comparar grupos
modelo_anova <- aov(variable1 ~ grupo, data = datos_limpios)
resultados_anova <- tidy(modelo_anova)

# Correlaciones (si hubiera más variables numéricas)
matriz_correlacion <- cor(datos_limpios %>% select_if(is.numeric), 
                          use = "pairwise.complete.obs")

# Guardar resultados
save(
  resumen_estadistico, 
  resultados_anova, 
  matriz_correlacion, 
  file = here("salida", "resultados", "datos_procesados.RData")
)

# Mensaje final
cat("Análisis estadístico completado:", format(Sys.time(), "%Y-%m-%d %H:%M:%S"))
cat("")
cat("Resultados guardados en: salida/resultados/datos_procesados.RData")
cat("")


