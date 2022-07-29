# akamlah@dabian11-1E5-2:~/inception_sf/srcs$ tree -a
# .
# ├── docker-compose.yml
# ├── .env
# └── services
#     ├── mariadb
#     │   ├── Dockerfile
#     │   └── mariadb-entrypoint.sh
#     ├── nginx
#     │   ├── akamlah-42-fr_ssl.conf
#     │   ├── Dockerfile
#     │   └── nginx.conf
#     └── php_wp
#         ├── Dockerfile
#         └── wp-config.php

NAME=inception

all: $(NAME)

$(NAME):
	(cd ./srcs && sudo docker-compose up -d)

clean:
	(cd ./srcs && sudo docker-compose down)

fclean: clean
	(cd ./srcs && sudo docker system prune -a)

re: fclean all


# following rules wipe the entire db: use only in development of services or the webpage will be lost

scratch_re: wipe_all scratch

scratch:
	sudo mkdir -p /home/akamlah/data/wp-database_volume /home/akamlah/data/wp-content_volume \
	&& sudo chmod 777  /home/akamlah/data/wp-database_volume /home/akamlah/data/wp-content_volume
	make

wipe_all: fclean
	sudo rm -rf /home/akamlah/data/wp-database_volume /home/akamlah/data/wp-content_volume
	sudo docker volume rm wp-content_volume wp-database_volume


#sudo docker exec -it wsc /bin/bash
#sudo docker exec -it phpc /bin/bash
#sudo docker exec -it mdbc /bin/bash
