# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
#  inception project - LEMP stack, containerized.
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=

# REQUIRED TREE

# ├── .gitignore
# ├── Makefile
# └── srcs
#     ├── docker-compose.yml
#     ├── .env
#     └── services
#         ├── mariadb
#         │   ├── Dockerfile
#         │   └── mariadb-entrypoint.sh
#         ├── nginx
#         │   ├── akamlah-42-fr_ssl.conf
#         │   ├── Dockerfile
#         │   └── nginx.conf
#         └── php_wp
#             ├── Dockerfile
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

all: $(NAME)

$(NAME): $(ENV_FILE) $(COMPOSE_FILE) $(DOCKER_IMAGES) create_volumes
	@echo "Building containers"
	sudo docker-compose -f $(COMPOSE_FILE) --env-file $(ENV_FILE) up -d --build

clean:
	sudo docker-compose -f $(COMPOSE_FILE) down

fclean: clean
	(cd $(SRC_DIR) && sudo docker system prune -a)

re: clean all

# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=

# DEVELOPMENT:

# FCLEAN: clear cache, but clean should be enough in most cases, that is why 're' calls just 'clean'

fclean: clean
	(cd $(SRC_DIR) && sudo docker system prune -a)

# Following rule deletes and recreates the directories of the persistent data.
# Do this only to start over from scratch: all webpages and data will be lost.

new_volumes: create_volumes
	sudo mkdir -p $(WP_DB_VOLUME) $(WP_CONTENT_VOLUME) \
	&& sudo chmod 777  $(WP_DB_VOLUME) $(WP_CONTENT_VOLUME)

create_volumes:
	@sudo mkdir -p $(WP_DB_VOLUME) $(WP_CONTENT_VOLUME) \
	&& sudo chmod 777  $(WP_DB_VOLUME) $(WP_CONTENT_VOLUME)

# DEBUGGING methods:

# view logs:

logs:
	sudo docker-compose logs

# Open terminals in the containers:

exec_mdb:
	sudo docker-compose exec -it wsc /bin/bash

exec_php:
	sudo docker-compose exec -it phpc /bin/bash

exec_nginx:
	sudo docker-compose exec -it mdbc /bin/bash
