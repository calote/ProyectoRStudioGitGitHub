#!/usr/bin/env Rscript
# Script para crear la estructura inicial del proyecto

# Función para crear la estructura de directorios
crear_estructura_directorios <- function() {
  directorios <- c(
    "datos/crudos", 
    "datos/procesados", 
    "imagenes", 
    "scripts",
    "salida/figuras", 
    "salida/resultados",
    "logs"
  )
  
  for (dir in directorios) {
    if (!dir.exists(dir)) {
      message(paste("Creando directorio:", dir))
      dir.create(dir, recursive = TRUE)
    } else {
      message(paste("El directorio ya existe:", dir))
    }
  }
}

# Función para crear archivos de plantilla
crear_archivos_plantilla <- function() {
  # Lista de archivos de script con contenido básico
  scripts <- list(
    "scripts/01_importar.R" = '# Script para importar y preparar datos
library(tidyverse)
library(here)

# Importar datos
datos_crudos <- read.csv(here("datos", "crudos", "datos.csv"))

# Procesar datos
datos_limpios <- datos_crudos %>%
  # Añade aquí tu procesamiento de datos
  na.omit()

# Guardar datos procesados
write_csv(datos_limpios, here("datos", "procesados", "datos_limpios.csv"))
saveRDS(datos_limpios, here("datos", "procesados", "datos_limpios.rds"))
',
    
    "scripts/02_analizar.R" = '# Script para realizar análisis estadísticos
library(tidyverse)
library(here)

# Cargar datos procesados
datos_limpios <- readRDS(here("datos", "procesados", "datos_limpios.rds"))

# Realizar análisis
# [Añade aquí tu código de análisis]

# Guardar resultados
save(list = ls(pattern = "resultado|modelo|analisis"), 
     file = here("salida", "resultados", "datos_procesados.RData"))
',
    
    "scripts/03_visualizar.R" = '# Script para generar gráficos
library(tidyverse)
library(here)

# Cargar datos procesados
datos_limpios <- readRDS(here("datos", "procesados", "datos_limpios.rds"))

# Crear gráficos
p <- ggplot(datos_limpios, aes(x = variable1, y = variable2)) +
  geom_point() +
  theme_minimal() +
  labs(title = "Título del gráfico")

# Guardar gráficos
ggsave(here("salida", "figuras", "grafico1.png"), p, width = 8, height = 5, dpi = 300)
',
    
    "informe.qmd" = '---
title: "Título del informe"
author: "Tu nombre"
date: today
format:
  html:
    toc: true
    code-fold: true
  pdf:
    toc: true
    number-sections: true
execute:
  echo: false
  warning: false
  message: false
lang: es
---

## Introducción

Este es un informe reproducible creado con Quarto.

```{r configuracion}
#| include: false
library(tidyverse)
library(knitr)

# Configuración global
knitr::opts_chunk$set(fig.width = 8, fig.height = 5)

# Cargar resultados
load("salida/resultados/datos_procesados.RData")
```

### Análisis

```{r}
#| fig-cap: "Figura 1: Descripción de la figura"
knitr::include_graphics("salida/figuras/grafico1.png")
```

### Conclusiones

Tus conclusiones aquí.  
',
    ".gitignore" = '# Archivos de historial de R

.Rhistory  
.Rapp.history

## Archivos de sesión de R

.RData  
.Rproj.user/

## Archivos de RStudio

.Rproj.user  
*.Rproj

## Archivos generados por knitr y Quarto

*.utf8.md  
*.knit.md  
*.html  
*.pdf  
_book/  
_freeze/  
/.quarto/

## Archivos grandes en datos (si aplica)

datos/crudos/_.csv  
datos/crudos/_.xlsx  
datos/crudos/*.rds

## Archivos del sistema operativo

.DS_Store  
Thumbs.db

## Registro de errores

logs/  
',
    
    "README.md" = '# Proyecto de Análisis

Este repositorio contiene un proyecto de análisis reproducible con Quarto y R.

### Estructura

- `datos/`: Directorio para almacenar datos
    - `crudos/`: Datos originales sin procesar
    - `procesados/`: Datos después del preprocesamiento
- `scripts/`: Scripts de R para análisis
- `salida/`: Resultados generados
    - `figuras/`: Gráficos y visualizaciones
    - `resultados/`: Objetos de R con resultados del análisis
- `informe.qmd`: Documento Quarto para generar el informe final

### Uso

1. Clona este repositorio
2. Ejecuta `Rscript crear_estructura.R` para verificar la estructura de directorios
3. Coloca tus datos en `datos/crudos/`
4. Adapta los scripts en `scripts/` según tus necesidades
5. Ejecuta `Rscript generar_informe.R` para generar el informe final  
    ' 
  )
  
  ## Crear cada archivo si no existe
  
  for (archivo in names(scripts)) {  
    if (!file.exists(archivo)) {  
      message(paste("Creando archivo:", archivo))  
      writeLines(scripts[[archivo]], archivo)  
    } else {  
      message(paste("El archivo ya existe:", archivo))  
    }  
  }
  
  ## Crear archivo de datos de ejemplo
  
  if (!file.exists("datos/crudos/datos.csv")) {  
    message("Creando archivo de datos de ejemplo...")  
    set.seed(123)  
    datos_ejemplo <- data.frame(  
      id = 1:100,  
      variable1 = rnorm(100, mean = 50, sd = 10),  
      variable2 = rnorm(100, mean = 75, sd = 15),  
      grupo = sample(c("A", "B", "C"), 100, replace = TRUE)  
    )  
    write.csv(datos_ejemplo, "datos/crudos/datos.csv", row.names = FALSE)  
  }  
}

## Crear archivo de proyecto RStudio

crear_proyecto_rstudio <- function() {
  
  ## Obtener nombre de la carpeta actual
  
  nombre_proyecto <- basename(getwd())
  
  ## Archivo .Rproj
  
  contenido_rproj <- paste0(  
    "Version: 1.0\n\n",  
    "RestoreWorkspace: Default\n",  
    "SaveWorkspace: Default\n",  
    "AlwaysSaveHistory: Default\n\n",  
    "EnableCodeIndexing: Yes\n",  
    "UseSpacesForTab: Yes\n",  
    "NumSpacesForTab: 2\n",  
    "Encoding: UTF-8\n\n",  
    "RnwWeave: Sweave\n",  
    "LaTeX: pdfLaTeX\n"  
  )
  
  ## Crear archivo .Rproj si no existe
  
  if (!file.exists(paste0(nombre_proyecto, ".Rproj"))) {  
    message(paste("Creando archivo de proyecto RStudio:", paste0(nombre_proyecto, ".Rproj")))  
    writeLines(contenido_rproj, paste0(nombre_proyecto, ".Rproj"))  
  }  
}

## Función principal

crear_estructura_proyecto <- function() {
  
  ## Mostrar mensaje de inicio
  
  cat("=== Creando estructura de proyecto para análisis reproducible ===\n")
  
  ## Crear estructura de directorios
  
  crear_estructura_directorios()
  
  ## Crear archivos de plantilla
  
  crear_archivos_plantilla()
  
  ## Crear archivo de proyecto RStudio
  
  crear_proyecto_rstudio()
  
  ## Verificar paquetes necesarios
  
  paquetes_necesarios <- c("tidyverse", "knitr", "here", "quarto")  
  paquetes_faltantes <- paquetes_necesarios[!paquetes_necesarios %in% rownames(installed.packages())]
  
  if (length(paquetes_faltantes) > 0) {  
    message("\nSe recomienda instalar los siguientes paquetes:")  
    for (pkg in paquetes_faltantes) {  
      if (pkg == "quarto") {  
        message(paste(" -", pkg, "(con remotes::install_github('quarto-dev/quarto-r'))"))  
      } else {  
        message(paste0(" - ", pkg, "( con install.packages('", pkg, "') )"))
      }  
    }  
  }
  
  cat("\n=== Estructura del proyecto creada exitosamente ===\n")  
  cat("Ahora puedes:\n")  
  cat("1. Adaptar los scripts en la carpeta 'scripts/'\n")  
  cat("2. Colocar tus datos en 'datos/crudos/'\n")  
  cat("3. Ejecutar 'Rscript generar_informe.R' para procesar datos y generar el informe\n")  
}
