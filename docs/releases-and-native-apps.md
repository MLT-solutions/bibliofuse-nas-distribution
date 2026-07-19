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
| Synology Package Center file (`.spk`) | GitHub Releases after the generic release candidate passes physical validation |
| Product overview and native-app links | [bibliofuse.com](https://bibliofuse.com) |

## Free and Premium boundary

The Docker/Synology Container Manager server is free to host. The browser library and
web reader are free.

The currently released iOS and visionOS apps do not have a supported Docker pairing
flow. The generic Synology release candidate includes the native streaming listener and
host-network discovery, but its local Wi-Fi/Tailscale pairing remains pending physical
validation. Streaming into native clients remains subject to the native app's Premium
feature boundary.

Availability, pricing and supported connection methods can change before the `.spk`
release. Release notes and [bibliofuse.com](https://bibliofuse.com) are authoritative
for the version a user installs.
