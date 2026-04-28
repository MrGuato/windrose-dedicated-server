.PHONY: help setup start stop restart down logs status invite update build shell backup

help:
	@./windrose help

setup:
	@./windrose setup
start:
	@./windrose start
stop:
	@./windrose stop
restart:
	@./windrose restart
down:
	@./windrose down
logs:
	@./windrose logs
status:
	@./windrose status
invite:
	@./windrose invite
update:
	@./windrose update
build:
	@./windrose build
shell:
	@./windrose shell
backup:
	@./windrose backup
