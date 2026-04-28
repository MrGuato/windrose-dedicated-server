---
title: Home
layout: default
nav_order: 1
---

# Windrose Dedicated Server

Self-hosted Windrose dedicated server for Linux, packaged as a Docker container running SteamCMD and Wine.

Players join via Invite Code from the in-game menu. No port forwarding required.

## What you get

- Single CLI (`./windrose`) for setup, lifecycle, status, and updates
- Anonymous SteamCMD download and validation on every container start
- Wine plus Xvfb headless runtime, no desktop required
- Persistent saves and config via bind-mounted volumes
- All settings driven from `.env`, no manual JSON editing
- Healthcheck watches the server process
- Automated builds publish to GHCR
- Backup and restore scripts with retention

## Pages

- [Installation]({{ '/installation.html' | relative_url }})
- [Configuration]({{ '/configuration.html' | relative_url }})
- [Updates]({{ '/updates.html' | relative_url }})
- [Backups]({{ '/backups.html' | relative_url }})
- [Troubleshooting]({{ '/troubleshooting.html' | relative_url }})

## Requirements

| Component      | Minimum |
| -------------- | ------- |
| OS             | Ubuntu 22.04+ or Debian 12+ |
| Docker         | 24.x or newer |
| Docker Compose | v2 (`docker compose`) |
| RAM            | 8 GB (16 GB recommended for 4+ players) |
| Disk           | 8 GB free |

## Source

[github.com/MrGuato/windrose-dedicated-server](https://github.com/MrGuato/windrose-dedicated-server)

## Credit

Original approach by [UberDudePL/windrose-dedicated-server-docker](https://github.com/UberDudePL/windrose-dedicated-server-docker).
