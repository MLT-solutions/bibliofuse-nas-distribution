<p align="center">
  <img src="assets/bibliofuse-logo.png" alt="BiblioFuse logo" width="180">
</p>

<h1 align="center">BiblioFuse NAS</h1>

<p align="center">
  A private, self-hosted ebook and comic library for Docker and Synology NAS.
  <br>
  <a href="https://bibliofuse.com">BiblioFuse website</a>
</p>

## Free to host and read in your browser

BiblioFuse NAS is free to host in Docker or Synology Container Manager. Its web
library and browser reader are also free to use. No subscription is required for
the Docker server or web UI.

This public distribution repository contains installation files and documentation.
The BiblioFuse server source code is maintained separately and is not included here.

## Product status

| Host or client | Availability | Reading and connection support |
| --- | --- | --- |
| Docker / Synology Container Manager | Prepared for first public release | Free server and free browser UI |
| BiblioFuse web reader | Included | CBZ, ZIP, CBR, RAR, EPUB, TXT, TEXT and Markdown |
| Released iOS / visionOS apps with Docker | Not supported yet | There is no supported Docker-to-native-app connection flow in the released apps |
| Synology Package Center app (`.spk`) | Planned | Easier installation and supported iOS/visionOS native streaming are planned |
| iOS / visionOS native streaming from the planned Synology app | Planned Premium feature | Requires BiblioFuse Premium in the native client |
| BiblioFuse Mac / PC host | Separate product | Recommended when the smoothest native streaming performance is the priority |

Do not buy BiblioFuse Premium solely for Docker-to-iOS or Docker-to-visionOS
streaming today. That connection path is not currently supported.

## Performance expectations

An always-on NAS is convenient, private and power-efficient, but it is not normally
as fast at preparing comic/archive pages as a modern Mac or PC.

- **Mac or PC host:** the best choice for the smoothest native reading experience.
- **NAS host:** ideal for an always-available personal library, with some expected lag
  while browsing or opening uncached pages.
- **NAS CPU matters:** archive indexing, decompression, thumbnails and next-page
  preparation are CPU work. A more powerful desktop processor often makes a larger
  difference than replacing an HDD alone.
- **HDD versus SSD/NVMe:** SSD storage or NVMe cache can improve cold reads and repeated
  access, but it does not make a low-power NAS CPU perform like a current Mac or PC.
- **Continuous comic mode:** pages load progressively. A brief gap while the next
  uncached page is prepared can be normal on NAS hardware.

BiblioFuse caches prepared pages and starts preparing upcoming pages on the server.
The first visit to a large archive can still be slower than later visits.

## Before you begin

You need:

- a 64-bit Intel/AMD or ARM64 host with Docker Compose, or a Synology model with
  Container Manager;
- one persistent folder for BiblioFuse configuration;
- one disposable folder for cache;
- a folder containing your books;
- TCP port `7343` available for the web UI.

On Synology, create folders similar to:

```text
/volume1/docker/bibliofuse/config
/volume1/docker/bibliofuse/cache
/volume1/books
```

Your paths can be different. BiblioFuse never needs write access to the book folder.

## Install with Docker Compose

1. Download `docker/compose.yaml` and `docker/.env.example` from this repository.
2. Copy `.env.example` to `.env`.
3. Edit `.env` and set `CONFIG_PATH`, `CACHE_PATH`, `LIBRARY_PATH`, `PUID`, `PGID`,
   and `BF_TIME_ZONE`.
4. Start BiblioFuse:

```sh
docker compose up -d
```

5. Open `http://<server-ip>:7343`.
6. Create the first administrator account.
7. Open Settings, confirm the default **Library** root, and select **Refresh**.

The Compose file mounts your real book folder at `/library`. BiblioFuse automatically
creates the first Library Root for `/library`; you do not need to add it manually.
Use **Add root** only when you have mounted additional book folders into the container.

See the [Docker installation guide](docs/docker-install.md) for updates, backups,
permissions, remote access and troubleshooting.

## Install with Synology Container Manager

Use `synology/compose.yaml` as a Container Manager project. Set the project variables
to absolute Synology paths, then start the project and open:

```text
http://<nas-ip>:7343
```

The book folder is mounted read-only. The config and cache folders must be writable by
the numeric `PUID` and `PGID` selected for the container.

See the [Synology tutorial](docs/synology-container-manager.md) for a complete walkthrough.

## Library refresh

**Refresh** checks the complete folder tree for additions, removals and renames, while
reindexing only new or changed books. It is safe to use after copying new books into
the mounted folder.

In Settings, automatic refresh is disabled by default. You can choose:

- daily at a selected time; or
- weekly on a selected day and time.

Times are available in 30-minute intervals and use the `BF_TIME_ZONE` configured for
the container.

## Supported web-reader formats

- Comics and image archives: CBZ, ZIP, CBR and RAR
- Reflowable ebooks: EPUB
- Plain text: TXT, TEXT and Markdown

Comic archives support paged and continuous reading modes. EPUB and text reading
position is stored by the web UI. PDF is not currently included in the Docker web
reader.

## Passwords and security

The first browser administrator password must be at least 12 characters. Store it in a
password manager.

- Port `7343` is the browser UI. Keep it on a trusted LAN or put it behind a trusted
  HTTPS reverse proxy.
- Do not expose `7343` directly with router port forwarding.
- Port `7342` is reserved for the server's native-client HTTPS API. Publishing it does
  not make the current released iOS or visionOS app support Docker pairing.
- Port `7341` is reserved and must never be published.

There is no email-based password recovery. If the password is lost, do not delete the
library. Preserve the mounted config folder and follow the recovery instructions for
the installed version.

## Backups and updates

- Back up the entire persistent config folder.
- The cache folder is disposable and does not need backup.
- The library remains in your own host/NAS folder and is never stored inside the
  container.
- Before updating, use Settings to download a BiblioFuse backup and retain a copy of
  the config folder.
- Update with:

```sh
docker compose pull
docker compose up -d
```

Removing or recreating the container does not remove your account or catalog when the
same config folder remains mounted.

## Downloads and releases

The intended public release channels are:

- **Docker image:** `ghcr.io/mlt-solutions/bibliofuse-nas`
- **Docker and Synology Container Manager templates:** this repository
- **Version notes and downloadable assets:** GitHub Releases
- **Synology `.spk`:** GitHub Releases for manual Package Center installation when the
  package is ready
- **Product overview and native apps:** [bibliofuse.com](https://bibliofuse.com)

The `.spk` is planned and is not yet available. Until a release is published, treat
this repository as installation preparation rather than a finished public download.

## Help

Start with:

- [Docker installation and operations](docs/docker-install.md)
- [Synology Container Manager tutorial](docs/synology-container-manager.md)
- [Performance guide](docs/performance.md)
- [Release channels and support boundary](docs/releases-and-native-apps.md)

When requesting help, include the NAS/host model, CPU architecture, Docker version,
book format, and recent container logs. Never post passwords, private keys, library
filenames you consider sensitive, or the contents of the config folder.
