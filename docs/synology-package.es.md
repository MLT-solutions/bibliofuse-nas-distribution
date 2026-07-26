# Paquete nativo de Synology

[English](synology-package.md) | [Español](synology-package.es.md) | [Français](synology-package.fr.md) | [Nederlands](synology-package.nl.md) | [Português](synology-package.pt.md) | [Русский](synology-package.ru.md) | [简体中文](synology-package.zh-CN.md) | [日本語](synology-package.ja.md) | [한국어](synology-package.ko.md) | [Bahasa Indonesia](synology-package.id.md) | [Bahasa Melayu](synology-package.ms.md)

## Estado actual

El paquete x86-64 `0.1.0-0013` es la versión DSM 7. Proporciona un flujo de acceso sencillo y sin root:

- ningún nombre de carpeta compartida, dirección NAS o ruta de biblioteca está integrado en el paquete;
- los libros permanecen en sus carpetas compartidas DSM existentes;
- BiblioFuse no puede concederse acceso ni cambiar permisos DSM;
- Configuración explica cómo dar acceso de solo lectura a la cuenta restringida del paquete;
- Adjuntar biblioteca y Desvincular controlan solo la indexación y nunca eliminan archivos de biblioteca.

El paquete no es un contenedor. Package Center controla el ciclo de vida, el icono del menú principal y la cuenta interna restringida del sistema.

## Idioma del navegador

En Configuración, elija **Idioma** para seguir el idioma del sistema o seleccionar inglés, español, francés, neerlandés, portugués, ruso, chino simplificado, japonés, coreano, indonesio o malayo. La selección se guarda solo en ese navegador y permanece tras las actualizaciones del paquete.

## Instale y conceda acceso

1. Instale el `.spk` x86-64 mediante Package Center → Manual Install.
2. Abra BiblioFuse NAS y cree un administrador con al menos 12 caracteres.
3. Abra Configuración → **Mostrar los 6 pasos**, o siga estos pasos:
   1. Abra DSM **Control Panel** → **Shared Folder**.
   2. Seleccione la carpeta compartida existente que contiene sus libros y elija **Edit**.
   3. Abra **Permissions**.
   4. Cambie el desplegable a **System internal user**.
   5. Busque `BiblioFuseNAS`, conceda **Read only** y guarde.
   6. Vuelva a BiblioFuse → **Adjuntar biblioteca** → **Actualizar acceso** y luego elija el recurso compartido o una subcarpeta de libros.
4. Seleccione **Actualizar libros**.

No es necesario escribir una ruta `/volume1/...` ni `/var/packages/...`. No es necesario reiniciar el paquete después de conceder acceso.

## Ciclo de vida de los datos

- **Desactivar:** conserva el catálogo y permite volver a habilitar el adjunto.
- **Desvincular:** purga el catálogo, metadatos y progreso de lectura de BiblioFuse de ese adjunto.
- **Actualizar paquete:** conserva cuenta, identidad de certificado, configuración, catálogo y caché.
- **Desinstalar paquete:** borra todos los datos propiedad de BiblioFuse: cuenta, contraseña, identidad, configuración, catálogo, registro y caché.
- **Biblioteca:** siempre permanece fuera de los datos del paquete BiblioFuse y nunca se elimina.

Una actualización desde el paquete de prueba privado v8 migra su alias de recurso del paquete a la ruta normal de volumen DSM preservando la identidad de la raíz.

## Red y límite de soporte actual

- `7343/tcp`: biblioteca y lector de navegador gratuitos en la LAN de confianza.
- `7342/tcp`: listener de cliente nativo HTTPS fijado.
- `7341/tcp`: reservado y nunca utilizado.

Al iniciarse, el paquete obtiene la dirección LAN privada activa de DSM y anuncia Bonjour directamente desde el host NAS. Si DSM Tailscale está activo, la dirección `tailscale0` se incluye como sugerencia opcional de conexión manual. Las respuestas JSON nativas grandes incluyen `Content-Length` para compatibilidad con el transporte fijado de Apple publicado.

El emparejamiento Wi-Fi local con las apps iOS/visionOS publicadas es compatible mediante Bonjour y HTTPS fijado. El streaming nativo sigue sujeto al límite Premium de la app nativa.

## Arquitectura

El paquete inicial es compatible con Synology x86-64. ARM64 permanece sin compilar y sin probar. Compruebe la arquitectura de CPU de su NAS antes de descargar una versión.
