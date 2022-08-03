ARG VERSION=10.12
FROM --platform=amd64 debian:${VERSION}
MAINTAINER akamlah

# install needed packages, set frontend to non-interactive to silence debconf warnings
RUN	set -ex; \
	apt-get update \
	&& DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends --no-install-suggests \
		mariadb-server \
		# mariadb-client \
		# mariadb-backup \
		# socat \
		vim \
	; \
	rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*; \
	# config as remote service on port 3306:
	# sed -i -e '/includedir/ {N;s/\(.*\)\n\(.*\)/[mariadbd]\nskip-host-cache\nskip-name-resolve\n\n\2\n\1/}' /etc/mysql/mariadb.cnf; \
	sed -i 's/bind-address            = 127.0.0.1/skip-bind-address/g' /etc/mysql/mariadb.conf.d/50-server.cnf; \
	sed -i 's/#port                   = 3306/port                   = 3306/g' /etc/mysql/mariadb.conf.d/50-server.cnf; \
	sed -i 's/# Port or socket location where to connect/socket = \/run\/mysqld\/mysqld.sock/g' /etc/mysql/mariadb.cnf;

RUN service mysql start \
	&& mysql -uroot -e "CREATE DATABASE wordpress" \
	&& mysql -uroot -e "CREATE USER IF NOT EXISTS '$WP_DB_USER'@'%' IDENTIFIED BY '$WP_DB_PASSWORD'" \
	&& mysql -uroot -e "GRANT ALL ON inception.* TO '$WP_DB_USER'@'%' IDENTIFIED BY '$WP_DB_PASSWORD'" \
	&& mysql -uroot -e "FLUSH PRIVILEGES" \
	&& mysql -uroot -e "exit" ;

EXPOSE 3306

COPY ./mariadb-entrypoint.sh /usr/local/bin/

STOPSIGNAL SIGQUIT

ENTRYPOINT ["mariadb-entrypoint.sh"]

CMD ["mysqld_safe"]

# mysql -u root -p > does not work without password