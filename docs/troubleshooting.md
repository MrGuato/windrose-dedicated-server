---
title: Troubleshooting
layout: default
nav_order: 6
---

# Troubleshooting

## Permission errors

Symptom: `wine: '/home/steam' is not owned by you` or similar.

Fix: the container runs as UID 1000. Host directories must match:

```bash
sudo chown -R 1000:1000 ./data ./steam-home
./windrose start
```

## SteamCMD fails to install

Symptom: `ERROR! Failed to install app`.

Checks:

- `STEAM_LOGIN=anonymous` in `.env` (Windrose dedicated allows anonymous downloads)
- Outbound network reachable: `curl -sI https://steamcdn-a.akamaihd.net/`
- `WINDROSE_APP_ID=4129620`
- At least 8 GB free disk

Inspect SteamCMD logs:

```bash
./windrose shell
cat /home/steam/Steam/logs/stderr.txt
exit
```

## Server not visible to players

Windrose uses an Invite Code, not a server browser:

```bash
./windrose invite
```

If empty, the first-run config did not finish. Check the log:

```bash
./windrose logs | grep -i invite
```

## Config keeps reverting

If you edit `data/R5/ServerDescription.json` while the container runs, the server overwrites it on shutdown. Either:

- Stop the container before editing, or
- Use `.env` and let the entrypoint patch the file (preferred), or
- Set `GENERATE_SETTINGS=false` to disable the patcher entirely

## Health stuck on `starting`

The healthcheck has a 5-minute `start_period` to allow first-run downloads and Wine init. If health stays `unhealthy` past that:

```bash
./windrose status
./windrose logs 200
```

Look for `Starting Windrose dedicated server` followed by Wine output. If Wine itself crashes, capture the full log and open an issue on the repo.

## Stale Xvfb lock

Symptom: `Server is already active for display 99`.

The entrypoint removes `/tmp/.X99-lock` on every start. If it persists:

```bash
./windrose down
./windrose start
```

## Out-of-memory

Windrose can spike at startup and during world generation. Check:

```bash
docker stats windrose
```

If the host is constrained, add explicit limits in `docker-compose.yml`:

```yaml
deploy:
  resources:
    limits:
      memory: 12G
      cpus: "4.0"
```

Reduce `MAX_PLAYERS` if memory pressure persists.

## Reset everything

```bash
./windrose down
sudo rm -rf ./data ./steam-home
./windrose start
```

Destructive. Take a backup first.

## Get inside the container

```bash
./windrose shell
```

Useful from inside:

```bash
pgrep -af WindroseServer
ps -u steam
tail -f /tmp/windrose-first-run.log
ls -la /data /home/steam/.wine
```

## Image pull denied

Symptom: `Error response from daemon: ... denied`.

The container image package on GHCR needs to be public. On github.com:

1. Profile -> Packages -> windrose-dedicated-server -> Package settings
2. Change visibility -> Public

Or build locally instead:

```bash
./windrose build
IMAGE_REPOSITORY=windrose-dedicated-server IMAGE_TAG=dev ./windrose start
```
