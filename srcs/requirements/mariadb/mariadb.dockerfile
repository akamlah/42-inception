ARG VERSION=10.12
FROM --platform=amd64 debian:${VERSION}

# install needed packages, set frontend to non-interactive to silence debconf warnings
RUN	set -ex; \
	apt-get update \
	&& DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends --no-install-suggests \
		mariadb-server \
		mariadb-backup \
		socat \
	; \
	rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*; \
	\
	# config as remote service on port 3306:
	sed -i -e '/includedir/ {N;s/\(.*\)\n\(.*\)/[mariadbd]\nskip-host-cache\nskip-name-resolve\n\n\2\n\1/}' /etc/mysql/mariadb.cnf; \
	sed -i 's/bind-address            = 127.0.0.1/skip-bind-address/g' /etc/mysql/mariadb.conf.d/50-server.cnf; \
	sed -i 's/#port                   = 3306/port                   = 3306/g' /etc/mysql/mariadb.conf.d/50-server.cnf;

ENV DB_NAME=${DB_NAME}

COPY ./mariadb-entrypoint.sh /usr/local/bin/

ENTRYPOINT ["mariadb-entrypoint.sh"]

EXPOSE 3306

STOPSIGNAL SIGQUIT

CMD ["mysqld_safe"]
