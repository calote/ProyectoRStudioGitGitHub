#!/usr/bin/env Rscript
# Script para ejecutar todo el proceso de análisis y generar el informe-solo final

# Verificar que existan los directorios necesarios
verificar_estructura_solo <- function() {
  directorios_requeridos <- c(
    # "datos/crudos", 
    # "datos/procesados", 
    # "scripts",
    "salida/figuras", 
    "salida/resultados"
  )
  
  faltantes <- directorios_requeridos[!dir.exists(directorios_requeridos)]
  
  if (length(faltantes) > 0) {
    stop(paste("Faltan directorios necesarios:", 
               paste(faltantes, collapse = ", "), 
               "\nEjecuta primero 'Rscript crear_estructura.R'"))
  }
  
  # Verificar que exista el archivo de informe
  if (!file.exists("informe.qmd")) {
    stop("No se encuentra el archivo informe.qmd. Ejecuta primero 'Rscript crear_estructura.R'")
  }
  

}

# Función para ejecutar un script con manejo de errores
ejecutar_script_solo <- function(ruta_script) {
  # Crear directorio de logs si no existe
  if (!dir.exists("logs")) {
    dir.create("logs")
  }
  
  # Nombre del archivo de log basado en el nombre del script
  nombre_script <- basename(ruta_script)
  archivo_log <- paste0("logs/", gsub("\\.R$", "", nombre_script), "_", 
                        format(Sys.time(), "%Y%m%d_%H%M%S"), ".log")
  
  mensaje_inicio <- paste("Ejecutando:", ruta_script, "-", format(Sys.time(), "%Y-%m-%d %H:%M:%S"))
  message(mensaje_inicio)
  
  # Abrir conexión para capturar la salida
  log_con <- file(archivo_log, open = "w")
  sink(log_con, type = "output")
  sink(log_con, type = "message")
  
  # Ejecutar el script con manejo de errores
  resultado <- try({
    source(ruta_script, echo = TRUE)
    TRUE  # Éxito
  }, silent = FALSE)
  
  # Cerrar la conexión
  sink(type = "message")
  sink(type = "output")
  close(log_con)
  
  if (inherits(resultado, "try-error")) {
    mensaje_error <- paste("ERROR al ejecutar", ruta_script, ":", resultado[1])
    message(mensaje_error)
    write(mensaje_error, "logs/errores.log", append = TRUE)
    return(FALSE)
  } else {
    mensaje_exito <- paste("Completado:", ruta_script, "-", format(Sys.time(), "%Y-%m-%d %H:%M:%S"))
    message(mensaje_exito)
    return(TRUE)
  }
}

