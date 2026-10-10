# Changelog

All notable changes to this repo.

## [Unreleased]

## [2026-10-10]
### Changed
- Repo now documents the current lab: single Proxmox VE 9.2 node `pve1`
  (Ryzen 9 5900X, 64 GB, RTX 4070) with four LXC stacks. New README, `docs/`,
  and sanitized configs under `pve1/` (LXC definitions, systemd units, compose
  files, Homepage config).
- The 2025 Raspberry Pi 5 + mini-PC lab moved to `legacy/2025-pi-cluster/`.
### Removed
- Router configuration backup, purged from git history. Config dumps
  (`*.tar.gz`, `*.zip`, ...) are now gitignored.

## pve1 build log (2026)
- 09-04: pve1 built; CT 100 arr-stack (Jellyfin, arrs, SABnzbd, Seerr).
- 09-07: CT 102 Homepage dashboard; CT 103 services (Uptime Kuma, Scrutiny,
  Jellystat, ntfy, Paperless-ngx); Glances + Scrutiny collector on the host.
- 09-08: Jellyfin transcodes on a 16 GB tmpfs; Tailscale + ntfy push on CT 103.
- 09-11: Torrent fallback: gluetun (WireGuard) + qBittorrent + FlareSolverr,
  usenet-first delay profile, custom format against mislabelled dual-audio fakes.
- 09-12: Weekly LVM-thin TRIM timer (reclaimed 285 GB); CT 104 Valheim
  crossplay server with join-code tile on Homepage.
- 09-17: Reboot-proof NVIDIA passthrough (devnodes unit, PVE `devN:` entries,
  CDI regeneration); first host reboot; PVE 9.2 + kernel 7.0.
- 09-18: arr-stack health check (15 min) and daily read-only Claude report to
  ntfy; qBittorrent excludes executable payloads.
- 09-24: Tailscale SSH on the host; Claude Code Remote Control for phone admin.
- 09-26: Backups moved to a dedicated Crucial P2 (7 daily + 4 weekly).
- 10-05: arr-stack image updates with rollback tags; Jellyfin held at 10.11.
- 10-08: IronRank gym-tracker PWA on CT 103.

## [2025-11-02]
- Initial repo structure, docs templates, and starter compose.
- Added automation scripts for backup, health, and updates.
- Added Prometheus starter config.

## [2025-11-04]
- Started up all services on Raspberry Pi 5 through docker-compose.yml.
- Configured uptime-kuma + prometheus.

## [2025-11-07]
### Added
- Added new `camera-stream/` module for remote viewing of homelab LCD via USB webcam.
