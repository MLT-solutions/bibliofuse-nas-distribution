# Maintainer release checklist

This is a publication checklist, not an end-user install guide.

## Repository

- [x] Create a public GitHub repository for these distribution files.
- [x] Keep the server source repository private.
- [x] Confirm the public repository contains no source, credentials, private addresses,
      production configuration, signing material or customer/library data.
- [ ] Before every public push and release-tag creation, audit the staged files and final
      tag against the allowlist: documentation, Compose templates, approved static
      assets, checksums and release binaries only. Reject source directories, Dockerfiles
      and code extensions (`.go`, `.js`, `.ts`, `.swift`, `.py`, `.java`, `.cs`, `.rs`,
      `.c`, `.cpp`, `.h`).
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

Docker `0.1.9` was anonymously pulled and verified on 2026-08-07 (`docker manifest
inspect` succeeded with no stored `ghcr.io` credentials in `~/.docker/config.json`).
The published multi-platform image digest reported by Docker is
`sha256:27e004d5c966b494fba17650917cb620b655257507af019fc95b98f6044ef20a`. This release
adds the Tailscale Serve Remote Access and Subnet Access Settings wizards for reaching
Kavita/Komga remotely — see [v0.1.9 release notes](releases/v0.1.9.md). The Synology
`.spk` was rebuilt as `BiblioFuseNAS-0.1.0-0043-x86_64.spk` and fresh-install, upgrade
and uninstall were validated on a physical DS923+. ARM64 `.spk` remains unbuilt.

Docker `0.1.10` was anonymously fetched and inspected through the public GHCR registry
API on 2026-08-10. The OCI index contains `linux/amd64` and `linux/arm64` images plus
provenance/SBOM attestation manifests. Both runtime filesystems contain the stripped,
static BiblioFuse executable and required Alpine runtime files, with no source tree,
Dockerfile or source-code files. The multi-platform digest is
`sha256:826995ce40f6b1a93b33b87795969516613e1649859ae49a4a2982d1c8aa1b8d`.
The DSM 7 x86-64 package was rebuilt as `BiblioFuseNAS-0.1.0-0050-x86_64.spk`;
physical Synology fresh-install and upgrade validation for build 0050 remains pending.

Docker `0.1.11` was anonymously fetched and inspected through the public GHCR registry
API on 2026-08-18 (no stored `ghcr.io` credentials in `~/.docker/config.json`). The OCI
index contains `linux/amd64` and `linux/arm64` images plus provenance/SBOM attestation
manifests. The `linux/amd64` image's layers were downloaded and listed directly:
one layer holds only the stripped, trimpathed static BiblioFuse executable at
`/usr/local/bin/bibliofuse`, the base layers hold only expected Alpine/busybox and
ca-certificates files, and the final layer holds only the empty `/config`, `/cache` and
`/library` directories — no source tree, `Dockerfile`, or absolute local machine paths
in any layer or embedded in the binary's symbol table. The multi-platform digest is
`sha256:87e95083f6b09f10b1f5e0205b1ad3508923ecbb8710e9863ad018f50ded5187`.
The DSM 7 x86-64 package was rebuilt as `BiblioFuseNAS-0.1.0-0056-x86_64.spk`
(SHA-256 `f0ee31922b51afddecf196425f838aa0b23c9e5da228da55ae86754a243424d4`); its archive
was extracted and inspected locally with the same result. Physical Synology
fresh-install and upgrade validation for build 0056 remains pending.

Docker `0.1.12` carries the EPUB illustration fix — see [v0.1.12 release notes](releases/v0.1.12.md).
It was anonymously fetched and inspected through the public GHCR registry API on
2026-09-02 (registry token obtained with no credentials, confirming public visibility).
The OCI index contains `linux/amd64` and `linux/arm64` images plus provenance/SBOM
attestation manifests. The `linux/amd64` image's four layers were downloaded and listed
directly: the base layers hold only expected Alpine/busybox and ca-certificates files,
one layer holds only the stripped, trimpathed static BiblioFuse executable at
`/usr/local/bin/bibliofuse`, and the final layer holds only the empty `/config`, `/cache`
and `/library` directories — no source tree, `Dockerfile`, code-extension files, or
absolute local machine paths in any layer or embedded in the binary. The multi-platform
digest is `sha256:f68f59e67bd09479008e371b54589ba1da8c11061532428b0d5882031e8aaa5a`.
The DSM 7 x86-64 package was rebuilt as
`BiblioFuseNAS-0.1.0-0057-x86_64.spk` (SHA-256
`e2db3a1ea084bbc43c228d7c3d060a91d650b89618bb5d0802b1bc3ebc721b14`); its archive was
extracted and inspected locally — one static, stripped, trimpathed server executable plus
package metadata, UI resources and the port-config file, with no source tree, no
`Dockerfile`, no code-extension files and no absolute local machine paths. Build 0057 was
installed on physical Synology hardware and the EPUB illustration fix verified there
before release.


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
- [ ] State the minimum compatible native-app version in the release notes and Synology
      package guide before publishing a new `.spk`.
- [ ] Keep older releases available for rollback, with database compatibility warnings.
- [x] Confirm `.github/workflows/publish-package-source.yml` regenerated
      `synology-repo.json` on `gh-pages` with the new release's version, link and md5
      after publishing (see `docs/synology-package.md#add-bibliofuse-as-a-package-source-recommended-for-automatic-updates`).

## Website

- [ ] State that Docker hosting and the web UI are free.
- [ ] State that Docker-to-released-iOS/visionOS is not currently supported.
- [x] Document the generic x86-64 package's read-only DSM access flow and remaining
      physical validation gate.
- [ ] Keep Premium wording attached to native-client streaming, not Docker web use.
- [ ] Set honest NAS performance expectations and recommend Mac/PC hosting for the
      smoothest reading experience.
