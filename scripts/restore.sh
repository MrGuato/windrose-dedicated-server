#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")/.."

ARCHIVE="${1:-}"
COMPOSE=${COMPOSE:-docker compose}

if [ -z "$ARCHIVE" ] || [ ! -f "$ARCHIVE" ]; then
    echo "Usage: $0 <backup-archive.tar.gz>"
    echo "Example: $0 ./backups/windrose-2026-04-26-2200.tar.gz"
    exit 1
fi

echo "[restore] Stopping container"
$COMPOSE stop

echo "[restore] Extracting $ARCHIVE"
tar -xzf "$ARCHIVE"

echo "[restore] Starting container"
$COMPOSE start

echo "[restore] Done"
