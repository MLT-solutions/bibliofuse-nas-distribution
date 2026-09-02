<p align="center">
  <img src="assets/bibliofuse-logo.png" alt="Logotipo de BiblioFuse" width="180">
</p>

<h1 align="center">BiblioFuse NAS</h1>

[English](README.md) | [Español](README.es.md) | [Français](README.fr.md) | [Nederlands](README.nl.md) | [Português](README.pt.md) | [Русский](README.ru.md) | [简体中文](README.zh-CN.md) | [日本語](README.ja.md) | [한국어](README.ko.md) | [Bahasa Indonesia](README.id.md) | [Bahasa Melayu](README.ms.md)

<p align="center">
  Una biblioteca privada y autoalojada de ebooks y cómics para Docker y Synology NAS.
  <br>
  <a href="https://bibliofuse.com">Sitio web de BiblioFuse</a>
</p>

## Gratis para alojar y leer en el navegador

BiblioFuse NAS es gratuito para alojar en Docker o Synology Container Manager. Su biblioteca web y lector de navegador también son gratuitos. No se requiere suscripción para el servidor Docker ni la interfaz web.

Este repositorio público de distribución contiene archivos de instalación y documentación. El código fuente del servidor BiblioFuse se mantiene por separado y no se incluye aquí.

## Estado del producto

| Alojamiento o cliente | Disponibilidad | Compatibilidad de lectura y conexión |
| --- | --- | --- |
| Docker / Synology Container Manager | Beta pública `0.1.12` | Servidor gratuito, interfaz de navegador y streaming nativo por Wi-Fi local |
| Lector web de BiblioFuse | Incluido | CBZ, ZIP, CBR, RAR, EPUB, TXT, TEXT y Markdown |
| Apps publicadas de iOS / visionOS con Docker | Compatible en Wi-Fi local | Detección Bonjour y streaming HTTPS fijado; Premium se aplica en la app nativa |
| App de Synology Package Center (`.spk`) | Versión pública x86-64 | Paquete sin root con acceso de solo lectura guiado a carpetas compartidas DSM existentes |
| Streaming nativo de iOS / visionOS desde la app de Synology | Compatible en Wi-Fi local | Detección Bonjour y streaming HTTPS fijado; Premium se aplica en la app nativa |
| Host BiblioFuse Mac / PC | Producto independiente | Recomendado cuando el streaming nativo más fluido sea prioritario |

Docker y el lector de navegador siguen siendo gratuitos. El streaming nativo es una función Premium de la app para iOS/visionOS y funciona en la misma red Wi-Fi local.

## Idiomas del navegador

La app de navegador puede seguir el idioma del sistema o configurarse en Ajustes en inglés, español, francés, neerlandés, portugués, ruso, chino simplificado, japonés, coreano, indonesio o malayo. Esta elección se guarda en el navegador y no cambia la configuración del servidor, los metadatos de los libros ni los clientes nativos.

## Expectativas de rendimiento

Un NAS siempre encendido es práctico, privado y eficiente energéticamente, pero normalmente no prepara páginas de cómics/archivos tan rápido como un Mac o PC moderno.

- **Host Mac o PC:** la mejor opción para la experiencia de lectura nativa más fluida.
- **Host NAS:** ideal para una biblioteca personal siempre disponible, con cierta demora esperable al explorar o abrir páginas no almacenadas en caché.
- **La CPU del NAS importa:** la indexación de archivos, descompresión, miniaturas y preparación de la página siguiente requieren CPU. Un procesador de escritorio más potente suele marcar una diferencia mayor que cambiar solo un HDD.
- **HDD frente a SSD/NVMe:** el almacenamiento SSD o caché NVMe puede mejorar las lecturas en frío y el acceso repetido, pero no hace que una CPU NAS de bajo consumo rinda como un Mac o PC actual.
- **Modo cómic continuo:** las páginas cargan progresivamente. Una breve pausa mientras se prepara la siguiente página no almacenada en caché puede ser normal en hardware NAS.

