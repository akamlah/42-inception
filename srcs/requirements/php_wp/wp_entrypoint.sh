#!/bin/bash

set -e

# temporarily start service for initialization purpose
service php7.3-fpm start

if [ ! -f "/var/www/example_page/html/wordpress/wp-config.php" ]; then

# sudo docker logs php_wp_c to see if this part was executed
# It happens in fact only if no configuration for wordpress is found in the binded mount.
echo "Creating new installation"

sleep 1

# generate config file for wordpress
wp --allow-root --path=/var/www/example_page/html/wordpress config create \
	--dbhost=${DB_HOST} \
	--dbname=${DB_NAME} \
	--dbuser=${WP_USER} \
	--dbpass=${WP_PASSWORD}

chmod 644 /var/www/example_page/html/wordpress/wp-config.php
chown -R www-data:www-data /var/www/example_page/html/

wp --allow-root --path=/var/www/example_page/html/wordpress core install \
	--url=akamlah.42.fr \
	--title="Example" \
	--admin_name=${WP_USER} \
	--admin_password=${WP_PASSWORD} \
	--admin_email=example@example.com

fi

# delete sensitive and redundant data
unset WP_PASSWORD WP_USER DB_HOST DB_NAME MYSQL_ROOT_PASSWORD PHP_WORDPRESS_CONTAINER

# stop php-fpm to free port 9000 to restart service in foreground
service php7.3-fpm stop

# restart php-fpm in foreground ($@ in CMD)
exec "$@"
