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
| Docker / Synology Container Manager | Public beta `0.1.5` | Free server, browser UI and Local Wi-Fi native streaming |
| BiblioFuse web reader | Included | CBZ, ZIP, CBR, RAR, EPUB, TXT, TEXT and Markdown |
| Released iOS / visionOS apps with Docker | Supported on Local Wi-Fi | Bonjour discovery and pinned HTTPS streaming; Premium is enforced by the native app |
| Synology Package Center app (`.spk`) | Public x86-64 release | Non-root package with guided read-only access to existing DSM shared folders |
| iOS / visionOS native streaming from the Synology app | Supported on Local Wi-Fi | Bonjour discovery and pinned HTTPS streaming; Premium is enforced by the native app |
| BiblioFuse Mac / PC host | Separate product | Recommended when the smoothest native streaming performance is the priority |

Docker and the browser reader remain free. Native streaming is a Premium feature of the
iOS/visionOS app and works on the same local Wi-Fi network.

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
   and `BF_TIME_ZONE`. `LIBRARY_PATH` is your own host folder; BiblioFuse never assumes
   a personal folder name or path.
4. Start BiblioFuse:

```sh
docker compose up -d
```

5. Open `http://<server-ip>:7343`.
6. Create the first administrator account.
7. Open Settings → **Attach library**, choose the displayed **Library** location or a
   subfolder, then select **Refresh**.

The Compose file makes your selected `LIBRARY_PATH` available as the friendly **Library**
location. A fresh installation attaches no folders automatically: selecting a folder in
Settings controls what BiblioFuse indexes. The container cannot find a host folder that
was not mounted in Compose.

See the [Docker installation guide](docs/docker-install.md) for updates, backups,
permissions, remote access and troubleshooting.

## Install with Synology Container Manager

Use `synology/compose.yaml` as a Container Manager project. Set the project variables
to absolute Synology paths, then start the project and open:

```text
http://<nas-ip>:7343
```

The Synology project mounts DSM `/volume1` read-only and automatically lists the actual
shared folders the selected `PUID`/`PGID` can read. It does not attach any folder until
the administrator chooses one in Settings. Config and cache folders must be writable by
that numeric user/group.

Library folders can be changed, disabled, or detached in Settings. Detaching one,
including the last one, clears that root's BiblioFuse catalog, metadata and reading
progress without deleting books or folders.

See the [Synology tutorial](docs/synology-container-manager.md) for a complete walkthrough.

## Native Synology package status

The generic x86-64 package runs as the restricted `BiblioFuseNAS` DSM account and does
not create, move or assume a library folder. A Settings guide shows how to grant that
account read-only access to an existing shared folder. The folder picker then lists only
shares the account can actually read; Attach and Detach never delete book files.

See the [native Synology package guide](docs/synology-package.md) for installation and
permissions.

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
- Port `7342` is the server's pinned native-client HTTPS API. On Local Wi-Fi, iOS and
  visionOS discover it through Bonjour.
- Port `7341` is reserved and must never be published.

There is no email-based password recovery. For Docker, recreating only the container
does not reset the password because `/config` is persistent; use the documented explicit
factory reset after making a backup. For the Synology package, uninstall and reinstall
resets all BiblioFuse-owned data without touching the library.

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

Detaching a library is different: it purges that root's BiblioFuse catalog,
annotations and reading progress while leaving the read-only library files intact.

## Downloads and releases

The intended public release channels are:

- **Docker image:** `ghcr.io/mlt-solutions/bibliofuse-nas:0.1.5`
- **Docker and Synology Container Manager templates:** this repository
- **Version notes and downloadable assets:** GitHub Releases
- **Synology `.spk`:** GitHub Releases (`x86-64` DSM 7)
- **Product overview and native apps:** [bibliofuse.com](https://bibliofuse.com)

The Docker image is a public beta. The native x86-64 `.spk` is available for DSM 7.
Both use Local Wi-Fi Bonjour discovery for native streaming; no Docker Tailscale/manual
native route is provided.

## Help

Start with:

- [Docker installation and operations](docs/docker-install.md)
- [Synology Container Manager tutorial](docs/synology-container-manager.md)
- [Native Synology package status](docs/synology-package.md)
- [Performance guide](docs/performance.md)
- [Release channels and support boundary](docs/releases-and-native-apps.md)

When requesting help, include the NAS/host model, CPU architecture, Docker version,
book format, and recent container logs. Never post passwords, private keys, library
filenames you consider sensitive, or the contents of the config folder.
