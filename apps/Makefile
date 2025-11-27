SHELL := /bin/bash

ENV_DEV ?= .env.dev
COMPOSE := docker compose --project-directory .
UP := up --watch --build --remove-orphans
DOWN := down --remove-orphans -v

up:
	$(COMPOSE) --env-file $(ENV_DEV) $(UP)

down:
	$(COMPOSE) --env-file $(ENV_DEV) $(DOWN) 

re: down up

deps:
	docker plugin install grafana/loki-docker-driver:3.3.2-arm64 --alias loki --grant-all-permissions

.PHONY: up down re deps
