#!/bin/sh

if [ -f /var/www/html/scripts/tools/config.sh ]
then
    . /var/www/html/scripts/tools/config.sh
    port=`printf '11%03d' "$subscriber"`
    echo "Remote tunnel on port $port"
    autossh -f -N -o "StrictHostKeyChecking no" -i /home/corvex/tunnel_key -L 3128:127.0.0.1:3128 -L 13306:127.0.0.1:3306 -L 8080:127.0.0.1:80 -R *:$port:127.0.0.1:22 ccs@db1.corvexconnected.com 2>&1
fi


