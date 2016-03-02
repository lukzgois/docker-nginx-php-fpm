#!/bin/bash

# Installing NGINX
apt-get install -y --force-yes nginx
echo "\ndaemon off;" >> /etc/nginx/nginx.conf
sed -i -e "s/user www-data/user root/g" /etc/nginx/nginx.conf
rm /etc/nginx/sites-available/default
cp /build/templates/virtualhost /etc/nginx/sites-available/default