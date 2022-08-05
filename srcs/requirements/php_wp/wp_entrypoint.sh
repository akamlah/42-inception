#!/bin/bash

set -e

# temporarily start service for initialization purpose
service php7.3-fpm start

if [ ! -f "/var/www/example_page/html/wordpress/wp-config.php" ]; then

# sudo docker logs php_wp_c to see if this part was executed
# It happens in fact only if no configuration for wordpress is found in the binded mount.
echo "Creating new installation"

sleep 2

# generate config file for wordpress
wp --allow-root --path=/var/www/example_page/html/wordpress config create \
	--dbhost=${DB_HOST} \
	--dbname=${DB_NAME} \
	--dbuser=${WP_DB_USER} \
	--dbpass=${WP_DB_PASSWORD}

chmod 644 /var/www/example_page/html/wordpress/wp-config.php
chown -R www-data:www-data /var/www/example_page/html/

wp --allow-root --path=/var/www/example_page/html/wordpress core install \
	--url=${DOMAINNAME} \
	--title="Example" \
	--admin_name=${WP_ADMIN_USER} \
	--admin_password=${WP_ADMIN_PASSWORD} \
	--admin_email=${WP_ADMIN_EMAIL}

wp --allow-root --path=/var/www/example_page/html/wordpress user create \
	${WP_CONTRIBUTOR_USER} \
	${WP_CONTRIBUTOR_EMAIL} \
	--user_pass=${WP_CONTRIBUTOR_PASSWORD} \
	--role=contributor

fi

# stop php-fpm to free port 9000 to restart service in foreground
service php7.3-fpm stop

# restart php-fpm in foreground ($@ in CMD)
exec "$@"
