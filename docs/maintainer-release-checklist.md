# Maintainer release checklist

This is a publication checklist, not an end-user install guide.

## Repository

- [x] Create a public GitHub repository for these distribution files.
- [x] Keep the server source repository private.
- [ ] Confirm the public repository contains no source, credentials, private addresses,
      production configuration, signing material or customer/library data.
- [ ] Add a support/contact path and an explicit license or terms decision.
- [ ] Link the repository from the NAS/Docker page on `bibliofuse.com`.

## Container

- [ ] Build from an immutable private-source commit and version tag.
- [ ] Publish `linux/amd64` and `linux/arm64`.
- [ ] Publish a numbered tag and only then move `latest`.
- [ ] Include OCI provenance, SBOM and registry attestation.
- [ ] Set the GHCR package visibility to public.
- [ ] Verify an anonymous pull on a logged-out/clean machine.
- [ ] Inspect the final image and confirm it contains only required runtime artifacts.
- [ ] Record the image digest in the GitHub Release.

## Validation

- [ ] Fresh-install Docker Compose on amd64.
- [ ] Fresh-install Docker Compose on arm64.
- [ ] Fresh-install Synology Container Manager on supported physical hardware.
- [ ] Verify first administrator creation and default `/library` root.
- [ ] Verify refresh, scheduled refresh, restart persistence, backup and restore.
- [ ] Verify CBZ/ZIP/CBR/RAR, EPUB and TXT/TEXT/Markdown with representative books.
- [ ] Verify paged and continuous comic reading, including cold and warm cache behavior.
- [ ] Verify no port `7341` mapping or advertisement.
- [ ] Verify current iOS/visionOS unsupported messaging against released apps.
- [x] Fresh-install, upgrade and uninstall the x86-64 `.spk` on a physical DS923+.
- [x] Verify the `.spk` folder picker, root removal, catalog refresh and browser reader.
- [ ] Verify `.spk` local Wi-Fi and Tailscale native-client pairing.
- [ ] Build and validate an ARM64 `.spk` on supported physical hardware.

## GitHub Release

- [ ] Create release notes with compatibility and known limitations.
- [ ] Link versioned Compose files.
- [ ] Publish checksums for downloadable assets.
- [ ] Add a generic `.spk` and checksum only after install-time share selection and
      physical Synology validation.
- [ ] Keep older releases available for rollback, with database compatibility warnings.

## Website

- [ ] State that Docker hosting and the web UI are free.
- [ ] State that Docker-to-released-iOS/visionOS is not currently supported.
- [x] Document the private x86-64 validation and why its machine-specific artifact is
      not publicly downloadable.
- [ ] Keep Premium wording attached to native-client streaming, not Docker web use.
- [ ] Set honest NAS performance expectations and recommend Mac/PC hosting for the
      smoothest reading experience.
