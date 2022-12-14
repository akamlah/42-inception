# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# MAKEFILE -
# Inception project - LEMP stack, containerized.
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=

# TREE

# ├── .gitignore
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
#             └── wp_entrypoint.sh

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

# command
COMPOSE = sudo docker-compose -f $(COMPOSE_FILE)

all: $(NAME)

$(NAME): $(ENV_FILE) $(COMPOSE_FILE) $(DOCKER_IMAGES) create_volumes
	@echo "Building containers"
	$(COMPOSE) --env-file $(ENV_FILE) up -d --build

create_volumes:
	sudo mkdir -p $(WP_DB_VOLUME) $(WP_CONTENT_VOLUME) \
	&& sudo chmod 777  $(WP_DB_VOLUME) $(WP_CONTENT_VOLUME)

clean:
	$(COMPOSE) down

re: fclean all

# FCLEAN: clears docker image build cache
fclean: clean
	(cd $(SRC_DIR) && sudo docker system prune -a)

# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=

# [ ! ]
# complete scratch - deletes all data
scratch: ffclean all

# ADDITIONAL & DEVELOPMENT:

# [ ! ]
# clean all cached and dangeling images and destroy all data and volumes
ffclean: fclean new_volumes

# Following rule deletes and recreates the directories of the persistent data.
# Do this only to start over from scratch: all webpages and data will be lost.
clear_local_volumes:
	@echo -n "Deleting all existing data (^C to stop process) in "; sleep 1; echo -n "3 "; \
	sleep 1; echo -n "2 "; sleep 1; echo -n "1 "; sleep 1; echo "Deleting all data"; sleep 1
	sudo rm -rf $(WP_DB_VOLUME) $(WP_CONTENT_VOLUME)

new_volumes: clear_local_volumes create_volumes
	sudo docker volume rm wp-content_volume wp-database_volume

# DEBUGGING methods:

# view logs:
logs:
	$(COMPOSE) logs

# Open terminals in the containers:

# services and containers are named the same in the compose file
NGINX_COMPOSE_SERVICE_NAME = nginx
MARIADB_COMPOSE_SERVICE_NAME = mariadb
PHP_WORDPRESS_COMPOSE_SERVICE_NAME = php_wordpress

exec_mdb:
	$(COMPOSE) exec $(MARIADB_COMPOSE_SERVICE_NAME) /bin/bash

exec_php:
	$(COMPOSE) exec $(PHP_WORDPRESS_COMPOSE_SERVICE_NAME) /bin/bash

exec_nginx:
	$(COMPOSE) exec $(NGINX_COMPOSE_SERVICE_NAME) /bin/bash


# To redo just one container: rm with one of these rules and then run: make prune
# This will clear all images & cache linked with only stopped and removed containers.
# Then run make to rebuild and reintegrate the removed service
# Or use 're' rules below.
rm_nginx:
	$(COMPOSE) stop $(NGINX_COMPOSE_SERVICE_NAME) \
	&& $(COMPOSE) rm $(NGINX_COMPOSE_SERVICE_NAME)

rm_mdb:
	$(COMPOSE) stop $(MARIADB_COMPOSE_SERVICE_NAME) \
	&& $(COMPOSE) rm $(MARIADB_COMPOSE_SERVICE_NAME)

rm_php:
	$(COMPOSE) stop $(PHP_WORDPRESS_COMPOSE_SERVICE_NAME) \
	&& $(COMPOSE) rm $(PHP_WORDPRESS_COMPOSE_SERVICE_NAME)

prune:
	sudo docker system prune

prune_all:
	sudo docker system prune -a

re_nginx: rm_nginx prune_all all
re_mdb: rm_mdb prune_all all
re_php: rm_php prune_all all

ps:
	sudo docker ps

# show that wordpress database has two users:
# select host, user, password from mysql.user; 