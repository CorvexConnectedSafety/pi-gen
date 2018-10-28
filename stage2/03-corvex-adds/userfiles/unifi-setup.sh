#!/bin/sh

mkdir /var/unifi
cd /var/unifi
curl -O https://raw.githubusercontent.com/ryansch/docker-unifi-rpi/master/docker-compose.yml
docker-compose up -d
