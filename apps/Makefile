SHELL := /bin/bash

ENV_DEV ?= .env.dev
COMPOSE := docker compose --project-directory . -f compose.yaml -f compose.dev.yaml --env-file $(ENV_DEV)
UP := up --watch --build --remove-orphans
DOWN := down --remove-orphans -v

up:
	$(COMPOSE) $(UP) \
		--no-attach postgres \
		--no-attach minio \
		--no-attach admin \
		--no-attach pgadmin \
		--no-attach lgtm \
		--no-attach backend

front:
	$(COMPOSE) $(UP) frontend

back:
	$(COMPOSE) $(UP) backtend

minio:
	$(COMPOSE) $(UP) minio

postgres:
	$(COMPOSE) $(UP) postgres

admin:
	$(COMPOSE) $(UP) admin

down:
	$(COMPOSE) $(DOWN) 

re: down up

.PHONY: up down re front back minio postgres admin
