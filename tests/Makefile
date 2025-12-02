SHELL := /bin/bash

APP_DIR := ../apps/
ENV_DEV ?= $(APP_DIR).env.test
COMPOSE := docker compose --project-directory $(APP_DIR) -f $(APP_DIR)compose.yaml --env-file $(ENV_DEV)
UP := up --build --remove-orphans
DOWN := down --remove-orphans -v

up:
	$(COMPOSE) $(UP)

front:
	$(COMPOSE) $(UP) frontend

back:
	$(COMPOSE) $(UP) backend

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
