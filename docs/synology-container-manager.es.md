# Tutorial de Synology Container Manager

[English](synology-container-manager.md) | [Español](synology-container-manager.es.md) | [Français](synology-container-manager.fr.md) | [Nederlands](synology-container-manager.nl.md) | [Português](synology-container-manager.pt.md) | [Русский](synology-container-manager.ru.md) | [简体中文](synology-container-manager.zh-CN.md) | [日本語](synology-container-manager.ja.md) | [한국어](synology-container-manager.ko.md) | [Bahasa Indonesia](synology-container-manager.id.md) | [Bahasa Melayu](synology-container-manager.ms.md)

Esta guía instala el servidor Docker gratuito y la interfaz web mediante Container Manager. Para el paquete DSM nativo probado por separado, consulte la [guía del paquete Synology](synology-package.md).

## Requisitos

- DSM 7 con Container Manager
- Un modelo Intel/AMD de 64 bits o ARM64 compatible con la imagen publicada
- Permiso para crear carpetas compartidas y proyectos de Container Manager

## 1. Crear carpetas

En File Station, cree:

```text
docker/bibliofuse/config
docker/bibliofuse/cache
```

El proyecto monta DSM `/volume1` en modo de solo lectura. Ajustes mostrará las carpetas compartidas reales que la cuenta DSM configurada puede leer; no adjunta ninguna automáticamente.

## 2. Seleccionar el usuario del contenedor

El contenedor debe escribir la configuración/caché y leer la biblioteca. Use el UID y GID numéricos de una cuenta DSM dedicada con esos permisos. Mediante SSH:

```sh
id <username>
```

Los valores predeterminados `1026:100` son solo ejemplos y pueden no coincidir con su NAS.

## 3. Crear el proyecto

1. Descargue `synology/compose.yaml`.
2. Abra Container Manager → Project → Create.
3. Elija un nombre de proyecto como `bibliofuse`.
4. Cargue o pegue el archivo Compose.
5. Defina:
   - `CONFIG_PATH`, por ejemplo `/volume1/docker/bibliofuse/config`
   - `CACHE_PATH`, por ejemplo `/volume1/docker/bibliofuse/cache`
   - `PUID` y `PGID`
   - `BF_TIME_ZONE`, por ejemplo `Asia/Kuala_Lumpur`
6. Compile/inicie el proyecto.

## 4. Primera configuración

Abra:

```text
http://<nas-ip>:7343
```

Cree una contraseña de administrador de al menos 12 caracteres. En Ajustes, elija **Attach library**, seleccione una carpeta compartida DSM mostrada o una subcarpeta de libros y luego elija Refresh. No necesita escribir ninguna ruta DSM ni de contenedor. El selector excluye los recursos no legibles usando el UID/GID del contenedor seleccionado.

Las raíces pueden cambiarse, desactivarse o eliminarse. Desactivar conserva los datos del catálogo. Eliminar purga de BiblioFuse el catálogo, los metadatos y el progreso de lectura de esa raíz sin borrar archivos ni carpetas; eliminar la última raíz deja una biblioteca vacía válida.

## 5. Lectura y actualización

Refresh comprueba todo el árbol montado e indexa libros nuevos, modificados, renombrados o eliminados. La actualización automática está desactivada de forma predeterminada; Ajustes puede programar una actualización diaria o semanal.

El modo de cómic continuo carga las páginas progresivamente. En un DS923+ o NAS similar, todavía puede haber una breve demora de carga para páginas de archivos no almacenadas en caché. Un Mac o PC normalmente ofrecerá una experiencia de transmisión nativa más fluida, porque su CPU puede descomprimir y preparar páginas más rápido.

## 6. Copia de seguridad y actualización

- Incluya la carpeta de configuración en Hyper Backup.
- La caché puede excluirse.
- Descargue una copia de seguridad de BiblioFuse desde Ajustes antes de actualizar.
- Conserve la copia de seguridad de configuración anterior porque las migraciones de base de datos pueden ser solo hacia adelante.
- Descargue la nueva imagen y vuelva a crear el proyecto sin cambiar las asignaciones de carpetas.

Nunca seleccione una opción de desinstalación que elimine las carpetas de configuración o biblioteca asignadas.

Para un restablecimiento de fábrica de Container Manager, detenga el proyecto, haga una copia de seguridad y cambie el nombre de las carpetas de configuración y caché configuradas, cree carpetas nuevas vacías con los nombres y permisos originales y reinicie. Nunca incluya la carpeta de biblioteca en esta limpieza.

## 7. Límite de red

- `7343`: interfaz gratuita de navegador en una LAN de confianza
- `7342`: API HTTPS fijada para clientes nativos, detectada en Wi-Fi local mediante Bonjour
- `7341`: no publicar

Container Manager y el `.spk` nativo se emparejan con las aplicaciones iOS/visionOS publicadas en Wi-Fi local mediante Bonjour. La transmisión nativa sigue sujeta al límite de funciones Premium de la aplicación nativa; Docker no proporciona una ruta nativa manual/Tailscale.

No ejecute este proyecto de Container Manager junto al paquete Synology nativo de BiblioFuse en el mismo NAS. Ambos servicios vinculan `7342` y `7343`; elija un método de instalación.
