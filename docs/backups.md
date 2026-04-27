---
title: Backups
layout: default
nav_order: 5
---

# Backups

The repo ships with a backup script that snapshots saves and config to a timestamped tarball, with retention.

## Manual backup

```bash
make backup
```

Equivalent to:

```bash
./scripts/backup.sh
```

Output goes to `./backups/windrose-YYYY-MM-DD-HHMM.tar.gz`. By default, archives older than 14 days are deleted automatically.

Override retention or location with environment variables:

```bash
BACKUP_DIR=/srv/backups RETENTION_DAYS=30 ./scripts/backup.sh
```

## Scheduled backups

Cron entry for backups every six hours:

```cron
0 */6 * * * cd /opt/windrose-dedicated-server && ./scripts/backup.sh >> /var/log/windrose-backup.log 2>&1
```

## What gets backed up

- `data/R5/Saved/` (world saves and player data)
- `data/R5/ServerDescription.json` (server config snapshot)

The image and SteamCMD cache are intentionally excluded since they are reproducible.

## Restore

```bash
make restore FILE=./backups/windrose-2026-04-26-2200.tar.gz
```

The script stops the container, extracts the archive over the current files, and restarts. Always restore to the same project directory the backup was taken from.

## Off-host backups

For real disaster recovery, push tarballs off the server. Examples:

S3-compatible (MinIO, AWS, Backblaze B2) using the AWS CLI:

```bash
aws s3 cp ./backups/ s3://my-bucket/windrose/ --recursive --exclude "*" --include "windrose-*.tar.gz"
```

Restic to any backend:

```bash
restic -r s3:s3.amazonaws.com/my-bucket/windrose backup ./data/R5/Saved
```

Borg, rclone, or rsync to a remote host all work. Wire any of these into the cron entry that runs after `backup.sh`.
