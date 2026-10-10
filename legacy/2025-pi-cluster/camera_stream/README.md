# Homelab Camera Stream (RTSP-only)

This folder runs a USB webcam on a Raspberry Pi and exposes it as an RTSP stream via MediaMTX + FFmpeg.

This is used to view the display on my physical homelab when configuring it remotely.

## Features
- ✅ Simple config
- ✅ Only RTSP (no http, webrtc, hls, rtmp, srt)
- ✅ Secure: Access via Tailscale or LAN only
- ✅ Lightweight (zero transcoding if your cam supports MJPEG)

---

## Requirements
- Docker + docker-compose
- USB webcam available as `/dev/video0`
- Optional: Tailscale for remote access

To verify the camera exists:
```bash
v4l2-ctl --list-devices
```
---

## Viewing Instructions
VLC (LAN or Tailscale)
- rtsp://(raspberry-pi-ip):8554/cam
