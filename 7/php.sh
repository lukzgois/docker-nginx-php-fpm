#!/bin/bash

# Installing PHP and stuff
LC_ALL=en_US.UTF-8 apt-add-repository ppa:ondrej/php -y
apt-get update
apt-get install -y --force-yes php7.0-cli php7.0-dev \
php-pgsql php-sqlite3 php-gd php-apcu \
php-curl php7.0-mcrypt \
php-imap php-mysql php-memcached php7.0-readline php-xdebug \
php-mbstring php-xml php7.0-fpm

# Installing composer
curl -sS https://getcomposer.org/installer | php
mv composer.phar /usr/local/bin/composer

# Setting  some PHP config for development
sed -i "s/error_reporting = .*/error_reporting = E_ALL/" /etc/php/7.0/cli/php.ini
sed -i "s/display_errors = .*/display_errors = On/" /etc/php/7.0/cli/php.ini
sed -i "s/memory_limit = .*/memory_limit = 512M/" /etc/php/7.0/cli/php.ini
sed -i "s/;date.timezone.*/date.timezone = UTC/" /etc/php/7.0/cli/php.ini

sed -i "s/error_reporting = .*/error_reporting = E_ALL/" /etc/php/7.0/fpm/php.ini
sed -i "s/display_errors = .*/display_errors = On/" /etc/php/7.0/fpm/php.ini
sed -i "s/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/" /etc/php/7.0/fpm/php.ini
sed -i "s/memory_limit = .*/memory_limit = 512M/" /etc/php/7.0/fpm/php.ini
sed -i "s/upload_max_filesize = .*/upload_max_filesize = 100M/" /etc/php/7.0/fpm/php.ini
sed -i "s/post_max_size = .*/post_max_size = 100M/" /etc/php/7.0/fpm/php.ini
sed -i "s/;date.timezone.*/date.timezone = UTC/" /etc/php/7.0/fpm/php.ini
sed -e 's/;daemonize = yes/daemonize = no/' -i /etc/php/7.0/fpm/php-fpm.conf
sed -i -e "s/www-data/root/g" /etc/php/7.0/fpm/pool.d/www.conf
sed -i -e "s/;clear_env = no/clear_env = no/g" /etc/php/7.0/fpm/pool.d/www.conf
sed -i -e "s/listen = \/run\/php\/php7.0-fpm.sock/listen = \/var\/run\/php\/php7.0-fpm.sock/g" /etc/php/7.0/fpm/pool.d/www.conf

# We will disable xdebug for composer and create an alias to use it with the php comand
rm /etc/php/7.0/cli/conf.d/20-xdebug.ini
echo "alias php=\"php -dzend_extension=xdebug.so\"" >> ~/.bashrc

# We will replace the pecl bin with a version that loads xml.so, because the extension is not compiled in the source
# on the PPA and the pecl disable all .ini files
rm /usr/bin/pecl
cp /build/templates/pecl /usr/bin/pecl
chmod +x /usr/bin/pecl

# Installing the lastest mongodb extension
pecl install mongodb
echo "extension=mongodb.so" >> /etc/php/7.0/fpm/conf.d/20-mongodb.ini
echo "extension=mongodb.so" >> /etc/php/7.0/cli/conf.d/20-mongodb.ini
