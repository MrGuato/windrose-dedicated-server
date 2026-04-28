---
title: Installation
layout: default
nav_order: 2
---

# Installation

Step-by-step setup on a fresh Ubuntu 22.04 or 24.04 host.

## 1. Install Docker

```bash
sudo apt update
sudo apt install -y ca-certificates curl gnupg

sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | \
    sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg

echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] \
https://download.docker.com/linux/ubuntu $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
    sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt update
sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

sudo usermod -aG docker "$USER"
newgrp docker
docker run --rm hello-world
```

## 2. Clone the repo

```bash
git clone https://github.com/MrGuato/windrose-dedicated-server.git
cd windrose-dedicated-server
chmod +x windrose
```

## 3. Run setup

```bash
./windrose setup
```

The setup wizard prompts for server name, password, max players, and ports. It writes `.env` and creates the bind-mount directories with the correct ownership.

To skip the wizard and edit the env file by hand:

```bash
cp .env.example .env
nano .env
mkdir -p data steam-home backups logs
sudo chown -R 1000:1000 data steam-home
```

## 4. Start the server

```bash
./windrose start
```

That pulls the prebuilt image from GHCR (or uses your local build), starts the container, and tails logs. First boot pulls roughly 3 GB of game files via SteamCMD.

When you see this in the logs the server is up:

```
[windrose] Starting Windrose dedicated server
```

## 5. Get the invite code

```bash
./windrose invite
```

Share that code with players. They use it in the game's Join via Code menu.

## Optional: build the image locally

If you'd rather build from source than pull from GHCR:

```bash
./windrose build
IMAGE_REPOSITORY=windrose-dedicated-server IMAGE_TAG=dev ./windrose start
```

The build takes about 10-15 minutes on a first run because of the apt install of Wine and i386 libraries. Subsequent builds use Docker's layer cache.

## Optional: scheduled backups

```bash
crontab -e
```

Add:

```cron
0 4 * * * cd /opt/windrose-dedicated-server && ./windrose backup >> logs/backup.log 2>&1
```
