#! /bin/sh
#
# entrypoint.sh

set -e

[[ "$DEBUG" == "true" ]] && set -x

# Set environments
sed -i "s|include = /etc/php5/fpm.d/\*.conf||g" /etc/php5/php-fpm.conf
sed -i "s|;*daemonize\s*=\s*yes|daemonize = no|g" /etc/php5/php-fpm.conf
sed -i "s|error_log\s*=\s*/var/log/php-fpm.log|error_log = /proc/self/fd/2|g" /etc/php5/php-fpm.conf
sed -i "s|;*access.log\s*=\s*log/\$pool.access.log|access.log = /proc/self/fd/1|g" /etc/php5/php-fpm.conf
sed -i "s|;*listen\s*=\s*127.0.0.1:9000|listen = 9000|g" /etc/php5/php-fpm.conf
sed -i "s|;*chdir\s*=\s*/var/www|chdir = /var/www|g" /etc/php5/php-fpm.conf
sed -i "s|pm.max_children =.*|pm.max_children = ${PM_MAX_CHILDREN}|i" /etc/php5/php-fpm.conf
sed -i "s|pm.start_servers =.*|pm.start_servers = ${PM_START_SERVERS}|i" /etc/php5/php-fpm.conf
sed -i "s|pm.min_spare_servers =.*|pm.min_spare_servers = ${PM_MIN_SPARE_SERVERS}|i" /etc/php5/php-fpm.conf
sed -i "s|pm.max_spare_servers =.*|pm.max_spare_servers = ${PM_MAX_SPARE_SERVERS}|i" /etc/php5/php-fpm.conf
sed -i "s|user =.*|user = phpuser|i" /etc/php5/php-fpm.conf
sed -i "s|group =.*|group = phpgroup|i" /etc/php5/php-fpm.conf
sed -i "s|;*date.timezone =.*|date.timezone = ${DATE_TIMEZONE}|i" /etc/php5/php.ini
sed -i "s|;*memory_limit =.*|memory_limit = ${MEMORY_LIMIT}|i" /etc/php5/php.ini
sed -i "s|;*upload_max_filesize =.*|upload_max_filesize = ${UPLOAD_MAX_FILESIZE}|i" /etc/php5/php.ini
sed -i "s|;*max_file_uploads =.*|max_file_uploads = ${MAX_FILE_UPLOADS}|i" /etc/php5/php.ini
sed -i "s|;*post_max_size =.*|post_max_size = ${POST_MAX_SIZE}|i" /etc/php5/php.ini
sed -i "s|;\s*max_input_vars =.*|max_input_vars = ${MAX_INPUT_VARS}|i" /etc/php5/php.ini
sed -i "s|;*cgi.fix_pathinfo=.*|cgi.fix_pathinfo= 0|i" /etc/php5/php.ini

mkdir -p /var/www

addgroup -g ${GID} -S phpgroup && adduser -u ${UID} -G phpgroup -H -D -s /sbin/nologin phpuser

[[ $(stat -c %U /var/www) == "phpuser" ]] || chown -R phpuser /var/www
[[ $(stat -c %G /var/www) == "phpgroup" ]] || chgrp -R phpgroup /var/www

exec "$@"
