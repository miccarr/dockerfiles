#! /bin/sh
#
# entrypoint.sh

set -e

[[ "$DEBUG" == "true" ]] && set -x

# Set environments
sed -i "s|;*daemonize\s*=\s*yes|daemonize = no|g" /etc/php7/php-fpm.conf
sed -i "s|;*error_log\s*=\s*log/php7/error.log|error_log = /proc/self/fd/2|g" /etc/php7/php-fpm.conf
sed -i "s|;*access.log\s*=\s*log/php7/\$pool.access.log|access.log = /proc/self/fd/1|g" /etc/php7/php-fpm.d/www.conf
sed -i "s|;*listen\s*=\s*127.0.0.1:9000|listen = 9000|g" /etc/php7/php-fpm.d/www.conf
sed -i "s|;*chdir\s*=\s*/var/www|chdir = /var/www|g" /etc/php7/php-fpm.d/www.conf
sed -i "s|pm.max_children =.*|pm.max_children = 12|i" /etc/php7/php-fpm.d/www.conf
sed -i "s|pm.start_servers =.*|pm.start_servers = 6|i" /etc/php7/php-fpm.d/www.conf
sed -i "s|pm.min_spare_servers =.*|pm.min_spare_servers = 2|i" /etc/php7/php-fpm.d/www.conf
sed -i "s|pm.max_spare_servers =.*|pm.max_spare_servers = 10|i" /etc/php7/php-fpm.d/www.conf
sed -i "s|;*date.timezone =.*|date.timezone = ${TIMEZONE}|i" /etc/php7/php.ini
sed -i "s|;*memory_limit =.*|memory_limit = ${PHP_MEMORY_LIMIT}|i" /etc/php7/php.ini
sed -i "s|;*upload_max_filesize =.*|upload_max_filesize = ${MAX_UPLOAD}|i" /etc/php7/php.ini
sed -i "s|;*max_file_uploads =.*|max_file_uploads = ${PHP_MAX_FILE_UPLOAD}|i" /etc/php7/php.ini
sed -i "s|;*post_max_size =.*|post_max_size = ${PHP_MAX_POST}|i" /etc/php7/php.ini
sed -i "s|;\s*max_input_vars =.*|max_input_vars = ${MAX_INPUT_VARS}|i" /etc/php7/php.ini
sed -i "s|;*cgi.fix_pathinfo=.*|cgi.fix_pathinfo= 0|i" /etc/php7/php.ini

mkdir -p /var/www
chown -Rf nobody:nobody /var/www

exec "$@"
