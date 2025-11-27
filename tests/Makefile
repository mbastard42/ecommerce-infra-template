SHELL := /bin/bash

APP_DIR := ../apps/
ENV_DEV ?= $(APP_DIR).env.test
COMPOSE := docker compose --project-directory $(APP_DIR) -f $(APP_DIR)compose.yaml -f $(APP_DIR)compose.prod.yaml --env-file $(ENV_DEV)
UP := up --build --remove-orphans
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
