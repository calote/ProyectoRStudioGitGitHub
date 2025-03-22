# Script para generar gráficos
library(tidyverse)
library(here)
library(patchwork) # Para combinar gráficos

# Crear carpeta para figuras si no existe
if (!dir.exists(here("salida", "figuras"))) {
  dir.create(here("salida", "figuras"), recursive = TRUE)
}

# Mensaje de inicio
cat("Iniciando generación de gráficos:", format(Sys.time(), "%Y-%m-%d %H:%M:%S"))
cat("")


# Cargar datos procesados
datos_limpios <- readRDS(here("datos", "procesados", "datos_limpios.rds"))


# Crear gráficos
p <- ggplot(datos_limpios, aes(x = variable1, y = variable2)) +
  geom_point() +
  theme_minimal() +
  labs(title = "Título del gráfico")

# Tema personalizado para todos los gráficos
mi_tema <- theme_minimal() +
  theme(
    text = element_text(family = "sans", size = 12),
    axis.title = element_text(face = "bold"),
    plot.title = element_text(face = "bold", size = 14, hjust = 0.5),
    legend.position = "bottom"
  )

# Gráfico 1: Histograma de la variable numérica por grupo
p1 <- ggplot(datos_limpios, aes(x = variable1, fill = grupo)) +
  geom_histogram(alpha = 0.7, position = "identity", bins = 20) +
  labs(
    title = "Distribución por grupo",
    x = "Valor",
    y = "Frecuencia"
  ) +
  mi_tema

# Gráfico 2: Diagrama de cajas por grupo
p2 <- ggplot(datos_limpios, aes(x = grupo, y = variable1, fill = grupo)) +
  geom_boxplot() +
  labs(
    title = "Comparación entre grupos",
    x = "Grupo",
    y = "Valor"
  ) +
  mi_tema

# Combinar gráficos
exploracion <- p1 / p2

# Guardar gráficos
ggsave(here("salida", "figuras", "exploracion.png"), exploracion, 
       width = 8, height = 8, dpi = 300)

ggsave(here("salida", "figuras", "histograma.png"), p1, 
       width = 8, height = 4, dpi = 300)

ggsave(here("salida", "figuras", "boxplot.png"), p2, 
       width = 8, height = 4, dpi = 300)

ggsave(here("salida", "figuras", "grafico1.png"), p, 
       width = 8, height = 5, dpi = 300)
       
# Mensaje final
cat("Generación de gráficos completada:", format(Sys.time(), "%Y-%m-%d %H:%M:%S"))
cat("")
cat("Gráficos guardados en: salida/figuras/")
cat("")


