#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")/.."

BACKUP_DIR=${BACKUP_DIR:-./backups}
RETENTION_DAYS=${RETENTION_DAYS:-14}
TIMESTAMP=$(date +%F-%H%M)
ARCHIVE="$BACKUP_DIR/windrose-$TIMESTAMP.tar.gz"

mkdir -p "$BACKUP_DIR"

if [ ! -d ./data ]; then
    echo "[backup] No ./data directory found, nothing to back up"
    exit 1
fi

echo "[backup] Creating archive: $ARCHIVE"
tar --warning=no-file-changed -czf "$ARCHIVE" \
    ./data/R5/Saved \
    ./data/R5/ServerDescription.json 2>/dev/null || {
        echo "[backup] WARNING: some files were missing or skipped"
    }

echo "[backup] Pruning archives older than $RETENTION_DAYS days"
find "$BACKUP_DIR" -name 'windrose-*.tar.gz' -mtime "+$RETENTION_DAYS" -delete

echo "[backup] Done"
ls -lh "$ARCHIVE"
