SHELL := /bin/bash

APP_DIR := ../apps/
ENV_DEV ?= $(APP_DIR).env.test
COMPOSE := docker compose --project-directory $(APP_DIR) -f $(APP_DIR)compose.yaml -f $(APP_DIR)compose.staging.yaml --env-file $(ENV_DEV)
UP := up --build --remove-orphans
DOWN := down --remove-orphans -v
PRE := set -e; trap '$(COMPOSE) $(DOWN)' INT TERM EXIT

up:
	$(PRE); $(COMPOSE) $(UP)

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
	$(PRE); $(COMPOSE) $(DOWN) 

re: down up

.PHONY: up down re front back minio postgres admin
