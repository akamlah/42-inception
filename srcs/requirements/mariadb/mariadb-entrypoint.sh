#!/bin/bash

set -e

# service mysql start

if [ ! -d /var/lib/mysql/example_db ]; then

# temporarily start to create init files
service mysql start

# set root password, delete test db and empty users and create application's db
mysql --user=root <<_EOF_
UPDATE mysql.user SET Password=PASSWORD('$MYSQL_ROOT_PASSWORD') WHERE User='root';
DELETE FROM mysql.user WHERE User='';
DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1');
DROP DATABASE IF EXISTS test;
DELETE FROM mysql.db WHERE Db='test' OR Db='test\\_%';
CREATE DATABASE IF NOT EXISTS example_db;
CREATE USER IF NOT EXISTS 'example_user'@'%' IDENTIFIED BY 'example123';
GRANT ALL ON example_db.* TO 'example_user'@'%' IDENTIFIED BY 'example123';
FLUSH PRIVILEGES;
_EOF_

# stop temporarily
mysqladmin --user=root --password=$MYSQL_ROOT_PASSWORD shutdown

fi

# execute "mysqld_safe" passed as argment by 'CMD'
# -> restart mysql as daemon in foregound
exec "$@"

# CREATE DATABASE IF NOT EXISTS inception;
