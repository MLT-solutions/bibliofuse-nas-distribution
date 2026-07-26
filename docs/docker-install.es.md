# Instalación y operaciones de Docker

[English](docker-install.md) | [Español](docker-install.es.md) | [Français](docker-install.fr.md) | [Nederlands](docker-install.nl.md) | [Português](docker-install.pt.md) | [Русский](docker-install.ru.md) | [简体中文](docker-install.zh-CN.md) | [日本語](docker-install.ja.md) | [한국어](docker-install.ko.md) | [Bahasa Indonesia](docker-install.id.md) | [Bahasa Melayu](docker-install.ms.md)

## Idioma del navegador

Después de la configuración, abra Configuración y elija **Idioma**. El navegador puede seguir el idioma del sistema o usar inglés, español, francés, neerlandés, portugués, ruso, chino simplificado, japonés, coreano, indonesio o malayo. La elección se guarda solo en ese navegador y no afecta al contenedor ni a los metadatos de la biblioteca.

## 1. Elija las carpetas

BiblioFuse utiliza tres carpetas del host:

| Propósito | Ruta del contenedor | Acceso necesario | Copia de seguridad |
| --- | --- | --- | --- |
| Cuenta, identidad, catálogo y configuración | `/config` | Lectura/escritura | Sí |
| Páginas preparadas y miniaturas | `/cache` | Lectura/escritura | No |
| Su biblioteca de libros | `/library` | Solo lectura | Copia por separado |

Las rutas del contenedor no cambian. `CONFIG_PATH`, `CACHE_PATH` y `LIBRARY_PATH` seleccionan las carpetas reales del host. Docker no puede localizar una ruta de biblioteca por sí solo: asigne la carpeta antes del primer inicio y luego elija la carpeta que desea adjuntar en Configuración.

## 2. Configure Compose

Descargue los archivos de `docker/`, copie `.env.example` a `.env` y edite `.env`. Use rutas absolutas para una instalación de servidor.

En Linux, encuentre los ID numéricos de usuario y grupo con:

```sh
id
```

Establezca `PUID` y `PGID` en una identidad que pueda escribir las carpetas de configuración/caché y leer la biblioteca. BiblioFuse se ejecuta sin privilegios root.

## 3. Inicie y compruebe

```sh
docker compose pull
docker compose up -d
docker compose ps
docker compose logs --tail=100 bibliofuse
```

Abra `http://<server-ip>:7343`. Cree el administrador y después elija **Adjuntar biblioteca** en Configuración. El selector muestra el montaje **Biblioteca** configurado y sus subcarpetas, pero una instalación nueva no tiene raíz adjunta hasta que seleccione una y elija Actualizar libros.

No ejecute este servicio Docker de red de host junto al paquete nativo de Synology en el mismo NAS: ambos enlazan HTTPS nativo `7342` e interfaz de navegador `7343`.

La primera actualización recorre toda la biblioteca. Las actualizaciones posteriores siguen comprobando el árbol de carpetas, pero se reutilizan los metadatos de archivos sin cambios.

## 4. Añada otra carpeta de biblioteca

Cada Library Root debe apuntar a una ruta que exista dentro del contenedor. Primero añada un nuevo montaje de solo lectura a `compose.yaml`, por ejemplo:

```yaml
volumes:
  - "/srv/books:/library:ro"
  - "/srv/manga:/books/manga:ro"
environment:
  BF_LIBRARY_BROWSE_ROOTS: >-
    [{"name":"Library","path":"/library"},{"name":"Manga","path":"/books/manga"}]
```

Recree el contenedor; después use Configuración → Adjuntar biblioteca y seleccione **Manga** en el selector de carpetas. Los usuarios no escriben ni `/books/manga` ni la ruta host `/srv/manga` en la interfaz web.

Use **Cambiar** si una carpeta montada cambió de nombre; BiblioFuse conserva la identidad de catálogo de la raíz. **Desactivar** conserva los datos de catálogo. **Desvincular** también funciona para la última raíz y purga el catálogo, metadatos y progreso de lectura de esa raíz de BiblioFuse sin eliminar archivos o carpetas de libros.

## 5. Programe la actualización

Configuración admite Desactivado, Diario y Semanal. Las horas diarias/semanales usan intervalos de 30 minutos. Configure `BF_TIME_ZONE` en una zona horaria IANA válida, como `Asia/Kuala_Lumpur`.

## 6. Actualice

Prefiera una etiqueta de imagen numerada para implementaciones controladas. Haga una copia de seguridad de `/config` y después:

```sh
docker compose pull
docker compose up -d
docker image prune
```

`docker image prune` es opcional y elimina datos de imágenes sin uso, no libros.

## 7. Detenga o desinstale

```sh
docker compose down
```

Esto elimina el contenedor y la red. No elimina las carpetas host de configuración, caché o biblioteca.

Para un restablecimiento explícito de fábrica:

1. Ejecute `docker compose down`.
2. Haga copia de seguridad de las carpetas host indicadas por `CONFIG_PATH` y `CACHE_PATH`.
3. Cambie el nombre de esas dos carpetas como copias retenidas y cree nuevas carpetas vacías con los mismos nombres y permisos originales.
4. Ejecute `docker compose up -d` y cree un administrador nuevo.

Nunca cambie el nombre, vacíe ni elimine `LIBRARY_PATH`. BiblioFuse la monta como solo lectura.

## Acceso al navegador fuera de casa

No reenvíe el puerto `7343` directamente desde un router. Use un proxy inverso HTTPS de confianza con autenticación y certificado válido, o acceda a la dirección LAN mediante su propia red VPN/Tailscale.

El acceso Tailscale al navegador usa la dirección Tailscale del NAS/servidor seguida de `:7343`. Es acceso de navegador; no añade emparejamiento Docker a las apps iOS o visionOS publicadas actualmente.

## Solución de problemas

### El selector de biblioteca está vacío

- Confirme que `LIBRARY_PATH` es la carpeta real del host y está definida antes de `docker compose up`.
- Ejecute `docker compose config` y compruebe el montaje `/library:ro`.
- Confirme que `PUID:PGID` puede leer la carpeta host.
- Recree el contenedor después de cambiar un montaje y vuelva a abrir Configuración.

### Permiso denegado

El usuario/grupo numérico seleccionado no puede acceder a una carpeta montada. Corrija los permisos de carpeta host o seleccione el `PUID`/`PGID` correcto; no ejecute el contenedor como root como primera solución.

### Las páginas se pausan durante la lectura

Compruebe actividad de CPU y disco. Las páginas de archivo en frío deben descomprimirse y prepararse. El servidor precarga las páginas próximas, pero las CPU NAS de menor potencia pueden seguir mostrando pausas breves. La lectura repetida debería beneficiarse de la caché persistente.

### El contenedor se reinicia repetidamente

```sh
docker compose ps
docker compose logs --tail=200 bibliofuse
```

Compruebe rutas de montaje no válidas, permiso de escritura de configuración/caché, conflictos de puertos y un `.env` dañado o incompleto.

### Se perdió la contraseña de administrador

No existe recuperación por correo electrónico. Recrear solo el contenedor no restablece la contraseña porque el verificador se guarda en `/config`. Use el procedimiento explícito de restablecimiento de fábrica anterior si es aceptable perder la cuenta, identidad, catálogo y configuración existentes de BiblioFuse; la biblioteca permanece intacta.
