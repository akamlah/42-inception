ARG VERSION=10.12
FROM --platform=amd64 debian:${VERSION}

# install needed packages, set frontend to non-interactive to silence debconf warnings
RUN apt-get update \
	&& DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends --no-install-suggests \
		nginx \
		openssl \
	&& apt-get remove --purge --auto-remove -y \
	&& rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*; \
	mkdir -p /var/www/example_page/html/;

# generate self-signed key & certificate for ssl https encription.
# being self-signed, can be accessed accepting insecure connection.
# (type "thisisunsafe" and enter in chrome)
# data to build certs in copied file:
COPY ./example_page_certs.conf /etc/nginx/certs/example_page_certs.conf

RUN	set -e; \
	openssl req \
		-config /etc/nginx/certs/example_page_certs.conf \
		-new -x509 -sha256 -newkey rsa:2048 -nodes \
		-keyout /etc/nginx/certs/cert.key \
		-days 365 \
		-out /etc/nginx/certs/cert.crt \
	;

# nginx basic configuration file: substitution
COPY ./nginx.conf /etc/nginx/nginx.conf

# just some default value that will get overwritten by buildtime arg in compose file
# (or else please privide PHP_WORDPRESS_CONTAINER as build option if php is remote service)
ARG PHP_WORDPRESS_CONTAINER=localhost
ENV PHP_WORDPRESS_CONTAINER=${PHP_WORDPRESS_CONTAINER}

# set correct hostname for php service and ensure permissions fit.
RUN	set -e; \
	sed -i "s/PATSUBST_PHP_SERVICE/$PHP_WORDPRESS_CONTAINER/g" /etc/nginx/nginx.conf; \
	chown -R www-data:www-data /var/www/example_page/html/; \
	chmod +r /etc/nginx/certs/cert.crt; \
	unset WP_PASSWORD WP_USER DB_HOST DB_NAME MYSQL_ROOT_PASSWORD PHP_WORDPRESS_CONTAINER

EXPOSE 443

# start nginx in foreground
CMD ["nginx", "-g", "daemon off;"]
