FROM phusion/baseimage:0.9.18
MAINTAINER Lukz <lucaspgois@gmail.com>

# Use baseimage-docker's init system.
CMD ["/sbin/my_init"]

RUN export DEBIAN_FRONTEND="noninteractie"
	
# Installing nodejs
RUN curl --silent --location https://deb.nodesource.com/setup_4.x | bash -
RUN apt-get update
RUN DEBIAN_FRONTEND="noninteractive" apt-get install -y --force-yes nodejs
RUN npm upgrade npm -g
RUN npm set progress=false

# Installing PHP and stuff
RUN LC_ALL=en_US.UTF-8 apt-add-repository ppa:ondrej/php -y
RUN apt-get update
RUN DEBIAN_FRONTEND="noninteractive" apt-get install -y --force-yes php7.0-cli php7.0-dev \
	php-pgsql php-sqlite3 php-gd php-apcu \
	php-curl php7.0-fpm \
	php-imap php-mysql php-memcached php7.0-readline php-xdebug php7.0-mbstring php7.0-xml

RUN curl -sS https://getcomposer.org/installer | php
RUN mv composer.phar /usr/local/bin/composer

# Setting  some PHP config for development
RUN sed -i "s/error_reporting = .*/error_reporting = E_ALL/" /etc/php/7.0/cli/php.ini
RUN sed -i "s/display_errors = .*/display_errors = On/" /etc/php/7.0/cli/php.ini
RUN sed -i "s/memory_limit = .*/memory_limit = 512M/" /etc/php/7.0/cli/php.ini
RUN sed -i "s/;date.timezone.*/date.timezone = UTC/" /etc/php/7.0/cli/php.ini

RUN sed -i "s/error_reporting = .*/error_reporting = E_ALL/" /etc/php/7.0/fpm/php.ini
RUN sed -i "s/display_errors = .*/display_errors = On/" /etc/php/7.0/fpm/php.ini
RUN sed -i "s/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/" /etc/php/7.0/fpm/php.ini
RUN sed -i "s/memory_limit = .*/memory_limit = 512M/" /etc/php/7.0/fpm/php.ini
RUN sed -i "s/upload_max_filesize = .*/upload_max_filesize = 100M/" /etc/php/7.0/fpm/php.ini
RUN sed -i "s/post_max_size = .*/post_max_size = 100M/" /etc/php/7.0/fpm/php.ini
RUN sed -i "s/;date.timezone.*/date.timezone = UTC/" /etc/php/7.0/fpm/php.ini
RUN sed -e 's/;daemonize = yes/daemonize = no/' -i /etc/php/7.0/fpm/php-fpm.conf
RUN sed -i -e "s/www-data/root/g" /etc/php/7.0/fpm/pool.d/www.conf

# Installing NGINX
RUN DEBIAN_FRONTEND="noninteractive" apt-get install -y --force-yes nginx
RUN echo "\ndaemon off;" >> /etc/nginx/nginx.conf
RUN sed -i -e "s/user www-data/user root/g" /etc/nginx/nginx.conf
RUN rm /etc/nginx/sites-available/default
ADD templates/virtualhost /etc/nginx/sites-available/default

RUN service php7.0-fpm stop
RUN service nginx stop

# Run PHP and Nginx with runit
RUN mkdir /etc/service/php7.0-fpm
RUN mkdir /run/php
ADD run/php-fpm.sh /etc/service/php7.0-fpm/run
RUN chmod +x /etc/service/php7.0-fpm/run

RUN mkdir /etc/service/nginx
ADD run/nginx.sh /etc/service/nginx/run
RUN chmod +x /etc/service/nginx/run

EXPOSE 80

# Clean up APT when done.
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
