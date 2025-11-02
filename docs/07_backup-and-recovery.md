### `docs/07_backup-and-recovery.md`
```markdown

# Backup & Recovery

## Scope
- Config backups (router, switch, compose, Prometheus, AdGuard)
- Volumes: Vaultwarden, Kuma, Node-RED, Grafana

## Strategy
- Daily config snapshots (cron)
- Weekly offsite sync (NAS/cloud)
- Verify restores monthly

## Scripts
- `scripts/automation/backup_cron.sh` orchestrates
- Store large artifacts **outside** Git (document paths & checksums here)
