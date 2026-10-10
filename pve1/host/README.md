# pve1 host files

Files from the Proxmox host, laid out at their real paths. Snapshot of 2026-10-10.

| Path | What it does |
|---|---|
| `etc/pve/lxc/*.conf` | Container definitions for CT 100/102/103/104 (MAC addresses removed) |
| `etc/pve/jobs.cfg` | Nightly vzdump job `arr-stack-nightly` (03:00, 7 daily + 4 weekly) |
| `etc/pve/storage.cfg` | `local`, `local-lvm` (thin pool), `backups` (dedicated Crucial P2) |
| `etc/modules-load.d/nvidia.conf` | Loads `nvidia` + `nvidia_uvm` at boot for GPU passthrough |
| `etc/modules-load.d/wireguard.conf` | Kernel WireGuard for gluetun inside CT 100 |
| `etc/systemd/system/nvidia-devnodes.service` | Creates `/dev/nvidia*` before guests start; fails visibly if the driver is broken |
| `etc/systemd/system/pve-fstrim.{service,timer}` + `usr/local/sbin/pve-fstrim.sh` | Weekly LVM-thin reclaim for every running CT |
| `etc/systemd/system/glances.service.d/override.conf` | Glances REST API on the LAN for the Homepage header widget |

See [`docs/`](../../docs/) for the reasoning behind each.
