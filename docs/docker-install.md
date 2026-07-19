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

Open `http://<server-ip>:7343`. Create the administrator, confirm or change the
automatically created **Library** root with the folder picker, and choose Refresh.

The first refresh walks the complete library. Later refreshes still check the folder
tree, but unchanged archive metadata is reused.

## 4. Add another library folder

Every Library Root must point to a path that exists inside the container. First add a
new read-only mount to `compose.yaml`, for example:

```yaml
volumes:
  - "/srv/books:/library:ro"
  - "/srv/manga:/books/manga:ro"
environment:
  BF_LIBRARY_BROWSE_ROOTS: >-
    [{"name":"Library","path":"/library"},{"name":"Manga","path":"/books/manga"}]
```

Recreate the container, then use Settings → Attach library and select **Manga** in the folder
picker. Users do not type either `/books/manga` or the host path `/srv/manga` in the web
UI.

Use **Change** if a mounted folder was renamed; BiblioFuse keeps the root's catalog
identity. **Disable** retains catalog data. **Detach** works for the last root
too and purges that root's BiblioFuse catalog, metadata and reading progress without
deleting book files or folders.

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
library folders.

For an explicit factory reset:

1. Run `docker compose down`.
2. Back up the host folders named by `CONFIG_PATH` and `CACHE_PATH`.
3. Rename those two folders as retained backups and create new empty folders with the
   same original names and permissions.
4. Run `docker compose up -d` and create a new administrator.

Never rename, empty or delete `LIBRARY_PATH`. BiblioFuse mounts it read-only.

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

There is no email recovery. Recreating only the container does not reset the password
because the verifier is stored in `/config`. Use the explicit factory-reset procedure
above if losing the existing BiblioFuse account, identity, catalog and settings is
acceptable; the library itself remains untouched.
