SHELL := /bin/bash

ENV_DEV ?= .env.dev
COMPOSE := docker compose --project-directory . -f compose.yaml -f compose.dev.yaml --env-file $(ENV_DEV)
UP := up --build --remove-orphans
DOWN := down --remove-orphans -v

up:
	$(COMPOSE) $(UP) --watch

front:
	$(COMPOSE) $(UP) --watch frontend 

back:
	$(COMPOSE) $(UP) --watch backend 

minio:
	$(COMPOSE) $(UP) minio minio-init

postgres:
	$(COMPOSE) $(UP) postgres 

admin:
	$(COMPOSE) $(UP) admin 

down:
	$(COMPOSE) $(DOWN) 

re: down up

.PHONY: up down re front back minio postgres admin
