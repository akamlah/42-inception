ARG VERSION=10.12
FROM --platform=amd64 debian:${VERSION}
MAINTAINER akamlah

# install needed packages, set frontend to non-interactive to silence debconf warnings
RUN	set -ex; \
	apt-get update \
	&& DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends --no-install-suggests \
		mariadb-server \
		mariadb-backup \
		socat \
		vim \
	; \
	rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*; \
	# sed -i -e '/includedir/ {N;s/\(.*\)\n\(.*\)/[mariadbd]\nskip-host-cache\nskip-name-resolve\nskip-grant-tables\n\n\2\n\1/}' /etc/mysql/mariadb.cnf; \
	sed -i -e '/includedir/ {N;s/\(.*\)\n\(.*\)/[mariadbd]\nskip-host-cache\nskip-name-resolve\n\n\2\n\1/}' /etc/mysql/mariadb.cnf; \
	sed -i 's/bind-address            = 127.0.0.1/skip-bind-address/g' /etc/mysql/mariadb.conf.d/50-server.cnf; \
	sed -i 's/#port                   = 3306/port                   = 3306/g' /etc/mysql/mariadb.conf.d/50-server.cnf;

# ARG WP_DB_NAME
# ARG WP_DB_CHARSET
# ARG WP_DB_COLLATE
# ARG MYSQL_ROOT_PASSWORD

# RUN service mysql start \
# 	&& mysql -u root -e "CREATE DATABASE $WP_DB_NAME CHARACTER SET $WP_DB_CHARSET COLLATE $WP_DB_COLLATE" \
# 	&& mysql -u root -e "CREATE USER IF NOT EXISTS '$WP_DB_USER'@'%' IDENTIFIED BY '$WP_DB_PASSWORD'" \
# 	&& mysql -u root -e "GRANT ALL ON inception.* TO '$WP_DB_USER'@'%' IDENTIFIED BY '$WP_DB_PASSWORD'" \
# 	&& mysql -u root -e "FLUSH PRIVILEGES"; \
# 	mysql -u root -e "ALTER USER 'root'@'localhost' IDENTIFIED BY '$MYSQL_ROOT_PASSWORD'"; \
# 	mysql -u root -e "flush privileges";

EXPOSE 3306

COPY ./mariadb-entrypoint.sh /usr/local/bin/

STOPSIGNAL SIGQUIT

ENTRYPOINT ["mariadb-entrypoint.sh"]
# ENTRYPOINT mariadb-entrypoint.sh && bash

CMD ["mysqld_safe"]

# mysql -u root -p > does not work without password