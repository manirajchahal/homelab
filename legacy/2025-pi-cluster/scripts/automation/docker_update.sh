# Starter

#!/usr/bin/env bash
set -euo pipefail

# Purpose: Safely update Docker services (pull, recreate, prune old images).
# Optional: pre-update backup + CHANGELOG note.

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
cd "$REPO_DIR/configs/raspberrypi"

echo "[*] Pulling new images..."
docker compose pull

echo "[*] Recreating containers..."
docker compose up -d

echo "[*] Pruning old images..."
docker image prune -f

echo "[*] Update complete."
