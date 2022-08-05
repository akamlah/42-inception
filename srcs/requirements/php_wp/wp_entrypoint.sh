#!/bin/bash

set -e

# temporarily start service for initialization purpose
service php7.3-fpm start
sleep 5

if [ ! -f "/var/www/example_page/html/wordpress/wp-config.php" ]; then

# generate config file for wordpress
wp --allow-root --path=/var/www/example_page/html/wordpress config create \
	--dbhost=${DB_HOST} \
	--dbname=${DB_NAME} \
	--dbuser=${WP_USER} \
	--dbpass=${WP_PASSWORD}

chmod 644 /var/www/example_page/html/wordpress/wp-config.php
chown -R www-data:www-data /var/www/example_page/html/

fi

# delete sensitive and redundant data
unset WP_PASSWORD WP_USER DB_HOST DB_NAME MYSQL_ROOT_PASSWORD PHP_WORDPRESS_CONTAINER

# stop php-fpm to free port 9000 to restart service in foreground
service php7.3-fpm stop

# restart php-fpm in foreground ($@ in CMD)
exec "$@"

# WordPress login to view example page created in persiatent volume:
# Site Title	example_
# Username		example_user_
# Password		example123_
# Email		example_@example.com
