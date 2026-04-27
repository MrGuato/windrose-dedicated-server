SHELL := /bin/bash
COMPOSE ?= docker compose
SERVICE ?= windrose

.PHONY: help up down start stop restart logs status update pull build shell ps clean backup restore prune

help:
	@echo "Targets:"
	@echo "  up        Start the server in the background"
	@echo "  down      Stop and remove the container"
	@echo "  start     Start an existing stopped container"
	@echo "  stop      Stop the running container"
	@echo "  restart   Restart the container"
	@echo "  logs      Tail the live container logs"
	@echo "  status    Show container status and health"
	@echo "  update    Pull latest image and recreate (runs SteamCMD update on start)"
	@echo "  pull      Pull the latest image without recreating"
	@echo "  build     Build the image locally from the Dockerfile"
	@echo "  shell     Open a bash shell inside the running container"
	@echo "  backup    Snapshot the saves and config to ./backups"
	@echo "  restore   Restore a backup (use FILE=./backups/file.tar.gz)"
	@echo "  prune     Remove the data and steam-home directories (DESTRUCTIVE)"

up:
	$(COMPOSE) up -d

down:
	$(COMPOSE) down

start:
	$(COMPOSE) start

stop:
	$(COMPOSE) stop

restart:
	$(COMPOSE) restart

logs:
	$(COMPOSE) logs -f $(SERVICE)

status:
	$(COMPOSE) ps

update:
	./scripts/update.sh

pull:
	$(COMPOSE) pull

build:
	$(COMPOSE) build

shell:
	$(COMPOSE) exec $(SERVICE) bash

backup:
	./scripts/backup.sh

restore:
	./scripts/restore.sh $(FILE)

prune:
	@read -p "This will delete ./data and ./steam-home. Continue? [y/N] " a; \
	if [ "$$a" = "y" ] || [ "$$a" = "Y" ]; then \
		$(COMPOSE) down; \
		sudo rm -rf ./data ./steam-home; \
		echo "Removed."; \
	else \
		echo "Aborted."; \
	fi
