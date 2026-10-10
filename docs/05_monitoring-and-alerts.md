# Monitoring and alerts

Most alerts end up as a push notification on my phone via the self-hosted
**ntfy** in CT 103 (topic `homelab`).

| Layer | Tool | What it catches |
|---|---|---|
| Service up/down | Uptime Kuma (CT 103) | ~20 HTTP/port monitors, grouped on a status page |
| Disks | Scrutiny (hub in CT 103, collector on the host every 15 min) | SMART health of both NVMe drives |
| Host metrics | Glances REST API on the host | CPU, temps, RAM and disk on the dashboard header |
| Media pipeline | `arr-health-check.py` (CT 100, every 15 min) | Stuck imports, failed or slow downloads, aired-but-missing episodes, paused SABnzbd, stalled torrents, usenet indexers in backoff, unhealthy containers, low disk |
| Daily summary | Headless Claude Code (CT 100, 08:00) | Reads a GET-only status snapshot and writes a plain-English report |
| Backups | Proxmox notifications (mail to root) | vzdump job result |

## Design notes

- **Alert on change, not on state.** The health check keys every issue and only
  pushes keys that are *new* since the last run, plus one "all clear" when the
  list empties. A persistent problem alerts once.
- **The daily LLM report is read-only by construction.** Its only allowed
  tool is a snapshot script that makes GET requests and prints no keys. Edit,
  Write, Read and web tools are disallowed, with a turn cap.
- **Scrutiny version pinning.** The host collector is pinned to v0.8.1 to match
  the web image. A 0.9.x collector "registers" successfully with an empty
  device list and logs no error.
- **ntfy on iOS** needs `NTFY_UPSTREAM_BASE_URL` (a content-free wake-up relayed
  through ntfy.sh) and a base URL the phone can reach on cellular. Here that's
  the CT's Tailscale MagicDNS name. Changing the base URL changes the push topic
  hash, so the app subscription must be re-added.
- **Uptime Kuma can't see a dead VPN tunnel.** qBittorrent's WebUI stays
  reachable from the LAN either way. Tunnel health is covered by the
  container's own healthcheck (it curls out through the tunnel) and the
  health check above.
