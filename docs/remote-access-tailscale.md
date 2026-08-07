# Remote access to Kavita or Komga via Tailscale

Available since BiblioFuse NAS `0.1.9`.

Settings includes a guided wizard that helps you reach a Kavita or Komga server
remotely using your own [Tailscale](https://tailscale.com) account, and pair it into
the BiblioFuse app's OPDS **Add Server** screen. This runs entirely between your own
devices and your own Tailscale account: BiblioFuse does not proxy, relay or store your
Kavita/Komga traffic, and it does not run Tailscale commands for you. Every command is
generated for you to review and run yourself.

## Requirements

- Kavita or Komga already installed and reachable, either on the same NAS as
  BiblioFuse or elsewhere on your LAN.
- A Tailscale account, with the BiblioFuse host joined to your tailnet.
- The BiblioFuse app, to scan the generated QR code into OPDS → **Add Server**.

Open **Settings** in the BiblioFuse NAS web UI and choose one of the two flows below.
Both show the exact commands for your own node, pre-filled from the values you enter.

## Method 1: Tailscale Serve Remote Access

Best for a private HTTPS `*.ts.net` address that is reachable from any device in your
tailnet, without opening a router or firewall port.

1. In the Tailscale admin console, enable HTTPS for this device.
2. On Synology DSM, open **Control Panel → Task Scheduler → Settings** and turn on
   **Save output results**, choosing a folder for the report. (On a Docker host, run
   the same command directly in a root shell instead of Task Scheduler.)
3. Copy the generated enable command from Settings and run it as a `root`
   User-defined script task (Task Scheduler) or in a root shell (Docker). Use the
   generated disable command later to remove the mapping.
4. Open the saved report to confirm the resulting HTTPS address.
5. Generate the QR code in Settings and scan it from the BiblioFuse app's OPDS →
   **Add Server** screen.

Use the NAS host port, not the container's internal port — if Docker publishes
`5050:5000`, enter `5050`.

## Method 2: Tailscale Subnet Access

Best for reaching Kavita or Komga at its existing local IP address from any
Tailscale-connected device, without configuring Serve at all. This also works when
Kavita/Komga run on a different LAN machine than BiblioFuse.

1. Run the generated `tailscale up --advertise-routes=...` command on the host
   advertising the subnet, then approve the route in the Tailscale admin console
   under **Machines → Subnets**.
2. Enter the Kavita/Komga local IP address and port in Settings, and generate a QR
   code.
3. Scan the QR code from the BiblioFuse app's OPDS → **Add Server** screen.

## Security notes

- Tailscale Serve only accepts `localhost`/`127.0.0.1` targets; it cannot be pointed
  at another machine's address.
- The QR code is generated entirely in your browser. An API key you enter for it never
  leaves the browser except inside the QR image itself.
- BiblioFuse does not store a Tailscale account, token, or Kavita/Komga credential on
  your behalf.

## Troubleshooting

- **Wrong Docker port** — if Docker publishes `5050:5000`, use `127.0.0.1:5050`, not
  `127.0.0.1:5000`.
- **HTTPS address unreachable** — confirm Tailscale is connected and signed into the
  same tailnet on both devices, and that you are using the full `*.ts.net` hostname
  with the matching HTTPS port.
- **Task Scheduler error: access denied** — the scheduled task must run as `root`.
- **Local service unreachable** — confirm the Kavita/Komga container or service is
  running and reachable at the port you entered.

See also: [remote access to the BiblioFuse browser UI itself](docker-install.md#browser-access-outside-the-home).
