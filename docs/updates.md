---
title: Updates
layout: default
nav_order: 4
---

# Updates

Two layers update independently: the container image (Docker) and the game files (SteamCMD).

## One-command update

```bash
make update
```

That target:

1. Pulls the latest image from GHCR.
2. Stops the running container.
3. Recreates the container, which triggers SteamCMD `app_update validate` on start.
4. Tails logs so you see the update progress.

The same flow without the Makefile:

```bash
docker compose pull
docker compose down
docker compose up -d
docker compose logs -f windrose
```

Saves and config persist across updates because they live in the bind-mounted `./data` and `./steam-home` directories.

## Game-only update without changing the image

If you only want to run SteamCMD and skip pulling a new image:

```bash
docker compose restart
```

The entrypoint runs `app_update validate` every time the container starts when `UPDATE_ON_START=true`.

## Pin to a specific image tag

Editing the `image:` line in `docker-compose.yml`:

```yaml
image: ghcr.io/mrguato/windrose-dedicated-server:v1.0.0
```

Then:

```bash
docker compose pull
docker compose up -d
```

## Skip SteamCMD on start

For air-gapped or rate-limited setups, set in `.env`:

```ini
UPDATE_ON_START=false
```

The container starts the existing files without contacting Steam. To force an update later, flip the variable back and recreate, or run a one-shot update inside the container:

```bash
docker compose exec windrose su -s /bin/bash steam -c \
    "/opt/steamcmd/steamcmd.sh +force_install_dir /data +login anonymous +app_update 4129620 validate +quit"
docker compose restart
```

## Scheduled updates

Cron entry for a daily update at 04:00:

```cron
0 4 * * * cd /opt/windrose-dedicated-server && /usr/bin/make update >> /var/log/windrose-update.log 2>&1
```
