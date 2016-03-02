#!/bin/bash

export DEBIAN_FRONTEND="noninteractive"

echo "APT::Acquire::Queue-Mode \"access\";\nAPT::Acquire::Retries 3;" >> /etc/apt/apt.conf.d/99parallel
apt-get update
apt-get install -y software-properties-common curl git unzip openssl pkg-config wget vim libnotify-bin
echo "export TERM=xterm" >> ~/.bashrc
