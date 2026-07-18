# Docker installation and operations

## 1. Choose the folders

BiblioFuse uses three host folders:

| Purpose | Container path | Required access | Backup |
| --- | --- | --- | --- |
| Account, identity, catalog and settings | `/config` | Read/write | Yes |
| Prepared pages and thumbnails | `/cache` | Read/write | No |
| Your book library | `/library` | Read-only | Back up separately |

The container paths stay the same. `CONFIG_PATH`, `CACHE_PATH` and `LIBRARY_PATH`
select the real folders on the host.

## 2. Configure Compose

Download the files in `docker/`, copy `.env.example` to `.env`, and edit `.env`.
Use absolute paths for a server installation.

On Linux, find the numeric user and group IDs with:

```sh
id
```

Set `PUID` and `PGID` to an identity that can write the config/cache folders and read
the library. BiblioFuse runs without root privileges.

## 3. Start and verify

```sh
docker compose pull
docker compose up -d
docker compose ps
docker compose logs --tail=100 bibliofuse
```

Open `http://<server-ip>:7343`. Create the administrator, confirm the automatically
created `/library` root in Settings, and choose Refresh.

The first refresh walks the complete library. Later refreshes still check the folder
tree, but unchanged archive metadata is reused.

## 4. Add another library folder

Every Library Root must point to a path that exists inside the container. First add a
new read-only mount to `compose.yaml`, for example:

```yaml
volumes:
  - "/srv/books:/library:ro"
  - "/srv/manga:/books/manga:ro"
```

Recreate the container, then use Settings → Add root with `/books/manga`. Do not enter
the host path `/srv/manga` in the web UI.

## 5. Schedule refresh

Settings supports Disabled, Daily and Weekly. Daily/weekly times use 30-minute slots.
Set `BF_TIME_ZONE` to a valid IANA timezone such as `Asia/Kuala_Lumpur`.

## 6. Update

Prefer a numbered image tag for controlled deployments. Back up `/config`, then:

```sh
docker compose pull
docker compose up -d
docker image prune
```

`docker image prune` is optional and removes unused image data, not books.

## 7. Stop or uninstall

```sh
docker compose down
```

This removes the container and network. It does not delete the host config, cache or
library folders. Deleting `/config` removes the BiblioFuse account, server identity,
settings and catalog. Do not delete it as a password-reset shortcut without first
making a backup.

## Browser access outside the home

Do not forward port `7343` directly from a router. Use a trusted HTTPS reverse proxy
with authentication and a valid certificate, or access the LAN address through your
own VPN/Tailscale network.

Tailscale access to the browser uses the NAS/server's Tailscale address followed by
`:7343`. This is browser access; it does not add Docker pairing to the currently
released iOS or visionOS apps.

## Troubleshooting

### The library is empty

- Confirm `LIBRARY_PATH` is the real host folder.
- Run `docker compose config` and check the `/library:ro` mount.
- Confirm `PUID:PGID` can read the host folder.
- Open Settings and run Refresh.

### Permission denied

The selected numeric user/group cannot access a mounted folder. Fix the host folder
permissions or select the correct `PUID`/`PGID`; do not run the container as root as
the first workaround.

### Pages pause while reading

Check CPU and disk activity. Cold archive pages must be decompressed and prepared.
The server preloads upcoming pages, but lower-power NAS CPUs can still show brief gaps.
Repeated reading should benefit from the persistent cache.

### Container repeatedly restarts

```sh
docker compose ps
docker compose logs --tail=200 bibliofuse
```

Check invalid mount paths, config/cache write permission, port conflicts and a damaged
or incomplete `.env`.

### Administrator password is lost

There is no email recovery. Preserve `/config` and consult the recovery instructions
for the exact installed release before changing files. Recreating only the container
does not reset the password because the verifier is stored in `/config`.
