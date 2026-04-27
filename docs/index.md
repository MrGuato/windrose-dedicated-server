---
title: Home
layout: default
nav_order: 1
---

# Windrose Dedicated Server

Self-hosted Windrose dedicated server for Linux, packaged as a Docker container running SteamCMD and Wine.

Players join via Invite Code from the in-game menu. No port forwarding required.

## What this gives you

- Anonymous SteamCMD download and update on every container start
- Wine plus Xvfb headless runtime, no desktop required
- Persistent saves and config via bind-mounted volumes
- All settings configured through `.env`, no JSON editing for normal use
- One-command updates via `make update`
- Backup and restore scripts with retention
- Hardened compose defaults: `no-new-privileges`, `cap_drop: ALL`, tmpfs `/tmp`

## Quick links

- [Installation]({{ '/installation' | relative_url }})
- [Configuration]({{ '/configuration' | relative_url }})
- [Updates]({{ '/updates' | relative_url }})
- [Backups]({{ '/backups' | relative_url }})
- [Troubleshooting]({{ '/troubleshooting' | relative_url }})

## Requirements

| Component      | Minimum |
| -------------- | ------- |
| OS             | Ubuntu 22.04+ or Debian 12+ |
| Docker         | 24.x or newer |
| Docker Compose | v2 (`docker compose`) |
| RAM            | 8 GB (16 GB recommended) |
| Disk           | 8 GB free |

## Source code

The full project lives at [github.com/MrGuato/windrose-dedicated-server](https://github.com/MrGuato/windrose-dedicated-server).
