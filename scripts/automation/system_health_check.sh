# Starter

#!/usr/bin/env bash
set -euo pipefail

# Purpose: Summarize homelab health (containers, disk, CPU/RAM, key ports).
# Run ad-hoc or via cron, optionally send to webhook.

echo "=== System Health ($(hostname)) @ $(date) ==="

echo -e "\n[Docker containers]"
docker ps --format 'table {{.Names}}\t{{.Status}}\t{{.Ports}}'

echo -e "\n[Disk usage]"
df -h | awk 'NR==1 || /\/(root|home|var|srv|boot|mnt|data)/'

echo -e "\n[Top CPU processes]"
ps -eo pid,comm,pcpu,pmem --sort=-pcpu | head -n 10

echo -e "\n[Listening Ports]"
ss -tulpn | head -n 20

echo -e "\n[Ping critical hosts]"
for host in 192.168.8.1 192.168.8.10 192.168.8.11 192.168.8.12; do
  ping -c 1 -W 1 "$host" >/dev/null && echo "OK  $host" || echo "BAD $host"
done

echo -e "\nDone."
