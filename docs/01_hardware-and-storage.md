# Hardware and storage

| Part | Detail |
|---|---|
| CPU | AMD Ryzen 9 5900X, 12 cores / 24 threads (AM4) |
| RAM | 64 GB |
| GPU | NVIDIA RTX 4070, driver 610.57 (open kernel module, DKMS) |
| NVMe 1 | Samsung 980 PRO 2 TB: `pve-root`, swap, `local-lvm` thin pool |
| NVMe 2 | Crucial P2 500 GB: whole disk is the `backups` storage |
| Power | Kasa smart plug with energy monitoring; BIOS set to power on after AC loss |

## Storage layout

| PVE storage | Type | Content |
|---|---|---|
| `local` | dir on `pve-root` | ISOs, templates, imports. **Backups deliberately not allowed** |
| `local-lvm` | LVM-thin, 1.7 TB | Container root disks and CT 100's 1.4 TB `/data` |
| `backups` | dir on the Crucial P2, `is_mountpoint 1` | vzdump archives only |

Config: [`pve1/host/etc/pve/storage.cfg`](../pve1/host/etc/pve/storage.cfg).

## Gotcha: NVMe names are not stable

`nvme0n1` and `nvme1n1` swapped between boots after a drive was added. Any
destructive command addresses disks by `/dev/disk/by-id/...` and checks the
serial first.

## Thin-pool reclaim (weekly TRIM)

Deleting files inside an LXC frees the blocks in the guest filesystem but never
tells LVM-thin, so the pool keeps them allocated. The guest's `df` and the
pool's `Data%` drift apart indefinitely. **The pool is what actually runs
out:** at 100% every guest goes read-only at once.

After deleting about 270 GB of media, the pool showed 812 GB used while the
filesystems held only 481 GB: 310 GB of "ghost" blocks. One `pct fstrim` pass
per container reclaimed 285 GB (pool 47% to 31%).

The fix is now a weekly systemd timer:

- [`pve-fstrim.sh`](../pve1/host/usr/local/sbin/pve-fstrim.sh) trims every
  *running* CT (new guests are picked up automatically) and logs the pool's
  `Data%` before and after to syslog under `pve-fstrim`.
- [`pve-fstrim.timer`](../pve1/host/etc/systemd/system/pve-fstrim.timer) runs
  it Sunday 05:30 with idle I/O priority, clear of the 03:00 backup and other
  jobs.

Judge the result by `lvs -o lv_name,data_percent`, not by fstrim's own output.
fstrim reports the ranges it discarded, so a second run prints `0 B`.
