# Starter

#!/usr/bin/env bash
set -euo pipefail

# Purpose: Orchestrate recurring backups (configs + volumes).
# Usage: add to crontab, e.g., 2:05 AM daily
# 5 2 * * * /path/to/repo/scripts/automation/backup_cron.sh >> /var/log/homelab_backup.log 2>&1

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
BACKUP_DIR="/srv/homelab_backups/$(date +%F)"
mkdir -p "$BACKUP_DIR"

echo "[*] Starting backup: $(date)"

# 1) Capture compose + configs
tar -czf "$BACKUP_DIR/configs_raspberrypi.tgz" -C "$REPO_DIR/configs/raspberrypi" .

# 2) Service-specific lightweight exports (add as you go)
# e.g., Grafana JSON dashboards, Node-RED flows if not already exported

# 3) Optional: volume snapshots (stop container briefly if needed)
# docker run --rm -v repo_path:/data -v "$BACKUP_DIR":/backup alpine tar -czf /backup/volume-name.tgz /data

# 4) Router/Switch backups: copy latest files if present
cp -n "$REPO_DIR/configs/router/"*.tar.gz "$BACKUP_DIR" 2>/dev/null || true
cp -n "$REPO_DIR/configs/switch/"*.cfg "$BACKUP_DIR" 2>/dev/null || true

echo "[✓] Backup complete: $BACKUP_DIR"
