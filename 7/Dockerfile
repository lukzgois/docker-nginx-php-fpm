FROM phusion/baseimage:0.9.18
MAINTAINER Lukz <lucaspgois@gmail.com>

# Use baseimage-docker's init system.
CMD ["/sbin/my_init"]

ADD . /build/
RUN /build/prepare.sh
RUN /build/nodejs.sh
RUN /build/php.sh
RUN /build/nginx.sh
RUN /build/services.sh

EXPOSE 80

# Clean up APT when done.
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
