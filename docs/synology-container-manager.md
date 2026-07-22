# Synology Container Manager tutorial

This guide installs the free Docker server and web UI through Container Manager. For
the separately tested native DSM package, see the
[Synology package guide](synology-package.md).

## Requirements

- DSM 7 with Container Manager
- An Intel/AMD 64-bit or ARM64 model supported by the published image
- Permission to create shared folders and Container Manager projects

## 1. Create folders

In File Station, create:

```text
docker/bibliofuse/config
docker/bibliofuse/cache
```

The project mounts DSM `/volume1` read-only. Settings will list the actual shared
folders the configured DSM account can read; it does not auto-attach any of them.

## 2. Select the container user

The container must write config/cache and read the library. Use the numeric UID and GID
of a dedicated DSM account with those permissions. Over SSH:

```sh
id <username>
```

The defaults `1026:100` are examples only and may not match your NAS.

## 3. Create the project

1. Download `synology/compose.yaml`.
2. Open Container Manager → Project → Create.
3. Choose a project name such as `bibliofuse`.
4. Upload or paste the Compose file.
5. Set:
   - `CONFIG_PATH`, for example `/volume1/docker/bibliofuse/config`
   - `CACHE_PATH`, for example `/volume1/docker/bibliofuse/cache`
   - `PUID` and `PGID`
   - `BF_TIME_ZONE`, for example `Asia/Kuala_Lumpur`
6. Build/start the project.

## 4. First setup

Open:

```text
http://<nas-ip>:7343
```

Create an administrator password of at least 12 characters. In Settings, choose
**Attach library**, select a displayed DSM shared folder or book subfolder, then choose
Refresh. No DSM or container path needs to be typed. The picker filters out unreadable
shares using the selected container UID/GID.

Roots can be changed, disabled, or removed. Disable retains catalog data. Remove purges
that root's BiblioFuse catalog, metadata and reading progress without deleting files or
folders; removing the last root leaves a valid empty library.

## 5. Reading and refresh

Refresh checks the whole mounted tree and indexes new, changed, renamed or removed
books. Automatic refresh is disabled by default; Settings can schedule a daily or
weekly refresh.

Continuous comic mode loads pages progressively. On a DS923+ or similar NAS, some
brief loading lag can still occur for uncached archive pages. A Mac or PC host will
generally provide a more seamless native streaming experience because its CPU can
decompress and prepare pages faster.

## 6. Backup and upgrade

- Include the config folder in Hyper Backup.
- Cache can be excluded.
- Download a BiblioFuse backup in Settings before upgrading.
- Keep the previous config backup because database migrations may be forward-only.
- Pull the new image and recreate the project without changing folder mappings.

Never select an uninstall option that deletes the mapped config or library folders.

For a Container Manager factory reset, stop the project, back up and rename the
configured config and cache folders, create new empty folders with the original names
and permissions, then restart. Never include the library folder in this cleanup.

## 7. Network boundary

- `7343`: free browser UI on a trusted LAN
- `7342`: pinned native-client HTTPS API, discovered on Local Wi-Fi through Bonjour
- `7341`: do not publish

Container Manager and the native `.spk` pair with released iOS/visionOS apps on Local
Wi-Fi through Bonjour. Native streaming remains subject to the native app's Premium
feature boundary; Docker does not provide a manual/Tailscale native route.

Do not run this Container Manager project beside the native BiblioFuse Synology package
on the same NAS. Both services bind `7342` and `7343`; choose one installation method.
