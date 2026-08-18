# Releases and native-app support

## Public distribution

This repository is the public installation and support surface. It does not contain
the private BiblioFuse NAS server source.

Release locations:

| Artifact | Location |
| --- | --- |
| Multi-architecture Docker image | `ghcr.io/mlt-solutions/bibliofuse-nas` |
| Compose templates and guides | This repository |
| Versioned notes, checksums and downloads | GitHub Releases |
| Synology Package Center file (`.spk`) | GitHub Releases (`x86-64` DSM 7) |
| Synology Package Center auto-update feed | `https://mlt-solutions.github.io/bibliofuse-nas-distribution/synology-repo.json` |
| Product overview and native-app links | [bibliofuse.com](https://bibliofuse.com) |

## Free and Premium boundary

The Docker/Synology Container Manager server is free to host. The browser library and
web reader are free.

Released iOS and visionOS apps discover Docker and Synology hosts on Local Wi-Fi through
Bonjour and stream over pinned HTTPS. Docker provides no manual/Tailscale native route.
Streaming into native clients remains subject to the native app's Premium feature
boundary.

## Synology package compatibility

Install `BiblioFuseNAS-0.1.0-0056-x86_64.spk` only with
[BiblioFuse for iOS 2.1.8 (105) or later](https://appstoreconnect.apple.com/teams/94c57d4b-571f-4fc1-bee8-61d285a65029/apps/6758330093/testflight/visionos/768998c3-02f2-45e6-b22a-30599d0485ae).

Release notes and [bibliofuse.com](https://bibliofuse.com) are authoritative for the
version a user installs.
