---
title: Configuration
layout: default
nav_order: 3
---

# Configuration

All server config is driven by environment variables in `.env`. The entrypoint patches `data/R5/ServerDescription.json` from those variables on every container start, so you do not edit JSON by hand for normal use.

## Apply config changes

```bash
nano .env
make update     # or: docker compose up -d --force-recreate
```

## Variable reference

### Server identity

| Variable          | Default | Description |
| ----------------- | ------- | ----------- |
| `SERVER_NAME`     | _empty_ | Display name shown to players |
| `SERVER_NOTE`     | _empty_ | Optional description or MOTD |
| `SERVER_PASSWORD` | _empty_ | Set to require a password to join |
| `MAX_PLAYERS`     | `4`     | Maximum concurrent players |
| `INVITE_CODE`     | _empty_ | Override the auto-generated invite code |

When `SERVER_PASSWORD` is empty, password protection is disabled. When set, it is enabled automatically.

### Network

| Variable            | Default     | Description |
| ------------------- | ----------- | ----------- |
| `PORT`              | `7777`      | Game port (UDP) |
| `QUERYPORT`         | `7778`      | Query port (UDP) |
| `MULTIHOME`         | `0.0.0.0`   | Bind address inside the container |
| `P2P_PROXY_ADDRESS` | `127.0.0.1` | P2P proxy address used by Windrose |

### SteamCMD

| Variable          | Default     | Description |
| ----------------- | ----------- | ----------- |
| `STEAM_LOGIN`     | `anonymous` | SteamCMD account; anonymous works for this AppID |
| `STEAM_PASS`      | _empty_     | Only set if `STEAM_LOGIN` is not anonymous |
| `WINDROSE_APP_ID` | `4129620`   | Steam AppID for the Windrose dedicated server |
| `UPDATE_ON_START` | `true`      | Run SteamCMD validate on every container start |

### Runtime

| Variable             | Default | Description |
| -------------------- | ------- | ----------- |
| `PUID`               | `1000`  | UID inside container; match host directory ownership |
| `PGID`               | `1000`  | GID inside container |
| `GENERATE_SETTINGS`  | `true`  | Auto-generate and patch `ServerDescription.json` |
| `FIRST_RUN_TIMEOUT`  | `120`   | Seconds to wait for first-run config generation |

## Manual JSON editing

If you need to set fields the env-based patcher does not expose, stop the container first or your edits will be overwritten:

```bash
docker compose stop
nano data/R5/ServerDescription.json
docker compose start
```

To prevent the entrypoint from patching the file at all, set `GENERATE_SETTINGS=false` in `.env`.

## Volumes

| Host path       | Container path | Contents |
| --------------- | -------------- | -------- |
| `./data`        | `/data`        | Server files, saves, `ServerDescription.json` |
| `./steam-home`  | `/home/steam`  | Wine prefix, SteamCMD cache |

Both must be owned by `1000:1000` on the host.

## Hardening

The compose file ships with these defaults:

```yaml
security_opt:
  - no-new-privileges:true
cap_drop:
  - ALL
tmpfs:
  - /tmp:rw,nosuid,nodev,size=128m
```

Resource limits are present but commented out. Enable per host:

```yaml
deploy:
  resources:
    limits:
      memory: 12G
      cpus: "4.0"
```
