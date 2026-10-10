### `docs/02_network-topology.md`

# Network Topology

## Addressing
- Router (Beryl AX): 192.168.8.1/24
- Switch (GS308E): 192.168.8.2
- Pi (dashboard): 192.168.8.10 (static/DHCP reservation)
- Proxmox-1: 192.168.8.11
- Proxmox-2: 192.168.8.12

## Services
- DNS: AdGuard on Pi (optional), router fallback
- Remote: Tailscale overlay (plan), SSH access

## Diagram
- Source: `assets/diagrams/network_map.drawio`
- Export: `assets/images/network_map.png`
