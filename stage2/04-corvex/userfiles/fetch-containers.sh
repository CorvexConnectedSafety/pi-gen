#!/bin/sh

export REGISTRY=registry.gitlab.com
export REG_USER=shane.mccarron
export REG_PASS='7zK7GFEmDfNnyRXCUxLN'

if [ ! -f /usr/bin/docker ] ; then
    curl --insecure -sSL https://get.docker.com | sh
    apt-get update
    apt-get install -y docker-compose
    apt-get remove -y golang-docker-credential-helpers
fi

docker login -u $REG_USER -p $REG_PASS $REGISTRY

docker pull registry.gitlab.com/corvexconnected/rest-api:arm-latest
docker pull registry.gitlab.com/corvexconnected/webapp:arm-latest
docker pull grafana/promtail:latest
