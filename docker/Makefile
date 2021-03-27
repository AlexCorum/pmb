.PHONY: rebuild build down start httpd

help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(firstword $(MAKEFILE_LIST)) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[36m%-30s\033[0m %s\n", $$1, $$2}'

rebuild: build start

down: 				## Down all containers
	@docker-compose down

pull: down
	@docker-compose pull

build: down pull	## Rebuild containers
	@docker-compose build --pull

start:				## Start containers
	@docker-compose up -d --force-recreate --remove-orphans

	@# Vérifie si la date de php est correct
	docker-compose exec php date

httpd: 				## Restart Apache/Nginx
	-docker-compose exec php service apache2 restart