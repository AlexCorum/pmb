.PHONY: rebuild build down up httpd log

DC=docker compose
DC_UP=$(DC) up -d
DC_EXEC=$(DC) exec php
BIN_CONSOLE=$(DC_EXEC) bin/console

help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(firstword $(MAKEFILE_LIST)) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[36m%-30s\033[0m %s\n", $$1, $$2}'

rebuild: build up   ## Rebuild containers
	@make inspect

down: 				## Down all containers
	$(DC) down

pull: down
	$(DC) pull

build: down pull	## Rebuild containers
	$(DC) build --pull;

up:				## Start containers
	@$(DC) up -d

	@# Vérifie si la date de php est correct
	$(DC_EXEC) date

httpd: 				## Restart Apache/Nginx
	-$(DC_EXEC) nginx /etc/init.d/nginx restart

inspect: 				## Show Containers IPs
	docker inspect -f '{{.Name}} - {{range .NetworkSettings.Networks}} {{.IPAddress}} {{end}} ' pmbdb

logs:				## Show logs
	$(DC) logs -f

bash:				## Run bash
	-$(DC_EXEC) bash

inspect:                                ## Show Containers IPs
	docker inspect -f '{{.Name}} - {{range .NetworkSettings.Networks}} {{.IPAddress}} {{end}} ' pmbdb
