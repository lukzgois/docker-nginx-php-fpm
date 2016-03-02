#!/bin/bash

# Installing nodejs
curl --silent --location https://deb.nodesource.com/setup_5.x | bash -
apt-get update
apt-get install -y --force-yes nodejs
curl -L https://npmjs.org/install.sh | sh
npm set progress=false