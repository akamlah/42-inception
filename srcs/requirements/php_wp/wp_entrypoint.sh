#!/bin/bash

set -e

# # configure php-fpm service to listen on port 9000 (on which nginx container sends requests for fpm service)
# sed -i 's/listen = \/run\/php\/php7.3-fpm.sock/listen = 9000/g' /etc/php/7.3/fpm/pool.d/www.conf; \
# sed -i 's/;listen.mode = 0660/listen.mode = 0660/g' /etc/php/7.3/fpm/pool.d/www.conf; \
# sed -i 's/;daemonize = yes/daemonize = no/g' /etc/php/7.3/fpm/pool.d/www.conf; \
# sed -i 's/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/g' /etc/php/7.3/fpm/php.ini;

service php7.3-fpm start
sleep 5

if [ ! -f "/var/www/akamlah.42.fr/html/wordpress/wp-config.php" ]; then

wp --allow-root --path=/var/www/akamlah.42.fr/html/wordpress config create \
	--dbhost=${DB_HOST} \
	--dbname=example_db \
	--dbuser=example_user \
	--dbpass=example123

chmod 644 /var/www/akamlah.42.fr/html/wordpress/wp-config.php

# wp --allow-root --path=/var/www/akamlah.42.fr/html/wordpress core install \
# 	--url=localhost \
# 	--title="Example" \
# 	--admin_name=example_admin \
# 	--admin_password=example_admin123 \
# 	--admin_email=you@example.com \

fi

chown -R www-data:www-data /var/www/akamlah.42.fr/html/

service php7.3-fpm stop

exec "$@"