BiblioFuse almacena en caché las páginas preparadas y empieza a preparar las próximas en el servidor. La primera visita a un archivo grande puede seguir siendo más lenta que las posteriores.

## Antes de empezar

Necesita:

- un host Intel/AMD o ARM64 de 64 bits con Docker Compose, o un modelo Synology con Container Manager;
- una carpeta persistente para la configuración de BiblioFuse;
- una carpeta desechable para la caché;
- una carpeta que contenga sus libros;
- el puerto TCP `7343` disponible para la interfaz web.

En Synology, cree carpetas similares a:

```text
/volume1/docker/bibliofuse/config
/volume1/docker/bibliofuse/cache
/volume1/books
```

Sus rutas pueden ser diferentes. BiblioFuse nunca necesita acceso de escritura a la carpeta de libros.

## Instalar con Docker Compose

1. Descargue `docker/compose.yaml` y `docker/.env.example` de este repositorio.
2. Copie `.env.example` a `.env`.
3. Edite `.env` y defina `CONFIG_PATH`, `CACHE_PATH`, `LIBRARY_PATH`, `PUID`, `PGID` y `BF_TIME_ZONE`. `LIBRARY_PATH` es su propia carpeta del host; BiblioFuse nunca presupone un nombre o ruta de carpeta personal.
4. Inicie BiblioFuse:

```sh
docker compose up -d
```

5. Abra `http://<server-ip>:7343`.
6. Cree la primera cuenta de administrador.
7. Abra Configuración → **Adjuntar biblioteca**, elija la ubicación **Biblioteca** mostrada o una subcarpeta y después seleccione **Actualizar libros**.

El archivo Compose hace que su `LIBRARY_PATH` seleccionada esté disponible como la ubicación amigable **Biblioteca**. Una instalación nueva no adjunta carpetas automáticamente: seleccionar una carpeta en Configuración controla lo que BiblioFuse indexa. El contenedor no puede encontrar una carpeta de host que no se montó en Compose.

Consulte la [guía de instalación de Docker](docs/docker-install.es.md) para actualizaciones, copias de seguridad, permisos, acceso remoto y solución de problemas.

## Instalar con Synology Container Manager

Use `synology/compose.yaml` como proyecto de Container Manager. Configure las variables del proyecto con rutas absolutas de Synology, inicie el proyecto y abra:

```text
http://<nas-ip>:7343
```

El proyecto de Synology monta DSM `/volume1` como solo lectura y lista automáticamente las carpetas compartidas reales que el `PUID`/`PGID` seleccionado puede leer. No adjunta ninguna carpeta hasta que el administrador elija una en Configuración. Las carpetas de configuración y caché deben poder escribirse por ese usuario/grupo numérico.

Las carpetas de biblioteca se pueden cambiar, desactivar o desvincular en Configuración. Desvincular una, incluida la última, borra el catálogo, metadatos y progreso de lectura de esa raíz de BiblioFuse sin eliminar libros ni carpetas.

Consulte el [tutorial de Synology](docs/synology-container-manager.es.md) para una guía completa.

No ejecute el proyecto Docker y el paquete nativo de Synology en el mismo NAS al mismo tiempo. Ambos usan intencionadamente los puertos `7342` y `7343` para el mismo servicio Wi-Fi local; elija un método de alojamiento por NAS.

## Estado del paquete nativo de Synology

El paquete genérico x86-64 se ejecuta como la cuenta DSM restringida `BiblioFuseNAS` y no crea, mueve ni presupone una carpeta de biblioteca. Una guía de Configuración explica cómo dar a esa cuenta acceso de solo lectura a una carpeta compartida existente. El selector de carpetas muestra solo los recursos que la cuenta realmente puede leer; Adjuntar biblioteca y Desvincular nunca eliminan archivos de libros.

Consulte la [guía del paquete nativo de Synology](docs/synology-package.es.md) para la instalación y los permisos.

## Actualización de biblioteca

