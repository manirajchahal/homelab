# homelab

A single-node Proxmox VE server, `pve1`, running my media stack, dashboard,
monitoring, document archive and a game server, each in its own unprivileged
LXC container.

> The Raspberry Pi 5 + two mini-PC cluster this repo described in 2025 is
> retired. Its docs and configs are archived in
> [`legacy/2025-pi-cluster/`](legacy/2025-pi-cluster/).

---

## Host

| | |
|---|---|
| Hypervisor | Proxmox VE 9.2, kernel 7.0, standalone node `pve1` |
| CPU / RAM | AMD Ryzen 9 5900X (12C/24T) / 64 GB |
| GPU | NVIDIA RTX 4070, passed into CT 100 for Jellyfin NVENC/NVDEC |
| System disk | Samsung 980 PRO 2 TB: OS, swap, `local-lvm` thin pool (1.7 TB) |
| Backup disk | Crucial P2 500 GB, dedicated to vzdump |
| Network | Flat LAN `192.168.4.0/22`; Tailscale for remote access; no reverse proxy |

## Guests

| ID | Name | IP | CPU / RAM / disk | Runs |
|---|---|---|---|---|
| CT 100 | `arr-stack` | 192.168.4.2 | 6 / 32 GB / 64 G + 1.4 TB `/data` | Jellyfin (GPU), Seerr, Sonarr, Radarr, Prowlarr, Bazarr, SABnzbd, qBittorrent behind gluetun (WireGuard), FlareSolverr, Maintainerr, Recyclarr |
| CT 102 | `homepage` | 192.168.4.3 | 2 / 1 GB / 8 G | [Homepage](https://gethomepage.dev) dashboard |
| CT 103 | `services` | 192.168.4.4 | 4 / 4 GB / 32 G | Uptime Kuma, Scrutiny, Jellystat, ntfy, Paperless-ngx, IronRank |
| CT 104 | `valheim` | 192.168.4.5 | 4 / 8 GB / 32 G | Valheim dedicated server (crossplay, BepInEx mods) |
| VM 101 | `Debian` | - | 32 GB / 128 G | Spare, normally stopped |

Every container is Debian with Docker Compose under `/opt/<stack>`.

## Service map

| Port | Service | Host |
|---|---|---|
| 8096 | Jellyfin | CT 100 |
| 5055 | Seerr (requests) | CT 100 |
| 8989 / 7878 / 9696 / 6767 | Sonarr / Radarr / Prowlarr / Bazarr | CT 100 |
| 8080 | SABnzbd | CT 100 |
| 8085 | qBittorrent WebUI (inside the VPN namespace) | CT 100 |
| 6246 | Maintainerr | CT 100 |
| 3000 | Homepage | CT 102 |
| 3001 | Uptime Kuma | CT 103 |
| 8081 | Scrutiny (SMART) | CT 103 |
| 3002 | Jellystat | CT 103 |
| 8082 | ntfy | CT 103 |
| 8000 | Paperless-ngx | CT 103 |
| 8095 | IronRank (gym tracker PWA) | CT 103 |
| 2456-2458/udp, 8090 | Valheim, join-code JSON | CT 104 |
| 8006 | Proxmox UI | pve1 |
| 61208 | Glances REST API | pve1 |

## Highlights

- **GPU passthrough into an unprivileged LXC that survives reboots.** The
  `nvidia-uvm` device major changes between boots, so nothing hardcodes it.
  See [docs/04](docs/04_gpu-passthrough.md).
- **VPN-bound torrent fallback with a kill switch.** qBittorrent lives in
  gluetun's network namespace, and a 5-minute check repairs it when gluetun
  is restarted or recreated.
- **Weekly LVM-thin TRIM.** One pass reclaimed 285 GB of blocks that guests had
  freed but the thin pool still held. See [docs/01](docs/01_hardware-and-storage.md).
- **Nightly backups to a dedicated disk**, 7 daily + 4 weekly, with a guard
  that fails the job rather than filling the OS disk if the drive is missing.
  See [docs/06](docs/06_backup-and-recovery.md).
- **Push alerts to my phone** from a self-hosted ntfy: Uptime Kuma, a 15-minute
  arr-stack health check, and a daily read-only Claude Code report.
  See [docs/05](docs/05_monitoring-and-alerts.md).

## Repo layout

```
docs/                  How and why, one topic per file
pve1/host/             Host files at their real paths (LXC configs, systemd units, scripts)
pve1/ct100-arr-stack/  Pointer to the private arr-stack repo
pve1/ct102-homepage/   Homepage compose + config
pve1/ct103-services/   Uptime Kuma / Scrutiny / Jellystat / ntfy / Paperless / IronRank compose
pve1/ct104-valheim/    Valheim compose + BepInEx patcher hook
legacy/2025-pi-cluster/  The previous Pi 5 + mini-PC lab
```

## Secrets

This repo contains no secrets. Every stack reads them from a `.env` next to
its compose file (`chmod 600`, gitignored), and each stack ships a
`.env.example` listing the variable names. Homepage references its keys as
`{{HOMEPAGE_VAR_*}}` placeholders.
