#!/bin/bash

set -e

# service mysql start

if [ ! -d /var/lib/mysql/${WP_DB_NAME} ]; then

# bootstrap start to create init files
mysql_install_db
service mysql start

# automated secure installation and creation of application's database
mysql --user=root <<_EOF_
UPDATE mysql.user SET Password=PASSWORD('$MYSQL_ROOT_PASSWORD') WHERE User='root';
DELETE FROM mysql.user WHERE User='';
DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1');
DROP DATABASE IF EXISTS test;
DELETE FROM mysql.db WHERE Db='test' OR Db='test\\_%';
CREATE DATABASE IF NOT EXISTS $WP_DB_NAME CHARACTER SET $WP_DB_CHARSET COLLATE $WP_DB_COLLATE;
CREATE USER IF NOT EXISTS '$WP_DB_USER'@'%' IDENTIFIED BY '$WP_DB_PASSWORD';
GRANT ALL ON inception.* TO '$WP_DB_USER'@'%' IDENTIFIED BY '$WP_DB_PASSWORD';
FLUSH PRIVILEGES;
_EOF_

mysqladmin --user=root --password=$MYSQL_ROOT_PASSWORD shutdown

fi

# mariadb-admin shutdown -uroot -p=$MYSQL_ROOT_PASSWORD shutdown
# # mysqladmin -u root password "$MYSQL_ROOT_PASSWORD"
# mysql -u root <<-EOF || true
# CREATE DATABASE $WP_DB_NAME CHARACTER SET $WP_DB_CHARSET COLLATE $WP_DB_COLLATE;
# CREATE USER IF NOT EXISTS '$WP_DB_USER'@'%' IDENTIFIED BY '$WP_DB_PASSWORD';
# GRANT ALL ON inception.* TO '$WP_DB_USER'@'%' IDENTIFIED BY '$WP_DB_PASSWORD';
# SET PASSWORD FOR 'root'@'localhost' = PASSWORD('$MYSQL_ROOT_PASSWORD');
# FLUSH PRIVILEGES;
# exit;
# EOF

# mysql -u root -e "CREATE DATABASE $WP_DB_NAME CHARACTER SET $WP_DB_CHARSET COLLATE $WP_DB_COLLATE"
# mysql -u root -e "CREATE USER IF NOT EXISTS '$WP_DB_USER'@'%' IDENTIFIED BY '$WP_DB_PASSWORD'"
# mysql -u root -e "GRANT ALL ON inception.* TO '$WP_DB_USER'@'%' IDENTIFIED BY '$WP_DB_PASSWORD'"
# mysql -u root -e "FLUSH PRIVILEGES"

# execute "mysqld_safe" passed as argment by 'CMD'
exec "$@"
# bash
