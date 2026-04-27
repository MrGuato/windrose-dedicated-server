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
docker compose up -d
```

## Stale Xvfb lock

Symptom: `Server is already active for display 99`.

The entrypoint removes `/tmp/.X99-lock` on every start. If the error persists, the bind mount on `/tmp` may be stale; the included compose file mounts `/tmp` as tmpfs which avoids this. If you removed that mount, recreate the container:

```bash
docker compose down
docker compose up -d
```

## SteamCMD fails to install

Symptom: `ERROR! Failed to install app`.

Checks:

- `STEAM_LOGIN=anonymous` in `.env` (Windrose dedicated allows anonymous downloads).
- Outbound network from the host to Steam CDN is reachable (`curl -sI https://steamcdn-a.akamaihd.net/`).
- `WINDROSE_APP_ID=4129620`.
- Disk has at least 8 GB free.

Inspect the SteamCMD log inside the container:

```bash
docker compose exec windrose cat /home/steam/Steam/logs/stderr.txt
```

## Server not visible to players

Windrose uses an Invite Code, not a server browser. Pull yours and share it:

```bash
jq -r '.ServerDescription_Persistent.InviteCode' data/R5/ServerDescription.json
```

If the field is empty, the first-run config did not finish. Check the log:

```bash
docker compose logs windrose | grep -i invite
```

## Config keeps reverting

If you edit `data/R5/ServerDescription.json` while the container is running, the server overwrites it on shutdown. Either:

- Stop the container before editing, or
- Use `.env` and let the entrypoint patch the file (preferred), or
- Set `GENERATE_SETTINGS=false` to disable the patcher entirely.

## Health is stuck on `starting`

The healthcheck has a 5-minute `start_period` to allow for first-run downloads and Wine initialization. If health stays `unhealthy` past that:

```bash
docker compose ps
docker compose logs windrose | tail -100
```

Look for the line `Starting Windrose dedicated server` followed by Wine output. If Wine itself crashes, capture the full log and open an issue on the repo.

## Out-of-memory or CPU starvation

Windrose can spike at startup and during world generation. If the host is constrained, set explicit limits in `docker-compose.yml`:

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
docker compose down
sudo rm -rf ./data ./steam-home
docker compose up -d
```

Or:

```bash
make prune
```

Both are destructive and wipe saves. Take a backup first.

## Get inside the container for debugging

```bash
docker compose exec windrose bash
```

Useful from inside:

```bash
pgrep -af WindroseServer
ps -u steam
tail -f /tmp/windrose-first-run.log
ls -la /data /home/steam/.wine
```
