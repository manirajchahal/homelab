# Roadmap

- [ ] **Off-site backup copy.** Second host or cloud bucket for the vzdump
      archives (the one real gap in [backups](06_backup-and-recovery.md)).
- [ ] **Jellyfin 12.x.** Waiting on third-party plugin builds for 12.2;
      the upgrade is a one-way DB migration, so it waits until they're ready.
- [ ] **HTTPS for IronRank** (Tailscale certs) so the PWA gets a service worker and works offline.
- [ ] **Minecraft crossplay server** (Java + Bedrock via Geyser) as a hardened
      VM, with its config managed as code.
- [x] Dedicated backup disk (2026-09-26)
- [x] Reboot-proof GPU passthrough (2026-09-17)
- [x] Weekly thin-pool TRIM (2026-09-12)
- [x] Push alerting for the media pipeline (2026-09-18)
