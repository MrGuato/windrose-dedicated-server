# Windrose Dedicated Server (Docker)

Self-hosted Windrose dedicated server for Linux, packaged as a Docker container running SteamCMD and Wine. Configured entirely via environment variables, with persistent saves, healthchecks, and one-command updates.

Players join via Invite Code from the in-game menu. No port forwarding required.

Full documentation: [Installation Guide](https://mrguato.github.io/windrose-dedicated-server/)

## Features

- Anonymous SteamCMD download and update on every container start
- Wine plus Xvfb headless runtime, no desktop required
- Persistent saves and config via bind-mounted volumes
- All settings configured through `.env` (no manual JSON editing for normal use)
- `restart: unless-stopped` survives host reboots
- Healthcheck watches the server process
- Hardened compose defaults: `no-new-privileges`, `cap_drop: ALL`, tmpfs `/tmp`
- One-command updates via `make update`
- Backup and restore scripts with retention

## Requirements

| Component      | Minimum |
| -------------- | ------- |
| OS             | Ubuntu 22.04+ or Debian 12+ |
| Docker         | 24.x or newer |
| Docker Compose | v2 (`docker compose`) |
| RAM            | 8 GB (16 GB recommended) |
| Disk           | 8 GB free |

## Quick start

```bash
git clone https://github.com/MrGuato/windrose-dedicated-server.git
cd windrose-dedicated-server
cp .env.example .env
# edit .env with your server name, password, etc.
mkdir -p data steam-home
sudo chown -R 1000:1000 data steam-home
docker compose up -d
docker compose logs -f windrose
```

First boot pulls roughly 3 GB of game files. When you see `Starting Windrose dedicated server` the server is up.

Find your `InviteCode` in `data/R5/ServerDescription.json` and share it with players.

## Common operations

```bash
make up         # start in background
make logs       # tail logs
make status     # health and process state
make update     # pull latest image and run SteamCMD update
make backup     # snapshot saves to ./backups
make stop       # stop the server
make down       # stop and remove the container
```

## Configuration

All config lives in `.env`. The entrypoint patches `data/R5/ServerDescription.json` from these variables on every start, so changes apply by recreating the container:

```bash
nano .env
make update
```

Full variable reference: see [Configuration docs](https://mrguato.github.io/windrose-dedicated-server/configuration).

## Updates

```bash
make update
```

That target pulls the latest image, recreates the container, and the entrypoint runs SteamCMD with `validate` to fetch any new game files. Saves and config persist across updates.

## Backups

```bash
make backup
```

Writes a timestamped tarball to `./backups/` and prunes anything older than 14 days. Schedule it with cron:

```cron
0 */6 * * * cd /opt/windrose && ./scripts/backup.sh >> /var/log/windrose-backup.log 2>&1
```

Restore with `make restore FILE=./backups/windrose-2026-04-26-2200.tar.gz`.

## Directory layout

```
windrose-dedicated-server/
├── Dockerfile
├── docker-compose.yml
├── entrypoint.sh
├── Makefile
├── .env.example
├── scripts/
│   ├── update.sh
│   ├── backup.sh
│   └── restore.sh
├── docs/                      # GitHub Pages site
├── data/                      # Server files and saves (created on first run)
└── steam-home/                # Wine prefix and SteamCMD state (created on first run)
```

## Security notes

The compose file ships with `no-new-privileges`, `cap_drop: ALL`, and a tmpfs-mounted `/tmp`. The container runs as UID 1000 inside, so host directories must be owned by `1000:1000`. Resource limits are commented out in `docker-compose.yml` and can be enabled per host capacity.

## License

MIT. See [LICENSE](LICENSE).

## Credits

Approach inspired by [UberDudePL/windrose-dedicated-server-docker](https://github.com/UberDudePL/windrose-dedicated-server-docker).
