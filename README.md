# 42-inception
Writing small docker images from scratch as an exercise, and set up a functioning containerised LEMP stack 

## Usage

At the root of the repository:
```
$ make
```

You will build and run this way 3 docker containers:
* A container with nginx as server
* A container with php-fpm and Wordpress
* A contianer with a database (mariadb) linked to wordpress

The data generated is persistent thanks to the two volumes created:
* A volume containing the Wordpress files
* A volume containing the related database

You can bind these to two local folders of yours by changing this variables in the makefile:
```VOLUME_DIR = <The root of your two new folders>```
The makefile will create two folders at this location:
* ```wp-content_volume``` containing your wordpress data
* ```wp-database_volume``` containing the database for you page once you've set one up.

To do so, connect to //https:localhost:443// and follow the instructions of the inistallation wizard.
