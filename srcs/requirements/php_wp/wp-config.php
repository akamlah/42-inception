<?php
/**
 * The base configuration for WordPress
 *
 * The wp-config.php creation script uses this file during the installation.
 * You don't have to use the web site, you can copy this file to "wp-config.php"
 * and fill in the values.
 *
 * This file contains the following configurations:
 *
 * * Database settings
 * * Secret keys
 * * Database table prefix
 * * ABSPATH
 *
 * @link https://wordpress.org/support/article/editing-wp-config-php/
 *
 * @package WordPress
 */

/** MySQL database name */
// define( 'DB_NAME', getenv('WP_DB_NAME') );

/** MySQL database username */
// define( 'DB_USER', getenv('WP_DB_USER') );

/** MySQL database password */
// define( 'DB_PASSWORD', getenv('WP_DB_PASSWORD') );

/** MySQL hostname */
// define( 'DB_HOST', getenv('WP_DB_HOST') );

/** Database Charset to use in creating database tables. */
// define( 'DB_CHARSET', getenv('WP_DB_CHARSET') );

/** The Database Collate type. Don't change this if in doubt. */
// define( 'DB_COLLATE', getenv('WP_DB_COLLATE') );



/** MySQL database name */
define( 'DB_NAME', 'wordpress' );

/** MySQL database username */
define( 'DB_USER', getenv('WP_DB_USER') );

/** MySQL database password */
define( 'DB_PASSWORD', getenv('WP_DB_PASSWORD') );

/** MySQL hostname */
define( 'DB_HOST', 'php_wp_c' );

/** Database Charset to use in creating database tables. */
define( 'DB_CHARSET', 'utf8' );

/** The Database Collate type. Don't change this if in doubt. */
define( 'DB_COLLATE', '' );

/**#@+
 * These are sample values.
 */
define('AUTH_KEY',         ':BiuKIi%W7<p?4Jm}`1XTJOw!cQBKxcOt]DylUDyO$BB<>t)*FN.qf*q|+-W7}8f');
define('SECURE_AUTH_KEY',  '7[Kh-{P#A~<PGMkIOHC#9Fta$XGemco5F8k}G66I[lXqD|`IZ8cyM2O>!NjtvW(o');
define('LOGGED_IN_KEY',    'La{SEJ{$uI<6Txgv QqY4cxG]3+-r[Iqcx.IFxlfN.f/Yd?317zR*+Yt=*PMWM$(');
define('NONCE_KEY',        'U5pGQf.`J{.Hd~P/9Snw`V2+#<t+;>OTY!VOW[-aoruh;dhSUX]09xj*O<KXdZ6+');
define('AUTH_SALT',        'fmByAIfcEq&V}Xf,mF)!a09:-Q$R^/:79!k|<pEL@>VU)|C7|(>;`{N(4ZHg O)n');
define('SECURE_AUTH_SALT', 's5N%EIR(eM@tlg;M%L-+F#:<|r_x5-]Ix.&eYN)ya5ktoWLE+H~zUGkX#HceO/;H');
define('LOGGED_IN_SALT',   'EGcaE`=DAh7lv*klFyV0VLy5<@af_*--3otD$3:^;z~C(f^JB[C0T;`yqE)2@y${');
define('NONCE_SALT',       'rP1%&ojrP0XLRuQ1AS#@u}#2-Q+)5ftKeJpWC$oxD]?&3}|+n2Gt{1$`kZbSW`-q');

/**#@-*/

/**
 * WordPress Database Table prefix.
 */
$table_prefix = 'wp_';

/**
 * For developers: WordPress debugging mode.
 *
 * Change this to true to enable the display 
 * of notices during development.
 * It is strongly recommended that plugin 
 * and theme developers use WP_DEBUG
 * in their development environments.
 *
 * For information on other constants that 
 * can be used for debugging,
 * visit the documentation.
 *
 * @link https://wordpress.org/support/article/debugging-in-wordpress/
 */
define( 'WP_DEBUG', false );

/** Absolute path to the WordPress directory. */
if ( ! defined( 'ABSPATH' ) ) {
    define( 'ABSPATH', __DIR__ . '/' );
}

/** Sets up WordPress vars and included files. */
require_once ABSPATH . 'wp-settings.php';
?>
<!-- 
- Ensure that there is a Dockerfile.
- Ensure that there is no NGINX in the Dockerfile.
- Using the 'docker-compose ps' command, ensure that the container was 
created (using the flag '-p' is authorized if necessary).
- Ensure that there is a Volume. To do so:
Run the command 'docker volume ls' then 'docker volume inspect 
'. Verify that the result in the standard output contains 
the path '/home/login/data/', where login is the login of the evaluated 
student.
- Ensure that you can add a comment using the available WordPress user.
- Sign in with the administrator account to access the Administration 
dashboard. The Admin username must not include 'admin' or 'Admin' 
(e.g., admin, administrator, Admin-login, admin-123, and so forth).
- From the Administration dashboard, edit a page. Verify on the website 
that the page has been updated.
If any of the above points is not correct, the evaluation process ends 
now. -->

<!-- MariaDB and its volume

- Ensure that there is a Dockerfile.
- Ensure that there is no NGINX in the Dockerfile.
- Using the 'docker-compose ps' command, ensure that the container was 
created (using the flag '-p' is authorized if necessary).
- Ensure that there is a Volume. To do so:
Run the command 'docker volume ls' then 'docker volume inspect 
'. Verify that the result in the standard output contains 
the path '/home/login/data/', where login is the login of the evaluated 
student.
- The evaluated student must be able to explain you how to login into 
the database. Try to login into the SQL database as root but with no 
password. If the login is successful, the evaluation process ends now.
- Try to login into the SQL database with the user account and its 
password. Verify that the database is not empty.
If any of the above points is not correct, the evaluation process ends 
now. -->