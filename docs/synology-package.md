# Native Synology package

## Current status

The `0.1.0-0008` x86-64 package passed installation, first-run setup, folder selection,
catalog refresh, browser reading, safe root removal and complete package-data cleanup
on uninstall on a physical Synology DS923+.

That tested artifact was intentionally built with the test NAS's existing share name and
private LAN address. It is not a generic package and is not published in this public
repository.

## Public-release blocker

Synology's supported `data-share` package resource requires a shared-folder name to be
hard-coded in the package. The physical test used that mechanism to give the low-
privilege package account read-only access to an existing library.

A public package cannot assume that every user has the same share name. Publishing the
tested artifact would expose private configuration and fail for other users. The public
package therefore remains pending until it can safely select or obtain permission for
an existing share during installation without running the service as root.

The public artifact will require another physical installation, upgrade and uninstall
pass before release. ARM64 also remains unbuilt and untested.

## Data lifecycle

- **Disable root:** retain its catalog and allow it to be enabled again.
- **Remove root:** purge that root's BiblioFuse catalog, metadata and reading progress.
- **Upgrade package:** preserve account, identity, settings, catalog and cache.
- **Uninstall package:** wipe all BiblioFuse-owned account, password, identity, settings,
  catalog, log and cache data.
- **Library:** always remain outside BiblioFuse package data and never be deleted.

The tested package service received read-only access to the selected library share.

## Ports and current support boundary

- `7343/tcp`: free browser library and reader on the trusted LAN.
- `7342/tcp`: pinned-HTTPS native-client listener.
- `7341/tcp`: reserved and never used.

Local Wi-Fi and Tailscale pairing with the released iOS/visionOS apps remain pending
physical validation. Do not treat that connection path as supported until the release
notes say the tests have passed.

## Beta label

The `beta=yes` package field only displays beta status in Package Center. It is not a
time-limited trial, and the tested package contains no expiration timer. A later upgrade
may still be required for compatibility, security or support.
