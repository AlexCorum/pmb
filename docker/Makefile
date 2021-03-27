.PHONY: rebuild build down start httpd

help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(firstword $(MAKEFILE_LIST)) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[36m%-30s\033[0m %s\n", $$1, $$2}'

rebuild: build start

down: 				## Down all containers
	@docker-compose down

pull: down
	@docker-compose pull

build: down pull	## Rebuild ccontainers
	@# Recontruit les containers en remettant à jour les images. --pull est optionel
	@#docker-compose build --force-rm --pull --no-cache --build-arg http_proxy=http://proxy.in.ac-grenoble.fr:8080 --build-arg https_proxy=http://proxy.in.ac-grenoble.fr:8080
	@#docker-compose build --build-arg http_proxy=http://proxy.in.ac-grenoble.fr:8080 --build-arg https_proxy=http://proxy.in.ac-grenoble.fr:8080
	@#docker-compose build --force-rm --pull --no-cache
	@docker-compose build --pull

start:				## Start containers
	@# Lance les images en forcant la création et en supprimant les orphelins
	@docker-compose up -d --force-recreate --remove-orphans
	@#docker-compose up --force-recreate --remove-orphans

	@# Vérifie si la date de php est correct
	docker-compose exec php date
	@#docker-compose exec php php -m

httpd: 				## Restart Apache/Nginx
	-docker-compose exec php service apache2 restart