# README: Guía para usar este repositorio con Git, GitHub y RStudio
Pedro L. Luque

- [Requisitos previos](#requisitos-previos)
- [Paso a paso para empezar con el
  repositorio](#paso-a-paso-para-empezar-con-el-repositorio)
  - [1. Configuración inicial en tu ordenador (solo una
    vez)](#1-configuración-inicial-en-tu-ordenador-solo-una-vez)
  - [2. Cómo hacer una copia (fork) del
    repositorio](#2-cómo-hacer-una-copia-fork-del-repositorio)
  - [3. Clonar el repositorio a tu
    ordenador](#3-clonar-el-repositorio-a-tu-ordenador)
  - [4. Desarrollo del trabajo](#4-desarrollo-del-trabajo)
  - [5. Guardar cambios con Git
    (commit)](#5-guardar-cambios-con-git-commit)
  - [6. Enviar cambios a GitHub (push)](#6-enviar-cambios-a-github-push)
  - [7. Actualizar desde el repositorio original (si es
    necesario)](#7-actualizar-desde-el-repositorio-original-si-es-necesario)
  - [8. Entregar el trabajo](#8-entregar-el-trabajo)
- [Comandos útiles de usethis para
  Git/GitHub](#comandos-útiles-de-usethis-para-gitgithub)
- [Problemas comunes](#problemas-comunes)
- [Organización del proyecto](#organización-del-proyecto)
  - [Ventajas de esta separación](#ventajas-de-esta-separación)

# Requisitos previos

1.  **Instalar R y RStudio**: Si aún no los tienes, [descarga
    R](https://cran.r-project.org/) y
    [RStudio](https://posit.co/download/rstudio-desktop/)
2.  **Crear una cuenta en GitHub**: Regístrate en
    [GitHub](https://github.com/)
3.  **Instalar Git**: Descarga e instala desde
    [git-scm.com](https://git-scm.com/downloads)

# Paso a paso para empezar con el repositorio

## 1. Configuración inicial en tu ordenador (solo una vez)

En RStudio, ejecuta:

``` r
# Instalar el paquete usethis si no lo tienes
install.packages("usethis")

# Configurar tu nombre y email para Git
library(usethis)
use_git_config(user.name = "Tu Nombre", 
               user.email = "tu.email@example.com")

# Crear un token de acceso personal para GitHub
create_github_token()
```

Cuando ejecutes `create_github_token()`:

- Se abrirá GitHub en tu navegador
- Dale un nombre descriptivo como “RStudio para clase”
- Selecciona al menos los permisos: “repo”, “workflow” y “user”
- Copia el token generado

Ahora guarda el token en R:

``` r
# Guarda tu token (reemplaza TU_TOKEN por el token que generaste)
gitcreds::gitcreds_set()
```

## 2. Cómo hacer una copia (fork) del repositorio

1.  Ve a la página principal de este repositorio en GitHub
2.  Haz clic en el botón “Fork” en la esquina superior derecha
3.  Esto creará una copia del repositorio en tu cuenta

## 3. Clonar el repositorio a tu ordenador

En RStudio:

``` r
# Reemplaza "TU_USUARIO" y "NOMBRE_REPOSITORIO" con los valores correctos
usethis::create_from_github("TU_USUARIO/NOMBRE_REPOSITORIO", 
                           destdir = "~/ruta/donde/guardar")
```

RStudio descargará el repositorio y abrirá un nuevo proyecto.

## 4. Desarrollo del trabajo

1.  Modifica los archivos según las instrucciones de la asignatura
2.  Crea nuevos archivos si es necesario

## 5. Guardar cambios con Git (commit)

Cuando quieras guardar tus cambios:

1.  En RStudio, ve al panel “Git” (pestaña superior derecha)
2.  Marca (✓) los archivos que quieres guardar
3.  Haz clic en “Commit”
4.  Escribe un mensaje descriptivo de tus cambios
5.  Haz clic en “Commit”

Buen mensaje de commit: “Añade análisis de correlación para variables
económicas”  
Mal mensaje: “Actualización”

## 6. Enviar cambios a GitHub (push)

Cuando quieras subir tus cambios a GitHub:

1.  En el panel Git, haz clic en “Push” (flecha hacia arriba)
2.  Tus cambios ahora estarán en tu repositorio en GitHub

## 7. Actualizar desde el repositorio original (si es necesario)

Si el profesor actualiza el repositorio original:

``` r
# Configurar el repositorio original como "upstream" (solo la primera vez)
usethis::use_git_remote("upstream", 
                       url = "https://github.com/USUARIO_PROFESOR/NOMBRE_REPOSITORIO")

# Traer los cambios del repositorio original
pr_merge_from_upstream()
```

## 8. Entregar el trabajo

Cuando hayas terminado:

1.  Asegúrate de haber subido todos tus cambios con “Push”
2.  Comparte la URL de tu repositorio con tu profesor

# Comandos útiles de usethis para Git/GitHub

``` r
# Ver historial de cambios
usethis::pr_view_url()

# Crear una nueva rama
usethis::use_branch("nombre-rama")

# Obtener ayuda con Git
usethis::git_sitrep()

# Si tienes problemas de autenticación
gitcreds::gitcreds_set()
```

# Problemas comunes

- **Error de autenticación**: Vuelve a ejecutar
  `gitcreds::gitcreds_set()`
- **Conflictos de fusión**: Contacta con el profesor si aparecen
  mensajes de “merge conflict”
- **No aparece panel de Git**: Reinicia RStudio o usa
  `usethis::use_git()`

------------------------------------------------------------------------

¡Buena suerte con tu trabajo! Si tienes dudas, no dudes en crear un
“Issue” en este repositorio con tu pregunta.

# Organización del proyecto

## Ventajas de esta separación

1.  **Claridad conceptual**: Cada script tiene una única responsabilidad
    claramente definida

    - `crear_estructura.R`: Preparar el entorno inicial (se ejecuta solo
      una vez)
    - `generar_informe.R`: Ejecutar los análisis y generar el informe
      (cada vez que sea necesario)

2.  **Mejor experiencia para el usuario**:

    - El alumno primero usa `crear_estructura.R` para preparar su
      proyecto
    - Luego adapta los scripts a sus necesidades
    - Finalmente usa `generar_informe.R` para ejecutar todo el proceso

3.  **Gestión robusta de errores**:

    - Mejor registro de errores con archivos de log para cada script
    - Verificación de requisitos previos antes de ejecutar
    - Mensajes claros sobre qué hacer en caso de error

4.  **Flexibilidad de despliegue**:

    - Los informes finales se copian a una carpeta específica
      (`salida/informes/`)
    - Se intenta generar el informe de múltiples maneras si una falla

Esta estructura facilita el flujo de trabajo reproducible y ayuda a los
alumnos a entender las mejores prácticas en la organización de proyectos
de análisis de datos.
