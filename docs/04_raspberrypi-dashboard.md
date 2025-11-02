### `docs/04_raspberrypi-dashboard.md`

# Raspberry Pi Dashboard

## Stack
- Portainer, Node-RED, Grafana, Prometheus, Uptime Kuma, AdGuard, Vaultwarden

## Deployment
- `configs/raspberrypi/docker-compose.yml`
- `.env` derived from `.env.example`
- Volumes mapped per service folders

## Touchscreen UI
- Node-RED dashboard + links to Grafana/Kuma/Portainer
