# Network and remote access

- Flat LAN `192.168.4.0/22`, gateway and DNS `192.168.4.1`.
- Static IPs: pve1 `.53`, CT 100 `.2`, CT 102 `.3`, CT 103 `.4`, CT 104 `.5`.
- No reverse proxy and no local DNS; services are `IP:port`.

## Tailscale

| Node | Why it's on the tailnet |
|---|---|
| pve1 (host) | Tailscale SSH for remote admin, independent of any container |
| CT 100 | Jellyfin away from home; advertises the LAN as a subnet route |
| CT 103 | ntfy, so the phone gets push notifications on cellular |

Containers that need Tailscale or WireGuard get `/dev/net/tun` passed in:

```
lxc.cgroup2.devices.allow: c 10:200 rwm
lxc.mount.entry: /dev/net/tun dev/net/tun none bind,create=file
```

Nodes join with `--accept-dns=false` so they keep the LAN resolver.

## Admin from a phone

The host runs a Claude Code Remote Control server as a systemd service, so the
lab can be administered from the Claude iOS app. Tailscale SSH to the host is
the fallback.

## VPN egress for torrents

qBittorrent in CT 100 has no network of its own: it shares gluetun's network
namespace (`network_mode: service:gluetun`), and gluetun's firewall only allows
traffic through the WireGuard tunnel. The host loads the `wireguard` module
([`modules-load.d/wireguard.conf`](../pve1/host/etc/modules-load.d/wireguard.conf))
because gluetun uses kernel WireGuard inside the LXC.
