# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
#  inception project - LEMP stack, containerized.
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=

# REQUIRED TREE

# ├── Makefile
# └── srcs
#     ├── docker-compose.yml
#     ├── .env
#     └── requirements
#         ├── mariadb
#         │   ├── mariadb.dockerfile
#         │   └── mariadb-entrypoint.sh
#         ├── nginx
#         │   ├── akamlah-42-fr_ssl.conf
#         │   ├── nginx.conf
#         │   └── nginx.dockerfile
#         └── php_wp
#             ├── php_wp.dockerfile
#             └── wp-config.php

# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=

# MAIN BUILD:

NAME = inception

SRC_DIR = ./srcs
ENV_FILE = $(SRC_DIR)/.env
COMPOSE_FILE = $(SRC_DIR)/docker-compose.yml
DOCKER_IMAGES = $(SRC_DIR)/requirements

VOLUME_DIR = /home/akamlah/data
WP_CONTENT_VOLUME = $(VOLUME_DIR)/wp-content_volume
WP_DB_VOLUME = $(VOLUME_DIR)/wp-database_volume

# MAIN COMMAND: ------------------------------------
COMPOSE = sudo docker-compose -f $(COMPOSE_FILE)
# --------------------------------------------------

all: $(NAME)

$(NAME): $(ENV_FILE) $(COMPOSE_FILE) $(DOCKER_IMAGES) create_volumes
	@echo "Building containers"
	$(COMPOSE) --env-file $(ENV_FILE) up -d --build

create_volumes:
	@sudo mkdir -p $(WP_DB_VOLUME) $(WP_CONTENT_VOLUME) \
	&& sudo chmod 777  $(WP_DB_VOLUME) $(WP_CONTENT_VOLUME)

clean:
	$(COMPOSE) down

re: clean all

# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=

# ADDITIONAL & DEVELOPMENT:

# FCLEAN: clears docker image build cache, but clean should be enough in most cases, that is why 
# re' calls just 'clean'.
# Use fclean only to restart from complete scratch.
fclean: clean
	(cd $(SRC_DIR) && sudo docker system prune -a)

# Following rule deletes and recreates the directories of the persistent data.
# Do this only to start over from scratch: all webpages and data will be lost.

new_volumes: create_volumes
	sudo mkdir -p $(WP_DB_VOLUME) $(WP_CONTENT_VOLUME) \
	&& sudo chmod 777  $(WP_DB_VOLUME) $(WP_CONTENT_VOLUME)

# DEBUGGING methods:

# view logs:

logs:
	sudo docker-compose logs

# Open terminals in the containers:

# services and containers are named the same in the compose file
NGINX_CONTAINER_NAME = nginx
MARIADB_CONTAINER_NAME = mariadb
PHP_WORDPRESS_CONTAINER_NAME = php_wordpress

exec_mdb:
	$(COMPOSE) exec $(NGINX_CONTAINER_NAME) /bin/bash

exec_php:
	$(COMPOSE) exec $(PHP_WORDPRESS_CONTAINER_NAME) /bin/bash

exec_nginx:
	$(COMPOSE) exec $(NGINX_CONTAINER_NAME) /bin/bash
