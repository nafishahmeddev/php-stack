# PHP stack: PHP 7.3 / 7.4 / 8.0 / 8.4 / 8.5 + MySQL
#
#   make <target> [v=73|74|80|84|85|mysql]      (no v = everything)

VERSIONS := 73 74 80 84 85

# Which compose files and services to act on
ifeq ($(v),mysql)
  FILES    := -f docker-compose.mysql.yml
  SERVICES := mysql
else ifneq ($(v),)
  FILES    := -f docker-compose.php$(v).yml
  SERVICES := php$(v)
else
  FILES    := $(foreach n,$(VERSIONS),-f docker-compose.php$(n).yml) -f docker-compose.mysql.yml
  SERVICES :=
endif

DC        := docker compose $(FILES)
CONTAINER  = $(if $(filter mysql,$(v)),mysql,php$(v)-fpm)

# Targets that need a single version
need-v = @test -n "$(v)" || { echo "Specify a version: make $@ v=84"; exit 1; }

.PHONY: help build up down restart deploy logs ps shell composer install

help: ## Show this help
	@echo "Usage: make <target> [v=73|74|80|84|85|mysql]   (no v = everything)"
	@echo ""
	@grep -E '^[a-z-]+:.*## ' $(MAKEFILE_LIST) | awk -F':.*## ' '{printf "  %-10s %s\n", $$1, $$2}'

build: ## Build images
	$(DC) build

up: ## Start containers
	$(DC) up -d

down: ## Stop and remove containers
	$(DC) down

restart: ## Restart containers
	$(DC) restart $(SERVICES)

deploy: ## Rebuild from scratch (no cache, latest base) and recreate
	$(DC) build --no-cache --pull
	$(DC) up -d --force-recreate
	docker image prune -f

logs: ## Follow logs
	$(DC) logs -f $(SERVICES)

ps: ## Show container status
	$(DC) ps

shell: ## Open a shell in a container (needs v)
	$(need-v)
	docker exec -it $(CONTAINER) /bin/bash

composer: ## Run composer (needs v): make composer v=84 cmd="require x/y"
	$(need-v)
	docker exec -it $(CONTAINER) composer $(or $(cmd),install)

install: ## Run composer install (needs v)
	$(need-v)
	docker exec -it $(CONTAINER) composer install
