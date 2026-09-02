# Native Synology package

[English](synology-package.md) | [Español](synology-package.es.md) | [Français](synology-package.fr.md) | [Nederlands](synology-package.nl.md) | [Português](synology-package.pt.md) | [Русский](synology-package.ru.md) | [简体中文](synology-package.zh-CN.md) | [日本語](synology-package.ja.md) | [한국어](synology-package.ko.md) | [Bahasa Indonesia](synology-package.id.md) | [Bahasa Melayu](synology-package.ms.md)

## Current status

> **Important:** Install `0.1.0-0057` only with [BiblioFuse for iOS 2.1.8 (105) or later](https://appstoreconnect.apple.com/teams/94c57d4b-571f-4fc1-bee8-61d285a65029/apps/6758330093/testflight/visionos/768998c3-02f2-45e6-b22a-30599d0485ae).

The `0.1.0-0057` x86-64 package is the DSM 7 release. It provides a non-root,
layman-friendly access flow:

- no shared-folder name, NAS address or library path is baked into the package;
- books remain in their existing DSM shared folders;
- BiblioFuse cannot grant itself access or change DSM permissions;
- Settings explains how to grant the restricted package account read-only access;
- Attach and Detach control indexing only and never delete library files.

The package is not a container. Package Center owns lifecycle, the main-menu icon and
the restricted system-internal account.

## Browser language

In Settings, choose **Language** to follow the system language or select English,
Spanish, French, Dutch, Portuguese, Russian, Simplified Chinese, Japanese, Korean,
Indonesian, or Malay. The selection is stored only in that browser and survives package
upgrades.

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

## Add BiblioFuse as a Package Source (recommended, for automatic updates)

Manual Install works for a first install, but Package Center only offers an **Update**
button for packages that came from a registered Package Source. Adding this feed once
means future releases show up the same way an officially listed package does.

1. Open DSM **Package Center** → **Settings** → **Package Sources** → **Add**.
2. Name: `BiblioFuse NAS`.
3. Location: `https://mlt-solutions.github.io/bibliofuse-nas-distribution/synology-repo.json`
4. Save, then reopen Package Center. **BiblioFuse NAS** appears under **Community** and
   can be installed or updated from there going forward.

This feed is a static file, regenerated automatically from each GitHub Release; it lists
only the official x86-64 `.spk` published in this repository, with its checksum.
Package Center still validates the downloaded archive itself before installing or
upgrading.

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
