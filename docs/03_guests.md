# Guests

All guests are unprivileged Debian LXCs with `nesting=1`, `onboot: 1`, Docker
CE from Docker's apt repo, and a Compose project under `/opt/<stack>`.
Definitions: [`pve1/host/etc/pve/lxc/`](../pve1/host/etc/pve/lxc/).

## CT 100 - arr-stack (192.168.4.2)

6 cores, 32 GB RAM, 64 G root, plus a 1.4 TB `/data` volume excluded from
backups (`backup=0`). Holds the media library, downloads and torrents on one
filesystem so imports are hardlinks, not copies.

- Jellyfin with NVIDIA NVENC/NVDEC ([GPU passthrough](04_gpu-passthrough.md)).
  The transcode directory is a **16 GB tmpfs**. That's why the CT has 32 GB:
  tmpfs pages count against the container's memory cgroup. It also keeps
  orphaned HLS segments (which once bloated a backup from 4.6 to 31 GB) off
  disk. A daily cron sweeps segments older than 24 h.
- Seerr for requests; Sonarr, Radarr, Prowlarr, Bazarr; Recyclarr syncs
  TRaSH-guide quality profiles; Maintainerr cleans up watched media.
- SABnzbd (usenet) is primary. qBittorrent behind gluetun is the fallback,
  with a 2-hour delay profile so usenet wins whenever it can.
- Full compose, scripts and runbooks live in the private `arr-stack` repo.

## CT 102 - homepage (192.168.4.3)

2 cores, 1 GB. [Homepage](https://gethomepage.dev) on :3000:
[`pve1/ct102-homepage/`](../pve1/ct102-homepage/). Kept in its own container
so the dashboard survives arr-stack maintenance.

- Config is YAML and hot-reloads on save; only `.env` changes need
  `docker compose up -d`.
- Homepage has **no Docker socket**. Every tile talks to the service's HTTP
  API with a key from `.env`.
- The Proxmox widget uses a read-only API token (`homepage@pve`, role
  `PVEAuditor`).
- The header shows live host metrics from Glances on the hypervisor
  ([override](../pve1/host/etc/systemd/system/glances.service.d/override.conf)).
- The Valheim tile reads a JSON file the game server writes (join code,
  players, state).

## CT 103 - services (192.168.4.4)

4 cores, 4 GB: [`pve1/ct103-services/`](../pve1/ct103-services/).

| Service | Port | Notes |
|---|---|---|
| Uptime Kuma | 3001 | ~20 monitors, status page `homelab`, alerts to ntfy |
| Scrutiny | 8081 | Hub here; the collector runs on the host, where the NVMe drives are |
| Jellystat | 3002 | Jellyfin playback stats (Postgres) |
| ntfy | 8082 | Push notifications; `NTFY_UPSTREAM_BASE_URL=https://ntfy.sh` makes iOS push work |
| Paperless-ngx | 8000 | Scanned document archive (Postgres + Redis) |
| IronRank | 8095 | My ranked gym-tracker PWA: static app + a tiny Python sync API |

## CT 104 - valheim (192.168.4.5)

4 cores, 8 GB: [`pve1/ct104-valheim/`](../pve1/ct104-valheim/).

- `ghcr.io/community-valheim-tools/valheim-server` with `CROSSPLAY=true`, so
  Steam and Xbox/Game Pass PC players join with a 6-digit join code. The code
  changes on every server restart.
- Vanilla world modifiers (3x resources, casual portals and death penalty,
  fewer raids) plus a BepInEx mod set. The client mod profile is shared as an
  r2modman code, and server and client mod versions must match.
- A log-filter hook writes the current join code and player count to
  `joincode.json`, which the container's built-in httpd serves on :8090 for the
  Homepage tile.
- World backups every 2 h, kept 7 days, on top of the nightly vzdump. The
  regenerable SteamCMD install is excluded from vzdump.
- Lesson: to tell whether players are online, use the image's
  `valheim-is-idle` (counts UDP traffic). The log's `now N player(s)` count can
  stick after a connection timeout.
