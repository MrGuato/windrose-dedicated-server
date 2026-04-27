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
```

Add your user to the docker group so you can run docker without sudo:

```bash
sudo usermod -aG docker "$USER"
newgrp docker
docker run --rm hello-world
```

## 2. Clone the repo

```bash
sudo mkdir -p /opt && sudo chown "$USER":"$USER" /opt
cd /opt
git clone https://github.com/MrGuato/windrose-dedicated-server.git
cd windrose-dedicated-server
```

## 3. Create the environment file

```bash
cp .env.example .env
nano .env
```

At a minimum, set `SERVER_NAME` and `SERVER_PASSWORD`. See [Configuration]({{ '/configuration' | relative_url }}) for the full list of variables.

## 4. Prepare bind mounts

The container runs as UID 1000 internally. Host directories need to match:

```bash
mkdir -p data steam-home
sudo chown -R 1000:1000 data steam-home
```

## 5. Start the server

```bash
docker compose up -d
docker compose logs -f windrose
```

First boot downloads roughly 3 GB of game files via SteamCMD. When you see `Starting Windrose dedicated server` in the logs, the server is up and ready.

## 6. Get your Invite Code

```bash
jq -r '.ServerDescription_Persistent.InviteCode' data/R5/ServerDescription.json
```

Share that code with players. They use it in the game's Join via Code menu.

## Optional: prebuilt image

By default `docker-compose.yml` uses the prebuilt image from GHCR:

```yaml
image: ghcr.io/mrguato/windrose-dedicated-server:latest
```

For production, pin to a specific tag:

```yaml
image: ghcr.io/mrguato/windrose-dedicated-server:v1.0.0
```

To build locally instead, comment out the `image:` line and uncomment `build: .`, then:

```bash
docker compose build
docker compose up -d
```
