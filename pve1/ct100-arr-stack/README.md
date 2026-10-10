# CT 100 - arr-stack

The media stack (Jellyfin with NVIDIA transcoding, Seerr, Sonarr, Radarr,
Prowlarr, Bazarr, SABnzbd, qBittorrent behind a gluetun WireGuard tunnel,
FlareSolverr, Maintainerr, Recyclarr) is documented in its own private repo,
`ARR-Stack`: compose file, cron jobs, health checks and runbooks.

The container definition itself is here:
[`../host/etc/pve/lxc/100.conf`](../host/etc/pve/lxc/100.conf). GPU passthrough
is covered in [`docs/04_gpu-passthrough.md`](../../docs/04_gpu-passthrough.md).
