DATA_CONTAINER	:= cpp_study_data

GCC_CONTAINER	:= cpp_study_gcc
GCC_PORT	:= 8080
SERVER_PORT	:= 3000

.PHONY: all
all: help

.PHONY: clean
clean: ddown fclean ## delete files
	make -C ./src clean

.PHONY: fclean
fclean: 
	-@rm -rf .mysqldata
	-@rm .docker-compose.env
	-@rm .docker-compose.yml
	-@find . -name '*~' -print | xargs rm

.PHONY: help
help:
	@grep -E '^[a-zA-Z0-9_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

###############################################################
# Docker
###############################################################
.PHONY: create_env_files
create_env_files: .docker-compose.env .docker-compose.yml

.docker-compose.env: Makefile
	@echo "MYSQL_ROOT_PASSWORD=$(ROOT_PASSWORD)" >  .docker-compose.env
	@echo "GOPATH=/go"                           >> .docker-compose.env

.docker-compose.yml: Makefile etc/docker-compose/docker-compose.tpl
	@cat etc/docker-compose/docker-compose.tpl | \
		sed "s/%%DATA_CONTAINER%%/${DATA_CONTAINER}/g" | \
		sed "s/%%GCC_CONTAINER%%/${GCC_CONTAINER}/g" | \
		sed "s/%%GCC_PORT%%/${GCC_PORT}/g" | \
		sed "s/%%SERVER_PORT%%/${SERVER_PORT}/g" \
		 > .docker-compose.yml

.PHONY: dup
dup: create_env_files ## Docker up
	@docker ps | grep $(DATA_CONTAINER) | awk '$$1 == "" {exit};' | \
		docker-compose -f .docker-compose.yml up -d data
	@docker-compose -f .docker-compose.yml up -d gcc

.PHONY: ddown
ddown: create_env_files ## Docker down
	@docker-compose -f .docker-compose.yml down

.PHONY: dlogs
dlogs: create_env_files ## Docker logs
	@docker-compose -f .docker-compose.yml logs -f

.PHONY: dlogin
dlogin: create_env_files ## Docker login
	@docker exec -it $(GCC_CONTAINER) /usr/bin/scl enable devtoolset-7 bash

###############################################################
# GCC
###############################################################
.PHONY: build
build: create_env_files ## make all in Docker Container
	@docker-compose -f .docker-compose.yml run --rm build

.PHONY: _build
_build:
	@date
	@/usr/bin/scl enable devtoolset-7 "make -C ./src all"
	@date

.PHONY: echo-server
echo-server: ## Run Echo Server
	@docker-compose -f .docker-compose.yml run --service-ports --rm server ./bin/server --echo-server

.PHONY: kill-echo-server
kill-echo-server: ## Kill Echo Server
	@docker ps | grep "bin/server" | cut -d " " -f1 | xargs docker kill

.PHONY: echo-client
echo-client: ## Run Echo Client
	@telnet 127.0.0.1 $(SERVER_PORT)


