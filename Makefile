# Beautiful Makefile for PHP Stack Management

# Colors
GREEN  := $(shell tput -Txterm setaf 2)
YELLOW := $(shell tput -Txterm setaf 3)
WHITE  := $(shell tput -Txterm setaf 7)
CYAN   := $(shell tput -Txterm setaf 6)
RESET  := $(shell tput -Txterm sgr0)

TARGET_MAX_CHAR_NUM=20

.PHONY: help build up down restart logs shell composer install

## Show help
help:
	@echo ''
	@echo '${CYAN}PHP Stack Manager${RESET}'
	@echo ''
	@echo 'Usage:'
	@echo '  ${YELLOW}make${RESET} ${GREEN}<target>${RESET}'
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

## Build all containers
build:
	@echo "${YELLOW}Building all containers...${RESET}"
	docker-compose build

## Start all containers (detached)
up:
	@echo "${YELLOW}Starting up...${RESET}"
	docker-compose up -d
	@echo "${GREEN}Stack is running!${RESET}"

## Stop all containers
down:
	@echo "${YELLOW}Stopping...${RESET}"
	docker-compose down

## Restart all containers
restart: down up

## View logs (usage: make logs v=82)
logs:
	@if [ -z "$(v)" ]; then \
		docker-compose logs -f; \
	else \
		docker-compose logs -f php$(v); \
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