**Refresh** comprueba todo el árbol de carpetas en busca de añadidos, eliminaciones y cambios de nombre, y vuelve a indexar solo los libros nuevos o modificados. Es seguro usarlo después de copiar nuevos libros a la carpeta montada.

En Configuración, la actualización automática está desactivada por defecto. Puede elegir:

- diariamente a una hora seleccionada; o
- semanalmente en un día y hora seleccionados.

Las horas están disponibles en intervalos de 30 minutos y usan el `BF_TIME_ZONE` configurado para el contenedor.

## Formatos compatibles con el lector web

- Cómics y archivos de imágenes: CBZ, ZIP, CBR y RAR
- Ebooks refluibles: EPUB
- Texto sin formato: TXT, TEXT y Markdown

Los archivos de cómic admiten modos de lectura paginado y continuo. La posición de lectura EPUB y texto se guarda en la interfaz web. PDF no está incluido actualmente en el lector web Docker.

## Contraseñas y seguridad

La primera contraseña de administrador del navegador debe tener al menos 12 caracteres. Guárdela en un gestor de contraseñas.

- El puerto `7343` es la interfaz de navegador. Manténgalo en una LAN de confianza o póngalo detrás de un proxy inverso HTTPS de confianza.
- No exponga `7343` directamente mediante reenvío de puertos del router.
- El puerto `7342` es la API HTTPS fijada para clientes nativos. En Wi-Fi local, iOS y visionOS la detectan mediante Bonjour.
- El puerto `7341` está reservado y nunca debe publicarse.

No existe recuperación de contraseña por correo electrónico. Para Docker, recrear solo el contenedor no restablece la contraseña porque `/config` es persistente; use el restablecimiento explícito de fábrica documentado después de hacer una copia de seguridad. Para el paquete Synology, desinstalar y reinstalar restablece todos los datos propiedad de BiblioFuse sin tocar la biblioteca.

## Copias de seguridad y actualizaciones

- Haga una copia de seguridad de toda la carpeta de configuración persistente.
- La carpeta de caché es desechable y no necesita copia de seguridad.
- La biblioteca permanece en su propia carpeta host/NAS y nunca se almacena dentro del contenedor.
- Antes de actualizar, use Ajustes para descargar una copia de seguridad de BiblioFuse y conserve una copia de la carpeta de configuración.
- Actualice con:

```sh
docker compose pull
docker compose up -d
```

Eliminar o recrear el contenedor no elimina su cuenta ni catálogo cuando la misma carpeta de configuración sigue montada.

Separar una biblioteca es distinto: purga el catálogo, anotaciones y progreso de lectura de BiblioFuse de esa raíz, dejando intactos los archivos de biblioteca de solo lectura.

## Descargas y versiones

Los canales de distribución pública previstos son:

- **Imagen Docker:** `ghcr.io/mlt-solutions/bibliofuse-nas:0.1.12`
- **Plantillas Docker y Synology Container Manager:** este repositorio
- **Notas de versión y activos descargables:** GitHub Releases
- **Synology `.spk`:** GitHub Releases (`x86-64` DSM 7)
- **Descripción general del producto y apps nativas:** [bibliofuse.com](https://bibliofuse.com)

La imagen Docker es una beta pública. El `.spk` nativo x86-64 está disponible para DSM 7. Ambos usan detección Bonjour por Wi-Fi local para streaming nativo; no se proporciona una ruta nativa manual/Tailscale para Docker.

## Ayuda

Empiece por:

- [Instalación y operaciones de Docker](docs/docker-install.es.md)
- [Tutorial de Synology Container Manager](docs/synology-container-manager.es.md)
- [Estado del paquete nativo de Synology](docs/synology-package.es.md)
- [Guía de rendimiento](docs/performance.md)
- [Canales de versión y límite de soporte de apps nativas](docs/releases-and-native-apps.md)

Al solicitar ayuda, incluya el modelo NAS/host, arquitectura de CPU, versión de Docker, formato del libro y registros recientes del contenedor. Nunca publique contraseñas, claves privadas, nombres de archivo de biblioteca que considere confidenciales ni el contenido de la carpeta de configuración.
