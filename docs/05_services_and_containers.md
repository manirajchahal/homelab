### `docs/05_services_and_containers.md`

# Services & Containers

## Portainer
- Purpose: Docker mgmt GUI
- Port: 9000

## Node-RED
- Purpose: Touchscreen UI & glue logic
- Exported flows: `dashboards/node-red/touchscreen_ui.json`

## Grafana
- Purpose: Visualization
- Dashboards in `dashboards/grafana/`

## Prometheus
- Purpose: Metrics collection
- Config: `configs/raspberrypi/prometheus/prometheus.yml`
- Targets: Pi, Proxmox, exporters

## Uptime Kuma
- Purpose: HTTP/TCP/ICMP monitors + alerts

## AdGuard Home
- Purpose: DNS filtering
- Config: `configs/raspberrypi/adguard/AdGuardHome.yaml`

## Vaultwarden
- Purpose: Password manager
- Env: `configs/raspberrypi/vaultwarden/vaultwarden.env` (env.example provided)
