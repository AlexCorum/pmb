.PHONY: backup ssh restore list

NAME?=$(DATEHOUR)

include docker/.env

help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(firstword $(MAKEFILE_LIST)) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[36m%-30s\033[0m %s\n", $$1, $$2}'

env:
	@echo SITE : $(SITE)
	@echo VPS : $(VPS)
	@echo DATE : $(DATE)
	@echo KIMSUFI_SERVER : $(KIMSUFI_SERVER)
	@echo ARCHIVE_PATH : $(ARCHIVE_PATH)
	@echo ARCHIVE_FILES : $(ARCHIVE_FILES)
	@echo ARCHVIE_SQL : $(ARCHIVE_SQL)

www:
	tar cfz $(ARCHIVE_FILES) doc_num docscdi .img_cache
	chown pmb:pmb $(ARCHIVE_FILES)

sql:
	@docker exec pmbdb mysqldump --max_allowed_packet=1G -h db -u$(MYSQL_USER) -p$(MYSQL_PASSWORD) $(MYSQL_DATABASE) | bzip2 > $(ARCHIVE_SQL)
	chown pmb:pmb $(ARCHIVE_SQL)

ssh: www sql	 ## Automatic backup 3 folders and database and copy to Kimsufi
	scp $(ARCHIVE_FILES) $(ARCHIVE_SQL) pmb@$(KIMSUFI_SERVER):$(ARCHIVE_PATH)/

backup:			 ## Manual database backup. By default : NAME=$(DATEHOUR). Example : make backup NAME=RANDOM
	@echo Database exportation in progress : $(ARCHIVE_PATH)/$(NAME)-mysql-manual.sql.bz2
	@docker exec pmbdb mysqldump --max_allowed_packet=1G -h db -u$(MYSQL_USER) -p$(MYSQL_PASSWORD) $(MYSQL_DATABASE) | bzip2 > $(ARCHIVE_PATH)/$(NAME)-mysql-manual.sql.bz2

restore:		## Manual database restauration. By default : NAME=$(DATEHOUR). Example : make restore NAME=RANDOM
	@echo Database restauration in progress : $(ARCHIVE_PATH)/$(NAME)-mysql-manual.sql.bz2
	@bunzip2 < $(ARCHIVE_PATH)/$(NAME)-mysql-manual.sql.bz2 | docker exec -i pmbdb mysql -u$(MYSQL_USER) -p$(MYSQL_PASSWORD) $(MYSQL_DATABASE)

list:			## Display all databases manual backup in $(ARCHIVE_PATH)
	@ls -lh $(ARCHIVE_PATH)/*-mysql-manual.sql.bz2
