#!/bin/bash

set -e

# service mysql start

if [ ! -d /var/lib/mysql/$DB_NAME ]; then

# temporarily start to create init files
service mysql start

# set root password, delete test db and empty users and create application's db
mysql --user=root <<_EOF_
UPDATE mysql.user SET Password=PASSWORD('$MYSQL_ROOT_PASSWORD') WHERE User='root';
DELETE FROM mysql.user WHERE User='';
DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1');
DROP DATABASE IF EXISTS test;
DELETE FROM mysql.db WHERE Db='test' OR Db='test\\_%';
CREATE DATABASE IF NOT EXISTS $DB_NAME;
CREATE USER IF NOT EXISTS '$WP_DB_USER'@'%' IDENTIFIED BY '$WP_DB_PASSWORD';
GRANT ALL ON $DB_NAME.* TO '$WP_DB_USER'@'%' IDENTIFIED BY '$WP_DB_PASSWORD';
FLUSH PRIVILEGES;
_EOF_

# stop temporarily
mysqladmin --user=root --password=$MYSQL_ROOT_PASSWORD shutdown

fi

# execute "mysqld_safe" passed as argment by 'CMD' -> restart mysql as daemon
exec "$@"
