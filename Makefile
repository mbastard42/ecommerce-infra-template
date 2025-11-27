SHELL := /bin/bash

APPS_DIR  := apps
TESTS_DIR := tests

apps-up:
	$(MAKE) -C $(APPS_DIR) up

apps-down:
	$(MAKE) -C $(APPS_DIR) down

apps-re:
	$(MAKE) -C $(APPS_DIR) re

tests-up:
	$(MAKE) -C $(TESTS_DIR) up

tests-down:
	$(MAKE) -C $(TESTS_DIR) down

tests-re:
	$(MAKE) -C $(TESTS_DIR) re

deps:
	docker plugin install grafana/loki-docker-driver:3.3.2-arm64 --alias loki --grant-all-permissions

.PHONY: apps-up apps-down apps-re tests-up tests-down tests-re
