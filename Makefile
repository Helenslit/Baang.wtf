PHP_UP := $(shell docker ps --format '{{.Names}}' | grep php)
GREEN := "\e[92m"
STOP="\e[0m"

default:
	@printf ${GREEN}
	@echo 'Documentation for make commands:'
	@printf ${STOP}
	@echo '----------------------------------------------'
	@echo '  install        : will install and configure the whole skeleton project'
	@echo '  enter          : enter PHP container'
	@echo '  db-enter       : enter DB container'
	@echo '  sql            : enter SQL shell'
	@echo '----------------------------------------------'
	@echo ' '

install:
	$(info Running Q API Platform installation script, this might take a minute...)
	docker-compose up --detach --force-recreate --build --remove-orphans
	sleep 15 # Because we are not using `depends_on` and `healthcheck` options in `docker-compose.yml`
	docker exec -it baang_php /home/web-user/setup.sh
	@echo ' '1
	curl -IL -k http://localhost | head -n 8
	@echo ' '
	docker-compose ps
	@echo ' '
	@printf ${GREEN}
	@echo 'The application is available at: http://localhost:80'
	@printf ${STOP}
	@echo ' '

enter:
	$(info entering PHP container...)
	docker-compose exec php /bin/bash

db-enter:
	$(info entering DB container...)
	docker-compose exec db /bin/bash

sql:
	$(info entering SQL shell...)
	docker-compose exec db /bin/mysql -uuser -pP455W0RD
