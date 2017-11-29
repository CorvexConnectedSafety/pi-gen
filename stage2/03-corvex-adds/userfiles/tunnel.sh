#!/bin/sh

if [ -f /var/www/html/scripts/tools/config.sh ]
then
    . /var/www/html/scripts/tools/config.sh
    port=`printf '11%03d' "$subscriber"`
    echo "Remote tunnel on port $port"
    autossh -f -N -o "StrictHostKeyChecking no" -i /home/corvex/tunnel_key -R *:$port:127.0.0.1:22 ccs@db1.corvexconnected.com 2>&1
fi


