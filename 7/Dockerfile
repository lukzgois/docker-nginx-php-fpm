FROM phusion/baseimage:0.9.18
MAINTAINER Lukz <lucaspgois@gmail.com>

# Use baseimage-docker's init system.
CMD ["/sbin/my_init"]

# Preparing for the installation
RUN export DEBIAN_FRONTEND="noninteractive"
RUN apt-get update && apt-get install -y software-properties-common curl git unzip openssl pkg-config \
wget vim supervisor
RUN echo "export TERM=xterm" >> ~/.bashrc
RUN mkdir /build
COPY templates /build/templates
COPY run /build/run

# Installing nodejs
RUN curl --silent --location https://deb.nodesource.com/setup_5.x | bash - && \
apt-get update && apt-get install -y --force-yes nodejs && \
curl -L https://npmjs.org/install.sh | sh
# disabling npm progress bar to speed up installs. See: https://github.com/npm/npm/issues/11283
RUN npm set progress=false && npm install gulp -g

# Installing PHP and stuff
RUN LC_ALL=en_US.UTF-8 apt-add-repository ppa:ondrej/php -y
RUN apt-get update && apt-get install -y --force-yes php7.0-cli php7.0-dev \
php-pgsql php-sqlite3 php-gd php-apcu \
php-curl php7.0-mcrypt \
php-imap php-mysql php-memcached php7.0-readline php-xdebug \
php-mbstring php-xml php7.0-fpm

# Installing composer
RUN curl -sS https://getcomposer.org/installer | php && \
mv composer.phar /usr/local/bin/composer

# Setting some PHP Env variables
ENV PHP_ERROR_REPORTING     E_ALL
ENV PHP_DISPLAY_ERRORS      On
ENV PHP_MEMORY_LIMIT        512M
ENV PHP_TIMEZONE            UTC
ENV PHP_UPLOAD_MAX_FILESIZE 100M
ENV PHP_POST_MAX_SIZE       100M

# Setting some php settings for docker
RUN sed -i "s/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/" /etc/php/7.0/fpm/php.ini && \
sed -e 's/;daemonize = yes/daemonize = no/' -i /etc/php/7.0/fpm/php-fpm.conf && \
sed -i -e "s/www-data/root/g" /etc/php/7.0/fpm/pool.d/www.conf && \
sed -i -e "s/;clear_env = no/clear_env = no/g" /etc/php/7.0/fpm/pool.d/www.conf && \
sed -i -e "s/listen = \/run\/php\/php7.0-fpm.sock/listen = \/var\/run\/php\/php7.0-fpm.sock/g" /etc/php/7.0/fpm/pool.d/www.conf

# We will disable xdebug for composer and create an alias to use it with the php comand
RUN rm /etc/php/7.0/cli/conf.d/20-xdebug.ini && \
echo "alias php=\"php -dzend_extension=xdebug.so\"" >> ~/.bashrc

# We will replace the pecl bin with a version that loads xml.so, because the extension is not compiled in the source
# on the PPA and the pecl disable all .ini files
RUN rm /usr/bin/pecl && cp /build/templates/pecl /usr/bin/pecl && chmod +x /usr/bin/pecl

# Installing the mongodb and zip extension
RUN pecl install mongodb zip \
&& echo "extension=mongodb.so" >> /etc/php/7.0/fpm/conf.d/20-mongodb.ini \
&& echo "extension=mongodb.so" >> /etc/php/7.0/cli/conf.d/20-mongodb.ini \
&& echo "extension=zip.so" >> /etc/php/7.0/fpm/conf.d/20-zip.ini \
&& echo "extension=zip.so" >> /etc/php/7.0/cli/conf.d/20-zip.ini

# Installing NGINX
RUN apt-get install -y --force-yes nginx && \
echo "daemon off;" >> /etc/nginx/nginx.conf && \
sed -i -e "s/user www-data/user root/g" /etc/nginx/nginx.conf && \
rm /etc/nginx/sites-available/default && \
cp /build/templates/virtualhost /etc/nginx/sites-available/default

RUN service php7.0-fpm stop && service nginx stop && service supervisor stop

# Run PHP and Nginx with runit
RUN mkdir /etc/service/php7.0-fpm && mkdir /run/php && cp /build/run/php-fpm.sh /etc/service/php7.0-fpm/run \
&& chmod +x /etc/service/php7.0-fpm/run
RUN mkdir /etc/service/nginx && cp /build/run/nginx.sh /etc/service/nginx/run && chmod +x /etc/service/nginx/run
RUN mkdir /etc/service/supervisor && cp /build/run/supervisor.sh /etc/service/supervisor/run \ 
&& chmod +x /etc/service/supervisor/run

EXPOSE 80

# Clean up APT when done.
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* && rm -rf /build