# Función para renderizar el informe con Quarto
renderizar_informe_solo <- function() {
  # Crear directorio de logs si no existe
  if (!dir.exists("logs")) {
    dir.create("logs")
  }
  
  mensaje_inicio <- paste("Renderizando informe Quarto -", format(Sys.time(), "%Y-%m-%d %H:%M:%S"))
  message(mensaje_inicio)
  
  # Intentar cargar el paquete quarto
  tiene_quarto_r <- require("quarto", quietly = TRUE)
  
  # Archivo de log
  archivo_log <- paste0("logs/quarto_", format(Sys.time(), "%Y%m%d_%H%M%S"), ".log")
  
  # Intentar renderizar
  resultado_html <- FALSE
  resultado_pdf <- FALSE
  
  # Usar paquete quarto si está disponible
  if (tiene_quarto_r) {
    tryCatch({
      message("Generando versión HTML...")
      quarto::quarto_render("informe.qmd", output_format = "html")
      resultado_html <- TRUE
    }, error = function(e) {
      mensaje_error <- paste("Error al renderizar HTML:", e$message)
      message(mensaje_error)
      write(mensaje_error, archivo_log, append = TRUE)
    })
    
    tryCatch({
      message("Generando versión PDF...")
      quarto::quarto_render("informe.qmd", output_format = "pdf")
      resultado_pdf <- TRUE
    }, error = function(e) {
      mensaje_error <- paste("Error al renderizar PDF:", e$message)
      message(mensaje_error)
      write(mensaje_error, archivo_log, append = TRUE)
    })
  }
  
  # Si el paquete quarto no está disponible o falló, intentar con system
  if (!tiene_quarto_r || (!resultado_html && !resultado_pdf)) {
    message("Intentando renderizar con comando del sistema...")
    
    # Verificar si quarto está instalado en el sistema
    quarto_instalado <- suppressWarnings(system("quarto --version", intern = TRUE))
    
    if (!is.null(attr(quarto_instalado, "status"))) {
      mensaje_error <- "No se encontró Quarto instalado en el sistema. Instálalo desde https://quarto.org/docs/get-started/"
      message(mensaje_error)
      write(mensaje_error, archivo_log, append = TRUE)
    } else {
      message("Usando Quarto instalado en el sistema...")
      
      # Renderizar HTML
      if (!resultado_html) {
        system_resultado_html <- system("quarto render informe.qmd --to html", intern = TRUE)
        write(paste(system_resultado_html, collapse = "\n"), archivo_log, append = TRUE)
        resultado_html <- TRUE
      }
      
      # Renderizar PDF
      if (!resultado_pdf) {
        system_resultado_pdf <- system("quarto render informe.qmd --to pdf", intern = TRUE)
        write(paste(system_resultado_pdf, collapse = "\n"), archivo_log, append = TRUE)
        resultado_pdf <- TRUE
      }
    }
  }
  
  # Verificar resultados
  if (resultado_html && resultado_pdf) {
    message("Informe generado con éxito en formatos HTML y PDF")
    return(TRUE)
  } else if (resultado_html) {
    message("Informe generado solo en formato HTML")
    return(TRUE)
  } else if (resultado_pdf) {
    message("Informe generado solo en formato PDF")
    return(TRUE)
  } else {
    mensaje_error <- "No se pudo generar el informe en ningún formato"
    message(mensaje_error)
    write(mensaje_error, "logs/errores.log", append = TRUE)
    return(FALSE)
  }
}

# Organizar archivos de salida
organizar_archivos <- function() {
  # Mover archivos de informe a carpeta salida si existen
  if (file.exists("informe.html")) {
    if (!dir.exists("salida/informes")) {
      dir.create("salida/informes", recursive = TRUE)
    }
    file.copy("informe.html", "salida/informes/informe.html", overwrite = TRUE)
    message("Archivo HTML copiado a salida/informes/")
  }
  
  if (file.exists("informe.pdf")) {
    if (!dir.exists("salida/informes")) {
      dir.create("salida/informes", recursive = TRUE)
    }
    file.copy("informe.pdf", "salida/informes/informe.pdf", overwrite = TRUE)
    message("Archivo PDF copiado a salida/informes/")
  }
}

# Función principal
generar_informe_completo_solo <- function() {
  # Registrar hora de inicio
  hora_inicio <- Sys.time()
  cat("=== Iniciando generación de informe-solo:", format(hora_inicio, "%Y-%m-%d %H:%M:%S"), "===\n\n")
  
  # Verificar estructura
  tryCatch({
    verificar_estructura_solo()
  }, error = function(e) {
    stop(e$message)
  })
  

    # Renderizar el informe Quarto
    renderizado_exitoso <- renderizar_informe_solo()
    
    if (renderizado_exitoso) {
      # Organizar archivos de salida
      organizar_archivos()
    }
    
  # Registrar hora de finalización
  hora_fin <- Sys.time()
  tiempo_total <- difftime(hora_fin, hora_inicio, units = "mins")
  
  cat("\n=== Proceso completado en", round(tiempo_total, 2), "minutos ===\n")
  cat("Finalizado:", format(hora_fin, "%Y-%m-%d %H:%M:%S"), "\n")
}

# Ejecutar la función principal
generar_informe_completo_solo()
