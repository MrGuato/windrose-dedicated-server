---
title: Updates
layout: default
nav_order: 4
---

# Updates

Two things update independently: the container image (Docker) and the game files (SteamCMD).

## Update everything

```bash
./windrose update
```

That target:

1. Pulls the latest image from GHCR (image-level update).
2. Stops the running container.
3. Recreates it, which triggers SteamCMD `app_update validate` on start (game-files update).
4. Tails logs.

Saves and config persist across updates because they live in bind-mounted `./data` and `./steam-home`.

## Update game files only

```bash
./windrose restart
```

The entrypoint runs `app_update validate` every time the container starts when `UPDATE_ON_START=true`. So a restart is enough to pull new game files without changing the image.

## Pin to a specific image tag

In `.env`:

```ini
IMAGE_TAG=v1.0.0
```

Then:

```bash
./windrose update
```

Available tags: [Container image page](https://github.com/MrGuato/windrose-dedicated-server/pkgs/container/windrose-dedicated-server).

## Skip SteamCMD on start

For air-gapped or rate-limited setups:

```ini
UPDATE_ON_START=false
```

The container starts the existing files without contacting Steam. To force an update later, flip the variable back and recreate, or run a one-shot update inside the container:

```bash
./windrose shell
su -s /bin/bash steam -c \
    "/opt/steamcmd/steamcmd.sh +force_install_dir /data +login anonymous +app_update 4129620 validate +quit"
exit
./windrose restart
```

## Scheduled updates

Daily update at 04:00:

```cron
0 4 * * * cd /opt/windrose-dedicated-server && ./windrose update >> logs/update.log 2>&1
```
