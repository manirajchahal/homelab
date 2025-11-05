### `docs/06_monitoring-and-alerts.md`

# Monitoring & Alerts

## Prometheus Targets
- Node exporter (Pi/Proxmox)
- PVE exporter

## Grafana
- System metrics
- Proxmox cluster dashboard
- Uptime overview via Kuma datasource (optional)

## Alerting
- Uptime Kuma -> Discord
- Optional Grafana alert rules



# 📈 Monitoring (Prometheus + exporters)

**Prometheus:** `http://<pi-ip>:9090`

**Targets (UP):**
- `<pi-IP> :9100` (pi-node / node_exporter)
- `<pi-IP>:8080` (pi-cadvisor / containers)
- `<proxmox-1-IP>:9100` (proxmox-1 / node_exporter)
- `<proxmox-2-IP>:9100` (proxmox-2 / node_exporter)

**Config:** `prometheus/config/prometheus.yml`  
**Data (gitignored):** `prometheus/data/`

Useful:
- Hot reload: `curl -X POST http://<pi-ip>:9090/-/reload`

# docs/uptime-kuma-setup.md

# 🕒 Uptime Kuma

**URL:** `http://<pi-ip>:3001`  
**Purpose:** Uptime/health checks for infra + services.

Monitors (examples):
- Proxmox-1/2 GUI (HTTPS :8006) + Ping
- Prometheus (:9090), Grafana (:3000), Portainer (:9000)
- cAdvisor (:8080), node_exporter (:9100)
- Router & Switch (Ping), external reachability (1.1.1.1)
**Data (gitignored):** `uptime-kuma/data/, grafana/data/, prometheus/data/`
