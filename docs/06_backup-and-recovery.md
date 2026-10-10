# Backup and recovery

## Current setup

| | |
|---|---|
| Job | `arr-stack-nightly` ([`jobs.cfg`](../pve1/host/etc/pve/jobs.cfg)) |
| Schedule | Daily 03:00, snapshot mode, zstd |
| Guests | CT 100, 102, 103, 104 |
| Excluded | CT 100's 1.4 TB media volume (`backup=0`); Valheim's SteamCMD install (`exclude-path /opt/valheim/data/?*`) |
| Target | `backups` storage on a dedicated Crucial P2 500 GB |
| Retention | `keep-daily=7, keep-weekly=4` |
| Size | ~12 GB per night, ~133 GB at full retention of ~457 GB usable |

## Guard rails

- The `backups` storage has `is_mountpoint 1`. If the P2 isn't mounted,
  vzdump **fails** instead of silently writing into the empty directory on the
  OS disk.
- `local` (the OS disk) no longer allows `backup` content, and
  `/etc/vzdump.conf` defaults to `storage: backups`, so ad-hoc `vzdump <id>`
  lands on the right disk too.
- The mount unit is `WantedBy=multi-user`, so a dead backup drive doesn't
  block boot.

## History

- Backups originally lived on `pve-root` (94 GB, shared with the OS), which
  forced retention down to 3 daily + 1 weekly and reached 88% full. Moving them
  to a dedicated disk restored 7 + 4 and brought `pve-root` to 19%.
- `exclude-path /opt/valheim/data/` with a **trailing slash** is ignored by tar
  (`WARN: tar does not match exclusion with a trailing slash`). Every guest
  logged the warning, and 6 GB of regenerable game files were archived. The
  fix is `/opt/valheim/data/?*`. Note that `exclude-path` applies to the whole
  job.
- A backup once ballooned from 4.6 to 31 GB from orphaned Jellyfin transcode
  segments. The fix was moving the transcode dir to tmpfs.

## Known gap

Backups are on a separate disk but in the **same machine**, with no off-site
copy. Fire, theft, a PSU surge or a reinstall mistake would still lose
everything. See the [roadmap](07_roadmap.md).

## Restore

```sh
pct restore <vmid> /mnt/pve/backups/dump/vzdump-lxc-<vmid>-<date>.tar.zst --storage local-lvm
```

CT 100's media volume isn't in the archive. Re-attach the existing
`vm-100-disk-1` or recreate it, then let Sonarr/Radarr re-download.
