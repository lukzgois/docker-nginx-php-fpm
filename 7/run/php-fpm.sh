#!/bin/bash

if [ ! -z "$APP_DIR" ]; then
    DOCUMENT_ROOT="/var/www"
    rm -rf ${DOCUMENT_ROOT}

    if [ -d "${APP_DIR}/public" ]; then
        dir="${DOCUMENT_ROOT}"
    else
        dir="${DOCUMENT_ROOT}/public"
    fi

    mkdir -p `dirname ${dir}`
    ln -s $APP_DIR $dir
fi

# Setting  some PHP config for development
sed -i "s/error_reporting = .*/error_reporting = $PHP_ERROR_REPORTING/" /etc/php/7.0/cli/php.ini
sed -i "s/display_errors = .*/display_errors = $PHP_DISPLAY_ERRORS/" /etc/php/7.0/cli/php.ini
sed -i "s/memory_limit = .*/memory_limit = $PHP_MEMORY_LIMIT/" /etc/php/7.0/cli/php.ini
sed -i "s/;date.timezone.*/date.timezone = $PHP_TIMEZONE/" /etc/php/7.0/cli/php.ini

sed -i "s/error_reporting = .*/error_reporting = $PHP_ERROR_REPORTING/" /etc/php/7.0/fpm/php.ini
sed -i "s/display_errors = .*/display_errors = $PHP_DISPLAY_ERRORS/" /etc/php/7.0/fpm/php.ini
sed -i "s/memory_limit = .*/memory_limit = $PHP_MEMORY_LIMIT/" /etc/php/7.0/fpm/php.ini
sed -i "s/upload_max_filesize = .*/upload_max_filesize = $PHP_UPLOAD_MAX_FILESIZE/" /etc/php/7.0/fpm/php.ini
sed -i "s/post_max_size = .*/post_max_size = $PHP_POST_MAX_SIZE/" /etc/php/7.0/fpm/php.ini
sed -i "s/;date.timezone.*/date.timezone = $PHP_TIMEZONE/" /etc/php/7.0/fpm/php.ini

exec /usr/sbin/php-fpm7.0 --nodaemonize --allow-to-run-as-root >> /var/log/php7.0-fpm.log 2>&1