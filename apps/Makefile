SHELL := /bin/bash

ENV_DEV ?= .env.dev
COMPOSE := docker compose --project-directory . -f compose.yaml -f compose.dev.yaml --env-file $(ENV_DEV)
UP := up --watch --build --remove-orphans
DOWN := down --remove-orphans -v
PRE := set -e; trap '$(COMPOSE) $(DOWN)' INT TERM EXIT

up:
	$(PRE); $(COMPOSE) $(UP) \
		--no-attach postgres \
		--no-attach minio \
		--no-attach admin \
		--no-attach pgadmin \
		--no-attach lgtm \
		--no-attach backend

front:
	$(PRE); $(COMPOSE) $(UP) frontend

back:
	$(PRE); $(COMPOSE) $(UP) backend frontend

minio:
	$(PRE); $(COMPOSE) $(UP) minio

postgres:
	$(PRE); $(COMPOSE) $(UP) postgres

admin:
	$(PRE); $(COMPOSE) $(UP) admin

down:
	$(COMPOSE) $(DOWN) 

re: down up

.PHONY: up down re front back minio postgres admin
