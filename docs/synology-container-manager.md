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

Select the existing shared folder containing books. The library will be mounted
read-only.

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
   - `LIBRARY_PATH`, for example `/volume1/books`
   - `PUID` and `PGID`
   - `BF_TIME_ZONE`, for example `Asia/Kuala_Lumpur`
6. Build/start the project.

## 4. First setup

Open:

```text
http://<nas-ip>:7343
```

Create an administrator password of at least 12 characters. The default **Library**
root already uses `LIBRARY_PATH`. Confirm or change it with the folder picker in
Settings, then choose Refresh. No DSM or container path needs to be typed.

You only add another root after mounting another NAS folder at a distinct container
path and declaring that mount in `BF_LIBRARY_BROWSE_ROOTS`. Roots can be changed,
disabled, or removed. Disable retains catalog data. Remove purges that root's
BiblioFuse catalog, metadata and reading progress without deleting files or folders;
removing the last root leaves a valid empty library.

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
- `7342`: native-client server API, reserved for supported future connection flows
- `7341`: do not publish

Container Manager installation does not currently pair with the released iOS or
visionOS apps. The native `.spk` has a native streaming listener, but local Wi-Fi and
Tailscale pairing remain pending physical validation; native streaming remains subject
to the native app's Premium feature boundary.
