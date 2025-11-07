# Homelab Camera Stream (RTSP-only)

This folder runs a USB webcam on a Raspberry Pi (or similar Linux host) and
exposes it as an RTSP stream via MediaMTX + FFmpeg.

## Features
- ✅ Simple config
- ✅ Only RTSP (no http, webrtc, hls, rtmp, srt)
- ✅ Secure — access via Tailscale or LAN only
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
