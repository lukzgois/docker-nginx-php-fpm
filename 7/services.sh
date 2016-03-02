#!/bin/bash

service php7.0-fpm stop
service nginx stop

# Run PHP and Nginx with runit
mkdir /etc/service/php7.0-fpm
mkdir /run/php
cp /build/run/php-fpm.sh /etc/service/php7.0-fpm/run
chmod +x /etc/service/php7.0-fpm/run

mkdir /etc/service/nginx
cp /build/run/nginx.sh /etc/service/nginx/run
chmod +x /etc/service/nginx/run