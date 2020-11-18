#!/bin/sh

docker stop promtail
docker rm promtail
docker run \
  $1 \
  --name promtail \
  --network corvex \
  -v /home/corvex/:/home/corvex/ \
  -v /var/lib/docker:/var/docker \
  -v /etc/machine-id:/etc/machine-id \
  grafana/promtail:latest \
  -config.file=/home/corvex/promtail.yml
