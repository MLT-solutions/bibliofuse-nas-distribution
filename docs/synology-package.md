# Native Synology package

## Current status

The `0.1.0-0012` x86-64 package is the DSM 7 release. It provides a non-root,
layman-friendly access flow:

- no shared-folder name, NAS address or library path is baked into the package;
- books remain in their existing DSM shared folders;
- BiblioFuse cannot grant itself access or change DSM permissions;
- Settings explains how to grant the restricted package account read-only access;
- Attach and Detach control indexing only and never delete library files.

The package is not a container. Package Center owns lifecycle, the main-menu icon and
the restricted system-internal account.

## Install and grant access

1. Install the x86-64 `.spk` through Package Center → Manual Install.
2. Open BiblioFuse NAS and create an administrator using at least 12 characters.
3. Open Settings → **Show the 6 steps**, or follow them here:
   1. Open DSM **Control Panel** → **Shared Folder**.
   2. Select the existing shared folder that contains your books and choose **Edit**.
   3. Open **Permissions**.
   4. Change the dropdown to **System internal user**.
   5. Find `BiblioFuseNAS`, grant **Read only**, and save.
   6. Return to BiblioFuse → **Attach library** → **Refresh access**, then choose the
      share or a book subfolder.
4. Select **Refresh books**.

No `/volume1/...` or `/var/packages/...` path needs to be typed. No package restart is
needed after granting access.

## Data lifecycle

- **Disable:** retain the catalog and allow the attachment to be enabled again.
- **Detach:** purge that attachment's BiblioFuse catalog, metadata and reading progress.
- **Upgrade package:** preserve account, certificate identity, settings, catalog and
  cache.
- **Uninstall package:** wipe all BiblioFuse-owned account, password, identity, settings,
  catalog, log and cache data.
- **Library:** always remain outside BiblioFuse package data and never be deleted.

An upgrade from the private v8 test package migrates its package-share alias to the
normal DSM volume path while preserving the root identity.

## Network and current support boundary

- `7343/tcp`: free browser library and reader on the trusted LAN.
- `7342/tcp`: pinned-HTTPS native-client listener.
- `7341/tcp`: reserved and never used.

At start, the package derives the active private LAN address from DSM and advertises
Bonjour directly from the NAS host. If DSM Tailscale is active, the `tailscale0` address
is included as an optional manual-connection suggestion. Large native JSON responses
include `Content-Length` for compatibility with the released Apple pinned transport.

Local Wi-Fi pairing with released iOS/visionOS apps is supported through Bonjour and
pinned HTTPS. Native streaming remains subject to the native app's Premium boundary.

## Architecture

The initial package supports Synology x86-64. ARM64 remains unbuilt and untested. Check
your NAS CPU architecture before downloading a release.
