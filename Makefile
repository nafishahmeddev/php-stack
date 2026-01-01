# Beautiful Makefile for PHP Stack Management

# Colors
GREEN  := $(shell tput -Txterm setaf 2)
YELLOW := $(shell tput -Txterm setaf 3)
WHITE  := $(shell tput -Txterm setaf 7)
CYAN   := $(shell tput -Txterm setaf 6)
RESET  := $(shell tput -Txterm sgr0)

TARGET_MAX_CHAR_NUM=20

.PHONY: help build up down restart logs shell composer install

# Define versions
VERSIONS := 73 74 80 84

# Helper to determine compose file args
ifndef v
	# If no version specified, include all
	COMPOSE_FILES := $(foreach ver,$(VERSIONS),-f docker-compose.php$(ver).yml)
else
	# specific version
	COMPOSE_FILES := -f docker-compose.php$(v).yml
endif

COMPOSE_CMD := docker compose $(COMPOSE_FILES)

## Show help
help:
	@echo ''
	@echo '${CYAN}PHP Stack Manager${RESET}'
	@echo ''
	@echo 'Usage:'
	@echo '  ${YELLOW}make${RESET} ${GREEN}<target>${RESET} [v=version]'
	@echo ''
	@echo 'Targets:'
	@awk '/^[a-zA-Z\-\_0-9]+:/ { \
		helpMessage = match(lastLine, /^## (.*)/); \
		if (helpMessage) { \
			helpCommand = substr($$1, 0, index($$1, ":")-1); \
			helpMessage = substr(lastLine, RSTART + 3, RLENGTH); \
			printf "  ${YELLOW}%-$(TARGET_MAX_CHAR_NUM)s${RESET} ${GREEN}%s${RESET}\n", helpCommand, helpMessage; \
		} \
	} \
	{ lastLine = $$0 }' $(MAKEFILE_LIST)

## Build containers (all or v=XX)
build:
	@echo "${YELLOW}Building...${RESET}"
	$(COMPOSE_CMD) build

## Start containers (all or v=XX)
up:
	@echo "${YELLOW}Starting up...${RESET}"
	$(COMPOSE_CMD) up -d
	@echo "${GREEN}Stack is running!${RESET}"

## Stop containers (all or v=XX)
down:
	@echo "${YELLOW}Stopping...${RESET}"
	$(COMPOSE_CMD) down

## Restart containers
restart: down up

## View logs (usage: make logs [v=82])
logs:
	@if [ -z "$(v)" ]; then \
		$(COMPOSE_CMD) logs -f; \
	else \
		$(COMPOSE_CMD) logs -f php$(v); \
	fi

## Access container shell (usage: make shell v=82)
shell:
	@if [ -z "$(v)" ]; then echo "${YELLOW}Please specify version: make shell v=82${RESET}"; exit 1; fi
	docker exec -it php$(v)-fpm /bin/bash

## Run Composer command (usage: make composer v=82 cmd="require vendor/pkg")
composer:
	@if [ -z "$(v)" ]; then echo "${YELLOW}Please specify version: make composer v=82 cmd=\"...\"${RESET}"; exit 1; fi
	@if [ -z "$(cmd)" ]; then echo "${YELLOW}Please specify command: make composer v=82 cmd=\"install\"${RESET}"; exit 1; fi
	docker exec -it php$(v)-fpm composer $(cmd)

## Run Composer Install (usage: make install v=82)
install:
	@if [ -z "$(v)" ]; then echo "${YELLOW}Please specify version: make install v=82${RESET}"; exit 1; fi
	docker exec -it php$(v)-fpm composer install
