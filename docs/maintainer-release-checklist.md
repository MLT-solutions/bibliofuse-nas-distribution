# Maintainer release checklist

This is a publication checklist, not an end-user install guide.

## Repository

- [x] Create a public GitHub repository for these distribution files.
- [x] Keep the server source repository private.
- [x] Confirm the public repository contains no source, credentials, private addresses,
      production configuration, signing material or customer/library data.
- [ ] Add a support/contact path and an explicit license or terms decision.
- [ ] Link the repository from the NAS/Docker page on `bibliofuse.com`.

## Container

- [x] Build from an immutable private-source commit and version tag.
- [x] Publish `linux/amd64` and `linux/arm64`.
- [x] Publish a numbered tag and only then move `latest`.
- [x] Include OCI provenance and SBOM attestations.
- [x] Set the GHCR package visibility to public.
- [x] Verify an anonymous pull with an empty Docker credential store.
- [x] Inspect the final image and confirm it contains only required runtime artifacts.
- [x] Record the image digest in the GitHub Release.

Docker `0.1.2` was anonymously pulled and verified on 2026-07-19. The published
multi-platform image digest reported by Docker is
`sha256:994682d50c3ddfc33e2b515557f265a93b347d606b876043be9bcb792c4f8f57`.

Docker `0.1.3` was anonymously pulled and runtime-verified on 2026-07-19. The published
multi-platform image digest reported by Docker is
`sha256:9db0f641664c62e5bc44c80c879a8437b545a7adc2a6d16a2d617f7dc21c035f`.

Docker `0.1.5` was published on 2026-07-22 with local-Wi-Fi Bonjour discovery and the
multi-platform digest `sha256:6bf3d1252d4372385aa9e6ca1488cebe8f44a6c407724e86db662cd6eb0bca4d`.

Docker `0.1.6` was published with the browser localization bundle and the multi-platform
digest `sha256:f8bb79cc17c32ebb562343c52d040b0092c473ea227d3e5e7dc5929c043b83b6`.

Docker `0.1.7` was anonymously pulled and verified on 2026-07-27 (empty
`~/.docker/config.json`, public GHCR package visibility confirmed via the API). The
published multi-platform image digest reported by Docker is
`sha256:0ef6b49d2ae2534fdb72e4b064563e9a6c7291bb33313b29ce9c16c772843e5f`.

Docker `0.1.8` was anonymously pulled and verified on 2026-07-27 (public GHCR package
visibility confirmed via the API, `docker manifest inspect` succeeded with no stored
`ghcr.io` credentials). The published multi-platform image digest reported by Docker is
`sha256:865a24b5006528faf784e304df4029dbdebfe135044eaf3c51deb7881e926e8c`. This release
fixes an iOS WebKit crash reproduced and diagnosed on a physical iPhone via Console.app
system log capture — see [v0.1.8 release notes](releases/v0.1.8.md).

## Validation

- [ ] Fresh-install Docker Compose on amd64.
- [ ] Fresh-install Docker Compose on arm64.
- [ ] Fresh-install Synology Container Manager on supported physical hardware.
- [x] Verify fresh setup starts with no attached root and requires an explicit Settings
      attachment.
- [ ] Verify refresh, scheduled refresh, restart persistence, backup and restore.
- [ ] Verify CBZ/ZIP/CBR/RAR, EPUB and TXT/TEXT/Markdown with representative books.
- [ ] Verify paged and continuous comic reading, including cold and warm cache behavior.
- [ ] Verify no port `7341` mapping or advertisement.
- [x] Verify Local Wi-Fi iOS discovery and pinned HTTPS streaming against the released
      app.
- [x] Fresh-install, upgrade and uninstall the x86-64 `.spk` on a physical DS923+.
- [x] Verify the `.spk` folder picker, root removal, catalog refresh and browser reader.
- [x] Verify `.spk` Local Wi-Fi native-client pairing.
- [ ] Build and validate an ARM64 `.spk` on supported physical hardware.

## GitHub Release

- [x] Create release notes with compatibility and known limitations.
- [ ] Link versioned Compose files.
- [x] Publish checksums for downloadable assets.
- [x] Add the generic `.spk` and checksum after DSM ACL attach/detach, upgrade and
      Local Wi-Fi Bonjour validation.
- [ ] Keep older releases available for rollback, with database compatibility warnings.

## Website

- [ ] State that Docker hosting and the web UI are free.
- [ ] State that Docker-to-released-iOS/visionOS is not currently supported.
- [x] Document the generic x86-64 package's read-only DSM access flow and remaining
      physical validation gate.
- [ ] Keep Premium wording attached to native-client streaming, not Docker web use.
- [ ] Set honest NAS performance expectations and recommend Mac/PC hosting for the
      smoothest reading experience.
