### `docs/00_overview.md`
```markdown
# Overview

This repo documents my homelab: physical rack, network, Proxmox cluster, Raspberry Pi services, monitoring, and backup/restore.

## Goals
- Single touchscreen dashboard to view/control the lab
- Simple, reproducible deployment
- Reliable monitoring + backups
- Clear changelog to undo bad changes

## Structure
- `docs/` narrative documentation
- `configs/` actual config files (compose, YAML, cfg)
- `scripts/` setup/maintenance automation
- `dashboards/` Grafana & Node-RED exports
- `assets/` diagrams & screenshots
- `backups/` backup plans & notes
