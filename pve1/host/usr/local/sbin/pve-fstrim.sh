#!/bin/sh
# Return freed blocks from running LXC guests to the LVM-thin pool.
#
# Deleting a file inside a container frees the filesystem block but does NOT
# tell LVM-thin, so the pool keeps holding it. The pool -- not the guest
# filesystem -- is what actually runs out: if it hits 100% every guest goes
# read-only at once. `pct fstrim` discards those ranges; it skips bind and
# read-only mountpoints on its own. Only running containers have their rootfs
# mounted at /var/lib/lxc/<id>/rootfs, so stopped guests are skipped.
set -u
total_before=$(lvs --noheadings -o data_percent /dev/pve/data 2>/dev/null | tr -d ' ')
for id in $(pct list 2>/dev/null | awk 'NR>1 && $2=="running" {print $1}'); do
  out=$(pct fstrim "$id" 2>&1) \
    && logger -t pve-fstrim "CT $id: $(echo "$out" | tr '\n' ';')" \
    || logger -t pve-fstrim "CT $id: FAILED: $(echo "$out" | tr '\n' ';')"
done
total_after=$(lvs --noheadings -o data_percent /dev/pve/data 2>/dev/null | tr -d ' ')
logger -t pve-fstrim "local-lvm data pool: ${total_before}% -> ${total_after}%"
