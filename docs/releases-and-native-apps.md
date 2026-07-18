# Releases and native-app support

## Public distribution

This repository is the public installation and support surface. It does not contain
the private BiblioFuse NAS server source.

Planned release locations:

| Artifact | Location |
| --- | --- |
| Multi-architecture Docker image | `ghcr.io/mlt-solutions/bibliofuse-nas` |
| Compose templates and guides | This repository |
| Versioned notes, checksums and downloads | GitHub Releases |
| Synology Package Center file (`.spk`) | GitHub Releases when ready |
| Product overview and native-app links | [bibliofuse.com](https://bibliofuse.com) |

## Free and Premium boundary

The Docker/Synology Container Manager server is free to host. The browser library and
web reader are free.

The currently released iOS and visionOS apps do not have a supported Docker pairing
flow. The planned Synology `.spk` is intended to add a supported connection experience.
Streaming from that Synology app into the native iOS/visionOS clients is intended to be
a Premium native-client feature.

Availability, pricing and supported connection methods can change before the `.spk`
release. Release notes and [bibliofuse.com](https://bibliofuse.com) are authoritative
for the version a user installs.
