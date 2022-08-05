# wordpress version used: 6.0.1
ARG DEBIAN_VERSION=10.12
FROM --platform=amd64 debian:${DEBIAN_VERSION}
ARG PHP_VERSION=7.3

ENV PHP_VERSION_ENV=${PHP_VERSION}

# PHP: install needed packages, set frontend to non-interactive to silence debconf warnings
RUN set -ex; \
	apt-get update \
	&& DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends --no-install-suggests \
		php${PHP_VERSION} \
		php${PHP_VERSION}-cli \
		php${PHP_VERSION}-curl \
		php${PHP_VERSION}-fpm \
		php${PHP_VERSION}-gd \
		php${PHP_VERSION}-json \
		php${PHP_VERSION}-mbstring \
		php${PHP_VERSION}-mysql \
		php${PHP_VERSION}-opcache \
		php${PHP_VERSION}-xml \
	&& apt-get remove --purge --auto-remove -y; \
	\
	# configure php-fpm service to listen on port 9000 (on which nginx container sends requests for fpm service)
	# keeping default user www-data (same as nginx config)
	sed -i "s/listen = \/run\/php\/php$PHP_VERSION_ENV-fpm.sock/listen = 9000/g" /etc/php/7.3/fpm/pool.d/www.conf; \
	sed -i 's/;listen.mode = 0660/listen.mode = 0660/g' /etc/php/7.3/fpm/pool.d/www.conf; \
	sed -i 's/;daemonize = yes/daemonize = no/g' /etc/php/7.3/fpm/pool.d/www.conf; \
	sed -i 's/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/g' /etc/php/7.3/fpm/php.ini;

# get wordpress and needed packages
RUN	set -ex; \
	apt-get update \
	&& DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends --no-install-suggests \
		curl \
		less \
		mariadb-client \
	&& apt-get remove --purge --auto-remove -y; \
	\
	mkdir -p /var/www/example_page/html/; \
	# download wordpress
	curl -o wordpress.tar.gz -kL "https://wordpress.org/wordpress-6.0.1.tar.gz"; \
	tar -xzf wordpress.tar.gz -C /var/www/example_page/html/; \
	rm wordpress.tar.gz; \
	\
	# download wp-cli
	curl -Ok https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
	&& chmod +x wp-cli.phar \
	&& mv wp-cli.phar /usr/local/bin/wp

COPY ./wp_entrypoint.sh /usr/local/bin/

ENTRYPOINT ["wp_entrypoint.sh"]

# force to stay in foreground, and ignore daemonize option from config file
CMD ["/usr/sbin/php-fpm7.3", "--nodaemonize"]
