# Windrose Dedicated Server

Self-hosted Windrose dedicated server for Linux. Docker image built on Ubuntu 22.04 with SteamCMD and Wine, configured entirely through `.env`, with persistent saves, healthchecks, and a single CLI for everything.

Players join via Invite Code from the in-game menu. No port forwarding required.

Full guide: [mrguato.github.io/windrose-dedicated-server](https://mrguato.github.io/windrose-dedicated-server/)

## Why this exists

I wanted a Windrose server I could pull onto a fresh Ubuntu VM, configure once, and keep running. The image runs the official Windows server binary under Wine inside a container, fetched and updated through SteamCMD on every start. Saves persist across container recreates.

## Requirements

| Component      | Minimum |
| -------------- | ------- |
| OS             | Ubuntu 22.04+ or Debian 12+ |
| Docker         | 24.x or newer |
| Docker Compose | v2 (`docker compose`) |
| RAM            | 8 GB (16 GB recommended for 4+ players) |
| Disk           | 8 GB free |

## Quick start

```bash
git clone https://github.com/MrGuato/windrose-dedicated-server.git
cd windrose-dedicated-server
chmod +x windrose
./windrose setup
./windrose start
```

`setup` writes a `.env` and creates the bind-mount directories. `start` pulls the image (or builds locally), launches the container, and tails logs. First boot downloads ~3 GB of game files via SteamCMD.

When you see `Starting Windrose dedicated server` in the logs, grab your code:

```bash
./windrose invite
```

Share that with players. They use it in the in-game Join via Code menu.

## Common operations

```bash
./windrose status      # container, health, server name, invite code
./windrose logs        # tail logs
./windrose restart     # restart in place
./windrose update      # pull latest image and update game files
./windrose backup      # snapshot saves to ./backups
./windrose stop        # stop the server
./windrose down        # remove the container (data persists)
./windrose shell       # bash inside the container
./windrose help        # full command list
```

`make` works too if you prefer (`make start`, `make logs`, etc.).

## Configuration

Everything lives in `.env`. Edit it, then recreate the container:

```bash
nano .env
./windrose update
```

Variable reference: [Configuration](https://mrguato.github.io/windrose-dedicated-server/configuration.html).

## Updates

```bash
./windrose update
```

Pulls the latest image from GHCR and recreates the container. SteamCMD validates and downloads any new game files on container start. Saves and config persist across updates.

## Backups

```bash
./windrose backup
```

Writes a timestamped tarball to `./backups/` and prunes anything older than 14 days. Schedule with cron:

```cron
0 4 * * * cd /opt/windrose-dedicated-server && ./windrose backup >> logs/backup.log 2>&1
```

Restore: `./windrose restore ./backups/windrose-2026-04-26-2200.tar.gz`.

## Local builds

Default config pulls a prebuilt image from GHCR. To build from source instead:

```bash
./windrose build
IMAGE_REPOSITORY=windrose-dedicated-server IMAGE_TAG=dev ./windrose start
```

## Layout

```
windrose-dedicated-server/
+-- windrose                 CLI wrapper (run this)
+-- Dockerfile               Ubuntu 22.04 + Wine + SteamCMD
+-- docker-compose.yml       Production compose (image from GHCR)
+-- docker-compose.dev.yml   Override for local builds
+-- entrypoint.sh            Runtime: SteamCMD update, Wine init, server start
+-- healthcheck.sh           Container health probe
+-- Makefile                 Thin wrapper around ./windrose
+-- .env.example             Copy to .env via ./windrose setup
+-- scripts/
|   +-- backup.sh            Tarball saves and config with retention
|   +-- restore.sh           Restore from a backup tarball
+-- docs/                    GitHub Pages site
+-- .github/workflows/       Build/publish to GHCR, hadolint, shellcheck
+-- data/                    Server files and saves (created on first run)
+-- steam-home/              Wine prefix and SteamCMD state (created on first run)
```

## License

MIT. See [LICENSE](LICENSE).

## Credits

Original approach by [UberDudePL/windrose-dedicated-server-docker](https://github.com/UberDudePL/windrose-dedicated-server-docker). This is an independent re-implementation with my own CLI, docs, and CI.
