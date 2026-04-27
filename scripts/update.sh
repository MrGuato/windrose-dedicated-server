#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")/.."

COMPOSE=${COMPOSE:-docker compose}

echo "[update] Pulling latest image"
$COMPOSE pull

echo "[update] Stopping container"
$COMPOSE stop

echo "[update] Recreating container (SteamCMD will validate and update game files)"
$COMPOSE up -d

echo "[update] Tailing logs (Ctrl+C to detach, server keeps running)"
$COMPOSE logs -f windrose
