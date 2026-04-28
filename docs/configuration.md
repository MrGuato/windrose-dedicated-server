---
title: Configuration
layout: default
nav_order: 3
---

# Configuration

All server config is driven by environment variables in `.env`. The entrypoint patches `data/R5/ServerDescription.json` from those variables on every container start, so you never edit JSON by hand for normal use.

## Apply config changes

```bash
nano .env
./windrose update
```

`update` recreates the container, which re-applies the env to the JSON.

## Variable reference

### Server identity

| Variable          | Default                  | Description |
| ----------------- | ------------------------ | ----------- |
| `SERVER_NAME`     | `MrGuato Windrose Server`| Display name shown to players |
| `SERVER_NOTE`     | _empty_                  | Optional description or MOTD |
| `SERVER_PASSWORD` | _empty_                  | Set to require a password to join |
| `MAX_PLAYERS`     | `4`                      | Maximum concurrent players |
| `INVITE_CODE`     | _empty_                  | Override the auto-generated code |

When `SERVER_PASSWORD` is empty the server is open. When set, password protection is enabled automatically.

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

### Image and runtime

| Variable             | Default                                      | Description |
| -------------------- | -------------------------------------------- | ----------- |
| `IMAGE_REPOSITORY`   | `ghcr.io/mrguato/windrose-dedicated-server`  | Image source |
| `IMAGE_TAG`          | `latest`                                     | Image tag (use `vX.Y.Z` for production) |
| `CONTAINER_NAME`     | `windrose`                                   | Docker container name |
| `HOSTNAME_OVERRIDE`  | `windrose`                                   | Container hostname |
| `PUID`               | `1000`                                       | UID inside container; match host directory ownership |
| `PGID`               | `1000`                                       | GID inside container |
| `GENERATE_SETTINGS`  | `true`                                       | Auto-generate and patch `ServerDescription.json` |

### Wine

| Variable      | Default               | Description |
| ------------- | --------------------- | ----------- |
| `WINEARCH`    | `win64`               | Wine architecture |
| `WINEPREFIX`  | `/home/steam/.wine`   | Wine prefix path inside container |

## Manual JSON editing

If you need a field the env-based patcher does not expose, stop the container first or your edits will be overwritten:

```bash
./windrose stop
nano data/R5/ServerDescription.json
./windrose start
```

To prevent the entrypoint from patching the file at all, set `GENERATE_SETTINGS=false` in `.env`.

## Volumes

| Host path       | Container path | Contents |
| --------------- | -------------- | -------- |
| `./data`        | `/data`        | Server files, saves, `ServerDescription.json` |
| `./steam-home`  | `/home/steam`  | Wine prefix, SteamCMD cache |

Both must be owned by `1000:1000` on the host. `./windrose setup` does this automatically.

## Pinning to a specific image version

For production, pin a specific tag in `.env`:

```ini
IMAGE_TAG=v1.0.0
```

Then `./windrose update` only pulls that exact version. List available tags at the [Container image page](https://github.com/MrGuato/windrose-dedicated-server/pkgs/container/windrose-dedicated-server).
